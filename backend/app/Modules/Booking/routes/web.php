<?php

use App\Modules\Booking\Http\Controllers\Web\BookingController;
use App\Modules\Booking\Http\Controllers\Web\CalendarController;
use Illuminate\Support\Facades\Route;

/*
| Booking dashboard routes (inside the salon subdomain group: auth, membership, 2FA).
| JSON endpoints answer the API envelope, including 409 BOOKING_SLOT_TAKEN for drag & drop.
*/
Route::get('calendar', [CalendarController::class, 'index'])->middleware('can:booking.view')->name('calendar');
Route::get('calendar/events', [CalendarController::class, 'events'])->name('calendar.events');
Route::get('calendar/slots', [CalendarController::class, 'slots'])->name('calendar.slots');
Route::post('calendar/quote', [CalendarController::class, 'quote'])->name('calendar.quote');

Route::get('bookings', [BookingController::class, 'index'])->middleware('can:booking.view')->name('bookings.index');
Route::post('bookings', [BookingController::class, 'store'])->name('bookings.store');
Route::get('bookings/{booking}', [BookingController::class, 'show'])->name('bookings.show');
Route::put('bookings/{booking}/reschedule', [BookingController::class, 'reschedule'])->name('bookings.reschedule');
Route::put('bookings/{booking}/cancel', [BookingController::class, 'cancel'])->name('bookings.cancel');
Route::put('bookings/{booking}/{action}', [BookingController::class, 'transition'])->whereIn('action', ['confirm', 'arrive', 'start', 'complete', 'no-show'])->name('bookings.transition');
