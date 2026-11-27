<?php

namespace App\Core\Identity\Models;

use App\Core\Identity\Services\TwoFactorUser;
use Database\Factories\PlatformAdminFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Support\Carbon;

/**
 * Super Admin identity (platform guard). Has no implicit access inside a salon.
 *
 * @property int $id
 * @property string $name
 * @property string $email
 * @property string|null $two_factor_secret
 * @property string|null $two_factor_recovery_codes
 * @property Carbon|null $two_factor_confirmed_at
 */
class PlatformAdmin extends Authenticatable implements TwoFactorUser
{
    /** @use HasFactory<PlatformAdminFactory> */
    use HasFactory;

    protected $fillable = ['name', 'email', 'password'];

    protected $hidden = ['password', 'remember_token', 'two_factor_secret', 'two_factor_recovery_codes'];

    protected function casts(): array
    {
        return [
            'password' => 'hashed',
            'two_factor_secret' => 'encrypted',
            'two_factor_recovery_codes' => 'encrypted',
            'two_factor_confirmed_at' => 'datetime',
            'last_login_at' => 'datetime',
        ];
    }

    public function requiresTwoFactor(): bool
    {
        return true;
    }

    public function hasTwoFactorEnabled(): bool
    {
        // Raw attributes: also safe on partially loaded models under strict mode.
        return ($this->attributes['two_factor_secret'] ?? null) !== null
            && ($this->attributes['two_factor_confirmed_at'] ?? null) !== null;
    }
}
