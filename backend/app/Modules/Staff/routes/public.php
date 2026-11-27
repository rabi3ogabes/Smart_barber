<?php

use App\Modules\Staff\Http\Controllers\Web\InvitationAcceptController;
use Illuminate\Support\Facades\Route;

/*
| Public pages on the salon subdomain (no sign-in needed).
*/
Route::get('invitations/{token}', [InvitationAcceptController::class, 'show'])->where('token', '[A-Za-z0-9]{48}')->name('invitations.show');
Route::post('invitations/{token}', [InvitationAcceptController::class, 'accept'])->where('token', '[A-Za-z0-9]{48}')->middleware('throttle:login')->name('invitations.accept');
