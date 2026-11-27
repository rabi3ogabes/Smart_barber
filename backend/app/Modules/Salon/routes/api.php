<?php

use App\Modules\Salon\Http\Controllers\Api\PublicSalonController;
use Illuminate\Support\Facades\Route;

/*
| Salon module /api/v1 routes (public reads for the customer app).
*/
Route::middleware('throttle:api')->group(function (): void {
    Route::get('salons/{salon}', [PublicSalonController::class, 'show'])->name('api.salons.show');
    Route::get('salons/{salon}/branches', [PublicSalonController::class, 'branches'])->name('api.salons.branches');
    Route::get('branches/{branch}', [PublicSalonController::class, 'branch'])->name('api.branches.show');
});
