<?php

namespace App\Modules\Catalog\Models;

use App\Core\Audit\Auditable;
use App\Core\Money\Money;
use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;

/**
 * Per-branch availability and price override. No row means: available at the base price.
 *
 * @property int $id
 * @property int $salon_id
 * @property int $branch_id
 * @property int $service_id
 * @property bool $is_available
 * @property int|null $price_override minor units
 */
class BranchService extends Model
{
    use Auditable, BelongsToSalon, PricedInSalonCurrency;

    protected $table = 'branch_service';

    /** Mirrors the column defaults so new models are complete before a refresh. */
    protected $attributes = ['is_available' => true];

    protected $fillable = ['branch_id', 'service_id', 'is_available', 'price_override'];

    protected function casts(): array
    {
        return ['is_available' => 'boolean', 'price_override' => 'integer'];
    }

    public function priceOverride(): ?Money
    {
        return $this->money($this->price_override);
    }
}
