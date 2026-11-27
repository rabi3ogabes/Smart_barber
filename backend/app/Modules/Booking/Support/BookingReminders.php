<?php

namespace App\Modules\Booking\Support;

use App\Modules\Booking\Jobs\SendBookingReminder;
use App\Modules\Booking\Models\Booking;

/**
 * Schedules the 24 h and 2 h reminders for a booking's current start (skipping past ones).
 */
final class BookingReminders
{
    public static function schedule(Booking $booking): void
    {
        $startsAt = $booking->starts_at->toImmutable()->utc();
        foreach (['24h' => 24 * 60, '2h' => 120] as $kind => $minutes) {
            $at = $startsAt->subMinutes($minutes);
            if ($at->isFuture()) {
                SendBookingReminder::dispatch($booking->id, $startsAt->toIso8601ZuluString(), $kind)->delay($at)->afterCommit();
            }
        }
    }
}
