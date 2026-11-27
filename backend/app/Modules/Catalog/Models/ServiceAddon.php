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
 * An extra on top of a service (e.g. hot towel, black mask). Only offered with the services
 * it is linked to.
 *
 * @property int $id
 * @property string $public_id
 * @property int $salon_id
 * @property int $price minor units
 * @property int $extra_minutes
 * @property TaxClass $tax_class
 * @property bool $is_active
 */
class ServiceAddon extends Model
{
    use Auditable, BelongsToSalon, HasPublicId, HasTranslations, PricedInSalonCurrency, SoftDeletes;

    /** @var list<string> */
    public array $translatable = ['name'];

    /** Mirrors the column defaults so new models are complete before a refresh. */
    protected $attributes = ['extra_minutes' => 0, 'tax_class' => 'standard', 'is_active' => true];

    protected $fillable = ['name', 'price', 'extra_minutes', 'tax_class', 'is_active'];

    protected function casts(): array
    {
        return ['price' => 'integer', 'extra_minutes' => 'integer', 'tax_class' => TaxClass::class, 'is_active' => 'boolean'];
    }

    public function priceMoney(): Money
    {
        return $this->money($this->price) ?? throw new \LogicException('Add-on without price.');
    }

    /**
     * @return BelongsToMany<Service, $this>
     */
    public function services(): BelongsToMany
    {
        return $this->belongsToMany(Service::class, 'service_addon_service')->withPivot('salon_id')->withTimestamps();
    }

    /**
     * @param  list<int>  $serviceIds
     */
    public function syncServices(array $serviceIds): void
    {
        $this->services()->sync(collect($serviceIds)->mapWithKeys(fn (int $id) => [$id => ['salon_id' => $this->salon_id]])->all());
    }
}
