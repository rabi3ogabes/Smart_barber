<?php

namespace App\Modules\Booking\Events;

use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Modules\Booking\Models\Booking;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Contracts\Events\ShouldDispatchAfterCommit;
use Illuminate\Foundation\Events\Dispatchable;

/**
 * Live calendar update on private-salon.{salon}.branch.{branch} (Reverb). Carries ids only: the
 * calendar refetches through the authorised JSON endpoint, so nothing private leaks on the socket.
 */
final class BookingChanged implements ShouldBroadcast, ShouldDispatchAfterCommit
{
    use Dispatchable, InteractsWithSockets;

    public string $queue = 'notifications';

    public function __construct(
        public readonly string $salonId,
        public readonly string $branchId,
        public readonly string $bookingId,
        public readonly string $action,
    ) {}

    public static function for(Booking $booking, string $action): self
    {
        $salon = (string) Salon::query()->whereKey($booking->salon_id)->value('public_id');
        $branch = (string) Branch::query()->withoutGlobalScopes()->whereKey($booking->branch_id)->value('public_id');

        return new self($salon, $branch, $booking->public_id, $action);
    }

    public static function channelName(string $salon, string $branch): string
    {
        return "salon.{$salon}.branch.{$branch}";
    }

    /**
     * @return list<PrivateChannel>
     */
    public function broadcastOn(): array
    {
        return [new PrivateChannel(self::channelName($this->salonId, $this->branchId))];
    }

    public function broadcastAs(): string
    {
        return 'booking.changed';
    }

    /**
     * @return array{booking: string, action: string}
     */
    public function broadcastWith(): array
    {
        return ['booking' => $this->bookingId, 'action' => $this->action];
    }
}
