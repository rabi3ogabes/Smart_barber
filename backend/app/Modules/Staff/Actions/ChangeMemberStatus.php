<?php

namespace App\Modules\Staff\Actions;

use App\Core\Audit\AuditLogger;
use App\Core\Authorization\PermissionCatalog;
use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\SalonMembership;
use App\Modules\Staff\Models\Barber;
use Illuminate\Support\Facades\DB;

/**
 * Deactivate (never delete) or reactivate a member. Deactivation signs them out of this
 * salon's staff app at once and hides their barber profile from booking.
 */
final class ChangeMemberStatus
{
    public function __invoke(User $actor, SalonMembership $membership, bool $active): void
    {
        $user = $membership->user ?? throw new AppException(ErrorCode::NotFound);
        if ($user->is($actor)) {
            throw new AppException(ErrorCode::CannotChangeOwnAccess);
        }
        $user->unsetRelation('roles');
        if (! $active && $user->hasRole(PermissionCatalog::OWNER)) {
            EnsureOwnerRemains::check($membership);
        }

        DB::transaction(function () use ($membership, $user, $active): void {
            $membership->forceFill([
                'status' => $active ? SalonMembership::STATUS_ACTIVE : SalonMembership::STATUS_DEACTIVATED,
                'deactivated_at' => $active ? null : now(),
            ])->save();

            if ($active && $user->hasRole(PermissionCatalog::BARBER)) {
                Barber::query()->where('user_id', $user->id)->update(['is_bookable' => true]);
            }
            if (! $active) {
                DB::table('personal_access_tokens')->where('tokenable_type', 'user')->where('tokenable_id', $user->id)->where('salon_id', $membership->salon_id)->delete();
                DB::table('refresh_tokens')->where('tokenable_type', 'user')->where('tokenable_id', $user->id)->where('salon_id', $membership->salon_id)->update(['revoked_at' => now()]);
                Barber::query()->where('user_id', $user->id)->update(['is_bookable' => false]);
            }

            AuditLogger::record($active ? 'membership.reactivated' : 'membership.deactivated', $membership);
        });
    }
}
