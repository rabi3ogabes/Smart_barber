<?php

namespace App\Modules\Staff\Support;

use App\Core\Authorization\Access;
use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Identity\Models\User;

/**
 * Which roles a member may hand out (permissions.md, footnotes 2 and 4).
 */
final class RoleRules
{
    /** Roles that work across the whole salon and need no branch assignment. */
    public const SALON_WIDE = [P::OWNER, P::GENERAL_MANAGER, P::ACCOUNTANT, P::MARKETING_MANAGER];

    /**
     * @return list<string>
     */
    public static function assignableBy(User $actor): array
    {
        $roles = Access::roles($actor);

        if (in_array(P::OWNER, $roles, true)) {
            return P::ROLES;
        }
        if (in_array(P::GENERAL_MANAGER, $roles, true)) {
            return array_values(array_diff(P::ROLES, [P::OWNER, P::GENERAL_MANAGER]));
        }
        if (Access::scope($actor, 'staff.invite') === P::SCOPE_BRANCH) {
            return [P::RECEPTIONIST, P::BARBER];
        }

        return [];
    }

    /**
     * @param  list<string>  $roles
     */
    public static function needsBranches(array $roles): bool
    {
        return array_diff($roles, self::SALON_WIDE) !== [];
    }
}
