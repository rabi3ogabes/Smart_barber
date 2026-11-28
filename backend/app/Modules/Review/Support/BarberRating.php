<?php

namespace App\Modules\Review\Support;

use App\Modules\Review\Models\BookingReview;
use App\Modules\Staff\Models\Barber;

/**
 * barbers.rating_avg / rating_count are a cache derived from published reviews (rule 4: derived,
 * never edited by hand). Recomputed from scratch after every review change.
 */
final class BarberRating
{
    public static function recalculate(?int $barberId): void
    {
        if ($barberId === null) {
            return;
        }
        $published = BookingReview::query()->where('barber_id', $barberId)->where('status', BookingReview::PUBLISHED);
        $count = (clone $published)->count();
        $average = (clone $published)->avg('rating');

        Barber::withTrashed()->whereKey($barberId)->update([
            'rating_count' => $count,
            'rating_avg' => $count > 0 ? round((float) $average, 2) : null,
        ]);
    }
}
