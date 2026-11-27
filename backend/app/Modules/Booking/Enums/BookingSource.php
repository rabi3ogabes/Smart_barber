<?php

namespace App\Modules\Booking\Enums;

enum BookingSource: string
{
    case App = 'app';
    case Dashboard = 'dashboard';
    case WalkIn = 'walk_in';
    case Phone = 'phone';
    case Queue = 'queue';

    /** Customer self-service bookings follow the salon's lead-time and window rules. */
    public function isCustomer(): bool
    {
        return $this === self::App;
    }
}
