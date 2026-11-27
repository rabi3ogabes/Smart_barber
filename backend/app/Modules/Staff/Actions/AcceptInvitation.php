<?php

namespace App\Modules\Staff\Actions;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Actions\AddMember;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Tenancy;
use App\Modules\Staff\Models\StaffInvitation;
use Illuminate\Support\Facades\DB;

/**
 * Turns a pending invitation into a membership for an existing or new user.
 */
final class AcceptInvitation
{
    public function __construct(private readonly AddMember $addMember) {}

    public static function find(string $token): ?StaffInvitation
    {
        return StaffInvitation::query()->where('token_hash', hash('sha256', $token))->first();
    }

    /**
     * The existing account the invitation points at, if any.
     */
    public static function accountFor(StaffInvitation $invitation): ?User
    {
        return User::query()
            ->where(fn ($q) => $q
                ->when($invitation->email, fn ($q) => $q->orWhere('email', $invitation->email))
                ->when($invitation->phone, fn ($q) => $q->orWhere('phone', $invitation->phone)))
            ->first();
    }

    public function __invoke(StaffInvitation $invitation, User $user): void
    {
        if (! $invitation->isPending()) {
            throw new AppException(ErrorCode::InvitationInvalid);
        }

        $matches = ($invitation->email !== null && $invitation->email === $user->email)
            || ($invitation->phone !== null && $invitation->phone === $user->phone);
        if (! $matches) {
            throw new AppException(ErrorCode::InvitationAccountMismatch);
        }

        DB::transaction(function () use ($invitation, $user): void {
            $salon = Tenancy::current() ?? throw new AppException(ErrorCode::Forbidden);
            $branches = Branch::query()->whereIn('id', $invitation->branch_ids)->get();
            ($this->addMember)($salon, $user, $invitation->role_names, $branches);
            // Re-establish the tenant: AddMember::runAs restores the previous one.
            Tenancy::set($salon, $user->membershipIn((int) $salon->id));

            $invitation->forceFill(['accepted_at' => now(), 'accepted_user_id' => $user->id])->save();
        });
    }
}
