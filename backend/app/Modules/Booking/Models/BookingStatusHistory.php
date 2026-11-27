<?php

namespace App\Modules\Booking\Models;

use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;
use LogicException;

/**
 * Append-only timeline of a booking: creation, every status change and every reschedule
 * (meta holds the old and new times and barbers).
 *
 * @property int $id
 * @property int $booking_id
 * @property string|null $from_status
 * @property string $to_status
 * @property string|null $actor_type
 * @property int|null $actor_id
 * @property string|null $reason
 * @property array<string, mixed>|null $meta
 * @property Carbon $created_at
 */
class BookingStatusHistory extends Model
{
    use BelongsToSalon;

    public const UPDATED_AT = null;

    protected $table = 'booking_status_history';

    protected $fillable = ['booking_id', 'from_status', 'to_status', 'actor_type', 'actor_id', 'reason', 'meta'];

    protected static function booted(): void
    {
        static::updating(fn () => throw new LogicException('booking_status_history is append-only.'));
        static::deleting(fn () => throw new LogicException('booking_status_history is append-only.'));
    }

    protected function casts(): array
    {
        return ['meta' => 'array', 'created_at' => 'datetime'];
    }
}
