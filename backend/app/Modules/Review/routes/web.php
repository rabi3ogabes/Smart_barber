<?php

use App\Modules\Review\Http\Controllers\Web\ReviewController;
use Illuminate\Support\Facades\Route;

/*
| Review moderation (spec-review item 6), inside the salon subdomain group.
*/
Route::get('reviews', [ReviewController::class, 'index'])->middleware('can:review.moderate')->name('reviews.index');
Route::put('reviews/{review}', [ReviewController::class, 'update'])->name('reviews.update');
