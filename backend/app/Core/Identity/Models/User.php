<?php

namespace App\Core\Identity\Models;

use App\Core\Identity\Services\TwoFactorUser;
use App\Core\Support\HasPublicId;
use App\Core\Tenancy\Models\SalonMembership;
use App\Core\Tenancy\Tenancy;
use Database\Factories\UserFactory;
use Illuminate\Auth\Passwords\CanResetPassword;
use Illuminate\Contracts\Auth\CanResetPassword as CanResetPasswordContract;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Carbon;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;

/**
 * Salon staff identity (global). Access to a salon comes from a SalonMembership.
 *
 * @property int $id
 * @property string $public_id
 * @property string $name
 * @property string|null $email
 * @property string|null $phone
 * @property string $locale
 * @property string|null $two_factor_secret
 * @property string|null $two_factor_recovery_codes
 * @property Carbon|null $two_factor_confirmed_at
 * @property Carbon|null $last_login_at
 */
class User extends Authenticatable implements CanResetPasswordContract, TwoFactorUser
{
    /** @use HasFactory<UserFactory> */
    use CanResetPassword, HasApiTokens, HasFactory, HasPublicId, HasRoles, Notifiable, SoftDeletes;

    protected string $guard_name = 'web';

    protected $fillable = ['name', 'email', 'phone', 'password', 'locale'];

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

    /**
     * All memberships across salons (tenant scope bypassed: identity-level query).
     *
     * @return Collection<int, SalonMembership>
     */
    public function activeMemberships(): Collection
    {
        return Tenancy::bypass(fn () => SalonMembership::query()
            ->with('salon')
            ->where('user_id', $this->getKey())
            ->where('status', SalonMembership::STATUS_ACTIVE)
            ->whereHas('salon', fn ($q) => $q->where('status', 'active'))
            ->get());
    }

    /**
     * @return HasMany<SalonMembership, $this>
     */
    public function memberships(): HasMany
    {
        return $this->hasMany(SalonMembership::class);
    }

    public function membershipIn(int $salonId): ?SalonMembership
    {
        return Tenancy::bypass(fn () => SalonMembership::query()
            ->where('user_id', $this->getKey())
            ->where('salon_id', $salonId)
            ->first());
    }

    /**
     * Two-factor is mandatory when the user holds a required role in any salon (ADR-002).
     */
    public function requiresTwoFactor(): bool
    {
        $roles = config('smartbarber.two_factor_required_roles');
        $table = config('permission.table_names.model_has_roles');

        return DB::table($table)
            ->join(config('permission.table_names.roles'), 'roles.id', '=', "{$table}.role_id")
            ->where("{$table}.model_type", $this->getMorphClass())
            ->where("{$table}.model_id", $this->getKey())
            ->whereIn('roles.name', $roles)
            ->exists();
    }

    public function hasTwoFactorEnabled(): bool
    {
        // Raw attributes: also safe on partially loaded models under strict mode.
        return ($this->attributes['two_factor_secret'] ?? null) !== null
            && ($this->attributes['two_factor_confirmed_at'] ?? null) !== null;
    }
}
