<?php

use App\Modules\Staff\Http\Controllers\Web\BarberProfileController;
use App\Modules\Staff\Http\Controllers\Web\ScheduleController;
use App\Modules\Staff\Http\Controllers\Web\StaffController;
use App\Modules\Staff\Http\Controllers\Web\TimeOffController;
use Illuminate\Support\Facades\Route;

/*
| Staff module dashboard routes. Loaded inside the salon subdomain group (auth, membership, 2FA).
*/
Route::get('staff', [StaffController::class, 'index'])->middleware('can:staff.view')->name('staff.index');
Route::post('staff/invitations', [StaffController::class, 'invite'])->name('staff.invite');
Route::post('staff/invitations/{invitation}/resend', [StaffController::class, 'resendInvitation'])->name('staff.invitations.resend');
Route::delete('staff/invitations/{invitation}', [StaffController::class, 'revokeInvitation'])->name('staff.invitations.revoke');
Route::put('staff/{member}/access', [StaffController::class, 'updateAccess'])->name('staff.access');
Route::put('staff/{member}/status', [StaffController::class, 'status'])->name('staff.status');
Route::post('barbers/{barber}/profile', [BarberProfileController::class, 'update'])->name('barbers.profile');

Route::get('schedules', [ScheduleController::class, 'index'])->middleware('can:schedule.view')->name('schedules.index');
Route::put('schedules/{barber}', [ScheduleController::class, 'update'])->name('schedules.update');
Route::post('schedules/{barber}/overrides', [ScheduleController::class, 'storeOverride'])->name('schedules.overrides.store');
Route::delete('schedule-overrides/{override}', [ScheduleController::class, 'destroyOverride'])->name('schedules.overrides.destroy');

Route::get('time-off', [TimeOffController::class, 'index'])->name('time-off.index');
Route::post('time-off', [TimeOffController::class, 'store'])->name('time-off.store');
Route::put('time-off/{timeOff}/decision', [TimeOffController::class, 'decide'])->name('time-off.decide');
Route::put('time-off/{timeOff}/cancel', [TimeOffController::class, 'cancel'])->name('time-off.cancel');
