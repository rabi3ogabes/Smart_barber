<?php

use App\Core\Authorization\SyncRolesAndPermissions;
use App\Core\Tenancy\Models\Salon;
use Database\Seeders\DemoSalonBuilder;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schedule;
use Illuminate\Support\Str;

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

// A hosted demo salon (e.g. on a staging server): the same data as the local demo, but every
// account gets a strong random password, printed once. Refuses a slug that already exists.
Artisan::command('smartbarber:demo-salon {slug} {--en=Smart Barber} {--ar=سمارت باربر} {--branch-en=West Bay} {--branch-ar=فرع الخليج الغربي}', function (string $slug): int {
    if (Salon::query()->where('slug', $slug)->exists()) {
        $this->error("A salon with the slug [{$slug}] already exists.");

        return 1;
    }
    app(SyncRolesAndPermissions::class)();
    $accounts = (new DemoSalonBuilder)->build(
        ['slug' => $slug, 'ar' => (string) $this->option('ar'), 'en' => (string) $this->option('en'), 'branch_ar' => (string) $this->option('branch-ar'), 'branch_en' => (string) $this->option('branch-en')],
        fn (string $role) => "{$role}@{$slug}.demo",
        fn () => Str::password(16, symbols: false),
    );
    $this->table(['Role', 'Name', 'Email', 'Password'], array_map(fn ($a) => [$a['role'], $a['name'], $a['email'], $a['password']], $accounts));
    $this->warn('Passwords are shown once. Owners set up two-factor authentication on first sign-in.');

    return 0;
})->purpose('Create a demo salon with random passwords (staging/demo servers)');

Schedule::command('idempotency:prune')->hourly()->onOneServer();
Schedule::command('auth:prune-tokens')->daily()->onOneServer();
Schedule::command('horizon:snapshot')->everyFiveMinutes();
