<?php

use App\Modules\Customer\Http\Controllers\Web\CustomerLookupController;
use Illuminate\Support\Facades\Route;

Route::get('customers/search', [CustomerLookupController::class, 'search'])->name('customers.search');
Route::post('customers', [CustomerLookupController::class, 'store'])->name('customers.store');
