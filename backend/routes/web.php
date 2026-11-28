<?php

use App\Core\Audit\Http\AuditLogController;
use App\Core\Identity\Http\Controllers\Web\DashboardController;
use App\Core\Identity\Http\Controllers\Web\DevComponentsController;
use App\Core\Identity\Http\Controllers\Web\PasswordResetController;
use App\Core\Identity\Http\Controllers\Web\PreferencesController;
use App\Core\Identity\Http\Controllers\Web\StaffSessionController;
use App\Core\Platform\Http\Controllers\PlatformHomeController;
use App\Core\Platform\Http\Controllers\PlatformSessionController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

$domain = config('smartbarber.domain');
$adminHost = config('smartbarber.admin_subdomain').'.'.$domain;

/*
| Super Admin console — admin.{domain}. Registered before the salon wildcard so "admin"
| never resolves as a salon slug (it is also a reserved slug).
*/
Route::domain($adminHost)->name('platform.')->group(function (): void {
    Route::middleware('guest:platform')->group(function (): void {
        Route::get('login', [PlatformSessionController::class, 'showLogin'])->name('login');
        Route::post('login', [PlatformSessionController::class, 'login'])->middleware('throttle:login')->name('login.store');
        Route::get('two-factor/challenge', [PlatformSessionController::class, 'showChallenge'])->name('two-factor.challenge');
        Route::post('two-factor/challenge', [PlatformSessionController::class, 'challenge'])->middleware('throttle:login');
    });

    Route::middleware('auth:platform')->group(function (): void {
        Route::get('two-factor/setup', [PlatformSessionController::class, 'showSetup'])->name('two-factor.setup');
        Route::post('two-factor/setup', [PlatformSessionController::class, 'confirmSetup'])->name('two-factor.confirm');
        Route::post('logout', [PlatformSessionController::class, 'logout'])->name('logout');
        Route::post('locale', [PreferencesController::class, 'locale'])->name('locale');

        Route::middleware('two-factor.enrolled:platform.two-factor.setup')->group(function (): void {
            Route::get('/', PlatformHomeController::class)->name('home');
        });
    });
});

/*
| Salon dashboard — {slug}.{domain}. The tenant comes from the subdomain only (ADR-001).
*/
Route::domain('{salon_slug}.'.$domain)
    ->where(['salon_slug' => '[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?'])
    ->middleware('tenant.subdomain')
    ->group(function (): void {
        Route::post('locale', [PreferencesController::class, 'locale'])->name('locale');
        require base_path('app/Modules/Staff/routes/public.php');

        Route::middleware('guest:web')->group(function (): void {
            Route::get('login', [StaffSessionController::class, 'showLogin'])->name('login');
            Route::post('login', [StaffSessionController::class, 'login'])->middleware('throttle:login')->name('login.store');
            Route::get('two-factor/challenge', [StaffSessionController::class, 'showChallenge'])->name('two-factor.challenge');
            Route::post('two-factor/challenge', [StaffSessionController::class, 'challenge'])->middleware('throttle:login');
            Route::get('forgot-password', [PasswordResetController::class, 'showRequest'])->name('password.request');
            Route::post('forgot-password', [PasswordResetController::class, 'sendLink'])->middleware('throttle:login')->name('password.email');
            Route::get('reset-password/{token}', [PasswordResetController::class, 'showReset'])->name('password.reset');
            Route::post('reset-password', [PasswordResetController::class, 'reset'])->middleware('throttle:login')->name('password.update');
        });

        Route::middleware(['auth:web', 'tenant.member'])->group(function (): void {
            Route::post('logout', [StaffSessionController::class, 'logout'])->name('logout');
            Route::get('two-factor/setup', [StaffSessionController::class, 'showSetup'])->name('two-factor.setup');
            Route::post('two-factor/setup', [StaffSessionController::class, 'confirmSetup'])->name('two-factor.confirm');

            Route::middleware('two-factor.enrolled')->group(function (): void {
                Route::get('/', DashboardController::class)->middleware('can:dashboard.view')->name('dashboard');
                Route::post('branch', [PreferencesController::class, 'branch'])->name('branch.switch');
                Route::get('dev/components', DevComponentsController::class)->name('dev.components');
                Route::get('audit-log', AuditLogController::class)->middleware('can:audit_log.view')->name('audit-log');

                // Module routes (modules.md): each module owns its dashboard routes.
                require base_path('app/Modules/Salon/routes/web.php');
                require base_path('app/Modules/Staff/routes/web.php');
                require base_path('app/Modules/Catalog/routes/web.php');
                require base_path('app/Modules/Customer/routes/web.php');
                require base_path('app/Modules/Booking/routes/web.php');
            });
        });
    });

/*
| Root domain: a neutral entry page. Salons are reached through their own subdomain.
*/
Route::domain($domain)->group(function (): void {
    Route::get('/', fn () => Inertia::render('Welcome'))->name('welcome');
});
