<?php

use App\Core\Authorization\PermissionCatalog;
use Illuminate\Support\Facades\Route;

/*
| Route × role matrix generated from the permission catalog (permissions.md → Tests).
| Every dashboard route guarded by `can:{permission}` is requested by every role:
| roles with the permission get through, the rest get 403.
*/
it('enforces the permission matrix on every guarded dashboard route', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();

    $routes = collect(Route::getRoutes()->getRoutes())
        ->filter(fn ($r) => in_array('GET', $r->methods(), true))
        ->map(fn ($r) => [$r, collect($r->gatherMiddleware())->first(fn ($m) => is_string($m) && str_starts_with($m, 'can:'))])
        ->filter(fn ($pair) => $pair[1] !== null);

    expect($routes)->not->toBeEmpty();

    foreach (PermissionCatalog::ROLES as $role) {
        $user = $this->memberOf($salon, $role, [$branch]);
        $this->enableTwoFactor($user);

        foreach ($routes as [$route, $middleware]) {
            $permission = substr($middleware, 4);
            $allowed = PermissionCatalog::scope($role, $permission) !== null;

            $this->actingAs($user, 'web')
                ->get($this->salonUrl($salon, '/'.ltrim($route->uri(), '/')))
                ->assertStatus($allowed ? 200 : 403);
        }
    }
});
