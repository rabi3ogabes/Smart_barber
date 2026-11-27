<?php

namespace App\Modules\Booking\Support;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Events\BookingChanged;
use App\Modules\Booking\Models\Booking;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

/**
 * Applies one status transition under a row lock. Invalid transitions throw
 * BOOKING_INVALID_TRANSITION (409). $then runs inside the same transaction (e.g. a no-show fee).
 */
final class TransitionBooking
{
    public function __construct(private readonly BookingWriter $writer) {}

    /**
     * @param  array<string, mixed>  $attributes  extra columns to set
     * @param  (callable(Booking): void)|null  $then
     */
    public function __invoke(Booking $booking, BookingStatus $to, ?Model $actor, ?string $reason = null, array $attributes = [], ?callable $then = null): Booking
    {
        $booking = DB::transaction(function () use ($booking, $to, $actor, $reason, $attributes, $then) {
            $fresh = Booking::query()->whereKey($booking->id)->lockForUpdate()->firstOrFail();
            $from = $fresh->status;
            if (! $from->canBecome($to)) {
                throw new AppException(ErrorCode::BookingInvalidTransition, data: ['from' => $from->value, 'to' => $to->value]);
            }
            $fresh->forceFill(['status' => $to] + $attributes)->save();
            $this->writer->history($fresh, $from, $to, $actor, $reason);
            if ($then !== null) {
                $then($fresh);
            }

            return $fresh;
        });

        event(BookingChanged::for($booking, $to->value));

        return $booking;
    }
}
