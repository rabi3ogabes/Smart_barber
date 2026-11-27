<?php

namespace App\Modules\Booking\Events;

use App\Modules\Booking\Models\Booking;
use Illuminate\Contracts\Events\ShouldDispatchAfterCommit;
use Illuminate\Foundation\Events\Dispatchable;

/**
 * Dispatched after the transaction commits (ADR-004 step 5). Notification listeners arrive in Phase 11.
 */
final class BookingConfirmed implements ShouldDispatchAfterCommit
{
    use Dispatchable;

    /**
     * @param  array<string, mixed>  $meta
     */
    public function __construct(public readonly Booking $booking, public readonly array $meta = []) {}
}
