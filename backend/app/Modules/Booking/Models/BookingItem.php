<?php

namespace App\Modules\Booking\Models;

use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;
use Spatie\Translatable\HasTranslations;

/**
 * Snapshot of one priced line at booking time (table booking_services). Later catalog edits never
 * change it.
 *
 * @property int $id
 * @property int $booking_id
 * @property string $type service | addon | bundle
 * @property int|null $service_id
 * @property int|null $addon_id
 * @property int|null $bundle_id
 * @property int $price
 * @property int $discount_amount
 * @property int $tax_amount
 * @property int $total_amount
 * @property int $duration_minutes
 * @property int $sort_order
 */
class BookingItem extends Model
{
    use BelongsToSalon, HasTranslations;

    protected $table = 'booking_services';

    /** @var list<string> */
    public array $translatable = ['name'];

    protected $fillable = ['booking_id', 'type', 'service_id', 'addon_id', 'bundle_id', 'name', 'price', 'discount_amount', 'tax_amount', 'total_amount', 'duration_minutes', 'sort_order'];

    protected function casts(): array
    {
        return ['price' => 'integer', 'discount_amount' => 'integer', 'tax_amount' => 'integer', 'total_amount' => 'integer', 'duration_minutes' => 'integer'];
    }
}
