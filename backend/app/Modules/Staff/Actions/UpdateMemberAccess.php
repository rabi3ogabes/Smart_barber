<?php

namespace App\Modules\Staff\Actions;

use App\Core\Audit\AuditLogger;
use App\Core\Authorization\Access;
use App\Core\Authorization\PermissionCatalog;
use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Events\MemberAccessChanged;
use App\Core\Tenancy\Models\SalonMembership;
use Illuminate\Support\Facades\DB;

/**
 * Changes a member's roles and branches. Audited; nobody changes their own access;
 * the salon always keeps an active owner.
 */
final class UpdateMemberAccess
{
    public function __construct(private readonly InviteStaff $rules) {}

    /**
     * @param  list<string>  $roles
     * @param  list<string>  $branchPublicIds
     */
    public function __invoke(User $actor, SalonMembership $membership, array $roles, array $branchPublicIds): void
    {
        $user = $membership->user ?? throw new AppException(ErrorCode::NotFound);
        if ($user->is($actor)) {
            throw new AppException(ErrorCode::CannotChangeOwnAccess);
        }

        $branchIds = $this->rules->authorize($actor, $roles, $branchPublicIds);

        $user->unsetRelation('roles');
        $oldRoles = $user->getRoleNames()->all();
        // Branch managers may move people between their branches but not change roles.
        $rolesChanged = array_diff($oldRoles, $roles) !== [] || array_diff($roles, $oldRoles) !== [];
        if ($rolesChanged && Access::scope($actor, 'staff.roles.assign') === null) {
            throw new AppException(ErrorCode::RoleNotAssignable);
        }
        // A GM cannot remove (or give) owner/GM; assignableBy already blocks giving them.
        if (array_diff(array_intersect($oldRoles, [PermissionCatalog::OWNER, PermissionCatalog::GENERAL_MANAGER]), $roles) !== []
            && ! in_array(PermissionCatalog::OWNER, Access::roles($actor), true)) {
            throw new AppException(ErrorCode::RoleNotAssignable);
        }
        if (in_array(PermissionCatalog::OWNER, $oldRoles, true) && ! in_array(PermissionCatalog::OWNER, $roles, true)) {
            EnsureOwnerRemains::check($membership);
        }

        DB::transaction(function () use ($user, $membership, $roles, $branchIds, $oldRoles): void {
            $oldBranches = $membership->branches()->pluck('branches.public_id')->all();
            $user->syncRoles($roles);
            $membership->branches()->sync(collect($branchIds)->mapWithKeys(fn (int $id) => [$id => ['salon_id' => $membership->salon_id]])->all());

            AuditLogger::record(
                'membership.access_changed',
                $membership,
                ['roles' => $oldRoles, 'branches' => $oldBranches],
                ['roles' => $roles, 'branches' => $membership->branches()->pluck('branches.public_id')->all()],
            );
            event(new MemberAccessChanged($membership, $roles));
        });
    }
}
