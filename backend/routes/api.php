<?php

use App\Core\Identity\Http\Controllers\Api\AppConfigController;
use App\Core\Identity\Http\Controllers\Api\CustomerAuthController;
use App\Core\Identity\Http\Controllers\Api\CustomerProfileController;
use App\Core\Identity\Http\Controllers\Api\DeviceController;
use App\Core\Identity\Http\Controllers\Api\StaffAuthController;
use App\Core\Identity\Http\Controllers\Api\StaffMeController;
use Illuminate\Support\Facades\Route;

/*
| /api/v1 — mobile API (docs/architecture/api-map.md). Envelope + error codes from App\Core\Http.
| Module routes register themselves from their ServiceProviders under the same prefix.
*/

Route::get('meta/app-config', AppConfigController::class)->name('api.meta.app-config');

// Customer app -----------------------------------------------------------------------------
Route::prefix('customer')->name('api.customer.')->group(function (): void {
    Route::middleware('throttle:otp')->group(function (): void {
        Route::post('auth/otp', [CustomerAuthController::class, 'requestOtp'])->name('auth.otp');
        Route::post('auth/otp/verify', [CustomerAuthController::class, 'verifyOtp'])->name('auth.otp.verify');
    });
    Route::post('auth/refresh', [CustomerAuthController::class, 'refresh'])->middleware('throttle:refresh')->name('auth.refresh');

    Route::middleware(['auth:customer', 'throttle:api'])->group(function (): void {
        Route::post('auth/logout', [CustomerAuthController::class, 'logout'])->name('auth.logout');
        Route::get('me', [CustomerProfileController::class, 'show'])->name('me');
        Route::patch('me', [CustomerProfileController::class, 'update'])->name('me.update');
        Route::post('me/avatar', [CustomerProfileController::class, 'avatar'])->name('me.avatar');
        Route::get('me/notification-preferences', [CustomerProfileController::class, 'notificationPreferences'])->name('me.notifications');
        Route::put('me/notification-preferences', [CustomerProfileController::class, 'updateNotificationPreferences'])->name('me.notifications.update');
        Route::post('me/deletion-request', [CustomerProfileController::class, 'requestDeletion'])->middleware('idempotent:optional')->name('me.deletion');
    });
});

// Staff app --------------------------------------------------------------------------------
Route::prefix('staff')->name('api.staff.')->group(function (): void {
    Route::middleware('throttle:login')->group(function (): void {
        Route::post('auth/login', [StaffAuthController::class, 'login'])->name('auth.login');
        Route::post('auth/2fa', [StaffAuthController::class, 'twoFactor'])->name('auth.2fa');
        Route::post('auth/select-salon', [StaffAuthController::class, 'selectSalon'])->name('auth.select-salon');
    });
    Route::post('auth/refresh', [StaffAuthController::class, 'refresh'])->middleware('throttle:refresh')->name('auth.refresh');

    Route::middleware(['auth:staff', 'tenant.token', 'throttle:api'])->group(function (): void {
        Route::post('auth/logout', [StaffAuthController::class, 'logout'])->name('auth.logout');
        Route::get('me', [StaffMeController::class, 'show'])->name('me');
        Route::get('me/salons', [StaffMeController::class, 'salons'])->name('me.salons');
        Route::post('devices', [DeviceController::class, 'store'])->name('devices.store');
        Route::delete('devices/{fcmToken}', [DeviceController::class, 'destroy'])->name('devices.destroy');
    });
});

// Customer devices (staff devices are registered under /staff so they carry the salon).
Route::middleware(['auth:customer', 'throttle:api'])->group(function (): void {
    Route::post('devices', [DeviceController::class, 'store'])->name('api.devices.store');
    Route::delete('devices/{fcmToken}', [DeviceController::class, 'destroy'])->name('api.devices.destroy');
});

// Module routes.
require base_path('app/Modules/Salon/routes/api.php');
require base_path('app/Modules/Staff/routes/api.php');
require base_path('app/Modules/Catalog/routes/api.php');
require base_path('app/Modules/Customer/routes/api.php');
require base_path('app/Modules/Booking/routes/api.php');
