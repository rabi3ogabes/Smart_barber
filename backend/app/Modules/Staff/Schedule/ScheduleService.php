<?php

namespace App\Modules\Staff\Schedule;

use App\Core\Tenancy\Models\Branch;
use App\Modules\Salon\Models\BranchClosure;
use App\Modules\Salon\Models\BranchOpeningHour;
use App\Modules\Staff\Enums\TimeOffStatus;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\BarberBreak;
use App\Modules\Staff\Models\BarberScheduleOverride;
use App\Modules\Staff\Models\BarberWorkingHour;
use App\Modules\Staff\Models\TimeOffRequest;
use Carbon\CarbonImmutable;
use Carbon\CarbonPeriodImmutable;

/**
 * When a barber actually works at a branch (modules.md, Staff → ScheduleService).
 *
 * For each branch-local date: branch opening hours ∩ (override custom hours, else weekly hours),
 * minus breaks; nothing on branch closures or day-off overrides; then approved time off is
 * removed. Results are UTC intervals, sorted and merged. The booking engine (Phase 4) builds
 * slots from this and re-checks it inside the booking transaction.
 */
final class ScheduleService
{
    /**
     * @param  string  $from  first branch-local date (Y-m-d), inclusive
     * @param  string  $to  last branch-local date (Y-m-d), inclusive
     * @return list<Interval>
     */
    public function workingIntervals(Barber $barber, Branch $branch, string $from, string $to): array
    {
        $tz = $branch->timezone;
        $period = CarbonPeriodImmutable::create($from, $to);

        $opening = BranchOpeningHour::query()->where('branch_id', $branch->id)->get()->groupBy('weekday');
        $hours = BarberWorkingHour::query()->where('barber_id', $barber->id)->where('branch_id', $branch->id)->get()->groupBy('weekday');
        $breaks = BarberBreak::query()->where('barber_id', $barber->id)->where('branch_id', $branch->id)->get()->groupBy('weekday');
        $overrides = BarberScheduleOverride::query()
            ->where('barber_id', $barber->id)->where('branch_id', $branch->id)
            ->whereBetween('date', [$from, $to])->get()
            ->keyBy(fn (BarberScheduleOverride $o) => $o->date->toDateString());
        $closures = BranchClosure::query()
            ->where(fn ($q) => $q->whereNull('branch_id')->orWhere('branch_id', $branch->id))
            ->where('starts_on', '<=', $to)->where('ends_on', '>=', $from)
            ->get();

        $intervals = [];
        foreach ($period as $day) {
            $date = $day->toDateString();
            $weekday = $day->dayOfWeek;

            if ($closures->contains(fn (BranchClosure $c) => $c->starts_on->toDateString() <= $date && $c->ends_on->toDateString() >= $date)) {
                continue;
            }

            $override = $overrides->get($date);
            if ($override?->type === BarberScheduleOverride::DAY_OFF) {
                continue;
            }

            $open = $this->ranges($opening->get($weekday, collect())->map(fn ($r) => [$r->opens_at, $r->closes_at])->all(), $date, $tz);
            $work = $override?->type === BarberScheduleOverride::CUSTOM_HOURS && $override->starts_at && $override->ends_at
                ? $this->ranges([[$override->starts_at, $override->ends_at]], $date, $tz)
                : $this->ranges($hours->get($weekday, collect())->map(fn ($r) => [$r->starts_at, $r->ends_at])->all(), $date, $tz);
            $rest = $this->ranges($breaks->get($weekday, collect())->map(fn ($r) => [$r->starts_at, $r->ends_at])->all(), $date, $tz);

            array_push($intervals, ...Intervals::subtract(Intervals::intersect($work, $open), $rest));
        }

        if ($intervals === []) {
            return [];
        }

        $first = $intervals[0]->start;
        $last = end($intervals)->end;
        $timeOff = TimeOffRequest::query()
            ->where('barber_id', $barber->id)
            ->where('status', TimeOffStatus::Approved)
            ->where('starts_at', '<', $last)->where('ends_at', '>', $first)
            ->get()
            ->map(fn (TimeOffRequest $t) => new Interval(CarbonImmutable::instance($t->starts_at)->utc(), CarbonImmutable::instance($t->ends_at)->utc()))
            ->all();

        return Intervals::subtract($intervals, array_values($timeOff));
    }

    /**
     * Working intervals at every branch of the barber (staff app "my schedule").
     *
     * @return array<string, list<Interval>> keyed by branch public id
     */
    public function workingIntervalsAllBranches(Barber $barber, string $from, string $to): array
    {
        $out = [];
        foreach ($barber->branches()->where('is_active', true)->get() as $branch) {
            $out[$branch->public_id] = $this->workingIntervals($barber, $branch, $from, $to);
        }

        return $out;
    }

    /**
     * @param  list<array{0: string, 1: string}>  $ranges
     * @return list<Interval>
     */
    private function ranges(array $ranges, string $date, string $tz): array
    {
        $out = [];
        foreach ($ranges as [$start, $end]) {
            if ($end > $start) {
                $out[] = Interval::local($date, $start, $end, $tz);
            }
        }

        return $out;
    }
}
