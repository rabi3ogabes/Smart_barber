<?php

namespace App\Modules\Catalog\Models;

use App\Core\Audit\Auditable;
use App\Core\Money\Money;
use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use App\Modules\Catalog\Enums\TaxClass;
use Database\Factories\ServiceFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Translatable\HasTranslations;

/**
 * A bookable service. Prices are read through PricingService only; basePrice() is the raw
 * catalog value, never a customer price.
 *
 * @property int $id
 * @property string $public_id
 * @property int $salon_id
 * @property int $category_id
 * @property int|null $image_media_id
 * @property int $base_price minor units
 * @property int $duration_minutes
 * @property int $buffer_minutes
 * @property TaxClass $tax_class
 * @property bool $is_active
 * @property bool $is_bookable_online
 * @property int $sort_order
 */
class Service extends Model
{
    use Auditable, BelongsToSalon, HasPublicId, HasTranslations, PricedInSalonCurrency, SoftDeletes;

    /** @use HasFactory<ServiceFactory> */
    use HasFactory;

    /** @var list<string> */
    public array $translatable = ['name', 'description'];

    /** Mirrors the column defaults so new models are complete before a refresh. */
    protected $attributes = ['buffer_minutes' => 0, 'tax_class' => 'standard', 'is_active' => true, 'is_bookable_online' => true, 'sort_order' => 0];

    protected $fillable = ['category_id', 'name', 'description', 'image_media_id', 'base_price', 'duration_minutes', 'buffer_minutes', 'tax_class', 'is_active', 'is_bookable_online', 'sort_order'];

    protected function casts(): array
    {
        return [
            'base_price' => 'integer',
            'duration_minutes' => 'integer',
            'buffer_minutes' => 'integer',
            'tax_class' => TaxClass::class,
            'is_active' => 'boolean',
            'is_bookable_online' => 'boolean',
            'sort_order' => 'integer',
        ];
    }

    public function basePrice(): Money
    {
        return $this->money($this->base_price) ?? throw new \LogicException('Service without base price.');
    }

    /**
     * @return BelongsTo<ServiceCategory, $this>
     */
    public function category(): BelongsTo
    {
        return $this->belongsTo(ServiceCategory::class, 'category_id');
    }

    /**
     * @return HasMany<BranchService, $this>
     */
    public function branchSettings(): HasMany
    {
        return $this->hasMany(BranchService::class);
    }

    /**
     * @return HasMany<BarberService, $this>
     */
    public function barberSettings(): HasMany
    {
        return $this->hasMany(BarberService::class);
    }

    /**
     * @return BelongsToMany<ServiceAddon, $this>
     */
    public function addons(): BelongsToMany
    {
        return $this->belongsToMany(ServiceAddon::class, 'service_addon_service')->withPivot('salon_id')->withTimestamps();
    }
}
