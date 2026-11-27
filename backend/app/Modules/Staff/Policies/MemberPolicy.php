<?php

namespace App\Modules\Staff\Policies;

use App\Core\Authorization\Access;
use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\SalonMembership;

/**
 * Staff management. Branch-scoped managers act only on members whose branches are all theirs.
 */
final class MemberPolicy
{
    public function viewAny(User $user): bool
    {
        return Access::scope($user, 'staff.view') !== null;
    }

    public function invite(User $user): bool
    {
        return Access::scope($user, 'staff.invite') !== null;
    }

    public function update(User $user, SalonMembership $member): bool
    {
        return $this->inScope($user, 'staff.update', $member);
    }

    public function assignRoles(User $user, SalonMembership $member): bool
    {
        return Access::scope($user, 'staff.roles.assign') !== null && $this->inScope($user, 'staff.update', $member);
    }

    public function changeStatus(User $user, SalonMembership $member): bool
    {
        return Access::scope($user, 'staff.deactivate') === P::SCOPE_ALL;
    }

    private function inScope(User $user, string $permission, SalonMembership $member): bool
    {
        $scope = Access::scope($user, $permission);
        if ($scope === P::SCOPE_ALL) {
            return true;
        }
        if ($scope !== P::SCOPE_BRANCH) {
            return false;
        }
        $branches = $member->branches()->pluck('branches.id')->all();

        return $branches !== [] && Access::allowsInBranches($user, $permission, $branches);
    }
}
