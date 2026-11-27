<?php

namespace App\Modules\Catalog\Models;

use App\Core\Audit\Auditable;
use App\Core\Money\Money;
use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use App\Modules\Catalog\Enums\TaxClass;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Translatable\HasTranslations;

/**
 * Several services sold together at one price (e.g. Hair + Beard). Duration is the sum of the
 * items' durations for the chosen barber.
 *
 * @property int $id
 * @property string $public_id
 * @property int $salon_id
 * @property int $price minor units
 * @property TaxClass $tax_class
 * @property bool $is_active
 * @property int $sort_order
 */
class ServiceBundle extends Model
{
    use Auditable, BelongsToSalon, HasPublicId, HasTranslations, PricedInSalonCurrency, SoftDeletes;

    /** @var list<string> */
    public array $translatable = ['name', 'description'];

    /** Mirrors the column defaults so new models are complete before a refresh. */
    protected $attributes = ['tax_class' => 'standard', 'is_active' => true, 'sort_order' => 0];

    protected $fillable = ['name', 'description', 'price', 'tax_class', 'is_active', 'sort_order'];

    protected function casts(): array
    {
        return ['price' => 'integer', 'tax_class' => TaxClass::class, 'is_active' => 'boolean', 'sort_order' => 'integer'];
    }

    public function priceMoney(): Money
    {
        return $this->money($this->price) ?? throw new \LogicException('Bundle without price.');
    }

    /**
     * @return BelongsToMany<Service, $this>
     */
    public function services(): BelongsToMany
    {
        return $this->belongsToMany(Service::class, 'service_bundle_items', 'bundle_id')->withPivot(['salon_id', 'sort_order'])->orderByPivot('sort_order')->withTimestamps();
    }

    /**
     * @param  list<int>  $serviceIds  in display order
     */
    public function syncServices(array $serviceIds): void
    {
        $this->services()->sync(collect($serviceIds)->values()->mapWithKeys(fn (int $id, int $i) => [$id => ['salon_id' => $this->salon_id, 'sort_order' => $i]])->all());
    }
}
