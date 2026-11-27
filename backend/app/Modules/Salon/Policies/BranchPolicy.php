<?php

namespace App\Modules\Salon\Policies;

use App\Core\Authorization\Access;
use App\Core\Authorization\PermissionCatalog;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use Illuminate\Auth\Access\Response;

/**
 * Branch Managers may edit hours and closures of their own branches but may not create
 * or (de)activate branches (permissions.md, footnote 1).
 */
final class BranchPolicy
{
    public function viewAny(User $user): bool
    {
        return Access::scope($user, 'branch.view') !== null;
    }

    public function view(User $user, Branch $branch): bool
    {
        return Access::allowsInBranches($user, 'branch.view', [$branch->id]);
    }

    public function create(User $user): bool
    {
        return Access::scope($user, 'branch.manage') === PermissionCatalog::SCOPE_ALL;
    }

    /**
     * A branch outside the user's scope is reported as missing (404), not forbidden, so branch
     * managers cannot probe other branches (permissions.md → Tests).
     */
    public function update(User $user, Branch $branch): Response
    {
        if (Access::allowsInBranches($user, 'branch.manage', [$branch->id])) {
            return Response::allow();
        }

        return Access::allowsInBranches($user, 'branch.view', [$branch->id]) ? Response::deny() : Response::denyAsNotFound();
    }

    public function changeStatus(User $user, Branch $branch): bool
    {
        return Access::scope($user, 'branch.manage') === PermissionCatalog::SCOPE_ALL;
    }

    public function manageSalonClosures(User $user): bool
    {
        return Access::scope($user, 'branch.manage') === PermissionCatalog::SCOPE_ALL;
    }
}
