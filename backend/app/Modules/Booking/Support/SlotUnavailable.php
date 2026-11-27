<?php

namespace App\Modules\Booking\Support;

use RuntimeException;

/**
 * Internal signal inside the locked section: this barber cannot take the time. Turned into
 * BOOKING_SLOT_TAKEN / BOOKING_OUTSIDE_HOURS by the actions (never reaches a client as is).
 */
final class SlotUnavailable extends RuntimeException
{
    /**
     * @param  'overlap'|'outside_hours'  $reason
     */
    public function __construct(public readonly string $reason)
    {
        parent::__construct($reason);
    }
}
