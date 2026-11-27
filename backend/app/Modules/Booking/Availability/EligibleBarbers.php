<?php

namespace App\Modules\Booking\Availability;

use App\Core\Tenancy\Models\Branch;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Catalog\Models\BarberService;
use App\Modules\Staff\Models\Barber;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Collection;

/**
 * Barbers who can take a booking: bookable, active member, working at the branch, and
 * performing every chosen service. "Any barber" order (ADR-004, until matching in Phase 10):
 * fewest active bookings that day, then display order.
 */
final class EligibleBarbers
{
    /**
     * @param  list<int>  $serviceIds
     * @return Collection<int, Barber>
     */
    public static function for(Branch $branch, array $serviceIds, ?CarbonImmutable $day = null): Collection
    {
        $barbers = Barber::query()
            ->where('is_bookable', true)
            ->whereHas('branches', fn ($q) => $q->whereKey($branch->id))
            ->whereHas('membership', fn ($q) => $q->where('status', 'active'))
            ->orderBy('sort_order')->orderBy('id')
            ->get();

        $performs = BarberService::query()->whereIn('service_id', $serviceIds)->get()->groupBy('barber_id');
        $barbers = $barbers->filter(fn (Barber $b) => count(array_diff($serviceIds, $performs->get($b->id, collect())->pluck('service_id')->all())) === 0)->values();

        if ($day !== null && $barbers->count() > 1) {
            $from = $day->setTimezone($branch->timezone)->startOfDay()->utc();
            $counts = Booking::query()->whereIn('barber_id', $barbers->pluck('id'))
                ->whereIn('status', BookingStatus::ACTIVE)
                ->where('starts_at', '>=', $from)->where('starts_at', '<', $from->addDay())
                ->selectRaw('barber_id, count(*) as n')->groupBy('barber_id')->pluck('n', 'barber_id');
            $barbers = $barbers->sortBy(fn (Barber $b) => [(int) ($counts[$b->id] ?? 0), $b->sort_order, $b->id])->values();
        }

        return $barbers;
    }
}
