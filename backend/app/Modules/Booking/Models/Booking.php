<?php

namespace App\Modules\Booking\Models;

use App\Core\Money\Money;
use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use App\Core\Tenancy\Models\Branch;
use App\Modules\Booking\Enums\BookingSource;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Customer\Models\Customer;
use App\Modules\Staff\Models\Barber;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Carbon;

/**
 * One appointment. Times are UTC. blocked_until = ends_at + buffer and is what the overlap
 * check uses. Status changes only through the Booking actions (see BookingStatus).
 *
 * @property int $id
 * @property string $public_id
 * @property int $salon_id
 * @property int $branch_id
 * @property int $customer_id
 * @property int $barber_id
 * @property Carbon $starts_at
 * @property Carbon $ends_at
 * @property Carbon $blocked_until
 * @property BookingStatus $status
 * @property BookingSource $source
 * @property string|null $customer_notes
 * @property string|null $internal_notes
 * @property string|null $cancel_reason
 * @property Carbon|null $cancelled_at
 * @property int $subtotal_amount
 * @property int $discount_amount
 * @property int $tax_amount
 * @property int $total_amount
 * @property string $currency
 * @property array<string, mixed> $quote_snapshot
 * @property int $reschedule_count
 */
class Booking extends Model
{
    use BelongsToSalon, HasPublicId;

    protected $fillable = [
        'branch_id', 'customer_id', 'barber_id', 'starts_at', 'ends_at', 'blocked_until', 'status', 'source',
        'customer_notes', 'internal_notes', 'subtotal_amount', 'discount_amount', 'tax_amount', 'total_amount',
        'currency', 'quote_snapshot', 'created_by_type', 'created_by_id',
    ];

    protected $attributes = ['reschedule_count' => 0, 'discount_amount' => 0, 'tax_amount' => 0];

    protected function casts(): array
    {
        return [
            'starts_at' => 'datetime',
            'ends_at' => 'datetime',
            'blocked_until' => 'datetime',
            'cancelled_at' => 'datetime',
            'status' => BookingStatus::class,
            'source' => BookingSource::class,
            'quote_snapshot' => 'array',
            'subtotal_amount' => 'integer',
            'discount_amount' => 'integer',
            'tax_amount' => 'integer',
            'total_amount' => 'integer',
            'reschedule_count' => 'integer',
        ];
    }

    public function total(): Money
    {
        return Money::ofMinor($this->total_amount, $this->currency);
    }

    /**
     * @return BelongsTo<Customer, $this>
     */
    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    /**
     * @return BelongsTo<Barber, $this>
     */
    public function barber(): BelongsTo
    {
        return $this->belongsTo(Barber::class)->withTrashed();
    }

    /**
     * @return BelongsTo<Branch, $this>
     */
    public function branch(): BelongsTo
    {
        return $this->belongsTo(Branch::class);
    }

    /**
     * @return HasMany<BookingItem, $this>
     */
    public function items(): HasMany
    {
        return $this->hasMany(BookingItem::class)->orderBy('sort_order');
    }

    /**
     * @return HasMany<BookingStatusHistory, $this>
     */
    public function history(): HasMany
    {
        return $this->hasMany(BookingStatusHistory::class)->orderBy('id');
    }
}
