<?php

namespace App\Core\Tenancy\Actions;

use App\Core\Audit\AuditLogger;
use App\Core\Authorization\PermissionCatalog;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Models\SalonMembership;
use App\Core\Tenancy\Tenancy;
use InvalidArgumentException;

/**
 * Adds (or reactivates) a user's membership in a salon with roles and branches.
 * The invitation flow (Phase 2) calls this on acceptance.
 */
final class AddMember
{
    /**
     * @param  list<string>  $roles
     * @param  iterable<Branch>  $branches
     */
    public function __invoke(Salon $salon, User $user, array $roles, iterable $branches = []): SalonMembership
    {
        foreach ($roles as $role) {
            if (! in_array($role, PermissionCatalog::ROLES, true)) {
                throw new InvalidArgumentException("Unknown role [{$role}].");
            }
        }

        return Tenancy::runAs($salon, function () use ($salon, $user, $roles, $branches): SalonMembership {
            $membership = SalonMembership::query()->firstOrNew(['user_id' => $user->getKey()]);
            $membership->fill([
                'status' => SalonMembership::STATUS_ACTIVE,
                'joined_at' => $membership->joined_at ?? now(),
                'deactivated_at' => null,
            ])->save();

            foreach ($branches as $branch) {
                $membership->assignBranch($branch);
            }

            $user->unsetRelation('roles');
            $user->syncRoles($roles);
            AuditLogger::record('membership.roles_changed', $membership, new: ['roles' => $roles], salonId: (int) $salon->getKey());

            return $membership;
        });
    }
}
