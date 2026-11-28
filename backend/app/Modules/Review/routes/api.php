<?php

use App\Modules\Review\Http\Controllers\Api\CustomerReviewController;
use Illuminate\Support\Facades\Route;

/*
| "Rate your visit" (api-map.md → Phase 5). Idempotency-Key optional: the unique booking index
| already makes a repeat harmless.
*/
Route::prefix('customer')->name('api.customer.')->middleware(['auth:customer', 'throttle:api'])->group(function (): void {
    Route::post('bookings/{booking}/review', [CustomerReviewController::class, 'store'])->middleware('idempotent:optional')->name('bookings.review');
});
