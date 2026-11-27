<?php

namespace App\Modules\Booking\Actions;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Modules\Booking\Availability\AvailabilityService;
use App\Modules\Booking\Availability\BookingWindow;
use App\Modules\Booking\Events\BookingChanged;
use App\Modules\Booking\Events\BookingRescheduled;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Support\BookingReminders;
use App\Modules\Booking\Support\BookingWriter;
use App\Modules\Booking\Support\SlotUnavailable;
use App\Modules\Staff\Models\Barber;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Model;

/**
 * Moves a booking in time and/or to another barber of the same branch, keeping the same row and
 * public id (ADR-004). Locks the old and new barber in ascending id order, re-checks hours and
 * overlap (ignoring itself), and logs old/new values in booking_status_history.meta.
 * Same barber: price and durations stay as booked. New barber: re-priced for that barber.
 */
final class RescheduleBooking
{
    public function __construct(
        private readonly BookingWriter $writer,
        private readonly AvailabilityService $availability,
        private readonly CancelBooking $cancel,
    ) {}

    public function __invoke(Booking $booking, CarbonImmutable $startsAt, ?Barber $barber, ?Model $actor, bool $byCustomer = false, bool $overridePolicy = false): Booking
    {
        if (! $booking->status->isReschedulable()) {
            throw new AppException(ErrorCode::BookingInvalidTransition);
        }
        $branch = Branch::query()->findOrFail($booking->branch_id);
        $salon = Salon::query()->findOrFail($booking->salon_id);
        $startsAt = $startsAt->utc()->startOfMinute();
        // The online change window binds customers; staff may move bookings at any time.
        if ($byCustomer && ! $overridePolicy) {
            $this->cancel->assertWithinWindow($booking, $salon);
        }
        BookingWindow::assert($salon, $branch, $startsAt, $byCustomer);

        $target = $barber ?? Barber::query()->findOrFail($booking->barber_id);
        $selection = BookingWriter::selectionOf($booking);
        $from = ['starts_at' => $booking->starts_at->toIso8601ZuluString(), 'barber' => Barber::withTrashed()->whereKey($booking->barber_id)->value('public_id')];

        try {
            $booking = $this->writer->locked([$booking->barber_id, $target->id], function () use ($booking, $branch, $target, $startsAt, $selection, $actor, $from) {
                $fresh = Booking::query()->whereKey($booking->id)->lockForUpdate()->firstOrFail();
                if (! $fresh->status->isReschedulable()) {
                    throw new AppException(ErrorCode::BookingInvalidTransition);
                }

                if ($target->id === $fresh->barber_id) {
                    $duration = (int) $fresh->items()->sum('duration_minutes');
                    $buffer = (int) ($fresh->quote_snapshot['buffer_minutes'] ?? 0);
                    [$endsAt, $blockedUntil] = $this->writer->assertFree($branch, $target, $startsAt, $duration, $buffer, $fresh->id);
                } else {
                    $quote = $this->writer->quote($branch, $selection, $target, $fresh->customer);
                    [$endsAt, $blockedUntil] = $this->writer->assertFree($branch, $target, $startsAt, $quote->durationMinutes(), $quote->bufferMinutes, $fresh->id);
                    $this->writer->applyQuote($fresh, $quote);
                    $this->writer->snapshotItems($fresh, $quote);
                }

                $fresh->forceFill([
                    'barber_id' => $target->id,
                    'starts_at' => $startsAt,
                    'ends_at' => $endsAt,
                    'blocked_until' => $blockedUntil,
                    'reschedule_count' => $fresh->reschedule_count + 1,
                ])->save();
                $this->writer->history($fresh, $fresh->status, $fresh->status, $actor, meta: [
                    'rescheduled' => true,
                    'from' => $from,
                    'to' => ['starts_at' => $startsAt->toIso8601ZuluString(), 'barber' => $target->public_id],
                ]);

                return $fresh;
            });
        } catch (SlotUnavailable $e) {
            if ($e->reason === 'outside_hours') {
                throw new AppException(ErrorCode::BookingOutsideHours);
            }
            throw new AppException(ErrorCode::BookingSlotTaken, data: [
                'alternatives' => $this->availability->nextFree($branch, $selection, $target, $startsAt, 3, $byCustomer),
            ]);
        }

        event(new BookingRescheduled($booking, ['from' => $from]));
        event(BookingChanged::for($booking, 'rescheduled'));
        BookingReminders::schedule($booking);

        return $booking;
    }
}
