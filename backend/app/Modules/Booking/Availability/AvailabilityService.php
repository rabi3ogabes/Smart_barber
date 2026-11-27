<?php

namespace App\Modules\Booking\Availability;

use App\Core\Exceptions\AppException;
use App\Core\Settings\Settings;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Support\Selection;
use App\Modules\Catalog\Pricing\PricingService;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Schedule\Interval;
use App\Modules\Staff\Schedule\ScheduleService;
use Carbon\CarbonImmutable;

/**
 * Free start times for a selection on one branch-local date. Display only: CreateBooking re-checks
 * everything under the barber lock (ADR-004).
 *
 * A start s is offered for a barber when:
 *  - [s, s + duration] lies inside one of the barber's working intervals (ScheduleService:
 *    branch hours ∩ barber hours − breaks − closures − day-offs − approved time off);
 *  - [s, s + duration + buffer) overlaps no active booking's [starts_at, blocked_until)
 *    (touching is fine);
 *  - s is on the salon's slot grid (booking.slot_step minutes, default 15, from the hour);
 *  - s respects the booking window (lead time / days ahead for customers, "now" for staff).
 * Duration and buffer come from PricingService for that barber (own durations count).
 */
final class AvailabilityService
{
    public const DEFAULT_STEP = 15;

    public function __construct(
        private readonly ScheduleService $schedules,
        private readonly PricingService $pricing,
    ) {}

    /**
     * @param  Barber|null  $barber  null = any eligible barber
     * @return list<array{starts_at: string, time: string, barbers: list<string>}>
     */
    public function slots(Branch $branch, Selection $selection, ?Barber $barber, string $date, bool $forCustomer): array
    {
        $salon = Salon::query()->findOrFail($branch->salon_id);
        if ($forCustomer && $date > BookingWindow::lastDate($salon, $branch)) {
            return [];
        }

        $day = CarbonImmutable::parse($date, $branch->timezone);
        $candidates = $barber !== null ? collect([$barber]) : EligibleBarbers::for($branch, $selection->allServiceIds(), $day);
        $earliest = BookingWindow::earliest($salon, $forCustomer);
        $step = max(5, (int) Settings::get($salon, 'booking.slot_step', self::DEFAULT_STEP));

        $byStart = [];
        foreach ($candidates as $candidate) {
            foreach ($this->startsFor($branch, $selection, $candidate, $date, $earliest, $step) as $start) {
                $key = $start->toIso8601ZuluString();
                $byStart[$key] ??= ['starts_at' => $key, 'time' => $start->setTimezone($branch->timezone)->format('H:i'), 'barbers' => []];
                $byStart[$key]['barbers'][] = $candidate->public_id;
            }
        }
        ksort($byStart);

        return array_values($byStart);
    }

    /**
     * Next free starts for one barber from a given instant (used for "slot taken" alternatives).
     *
     * @return list<string> ISO-8601 UTC
     */
    public function nextFree(Branch $branch, Selection $selection, Barber $barber, CarbonImmutable $from, int $limit = 3, bool $forCustomer = false): array
    {
        $out = [];
        $day = $from->setTimezone($branch->timezone)->startOfDay();
        for ($i = 0; $i < 7 && count($out) < $limit; $i++) {
            foreach ($this->slots($branch, $selection, $barber, $day->addDays($i)->toDateString(), $forCustomer) as $slot) {
                if ($slot['starts_at'] > $from->toIso8601ZuluString() && count($out) < $limit) {
                    $out[] = $slot['starts_at'];
                }
            }
        }

        return $out;
    }

    /**
     * @return list<CarbonImmutable>
     */
    private function startsFor(Branch $branch, Selection $selection, Barber $barber, string $date, CarbonImmutable $earliest, int $step): array
    {
        try {
            $quote = $this->pricing->quote($branch, $selection->services, $selection->addons, $barber, null, $selection->bundles);
        } catch (AppException) {
            return []; // not eligible for this selection
        }
        $duration = $quote->durationMinutes();
        $buffer = $quote->bufferMinutes;

        $intervals = $this->schedules->workingIntervals($barber, $branch, $date, $date);
        if ($intervals === []) {
            return [];
        }
        $busy = Booking::query()
            ->where('barber_id', $barber->id)
            ->whereIn('status', BookingStatus::ACTIVE)
            ->where('starts_at', '<', end($intervals)->end->addMinutes($duration + $buffer))
            ->where('blocked_until', '>', $intervals[0]->start)
            ->get(['starts_at', 'blocked_until'])
            ->map(fn (Booking $b) => [CarbonImmutable::instance($b->starts_at)->utc(), CarbonImmutable::instance($b->blocked_until)->utc()])
            ->all();

        $starts = [];
        foreach ($intervals as $interval) {
            for ($s = $this->firstOnGrid($interval, $branch->timezone, $step); $s->addMinutes($duration)->lessThanOrEqualTo($interval->end); $s = $s->addMinutes($step)) {
                if ($s->lessThan($earliest)) {
                    continue;
                }
                $blockedUntil = $s->addMinutes($duration + $buffer);
                foreach ($busy as [$bStart, $bEnd]) {
                    if ($bStart->lessThan($blockedUntil) && $bEnd->greaterThan($s)) {
                        continue 2;
                    }
                }
                $starts[] = $s;
            }
        }

        return $starts;
    }

    private function firstOnGrid(Interval $interval, string $timezone, int $step): CarbonImmutable
    {
        $local = $interval->start->setTimezone($timezone);
        $minutes = (int) $local->format('H') * 60 + (int) $local->format('i');
        $rounded = (int) (ceil($minutes / $step) * $step);

        return $local->startOfDay()->addMinutes($rounded)->utc();
    }
}
