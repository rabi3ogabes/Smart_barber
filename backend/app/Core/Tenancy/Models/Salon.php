<?php

namespace App\Core\Tenancy\Models;

use App\Core\Support\HasPublicId;
use Database\Factories\SalonFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Translatable\HasTranslations;

/**
 * The tenant root. Not itself tenant-scoped.
 *
 * @property int $id
 * @property string $public_id
 * @property string $slug
 * @property string $currency
 * @property string $timezone
 * @property string $default_locale
 * @property string $country
 * @property string $status
 */
class Salon extends Model
{
    /** @use HasFactory<SalonFactory> */
    use HasFactory, HasPublicId, HasTranslations, SoftDeletes;

    public const STATUS_ACTIVE = 'active';

    public const STATUS_SUSPENDED = 'suspended';

    public const STATUS_CLOSED = 'closed';

    /** Sub-domains that can never be salon slugs. */
    public const RESERVED_SLUGS = ['admin', 'www', 'api', 'app', 'mail', 'static', 'assets', 'cdn', 'help', 'status', 'docs', 'support', 'billing'];

    /** @var list<string> */
    public array $translatable = ['name'];

    protected $fillable = ['slug', 'name', 'currency', 'timezone', 'default_locale', 'country', 'status'];

    /**
     * @return HasMany<Branch, $this>
     */
    public function branches(): HasMany
    {
        return $this->hasMany(Branch::class);
    }

    public function isActive(): bool
    {
        return $this->status === self::STATUS_ACTIVE;
    }
}
