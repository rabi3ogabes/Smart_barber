<?php

use App\Modules\Staff\Http\Controllers\Api\PublicBarbersController;
use App\Modules\Staff\Http\Controllers\Api\StaffScheduleApiController;
use Illuminate\Support\Facades\Route;

Route::get('branches/{branch}/barbers', PublicBarbersController::class)->middleware('throttle:api')->name('api.branches.barbers');

Route::prefix('staff')->name('api.staff.')->middleware(['auth:staff', 'tenant.token', 'throttle:api'])->group(function (): void {
    Route::get('schedule', [StaffScheduleApiController::class, 'schedule'])->name('schedule');
    Route::get('time-off', [StaffScheduleApiController::class, 'timeOff'])->name('time-off');
    Route::post('time-off', [StaffScheduleApiController::class, 'requestTimeOff'])->middleware('idempotent:optional')->name('time-off.store');
    Route::post('time-off/{timeOff}/cancel', [StaffScheduleApiController::class, 'cancel'])->name('time-off.cancel');
});
