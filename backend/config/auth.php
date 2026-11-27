<?php

use App\Core\Identity\Models\CustomerAccount;
use App\Core\Identity\Models\PlatformAdmin;
use App\Core\Identity\Models\User;

/*
 * Identities and guards (ADR-002):
 *  - web      : salon staff, session on {slug}.{domain} (dashboard)
 *  - platform : Super Admin, session on admin.{domain}
 *  - staff    : salon staff, Sanctum tokens bound to one salon (staff app)
 *  - customer : customer accounts, Sanctum tokens (customer app)
 */
return [

    'defaults' => [
        'guard' => env('AUTH_GUARD', 'web'),
        'passwords' => env('AUTH_PASSWORD_BROKER', 'users'),
    ],

    'guards' => [
        'web' => ['driver' => 'session', 'provider' => 'users'],
        'platform' => ['driver' => 'session', 'provider' => 'platform_admins'],
        'staff' => ['driver' => 'sanctum', 'provider' => 'users'],
        'customer' => ['driver' => 'sanctum', 'provider' => 'customer_accounts'],
    ],

    'providers' => [
        'users' => ['driver' => 'eloquent', 'model' => User::class],
        'platform_admins' => ['driver' => 'eloquent', 'model' => PlatformAdmin::class],
        'customer_accounts' => ['driver' => 'eloquent', 'model' => CustomerAccount::class],
    ],

    'passwords' => [
        'users' => [
            'provider' => 'users',
            'table' => env('AUTH_PASSWORD_RESET_TOKEN_TABLE', 'password_reset_tokens'),
            'expire' => 60,
            'throttle' => 60,
        ],
    ],

    'password_timeout' => env('AUTH_PASSWORD_TIMEOUT', 10800),

];
