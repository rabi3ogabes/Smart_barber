<?php

use App\Modules\Booking\Http\Controllers\Api\CustomerBookingController;
use App\Modules\Booking\Http\Controllers\Api\CustomerHomeController;
use App\Modules\Booking\Http\Controllers\Api\CustomerReviewController;
use App\Modules\Booking\Http\Controllers\Api\PublicSlotsController;
use App\Modules\Booking\Http\Controllers\Api\StaffBookingController;
use Illuminate\Support\Facades\Route;

/*
| Booking API (api-map.md → Phase 4). Create and reschedule REQUIRE an Idempotency-Key (rule 6).
*/
Route::get('branches/{branch}/slots', PublicSlotsController::class)->middleware('throttle:api')->name('api.branches.slots');

Route::prefix('customer')->name('api.customer.')->middleware(['auth:customer', 'throttle:api'])->group(function (): void {
    Route::post('quotes', [CustomerBookingController::class, 'quote'])->name('quotes');
    Route::get('bookings', [CustomerBookingController::class, 'index'])->name('bookings.index');
    Route::post('bookings', [CustomerBookingController::class, 'store'])->middleware('idempotent')->name('bookings.store');
    Route::get('bookings/{booking}', [CustomerBookingController::class, 'show'])->name('bookings.show');
    Route::get('bookings/{booking}/calendar.ics', [CustomerBookingController::class, 'calendar'])->name('bookings.calendar');
    Route::post('bookings/{booking}/reschedule', [CustomerBookingController::class, 'reschedule'])->middleware('idempotent')->name('bookings.reschedule');
    Route::post('bookings/{booking}/cancel', [CustomerBookingController::class, 'cancel'])->middleware('idempotent:optional')->name('bookings.cancel');
    // Phase 5: "Rate your visit" (the unique booking index already makes a repeat harmless) and the app home.
    Route::post('bookings/{booking}/review', [CustomerReviewController::class, 'store'])->middleware('idempotent:optional')->name('bookings.review');
    Route::get('salons', [CustomerHomeController::class, 'salons'])->name('salons');
    Route::get('home', [CustomerHomeController::class, 'home'])->name('home');
});

Route::prefix('staff')->name('api.staff.')->middleware(['auth:staff', 'tenant.token', 'throttle:api'])->group(function (): void {
    Route::get('bookings', [StaffBookingController::class, 'index'])->name('bookings.index');
    Route::post('bookings', [StaffBookingController::class, 'store'])->middleware('idempotent')->name('bookings.store');
    Route::get('bookings/{booking}', [StaffBookingController::class, 'show'])->name('bookings.show');
    Route::post('bookings/{booking}/reschedule', [StaffBookingController::class, 'reschedule'])->middleware('idempotent')->name('bookings.reschedule');
    Route::post('bookings/{booking}/cancel', [StaffBookingController::class, 'cancel'])->middleware('idempotent:optional')->name('bookings.cancel');
    Route::post('bookings/{booking}/{action}', [StaffBookingController::class, 'transition'])->whereIn('action', ['confirm', 'arrive', 'start', 'complete', 'no-show'])->middleware('idempotent:optional')->name('bookings.transition');
});
