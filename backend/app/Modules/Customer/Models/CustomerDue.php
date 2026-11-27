<?php

namespace App\Modules\Customer\Models;

use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;
use LogicException;

/**
 * Append-only ledger of amounts a customer owes (rule 4). Corrections are new rows with a
 * negative amount and reverses_id; rows are never updated or deleted.
 *
 * @property int $id
 * @property int $customer_id
 * @property int|null $booking_id
 * @property string $type no_show_fee | waiver | settlement
 * @property int $amount signed minor units
 * @property string $currency
 * @property int|null $reverses_id
 */
class CustomerDue extends Model
{
    use BelongsToSalon, HasPublicId;

    public const UPDATED_AT = null;

    protected $fillable = ['customer_id', 'booking_id', 'type', 'amount', 'currency', 'reverses_id', 'reason', 'actor_type', 'actor_id'];

    protected static function booted(): void
    {
        static::updating(fn () => throw new LogicException('customer_dues is append-only.'));
        static::deleting(fn () => throw new LogicException('customer_dues is append-only.'));
    }

    protected function casts(): array
    {
        return ['amount' => 'integer'];
    }
}
