<?php

use App\Modules\Customer\Http\Controllers\Api\StaffCustomerController;
use Illuminate\Support\Facades\Route;

Route::prefix('staff')->name('api.staff.')->middleware(['auth:staff', 'tenant.token', 'throttle:api'])->group(function (): void {
    Route::get('customers', [StaffCustomerController::class, 'index'])->name('customers.index');
    Route::post('customers', [StaffCustomerController::class, 'store'])->middleware('idempotent:optional')->name('customers.store');
});
