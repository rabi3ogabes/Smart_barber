<?php

use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schedule;

Artisan::command('idempotency:prune', function (): void {
    $deleted = DB::table('idempotency_keys')->where('expires_at', '<=', now())->delete();
    $this->info("Pruned {$deleted} expired idempotency keys.");
})->purpose('Delete expired idempotency keys (24h TTL)');

Artisan::command('auth:prune-tokens', function (): void {
    $access = DB::table('personal_access_tokens')->where('expires_at', '<=', now()->subDay())->delete();
    $refresh = DB::table('refresh_tokens')->where('expires_at', '<=', now()->subDay())->delete();
    $otp = DB::table('otp_codes')->where('expires_at', '<=', now()->subDay())->delete();
    $this->info("Pruned {$access} access tokens, {$refresh} refresh tokens and {$otp} OTP codes.");
})->purpose('Delete expired tokens and OTP codes');

Schedule::command('idempotency:prune')->hourly()->onOneServer();
Schedule::command('auth:prune-tokens')->daily()->onOneServer();
Schedule::command('horizon:snapshot')->everyFiveMinutes();
