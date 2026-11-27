<?php

namespace App\Core\Tenancy\Models;

use App\Core\Audit\Auditable;
use App\Core\Money\Money;
use App\Core\Money\MoneyCast;
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
 * @property int|null $logo_media_id
 * @property int|null $cover_media_id
 * @property Money $no_show_fee_amount
 */
class Salon extends Model
{
    /** @use HasFactory<SalonFactory> */
    use Auditable, HasFactory, HasPublicId, HasTranslations, SoftDeletes;

    public const STATUS_ACTIVE = 'active';

    public const STATUS_SUSPENDED = 'suspended';

    public const STATUS_CLOSED = 'closed';

    /** Sub-domains that can never be salon slugs. */
    public const RESERVED_SLUGS = ['admin', 'www', 'api', 'app', 'mail', 'static', 'assets', 'cdn', 'help', 'status', 'docs', 'support', 'billing'];

    /** @var list<string> */
    public array $translatable = ['name'];

    protected $fillable = [
        'slug', 'name', 'legal_name', 'currency', 'timezone', 'default_locale', 'country', 'status',
        'tax_number', 'tax_rate_bp', 'prices_include_tax', 'contact_phone', 'contact_email', 'social_links',
        'lead_time_minutes', 'max_days_ahead', 'cancellation_window_minutes', 'no_show_fee_amount',
    ];

    protected function casts(): array
    {
        return [
            'social_links' => 'array',
            'prices_include_tax' => 'boolean',
            'tax_rate_bp' => 'integer',
            'lead_time_minutes' => 'integer',
            'max_days_ahead' => 'integer',
            'cancellation_window_minutes' => 'integer',
            'no_show_fee_amount' => MoneyCast::class.':currency',
        ];
    }

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
