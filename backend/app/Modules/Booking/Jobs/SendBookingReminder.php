<?php

namespace App\Modules\Booking\Jobs;

use App\Core\Contracts\NotificationChannel;
use App\Modules\Booking\Models\Booking;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;

/**
 * "Your appointment is tomorrow / in 2 hours". Queued with a delay when a booking is created or
 * rescheduled; it re-checks at run time and does nothing if the booking moved or ended, so old
 * reminders for a rescheduled booking are harmless. Real channels plug in at Phase 11.
 */
final class SendBookingReminder implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable;

    /**
     * @param  '24h'|'2h'  $kind
     */
    public function __construct(public readonly int $bookingId, public readonly string $expectedStartsAt, public readonly string $kind)
    {
        $this->onQueue('notifications');
    }

    public function handle(NotificationChannel $channel): void
    {
        $booking = Booking::query()->with('customer')->find($this->bookingId);
        if ($booking === null || ! $booking->status->isActive() || $booking->starts_at->toIso8601ZuluString() !== $this->expectedStartsAt || $booking->customer === null) {
            return;
        }

        $channel->notify($booking->customer, "booking.reminder_{$this->kind}", [
            'booking' => $booking->public_id,
            'starts_at' => $this->expectedStartsAt,
        ]);
    }
}
