<?php

use App\Modules\Salon\Http\Controllers\Web\BranchController;
use App\Modules\Salon\Http\Controllers\Web\SalonSettingsController;
use Illuminate\Support\Facades\Route;

/*
| Salon module dashboard routes. Loaded inside the salon subdomain group (auth, membership, 2FA).
*/
Route::get('settings/salon', [SalonSettingsController::class, 'show'])->middleware('can:salon.settings.view')->name('settings.salon');
Route::put('settings/salon', [SalonSettingsController::class, 'update'])->name('settings.salon.update');
Route::post('settings/salon/images/{kind}', [SalonSettingsController::class, 'uploadImage'])->name('settings.salon.image');

Route::get('branches', [BranchController::class, 'index'])->middleware('can:branch.view')->name('branches.index');
Route::post('branches', [BranchController::class, 'store'])->name('branches.store');
Route::put('branches/{branch}', [BranchController::class, 'update'])->name('branches.update');
Route::put('branches/{branch}/status', [BranchController::class, 'status'])->name('branches.status');
Route::post('closures', [BranchController::class, 'storeClosure'])->name('closures.store');
Route::delete('closures/{closure}', [BranchController::class, 'destroyClosure'])->name('closures.destroy');
