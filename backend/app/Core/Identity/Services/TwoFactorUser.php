<?php

namespace App\Core\Identity\Services;

use Illuminate\Support\Carbon;

/**
 * An identity that can enrol in TOTP two-factor authentication.
 *
 * @property string|null $two_factor_secret
 * @property string|null $two_factor_recovery_codes
 * @property Carbon|null $two_factor_confirmed_at
 */
interface TwoFactorUser
{
    public function requiresTwoFactor(): bool;

    public function hasTwoFactorEnabled(): bool;
}
