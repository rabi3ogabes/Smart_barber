<?php

use App\Modules\Catalog\Http\Controllers\Web\AddonController;
use App\Modules\Catalog\Http\Controllers\Web\BundleController;
use App\Modules\Catalog\Http\Controllers\Web\CatalogController;
use App\Modules\Catalog\Http\Controllers\Web\ServiceController;
use Illuminate\Support\Facades\Route;

/*
| Catalog dashboard routes. Loaded inside the salon subdomain group (auth, membership, 2FA).
*/
Route::get('services', [CatalogController::class, 'index'])->middleware('can:service.view')->name('services.index');
Route::post('service-categories', [CatalogController::class, 'storeCategory'])->name('categories.store');
Route::put('service-categories/order', [CatalogController::class, 'reorderCategories'])->name('categories.reorder');
Route::put('service-categories/{category}', [CatalogController::class, 'updateCategory'])->name('categories.update');
Route::delete('service-categories/{category}', [CatalogController::class, 'destroyCategory'])->name('categories.destroy');

Route::post('services', [ServiceController::class, 'store'])->name('services.store');
Route::put('services/{service}', [ServiceController::class, 'update'])->name('services.update');
Route::post('services/{service}/image', [ServiceController::class, 'image'])->name('services.image');
Route::put('services/{service}/branches/{branch}', [ServiceController::class, 'branchPricing'])->name('services.branch-pricing');
Route::put('services/{service}/barbers', [ServiceController::class, 'barbers'])->name('services.barbers');
Route::put('services/{service}/addons', [ServiceController::class, 'addons'])->name('services.addons');

Route::post('service-addons', [AddonController::class, 'store'])->name('addons.store');
Route::put('service-addons/{addon}', [AddonController::class, 'update'])->name('addons.update');
Route::post('service-bundles', [BundleController::class, 'store'])->name('bundles.store');
Route::put('service-bundles/{bundle}', [BundleController::class, 'update'])->name('bundles.update');
