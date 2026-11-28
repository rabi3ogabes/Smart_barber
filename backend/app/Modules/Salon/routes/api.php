<?php

use App\Modules\Salon\Http\Controllers\Api\PublicSalonController;
use App\Modules\Salon\Http\Controllers\Api\SalonDirectoryController;
use Illuminate\Support\Facades\Route;

/*
| Salon module /api/v1 routes (public reads for the customer app).
*/
Route::middleware('throttle:api')->group(function (): void {
    // Static paths first so they are not taken for a salon slug.
    Route::get('salons/search', [SalonDirectoryController::class, 'search'])->name('api.salons.search');
    Route::get('salons/resolve', [SalonDirectoryController::class, 'resolve'])->name('api.salons.resolve');
    Route::get('salons/{salon}', [PublicSalonController::class, 'show'])->name('api.salons.show');
    Route::get('salons/{salon}/branches', [PublicSalonController::class, 'branches'])->name('api.salons.branches');
    Route::get('branches/{branch}', [PublicSalonController::class, 'branch'])->name('api.branches.show');
});
