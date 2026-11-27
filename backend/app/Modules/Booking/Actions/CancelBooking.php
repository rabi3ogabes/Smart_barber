<?php

namespace App\Modules\Booking\Actions;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Tenancy\Models\Salon;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Events\BookingCancelled;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Support\TransitionBooking;
use Illuminate\Database\Eloquent\Model;

/**
 * Cancels a pending, confirmed or arrived booking. Inside the salon's cancellation window
 * (salons.cancellation_window_minutes before the start) only staff with
 * booking.cancel.override_policy may cancel; customers get BOOKING_CANCEL_WINDOW_PASSED.
 */
final class CancelBooking
{
    public function __construct(private readonly TransitionBooking $transition) {}

    public function __invoke(Booking $booking, ?Model $actor, ?string $reason, bool $overridePolicy = false): Booking
    {
        if (! $overridePolicy) {
            $this->assertWithinWindow($booking, Salon::query()->findOrFail($booking->salon_id));
        }

        $booking = ($this->transition)($booking, BookingStatus::Cancelled, $actor, $reason, [
            'cancel_reason' => $reason,
            'cancelled_at' => now(),
            'cancelled_by_type' => $actor?->getMorphClass(),
            'cancelled_by_id' => $actor?->getKey(),
        ]);
        event(new BookingCancelled($booking, ['reason' => $reason]));

        return $booking;
    }

    /** Changes are allowed until cancellation_window_minutes before the start. */
    public function assertWithinWindow(Booking $booking, Salon $salon): void
    {
        $deadline = $booking->starts_at->copy()->subMinutes((int) $salon->cancellation_window_minutes);
        if (now()->greaterThan($deadline)) {
            throw new AppException(ErrorCode::BookingCancelWindowPassed);
        }
    }
}
