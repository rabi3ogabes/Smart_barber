<?php

namespace App\Modules\Booking\Listeners;

use App\Modules\Booking\Actions\CancelBooking;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Models\BookingReview;
use App\Modules\Customer\Events\CustomerAnonymising;

/**
 * Before a profile is anonymised: free the chairs of its upcoming bookings and clear what the
 * customer wrote (booking notes, review comments). Ratings stay, anonymous; bookings keep their
 * price snapshots.
 */
final class ClearAnonymisedCustomerBookings
{
    public function __construct(private readonly CancelBooking $cancel) {}

    public function handle(CustomerAnonymising $event): void
    {
        $customerId = $event->customer->id;
        $upcoming = Booking::query()->where('customer_id', $customerId)
            ->whereIn('status', [BookingStatus::Pending->value, BookingStatus::Confirmed->value])
            ->where('starts_at', '>', now())->get();
        foreach ($upcoming as $booking) {
            ($this->cancel)($booking, null, 'account_deleted', overridePolicy: true);
        }

        Booking::query()->where('customer_id', $customerId)->update(['customer_notes' => null]);
        BookingReview::query()->where('customer_id', $customerId)->update(['comment' => null]);
    }
}
