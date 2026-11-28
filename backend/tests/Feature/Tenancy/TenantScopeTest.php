<?php

use App\Core\Features\Feature;
use App\Core\Features\SalonFeature;
use App\Core\Identity\Models\User;
use App\Core\Settings\Setting;
use App\Core\Settings\Settings;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\SalonMembership;
use App\Core\Tenancy\Tenancy;
use App\Core\Tenancy\TenantNotResolved;
use App\Modules\Booking\Models\Booking;
use App\Modules\Catalog\Models\BarberService;
use App\Modules\Catalog\Models\BranchService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Models\ServiceCategory;
use App\Modules\Customer\Models\Customer;
use App\Modules\Customer\Models\CustomerDue;
use App\Modules\Salon\Models\BranchClosure;
use App\Modules\Salon\Models\BranchOpeningHour;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\BarberBreak;
use App\Modules\Staff\Models\BarberScheduleOverride;
use App\Modules\Staff\Models\BarberWorkingHour;
use App\Modules\Staff\Models\StaffInvitation;
use App\Modules\Staff\Models\TimeOffRequest;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Tests\Support\CountBranchesJob;

it('fails closed when no salon is set', function () {
    $this->makeSalon();
    Branch::query()->count();
})->throws(TenantNotResolved::class);

it('refuses to create tenant rows without a salon', function () {
    Branch::query()->create(['name' => ['ar' => 'x', 'en' => 'x']]);
})->throws(TenantNotResolved::class);

it('refuses to write rows for another salon', function () {
    ['salon' => $a] = $this->makeSalon('salon-a');
    ['salon' => $b] = $this->makeSalon('salon-b');

    Tenancy::runAs($a, function () use ($b) {
        $branch = new Branch(['name' => ['ar' => 'x', 'en' => 'x']]);
        $branch->forceFill(['salon_id' => $b->getKey()])->save();
    });
})->throws(TenantNotResolved::class);

it('refuses to move a row to another salon', function () {
    ['salon' => $a, 'branch' => $branch] = $this->makeSalon('salon-a');
    ['salon' => $b] = $this->makeSalon('salon-b');

    Tenancy::runAs($a, fn () => $branch->forceFill(['salon_id' => $b->getKey()])->save());
})->throws(TenantNotResolved::class);

/*
| Every tenant model: salon A only ever sees its own rows. Extend this dataset in every phase.
*/
dataset('tenant models', [
    'branches' => [fn () => Branch::factory()->create()],
    'memberships' => [fn () => SalonMembership::query()->firstOrFail()],
    'settings' => [function () {
        Settings::set(Tenancy::current(), 'booking.auto_confirm', true);

        return Setting::query()->firstOrFail();
    }],
    'salon features' => [function () {
        Feature::enable(Tenancy::current(), Feature::LOYALTY);

        return SalonFeature::query()->firstOrFail();
    }],
    // Phase 2
    'branch opening hours' => [fn () => BranchOpeningHour::query()->create(['branch_id' => Branch::query()->value('id'), 'weekday' => 1, 'opens_at' => '10:00', 'closes_at' => '22:00'])],
    'branch closures' => [fn () => BranchClosure::query()->create(['branch_id' => null, 'starts_on' => '2027-01-01', 'ends_on' => '2027-01-01'])],
    'staff invitations' => [fn () => StaffInvitation::query()->create(['email' => 'x@example.test', 'role_names' => ['barber'], 'branch_ids' => [], 'token_hash' => hash('sha256', Str::random(48)), 'invited_by' => User::factory()->create()->id, 'expires_at' => now()->addDay()])],
    'barbers' => [fn () => Barber::factory()->create()],
    'barber working hours' => [fn () => BarberWorkingHour::query()->create(['barber_id' => Barber::factory()->create()->id, 'branch_id' => Branch::query()->value('id'), 'weekday' => 1, 'starts_at' => '10:00', 'ends_at' => '18:00'])],
    'barber breaks' => [fn () => BarberBreak::query()->create(['barber_id' => Barber::factory()->create()->id, 'branch_id' => Branch::query()->value('id'), 'weekday' => 1, 'starts_at' => '13:00', 'ends_at' => '13:30'])],
    'schedule overrides' => [fn () => BarberScheduleOverride::query()->create(['barber_id' => Barber::factory()->create()->id, 'branch_id' => Branch::query()->value('id'), 'date' => '2027-01-04', 'type' => 'day_off'])],
    'time off requests' => [fn () => TimeOffRequest::query()->create(['barber_id' => Barber::factory()->create()->id, 'starts_at' => '2027-01-04 00:00:00', 'ends_at' => '2027-01-05 00:00:00', 'type' => 'annual', 'status' => 'pending'])],
    // Phase 3
    'service categories' => [fn () => ServiceCategory::factory()->create()],
    'services' => [fn () => Service::factory()->create()],
    'service add-ons' => [fn () => ServiceAddon::query()->create(['name' => ['ar' => 'x', 'en' => 'x'], 'price' => 1000])],
    'service bundles' => [fn () => ServiceBundle::query()->create(['name' => ['ar' => 'x', 'en' => 'x'], 'price' => 1000])],
    'branch prices' => [fn () => BranchService::query()->create(['branch_id' => Branch::query()->value('id'), 'service_id' => Service::factory()->create()->id, 'price_override' => 500])],
    'barber prices' => [fn () => BarberService::query()->create(['barber_id' => Barber::factory()->create()->id, 'service_id' => Service::factory()->create()->id, 'price_override' => 500])],
    // Phase 4
    'customers' => [fn () => Customer::query()->create(['name' => 'X', 'phone' => '+97455000099'])],
    'customer dues' => [fn () => CustomerDue::query()->create(['customer_id' => Customer::query()->create(['name' => 'Y', 'phone' => '+97455000098'])->id, 'type' => 'no_show_fee', 'amount' => 100, 'currency' => 'QAR'])],
    'bookings' => [function () {
        $barber = Barber::factory()->create();
        $customer = Customer::query()->create(['name' => 'Z', 'phone' => '+97455000097']);

        return Booking::query()->create(['branch_id' => Branch::query()->value('id'), 'customer_id' => $customer->id, 'barber_id' => $barber->id, 'starts_at' => '2027-01-04 07:00:00', 'ends_at' => '2027-01-04 07:30:00', 'blocked_until' => '2027-01-04 07:35:00', 'status' => 'confirmed', 'source' => 'dashboard', 'subtotal_amount' => 100, 'total_amount' => 100, 'currency' => 'QAR', 'quote_snapshot' => []]);
    }],
]);

it('isolates', function (Closure $make) {
    ['salon' => $a] = $this->makeSalon('salon-a');
    ['salon' => $b] = $this->makeSalon('salon-b');

    $recordOfB = Tenancy::runAs($b, $make);
    $class = $recordOfB::class;

    Tenancy::runAs($a, function () use ($class, $recordOfB) {
        expect($class::query()->whereKey($recordOfB->getKey())->exists())->toBeFalse()
            ->and($class::query()->pluck('salon_id')->unique()->all())->each->toBe(Tenancy::id());

        if ($recordOfB->getRouteKeyName() === 'public_id') {
            expect($class::query()->where('public_id', $recordOfB->getAttribute('public_id'))->exists())->toBeFalse();
        }
    });
})->with('tenant models');

it('stores settings per salon', function () {
    ['salon' => $a] = $this->makeSalon('salon-a');
    ['salon' => $b] = $this->makeSalon('salon-b');

    Tenancy::runAs($a, fn () => Settings::set($a, 'booking.auto_confirm', false));

    expect(Tenancy::runAs($a, fn () => Settings::get($a, 'booking.auto_confirm', true)))->toBeFalse()
        ->and(Tenancy::runAs($b, fn () => Settings::get($b, 'booking.auto_confirm', true)))->toBeTrue();
});

it('gates features per salon and honours expiry', function () {
    ['salon' => $a] = $this->makeSalon('salon-a');
    ['salon' => $b] = $this->makeSalon('salon-b');

    Feature::enable($a, Feature::AI_STUDIO);
    expect(Feature::enabled($a, Feature::AI_STUDIO))->toBeTrue()
        ->and(Feature::enabled($b, Feature::AI_STUDIO))->toBeFalse();

    Tenancy::runAs($a, fn () => SalonFeature::query()->update(['expires_at' => now()->subMinute()]));
    expect(Feature::enabled($a, Feature::AI_STUDIO))->toBeFalse();
});

it('restores the dispatching salon inside queued jobs and fails closed without one', function () {
    ['salon' => $a] = $this->makeSalon('salon-a');
    $this->addBranch($a);
    config(['queue.default' => 'database']);

    Tenancy::runAs($a, function (): void {
        dispatch(new CountBranchesJob);
    });
    dispatch(new CountBranchesJob); // no salon

    $this->artisan('queue:work', ['--once' => true, '--stop-when-empty' => true]);
    expect(Cache::get('job.salon'))->toBe($a->getKey())
        ->and(Cache::get('job.branches'))->toBe(2)
        ->and(Tenancy::id())->toBeNull();

    Cache::flush();
    $this->artisan('queue:work', ['--once' => true, '--stop-when-empty' => true]);
    expect(Cache::get('job.branches'))->toBeNull()
        ->and(DB::table('failed_jobs')->count())->toBe(1);
});
