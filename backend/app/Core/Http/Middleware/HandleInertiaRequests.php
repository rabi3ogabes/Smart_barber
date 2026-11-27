<?php

namespace App\Core\Http\Middleware;

use App\Core\Authorization\Access;
use App\Core\Features\Feature;
use App\Core\Identity\Models\PlatformAdmin;
use App\Core\Identity\Models\User;
use App\Core\Navigation\Menu;
use App\Core\Tenancy\Tenancy;
use Illuminate\Http\Request;
use Inertia\Middleware;

/**
 * Shared props. Permissions and features are for display only; the server enforces all.
 */
final class HandleInertiaRequests extends Middleware
{
    protected $rootView = 'app';

    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    /**
     * @return array<string, mixed>
     */
    public function share(Request $request): array
    {
        $locale = app()->getLocale();
        $salon = Tenancy::current();
        $user = $request->user();

        return [
            ...parent::share($request),
            'locale' => $locale,
            'dir' => $locale === 'ar' ? 'rtl' : 'ltr',
            'appName' => config('app.name'),
            'flash' => [
                'success' => fn () => $request->session()->get('success'),
                'error' => fn () => $request->session()->get('error'),
            ],
            'salon' => $salon === null ? null : [
                'id' => $salon->public_id,
                'slug' => $salon->slug,
                'name' => $salon->getTranslation('name', $locale),
                'currency' => $salon->currency,
            ],
            'auth' => fn () => $this->auth($user, $request),
        ];
    }

    /**
     * @return array<string, mixed>|null
     */
    private function auth(mixed $user, Request $request): ?array
    {
        if ($user instanceof PlatformAdmin) {
            return ['type' => 'platform', 'user' => ['name' => $user->name, 'email' => $user->email]];
        }

        $salon = Tenancy::current();
        if (! $user instanceof User || $salon === null || Tenancy::membership() === null) {
            return $user instanceof User ? ['type' => 'staff', 'user' => ['name' => $user->name, 'email' => $user->email], 'permissions' => [], 'menu' => []] : null;
        }

        $branches = Access::visibleBranches($user);
        $current = $request->session()->get('branch_id');
        $currentBranch = $branches->firstWhere('public_id', $current) ?? $branches->first();

        return [
            'type' => 'staff',
            'user' => [
                'id' => $user->public_id,
                'name' => $user->name,
                'email' => $user->email,
                'two_factor_enabled' => $user->hasTwoFactorEnabled(),
            ],
            'roles' => Access::roles($user),
            'permissions' => Access::permissions($user),
            'features' => Feature::enabledFor($salon),
            'menu' => Menu::for($user, $salon),
            'branches' => $branches->map(fn ($b) => ['id' => $b->public_id, 'name' => $b->getTranslation('name', app()->getLocale())])->values(),
            'currentBranch' => $currentBranch?->public_id,
        ];
    }
}
