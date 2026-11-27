<?php

namespace App\Modules\Staff\Actions;

use App\Core\Audit\AuditLogger;
use App\Core\Authorization\Access;
use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Tenancy;
use App\Modules\Staff\Jobs\SendStaffInvitationSms;
use App\Modules\Staff\Models\StaffInvitation;
use App\Modules\Staff\Notifications\StaffInvitationMail;
use App\Modules\Staff\Support\RoleRules;
use App\Modules\Staff\Support\SalonUrl;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Str;

/**
 * Invites a person by e-mail or phone with roles and branches. The link is valid for 7 days
 * and only its hash is stored. A newer invitation to the same contact replaces older ones.
 */
final class InviteStaff
{
    public const TTL_DAYS = 7;

    /**
     * @param  array{email?: string|null, phone?: string|null, name?: string|null, roles: list<string>, branches: list<string>}  $data
     * @return array{invitation: StaffInvitation, token: string}
     */
    public function __invoke(User $actor, array $data): array
    {
        $salon = Tenancy::current() ?? throw new AppException(ErrorCode::Forbidden);
        $branchIds = $this->authorize($actor, $data['roles'], $data['branches']);

        $email = isset($data['email']) && $data['email'] !== '' ? strtolower($data['email']) : null;
        $phone = $data['phone'] ?? null;

        $existing = User::query()
            ->where(fn ($q) => $q->when($email, fn ($q) => $q->orWhere('email', $email))->when($phone, fn ($q) => $q->orWhere('phone', $phone)))
            ->first();
        if ($existing !== null && $existing->membershipIn((int) $salon->id)?->isActive()) {
            throw new AppException(ErrorCode::AlreadyMember);
        }

        StaffInvitation::query()
            ->whereNull('accepted_at')->whereNull('revoked_at')
            ->where(fn ($q) => $q->when($email, fn ($q) => $q->orWhere('email', $email))->when($phone, fn ($q) => $q->orWhere('phone', $phone)))
            ->update(['revoked_at' => now()]);

        $token = Str::random(48);
        $invitation = StaffInvitation::query()->create([
            'email' => $email,
            'phone' => $phone,
            'name' => $data['name'] ?? null,
            'role_names' => $data['roles'],
            'branch_ids' => $branchIds,
            'token_hash' => hash('sha256', $token),
            'invited_by' => $actor->id,
            'expires_at' => now()->addDays(self::TTL_DAYS),
        ]);

        $this->send($invitation, $token);
        AuditLogger::record('staff.invited', $invitation, new: ['contact' => $email ?? $phone, 'roles' => $data['roles'], 'branches' => $data['branches']]);

        return ['invitation' => $invitation, 'token' => $token];
    }

    /**
     * New token, new expiry, sent again.
     */
    public function resend(StaffInvitation $invitation): string
    {
        $token = Str::random(48);
        $invitation->forceFill(['token_hash' => hash('sha256', $token), 'expires_at' => now()->addDays(self::TTL_DAYS), 'revoked_at' => null])->save();
        $this->send($invitation, $token);

        return $token;
    }

    /**
     * Checks the actor may give these roles in these branches; returns internal branch ids.
     *
     * @param  list<string>  $roles
     * @param  list<string>  $branchPublicIds
     * @return list<int>
     */
    public function authorize(User $actor, array $roles, array $branchPublicIds): array
    {
        if ($roles === [] || array_diff($roles, RoleRules::assignableBy($actor)) !== []) {
            throw new AppException(ErrorCode::RoleNotAssignable);
        }

        $branchIds = Branch::query()->whereIn('public_id', $branchPublicIds)->pluck('id')->map(fn ($id) => (int) $id)->all();
        if (count($branchIds) !== count(array_unique($branchPublicIds))) {
            throw new AppException(ErrorCode::NotFound);
        }
        if (RoleRules::needsBranches($roles) && $branchIds === []) {
            throw new AppException(ErrorCode::ValidationFailed, errors: ['branches' => [__('validation.required', ['attribute' => __('ui.staff.branches')])]]);
        }
        if ($branchIds !== [] && ! Access::allowsInBranches($actor, 'staff.invite', $branchIds)) {
            throw new AppException(ErrorCode::RoleNotAssignable);
        }

        return $branchIds;
    }

    private function send(StaffInvitation $invitation, string $token): void
    {
        $salon = Tenancy::current() ?? throw new AppException(ErrorCode::Forbidden);
        $url = SalonUrl::to($salon, "invitations/{$token}");

        if ($invitation->email !== null) {
            Notification::route('mail', $invitation->email)->notify(
                new StaffInvitationMail($salon->getTranslation('name', 'ar'), $salon->getTranslation('name', 'en'), $url),
            );
        }
        if ($invitation->phone !== null) {
            SendStaffInvitationSms::dispatch($invitation->phone, __('invitations.sms', ['salon' => $salon->getTranslation('name', 'ar'), 'url' => $url], 'ar'));
        }
    }
}
