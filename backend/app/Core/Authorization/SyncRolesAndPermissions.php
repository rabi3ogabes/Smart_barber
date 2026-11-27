<?php

namespace App\Core\Authorization;

use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;
use Spatie\Permission\PermissionRegistrar;

/**
 * Creates the platform template roles (salon_id null) and syncs their permissions from
 * the catalog. Assignments are per salon (spatie teams, team = salon). Idempotent.
 */
final class SyncRolesAndPermissions
{
    public function __invoke(): void
    {
        $registrar = app(PermissionRegistrar::class);
        $previousTeam = getPermissionsTeamId();
        setPermissionsTeamId(null);

        foreach (PermissionCatalog::permissions() as $name) {
            Permission::findOrCreate($name, 'web');
        }

        foreach (PermissionCatalog::ROLES as $roleName) {
            $role = Role::query()->whereNull(config('permission.column_names.team_foreign_key'))
                ->where('name', $roleName)->where('guard_name', 'web')->first()
                ?? Role::create(['name' => $roleName, 'guard_name' => 'web', 'salon_id' => null]);

            $role->syncPermissions(PermissionCatalog::permissionsFor($roleName));
        }

        $registrar->forgetCachedPermissions();
        setPermissionsTeamId($previousTeam);
    }
}
