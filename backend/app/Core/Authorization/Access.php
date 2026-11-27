<?php

namespace App\Core\Authorization;

use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\SalonMembership;
use App\Core\Tenancy\Tenancy;
use Illuminate\Database\Eloquent\Collection;

/**
 * Answers "may this member do X, and where?" inside the current salon.
 */
final class Access
{
    /**
     * @return list<string>
     */
    public static function roles(User $user): array
    {
        $user->unsetRelation('roles');

        return array_values($user->getRoleNames()->all());
    }

    public static function scope(User $user, string $permission): ?string
    {
        return PermissionCatalog::broadestScope(self::roles($user), $permission);
    }

    /**
     * @return list<string>
     */
    public static function permissions(User $user): array
    {
        $user->unsetRelation('roles')->unsetRelation('permissions');

        return array_values($user->getAllPermissions()->pluck('name')->all());
    }

    /**
     * Branch ids the member may act in for a permission (null = every branch of the salon).
     *
     * @return list<int>|null
     */
    public static function branchIds(User $user, ?SalonMembership $membership, string $permission): ?array
    {
        $scope = self::scope($user, $permission);

        if ($scope === PermissionCatalog::SCOPE_ALL) {
            return null;
        }

        if ($scope === null || $membership === null) {
            return [];
        }

        return array_map('intval', $membership->branches()->pluck('branches.id')->all());
    }

    /**
     * Branches visible in the header branch selector.
     *
     * @return Collection<int, Branch>
     */
    public static function visibleBranches(User $user): Collection
    {
        $ids = self::branchIds($user, Tenancy::membership(), 'branch.view');
        $query = Branch::query()->where('is_active', true)->orderBy('sort_order')->orderBy('id');

        return $ids === null ? $query->get() : $query->whereIn('id', $ids)->get();
    }
}
