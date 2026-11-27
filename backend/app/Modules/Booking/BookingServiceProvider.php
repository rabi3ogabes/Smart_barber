<?php

namespace App\Modules\Booking;

use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Policies\BookingPolicy;
use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;

/**
 * Booking module (L4): the status machine, AvailabilityService, the locked create/reschedule
 * path (ADR-004), the calendar broadcast and reminder scheduling.
 */
final class BookingServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        Gate::policy(Booking::class, BookingPolicy::class);
        Relation::morphMap(['booking' => Booking::class]);
    }
}
