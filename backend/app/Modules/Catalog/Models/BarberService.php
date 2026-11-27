<?php

namespace App\Modules\Catalog\Models;

use App\Core\Audit\Auditable;
use App\Core\Money\Money;
use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;

/**
 * A barber performs a service, optionally at their own price or duration (e.g. a senior barber
 * charges more). commission_rate_bp is a placeholder read by Phase 13.
 *
 * @property int $id
 * @property int $salon_id
 * @property int $barber_id
 * @property int $service_id
 * @property int|null $price_override minor units
 * @property int|null $duration_override minutes
 * @property int|null $commission_rate_bp
 */
class BarberService extends Model
{
    use Auditable, BelongsToSalon, PricedInSalonCurrency;

    protected $table = 'barber_service';

    protected $fillable = ['barber_id', 'service_id', 'price_override', 'duration_override', 'commission_rate_bp'];

    protected function casts(): array
    {
        return ['price_override' => 'integer', 'duration_override' => 'integer', 'commission_rate_bp' => 'integer'];
    }

    public function priceOverride(): ?Money
    {
        return $this->money($this->price_override);
    }
}
