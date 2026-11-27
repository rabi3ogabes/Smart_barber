<?php

return [
    // Root domain. Salons live on {slug}.{domain}; Super Admin on {admin_subdomain}.{domain}.
    'domain' => env('APP_DOMAIN', 'smartbarber.test'),
    'admin_subdomain' => env('APP_ADMIN_SUBDOMAIN', 'admin'),

    'locales' => ['ar', 'en'],
    'default_locale' => 'ar',

    'tokens' => [
        'access_ttl_minutes' => (int) env('ACCESS_TOKEN_TTL', 60),
        'refresh_ttl_days' => (int) env('REFRESH_TOKEN_TTL_DAYS', 60),
        'challenge_ttl_minutes' => 5,
    ],

    'otp' => [
        'length' => 6,
        'ttl_minutes' => 5,
        'max_attempts' => 5,
        'max_sends' => 3,
        'send_window_minutes' => 15,
        'resend_after_seconds' => 60,
    ],

    'idempotency' => [
        'ttl_hours' => 24,
        'max_key_length' => 100,
    ],

    // Roles that must use TOTP two-factor authentication.
    'two_factor_required_roles' => ['owner', 'general_manager'],
];
