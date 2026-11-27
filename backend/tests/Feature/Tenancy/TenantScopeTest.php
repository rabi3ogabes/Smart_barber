<?php

use App\Core\Features\Feature;
use App\Core\Features\SalonFeature;
use App\Core\Settings\Setting;
use App\Core\Settings\Settings;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\SalonMembership;
use App\Core\Tenancy\Tenancy;
use App\Core\Tenancy\TenantNotResolved;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
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
