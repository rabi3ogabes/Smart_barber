<?php

namespace App\Modules\Staff\Policies;

use App\Core\Authorization\Access;
use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Modules\Staff\Models\Barber;
use Illuminate\Auth\Access\Response;

final class BarberPolicy
{
    /** Profile (bio, photo, specialties). Barbers may edit their own (permissions.md, footnote 3). */
    public function updateProfile(User $user, Barber $barber): bool
    {
        return match (Access::scope($user, 'staff.update')) {
            P::SCOPE_ALL => true,
            P::SCOPE_BRANCH => Access::allowsInAnyBranch($user, 'staff.update', $barber->branches()->pluck('branches.id')->all()),
            P::SCOPE_OWN => $barber->user_id === $user->id,
            default => false,
        };
    }

    /** Bookable flag and display order are managerial, not self-service. */
    public function manage(User $user, Barber $barber): bool
    {
        $scope = Access::scope($user, 'staff.update');

        return $scope === P::SCOPE_ALL
            || ($scope === P::SCOPE_BRANCH && Access::allowsInAnyBranch($user, 'staff.update', $barber->branches()->pluck('branches.id')->all()));
    }

    public function viewSchedule(User $user, Barber $barber, Branch $branch): bool
    {
        $scope = Access::scope($user, 'schedule.view');

        return $scope === P::SCOPE_ALL
            || ($scope === P::SCOPE_BRANCH && Access::allowsInBranches($user, 'schedule.view', [$branch->id]))
            || ($scope === P::SCOPE_OWN && $barber->user_id === $user->id);
    }

    public function updateSchedule(User $user, Barber $barber, Branch $branch): Response
    {
        if (Access::allowsInBranches($user, 'schedule.update', [$branch->id])) {
            return Response::allow();
        }

        return Access::allowsInBranches($user, 'schedule.view', [$branch->id]) ? Response::deny() : Response::denyAsNotFound();
    }

    /** Time off is requested for oneself. */
    public function requestTimeOff(User $user, Barber $barber): bool
    {
        return Access::scope($user, 'timeoff.request') !== null && $barber->user_id === $user->id;
    }

    /** Approvers in scope may enter leave directly for a barber (auto-approved). */
    public function enterTimeOff(User $user, Barber $barber): bool
    {
        return Access::allowsInAnyBranch($user, 'timeoff.approve', $barber->branches()->pluck('branches.id')->all());
    }
}
