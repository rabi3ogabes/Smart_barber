<?php

use App\Modules\Catalog\Http\Controllers\Api\PublicCatalogController;
use Illuminate\Support\Facades\Route;

/*
| Public catalog for the customer app (api-map.md → Phase 3).
*/
Route::middleware('throttle:api')->group(function (): void {
    Route::get('branches/{branch}/service-categories', [PublicCatalogController::class, 'categories'])->name('api.catalog.categories');
    Route::get('branches/{branch}/services', [PublicCatalogController::class, 'services'])->name('api.catalog.services');
    Route::get('branches/{branch}/services/{service}', [PublicCatalogController::class, 'service'])->name('api.catalog.service');
});
