<?php

namespace App\Modules\Booking\Support;

use App\Core\Tenancy\Models\Salon;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Models\BookingItem;

/**
 * RFC 5545 iCalendar for one booking. Times are UTC (rule 5); calendar apps convert for display.
 * The UID is stable, so re-adding after a reschedule updates the same event.
 */
final class BookingCalendar
{
    public static function ics(Booking $booking): string
    {
        $booking->loadMissing(['items', 'branch', 'barber']);
        $salon = Salon::query()->findOrFail($booking->salon_id);
        $locale = app()->getLocale();
        $salonName = (string) ($salon->getTranslation('name', $locale, true) ?: $salon->slug);
        $services = $booking->items->map(fn (BookingItem $i) => (string) $i->getTranslation('name', $locale, true))->implode(', ');
        $barber = $booking->barber?->getTranslation('display_name', $locale, true);
        $branch = $booking->branch;
        $address = $branch ? (string) $branch->getTranslation('address', $locale, true) : '';
        $host = (string) parse_url((string) config('app.url'), PHP_URL_HOST) ?: 'smartbarber';
        $format = fn ($d) => $d->copy()->utc()->format('Ymd\THis\Z');

        $lines = [
            'BEGIN:VCALENDAR',
            'VERSION:2.0',
            'PRODID:-//Smart Barber//Bookings//EN',
            'CALSCALE:GREGORIAN',
            'METHOD:PUBLISH',
            'BEGIN:VEVENT',
            'UID:booking-'.$booking->public_id.'@'.$host,
            'DTSTAMP:'.$format(now()),
            'DTSTART:'.$format($booking->starts_at),
            'DTEND:'.$format($booking->ends_at),
            'SUMMARY:'.self::escape($salonName.($services !== '' ? ' — '.$services : '')),
            'DESCRIPTION:'.self::escape(trim(($barber ? $barber."\n" : '').$services)),
            'LOCATION:'.self::escape($address),
            'STATUS:'.($booking->status === BookingStatus::Cancelled ? 'CANCELLED' : 'CONFIRMED'),
        ];
        if ($branch?->lat !== null) {
            $lines[] = 'GEO:'.((float) $branch->lat).';'.((float) $branch->lng);
        }
        $lines = [...$lines, 'BEGIN:VALARM', 'TRIGGER:-PT1H', 'ACTION:DISPLAY', 'DESCRIPTION:'.self::escape($salonName), 'END:VALARM', 'END:VEVENT', 'END:VCALENDAR'];

        return implode("\r\n", array_map(self::fold(...), $lines))."\r\n";
    }

    private static function escape(string $text): string
    {
        return str_replace(['\\', ';', ',', "\r\n", "\n"], ['\\\\', '\;', '\,', '\n', '\n'], $text);
    }

    /** Lines longer than 75 octets are folded (RFC 5545 §3.1), never inside a UTF-8 character. */
    private static function fold(string $line): string
    {
        $out = '';
        $current = '';
        foreach (mb_str_split($line) as $char) {
            if (strlen($current.$char) > 75) {
                $out .= $current."\r\n ";
                $current = '';
            }
            $current .= $char;
        }

        return $out.$current;
    }
}
