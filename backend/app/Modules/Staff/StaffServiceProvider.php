<?php

namespace App\Modules\Staff;

use App\Core\Tenancy\Events\MemberAccessChanged;
use App\Core\Tenancy\Models\SalonMembership;
use App\Modules\Staff\Listeners\SyncBarberProfile;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\BarberScheduleOverride;
use App\Modules\Staff\Models\StaffInvitation;
use App\Modules\Staff\Models\TimeOffRequest;
use App\Modules\Staff\Policies\BarberPolicy;
use App\Modules\Staff\Policies\MemberPolicy;
use App\Modules\Staff\Policies\TimeOffPolicy;
use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;

/**
 * Staff module (L2): invitations, memberships UI, barber profiles, schedules, time off.
 */
final class StaffServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        Gate::policy(SalonMembership::class, MemberPolicy::class);
        Gate::policy(Barber::class, BarberPolicy::class);
        Gate::policy(TimeOffRequest::class, TimeOffPolicy::class);

        Event::listen(MemberAccessChanged::class, SyncBarberProfile::class);

        Relation::morphMap([
            'barber' => Barber::class,
            'staff_invitation' => StaffInvitation::class,
            'time_off_request' => TimeOffRequest::class,
            'barber_schedule_override' => BarberScheduleOverride::class,
        ]);
    }
}
