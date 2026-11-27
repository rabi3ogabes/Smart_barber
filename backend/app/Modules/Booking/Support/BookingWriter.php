<?php

namespace App\Modules\Booking\Support;

use App\Core\Tenancy\Models\Branch;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Models\BookingItem;
use App\Modules\Booking\Models\BookingStatusHistory;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Pricing\PricingService;
use App\Modules\Catalog\Pricing\Quote;
use App\Modules\Customer\Models\Customer;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Schedule\ScheduleService;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

/**
 * The locked write path shared by CreateBooking and RescheduleBooking (ADR-004).
 */
final class BookingWriter
{
    public function __construct(
        private readonly PricingService $pricing,
        private readonly ScheduleService $schedules,
    ) {}

    /**
     * Runs $work in a READ COMMITTED transaction after locking the given barber rows in ascending
     * id order (a fixed order rules out deadlocks when two barbers are locked).
     *
     * @template T
     *
     * @param  list<int>  $barberIds
     * @param  callable(): T  $work
     * @return T
     */
    public function locked(array $barberIds, callable $work): mixed
    {
        // READ COMMITTED so the overlap query after the lock sees rows committed while we waited.
        // It can only be set outside a transaction (tests wrap everything in one; the lock still
        // serialises them because the overlap read happens after it).
        if (DB::transactionLevel() === 0) {
            DB::statement('SET TRANSACTION ISOLATION LEVEL READ COMMITTED');
        }

        return DB::transaction(function () use ($barberIds, $work) {
            $ids = array_values(array_unique($barberIds));
            sort($ids);
            foreach ($ids as $id) {
                Barber::query()->withTrashed()->whereKey($id)->lockForUpdate()->first(['id']);
            }

            return $work();
        });
    }

    public function quote(Branch $branch, Selection $selection, Barber $barber, ?Customer $customer): Quote
    {
        return $this->pricing->quote($branch, $selection->services, $selection->addons, $barber, $customer, $selection->bundles);
    }

    /**
     * Must run inside locked(). Returns [ends_at, blocked_until].
     *
     * @return array{0: CarbonImmutable, 1: CarbonImmutable}
     */
    public function assertFree(Branch $branch, Barber $barber, CarbonImmutable $startsAt, int $durationMinutes, int $bufferMinutes, ?int $ignoreBookingId = null): array
    {
        $endsAt = $startsAt->addMinutes($durationMinutes);
        $blockedUntil = $endsAt->addMinutes($bufferMinutes);

        // The service (not the clean-up buffer) must fit inside one working interval.
        $date = $startsAt->setTimezone($branch->timezone)->toDateString();
        $fits = false;
        foreach ($this->schedules->workingIntervals($barber, $branch, $date, $date) as $interval) {
            if ($interval->start->lessThanOrEqualTo($startsAt) && $interval->end->greaterThanOrEqualTo($endsAt)) {
                $fits = true;
                break;
            }
        }
        if (! $fits) {
            throw new SlotUnavailable('outside_hours');
        }

        // Overlap on the blocked range; touching ends are allowed (strict inequalities).
        $overlaps = Booking::query()
            ->where('barber_id', $barber->id)
            ->whereIn('status', BookingStatus::ACTIVE)
            ->where('starts_at', '<', $blockedUntil)
            ->where('blocked_until', '>', $startsAt)
            ->when($ignoreBookingId !== null, fn ($q) => $q->whereKeyNot($ignoreBookingId))
            ->exists();
        if ($overlaps) {
            throw new SlotUnavailable('overlap');
        }

        return [$endsAt, $blockedUntil];
    }

    public function applyQuote(Booking $booking, Quote $quote): void
    {
        $booking->forceFill([
            'subtotal_amount' => $quote->subtotal()->minor(),
            'discount_amount' => $quote->discount()->minor(),
            'tax_amount' => $quote->tax()->minor(),
            'total_amount' => $quote->total()->minor(),
            'currency' => $quote->currency,
            'quote_snapshot' => json_decode((string) json_encode($quote->toArray()), true),
        ]);
    }

    public function snapshotItems(Booking $booking, Quote $quote): void
    {
        BookingItem::query()->where('booking_id', $booking->id)->delete();
        foreach ($quote->lines as $i => $line) {
            BookingItem::query()->create([
                'booking_id' => $booking->id,
                'type' => $line->type,
                'service_id' => $line->type === 'service' ? $line->modelId : null,
                'addon_id' => $line->type === 'addon' ? $line->modelId : null,
                'bundle_id' => $line->type === 'bundle' ? $line->modelId : null,
                'name' => $line->name,
                'price' => $line->unitPrice->minor(),
                'discount_amount' => $line->discount?->minor() ?? 0,
                'tax_amount' => $line->tax->minor(),
                'total_amount' => $line->total->minor(),
                'duration_minutes' => $line->durationMinutes,
                'sort_order' => $i,
            ]);
        }
    }

    /**
     * @param  array<string, mixed>  $meta
     */
    public function history(Booking $booking, ?BookingStatus $from, BookingStatus $to, ?Model $actor, ?string $reason = null, array $meta = []): void
    {
        BookingStatusHistory::query()->create([
            'booking_id' => $booking->id,
            'from_status' => $from?->value,
            'to_status' => $to->value,
            'actor_type' => $actor?->getMorphClass(),
            'actor_id' => $actor?->getKey(),
            'reason' => $reason,
            'meta' => $meta === [] ? null : $meta,
        ]);
    }

    /**
     * Rebuilds the Selection a booking was made with, from its line snapshots.
     */
    public static function selectionOf(Booking $booking): Selection
    {
        $items = $booking->items()->get();

        return new Selection(
            Service::withTrashed()->whereIn('id', $items->where('type', 'service')->pluck('service_id'))->get()->all(),
            ServiceAddon::withTrashed()->whereIn('id', $items->where('type', 'addon')->pluck('addon_id'))->get()->all(),
            ServiceBundle::withTrashed()->with('services')->whereIn('id', $items->where('type', 'bundle')->pluck('bundle_id'))->get()->all(),
        );
    }
}
