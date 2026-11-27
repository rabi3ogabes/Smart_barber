<?php

namespace App\Modules\Booking\Actions;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Settings\Settings;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Modules\Booking\Availability\AvailabilityService;
use App\Modules\Booking\Availability\BookingWindow;
use App\Modules\Booking\Availability\EligibleBarbers;
use App\Modules\Booking\Enums\BookingSource;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Events\BookingChanged;
use App\Modules\Booking\Events\BookingConfirmed;
use App\Modules\Booking\Events\BookingCreated;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Support\BookingReminders;
use App\Modules\Booking\Support\BookingWriter;
use App\Modules\Booking\Support\Selection;
use App\Modules\Booking\Support\SlotUnavailable;
use App\Modules\Customer\Models\Customer;
use App\Modules\Staff\Models\Barber;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Model;

/**
 * Creates a booking without ever double-booking a chair (ADR-004):
 *
 * For each candidate barber (the chosen one, or every eligible one in "any" order), ONE lock at a time:
 *  1. transaction at READ COMMITTED, SELECT … FOR UPDATE on the barber row;
 *  2. price via PricingService (also proves the barber performs every service);
 *  3. the service range must lie inside a working interval (ScheduleService);
 *  4. no active booking may overlap [starts_at, blocked_until) — touching is allowed;
 *  5. insert booking, line snapshots and the first history row; commit.
 * Events and reminders are dispatched after commit. When no candidate fits: 409
 * BOOKING_SLOT_TAKEN with up to 3 alternatives.
 */
final class CreateBooking
{
    public function __construct(
        private readonly BookingWriter $writer,
        private readonly AvailabilityService $availability,
    ) {}

    public function __invoke(
        Branch $branch,
        Customer $customer,
        Selection $selection,
        CarbonImmutable $startsAt,
        BookingSource $source,
        ?Barber $barber = null,
        ?Model $actor = null,
        ?string $customerNotes = null,
        ?string $internalNotes = null,
    ): Booking {
        $salon = Salon::query()->findOrFail($branch->salon_id);
        $startsAt = $startsAt->utc()->startOfMinute();
        BookingWindow::assert($salon, $branch, $startsAt, $source->isCustomer());
        if (! $branch->is_active) {
            throw new AppException(ErrorCode::ServiceUnavailableAtBranch);
        }

        $candidates = $barber !== null ? collect([$barber]) : EligibleBarbers::for($branch, $selection->allServiceIds(), $startsAt);
        if ($candidates->isEmpty()) {
            throw new AppException(ErrorCode::BarberNotEligible);
        }

        $status = $source->isCustomer() && ! (bool) Settings::get($salon, 'booking.auto_confirm', true)
            ? BookingStatus::Pending
            : BookingStatus::Confirmed;

        $outsideHours = 0;
        foreach ($candidates as $candidate) {
            try {
                $booking = $this->writer->locked([$candidate->id], function () use ($branch, $customer, $selection, $startsAt, $source, $candidate, $actor, $customerNotes, $internalNotes, $status) {
                    $quote = $this->writer->quote($branch, $selection, $candidate, $customer);
                    [$endsAt, $blockedUntil] = $this->writer->assertFree($branch, $candidate, $startsAt, $quote->durationMinutes(), $quote->bufferMinutes);

                    $booking = new Booking([
                        'branch_id' => $branch->id,
                        'customer_id' => $customer->id,
                        'barber_id' => $candidate->id,
                        'starts_at' => $startsAt,
                        'ends_at' => $endsAt,
                        'blocked_until' => $blockedUntil,
                        'status' => $status,
                        'source' => $source,
                        'customer_notes' => $customerNotes,
                        'internal_notes' => $internalNotes,
                        'created_by_type' => $actor?->getMorphClass(),
                        'created_by_id' => $actor?->getKey(),
                    ]);
                    $this->writer->applyQuote($booking, $quote);
                    $booking->save();
                    $this->writer->snapshotItems($booking, $quote);
                    $this->writer->history($booking, null, $status, $actor, meta: ['source' => $source->value]);

                    return $booking;
                });
            } catch (SlotUnavailable $e) {
                if ($barber !== null) {
                    if ($e->reason === 'outside_hours') {
                        throw new AppException(ErrorCode::BookingOutsideHours);
                    }
                    throw new AppException(ErrorCode::BookingSlotTaken, data: [
                        'alternatives' => $this->availability->nextFree($branch, $selection, $barber, $startsAt, 3, $source->isCustomer()),
                    ]);
                }
                $outsideHours += $e->reason === 'outside_hours' ? 1 : 0;

                continue; // "any": try the next barber; the previous lock is already released
            }

            event(new BookingCreated($booking));
            if ($booking->status === BookingStatus::Confirmed) {
                event(new BookingConfirmed($booking));
            }
            event(BookingChanged::for($booking, 'created'));
            BookingReminders::schedule($booking);

            return $booking;
        }

        if ($outsideHours === $candidates->count()) {
            throw new AppException(ErrorCode::BookingOutsideHours);
        }
        $date = $startsAt->setTimezone($branch->timezone)->toDateString();
        $alternatives = array_values(array_filter(
            $this->availability->slots($branch, $selection, null, $date, $source->isCustomer()),
            fn (array $slot) => $slot['starts_at'] > $startsAt->toIso8601ZuluString(),
        ));

        throw new AppException(ErrorCode::BookingSlotTaken, data: ['alternatives' => array_slice(array_column($alternatives, 'starts_at'), 0, 3)]);
    }
}
