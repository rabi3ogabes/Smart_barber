<?php

namespace App\Modules\Booking\Actions;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Tenancy\Models\Salon;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Events\BookingCompleted;
use App\Modules\Booking\Events\BookingConfirmed;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Support\TransitionBooking;
use App\Modules\Customer\Models\Customer;
use App\Modules\Customer\Models\CustomerDue;
use Illuminate\Database\Eloquent\Model;

/**
 * The reception flow: confirm → arrived → in service → completed, and no-show.
 * (Named actions from the prompt — ConfirmBooking, MarkArrived, StartService, CompleteBooking,
 * MarkNoShow — are the methods below.)
 */
final class ChangeBookingStatus
{
    public function __construct(private readonly TransitionBooking $transition) {}

    public function confirm(Booking $booking, ?Model $actor): Booking
    {
        $booking = ($this->transition)($booking, BookingStatus::Confirmed, $actor);
        event(new BookingConfirmed($booking));

        return $booking;
    }

    public function markArrived(Booking $booking, ?Model $actor): Booking
    {
        return ($this->transition)($booking, BookingStatus::Arrived, $actor);
    }

    public function startService(Booking $booking, ?Model $actor): Booking
    {
        return ($this->transition)($booking, BookingStatus::InService, $actor);
    }

    /** Completing counts the visit on the customer's cached stats. Payment is Phase 6 (POS). */
    public function complete(Booking $booking, ?Model $actor): Booking
    {
        $booking = ($this->transition)($booking, BookingStatus::Completed, $actor, then: function (Booking $b): void {
            $customer = Customer::query()->lockForUpdate()->find($b->customer_id);
            $customer?->forceFill([
                'first_visit_at' => $customer->first_visit_at ?? $b->starts_at,
                'last_visit_at' => $b->starts_at,
                'visits_count' => $customer->visits_count + 1,
            ])->save();
        });
        event(new BookingCompleted($booking));

        return $booking;
    }

    /**
     * Only after the start time. Records the salon's no-show fee as an amount owed (spec-review Q9
     * default: collected at the next POS checkout) in the append-only customer_dues ledger.
     */
    public function markNoShow(Booking $booking, ?Model $actor, bool $waiveFee = false): Booking
    {
        if ($booking->starts_at->isFuture()) {
            throw new AppException(ErrorCode::BookingNotStarted);
        }
        $salon = Salon::query()->findOrFail($booking->salon_id);

        return ($this->transition)($booking, BookingStatus::NoShow, $actor, $waiveFee ? 'fee_waived' : null, then: function (Booking $b) use ($salon, $actor, $waiveFee): void {
            Customer::query()->whereKey($b->customer_id)->increment('no_show_count');
            $fee = (int) $salon->getRawOriginal('no_show_fee_amount');
            if ($fee > 0 && ! $waiveFee) {
                CustomerDue::query()->create([
                    'customer_id' => $b->customer_id,
                    'booking_id' => $b->id,
                    'type' => 'no_show_fee',
                    'amount' => $fee,
                    'currency' => $salon->currency,
                    'actor_type' => $actor?->getMorphClass(),
                    'actor_id' => $actor?->getKey(),
                ]);
            }
        });
    }
}
