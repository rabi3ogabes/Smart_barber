<?php

use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Tenancy\Tenancy;
use App\Modules\Salon\Actions\SetOpeningHours;
use App\Modules\Staff\Enums\TimeOffStatus;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\BarberBreak;
use App\Modules\Staff\Models\BarberScheduleOverride;
use App\Modules\Staff\Models\BarberWorkingHour;
use App\Modules\Staff\Models\TimeOffRequest;
use Carbon\CarbonImmutable;
use Inertia\Testing\AssertableInertia as Assert;

function barberOf($salon, $user): Barber
{
    return Tenancy::runAs($salon, fn () => Barber::query()->where('user_id', $user->id)->firstOrFail());
}

function fullWeek(string $start, string $end): array
{
    return collect(range(0, 6))->mapWithKeys(fn ($d) => [$d => [['start' => $start, 'end' => $end]]])->all();
}

it('shows the weekly grid with hours, breaks and weekly totals', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $manager = $this->memberOf($salon, P::BRANCH_MANAGER, [$branch]);
    $barber = barberOf($salon, $this->memberOf($salon, P::BARBER, [$branch]));

    Tenancy::runAs($salon, fn () => app(SetOpeningHours::class)($branch, fullWeek('10:00', '22:00')));
    $this->actingAs($manager)->put($this->salonUrl($salon, "/schedules/{$barber->public_id}"), [
        'branch' => $branch->public_id,
        'hours' => fullWeek('10:00', '18:00'),
        'breaks' => [1 => [['start' => '13:00', 'end' => '13:30']]],
    ])->assertSessionHasNoErrors();

    $this->actingAs($manager)->get($this->salonUrl($salon, '/schedules'))
        ->assertInertia(fn (Assert $page) => $page->component('Schedules/Index')
            ->where('branch.id', $branch->public_id)
            ->has('barbers', 1)
            ->where('barbers.0.can_update', true)
            ->where('barbers.0.breaks.1.0.start', '13:00')
            ->where('barbers.0.week_minutes', 7 * 8 * 60 - 30));

    expect(Tenancy::runAs($salon, fn () => [BarberWorkingHour::query()->count(), BarberBreak::query()->count()]))->toBe([7, 1]);
});

it('rejects overlapping schedule ranges', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $this->enableTwoFactor($owner);
    $barber = barberOf($salon, $this->memberOf($salon, P::BARBER, [$branch]));

    $this->actingAs($owner)->put($this->salonUrl($salon, "/schedules/{$barber->public_id}"), [
        'branch' => $branch->public_id,
        'hours' => [2 => [['start' => '10:00', 'end' => '15:00'], ['start' => '14:00', 'end' => '20:00']]],
        'breaks' => [],
    ])->assertSessionHasErrors('hours');
});

it('limits who can change schedules: barbers see only their own, managers only their branches', function () {
    ['salon' => $salon, 'branch' => $mine] = $this->makeSalon();
    $other = $this->addBranch($salon);
    $manager = $this->memberOf($salon, P::BRANCH_MANAGER, [$mine]);
    $receptionist = $this->memberOf($salon, P::RECEPTIONIST, [$mine]);
    $barberUser = $this->memberOf($salon, P::BARBER, [$mine]);
    $this->memberOf($salon, P::BARBER, [$mine]);
    $barber = barberOf($salon, $barberUser);
    $elsewhere = barberOf($salon, $this->memberOf($salon, P::BARBER, [$other]));
    $payload = fn ($branch) => ['branch' => $branch->public_id, 'hours' => fullWeek('10:00', '12:00'), 'breaks' => []];

    $this->actingAs($barberUser)->get($this->salonUrl($salon, '/schedules'))
        ->assertInertia(fn (Assert $page) => $page->has('barbers', 1)->where('barbers.0.id', $barber->public_id)->where('barbers.0.can_update', false));
    $this->actingAs($barberUser)->put($this->salonUrl($salon, "/schedules/{$barber->public_id}"), $payload($mine))->assertNotFound();
    $this->actingAs($receptionist)->put($this->salonUrl($salon, "/schedules/{$barber->public_id}"), $payload($mine))->assertForbidden();
    $this->actingAs($manager)->put($this->salonUrl($salon, "/schedules/{$elsewhere->public_id}"), $payload($other))->assertNotFound();
    $this->actingAs($manager)->put($this->salonUrl($salon, "/schedules/{$barber->public_id}"), $payload($mine))->assertSessionHasNoErrors();
});

it('adds and removes one-off overrides', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $this->enableTwoFactor($owner);
    $barber = barberOf($salon, $this->memberOf($salon, P::BARBER, [$branch]));
    $day = now('Asia/Qatar')->addDays(2)->toDateString();
    $url = $this->salonUrl($salon, "/schedules/{$barber->public_id}/overrides");

    $this->actingAs($owner)->post($url, ['branch' => $branch->public_id, 'date' => $day, 'type' => 'custom_hours', 'start' => '18:00', 'end' => '14:00'])->assertSessionHasErrors('end');
    $this->actingAs($owner)->post($url, ['branch' => $branch->public_id, 'date' => $day, 'type' => 'custom_hours', 'start' => '14:00', 'end' => '18:00'])->assertSessionHasNoErrors();
    // Same date again replaces it.
    $this->actingAs($owner)->post($url, ['branch' => $branch->public_id, 'date' => $day, 'type' => 'day_off', 'reason' => 'Wedding'])->assertSessionHasNoErrors();

    $override = Tenancy::runAs($salon, fn () => BarberScheduleOverride::query()->sole());
    expect($override->type)->toBe('day_off');

    $this->actingAs($owner)->delete($this->salonUrl($salon, "/schedule-overrides/{$override->public_id}"))->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => BarberScheduleOverride::query()->count()))->toBe(0);
});

it('runs the time-off flow: request, overlap check, approve, cancel', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $manager = $this->memberOf($salon, P::BRANCH_MANAGER, [$branch]);
    $barberUser = $this->memberOf($salon, P::BARBER, [$branch]);
    $barber = barberOf($salon, $barberUser);
    $start = now('Asia/Qatar')->addDays(5)->toDateString();
    $end = now('Asia/Qatar')->addDays(7)->toDateString();

    $this->actingAs($barberUser)->post($this->salonUrl($salon, '/time-off'), ['barber' => $barber->public_id, 'starts_on' => $start, 'ends_on' => $end, 'type' => 'annual'])
        ->assertSessionHasNoErrors();
    $this->actingAs($barberUser)->post($this->salonUrl($salon, '/time-off'), ['barber' => $barber->public_id, 'starts_on' => $end, 'ends_on' => $end, 'type' => 'personal'])
        ->assertSessionHasErrors('starts_on');

    $request = Tenancy::runAs($salon, fn () => TimeOffRequest::query()->sole());
    expect($request->status)->toBe(TimeOffStatus::Pending)
        ->and($request->starts_at->toIso8601ZuluString())->toBe(CarbonImmutable::parse($start, 'Asia/Qatar')->utc()->toIso8601ZuluString())
        ->and($request->ends_at->diffInDays($request->starts_at, true))->toEqual(3);

    // A barber cannot approve their own request.
    $this->actingAs($barberUser)->put($this->salonUrl($salon, "/time-off/{$request->public_id}/decision"), ['approve' => true])->assertForbidden();

    $this->actingAs($manager)->get($this->salonUrl($salon, '/time-off'))
        ->assertInertia(fn (Assert $page) => $page->component('TimeOff/Index')->where('requests.0.can_decide', true));
    $this->actingAs($manager)->put($this->salonUrl($salon, "/time-off/{$request->public_id}/decision"), ['approve' => true, 'note' => 'Enjoy'])->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => $request->refresh()->status))->toBe(TimeOffStatus::Approved);
    $this->actingAs($manager)->put($this->salonUrl($salon, "/time-off/{$request->public_id}/decision"), ['approve' => false])->assertSessionHasErrors();

    $this->actingAs($barberUser)->put($this->salonUrl($salon, "/time-off/{$request->public_id}/cancel"))->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => $request->refresh()->status))->toBe(TimeOffStatus::Cancelled);
});

it('auto-approves leave a manager enters, and keeps managers to their branches', function () {
    ['salon' => $salon, 'branch' => $mine] = $this->makeSalon();
    $other = $this->addBranch($salon);
    $manager = $this->memberOf($salon, P::BRANCH_MANAGER, [$mine]);
    $here = barberOf($salon, $this->memberOf($salon, P::BARBER, [$mine]));
    $there = barberOf($salon, $this->memberOf($salon, P::BARBER, [$other]));
    $day = now('Asia/Qatar')->addDays(3)->toDateString();

    $this->actingAs($manager)->post($this->salonUrl($salon, '/time-off'), ['barber' => $here->public_id, 'starts_on' => $day, 'ends_on' => $day, 'type' => 'sick'])->assertSessionHasNoErrors();
    $this->actingAs($manager)->post($this->salonUrl($salon, '/time-off'), ['barber' => $there->public_id, 'starts_on' => $day, 'ends_on' => $day, 'type' => 'sick'])->assertForbidden();

    expect(Tenancy::runAs($salon, fn () => TimeOffRequest::query()->sole()->status))->toBe(TimeOffStatus::Approved);

    // Several requests on the page (regression: the list must not lazy-load barbers).
    $later = now('Asia/Qatar')->addDays(10)->toDateString();
    $this->actingAs($manager)->post($this->salonUrl($salon, '/time-off'), ['barber' => $here->public_id, 'starts_on' => $later, 'ends_on' => $later, 'type' => 'annual'])->assertSessionHasNoErrors();
    $this->actingAs($manager)->get($this->salonUrl($salon, '/time-off'))
        ->assertOk()
        ->assertInertia(fn (Assert $page) => $page->has('requests', 2)->where('barbers', fn ($b) => collect($b)->pluck('id')->all() === [$here->public_id]));
});

it('isolates schedules and time off between salons', function () {
    ['salon' => $a, 'owner' => $ownerA, 'branch' => $branchA] = $this->makeSalon('salon-a');
    ['salon' => $b, 'branch' => $branchB] = $this->makeSalon('salon-b');
    $this->enableTwoFactor($ownerA);
    $barberB = barberOf($b, $this->memberOf($b, P::BARBER, [$branchB]));
    $requestB = Tenancy::runAs($b, fn () => TimeOffRequest::query()->create(['barber_id' => $barberB->id, 'starts_at' => now()->addDays(3), 'ends_at' => now()->addDays(4), 'type' => 'annual', 'status' => 'pending']));

    $this->actingAs($ownerA)->put($this->salonUrl($a, "/schedules/{$barberB->public_id}"), ['branch' => $branchA->public_id, 'hours' => [], 'breaks' => []])->assertNotFound();
    $this->actingAs($ownerA)->put($this->salonUrl($a, "/time-off/{$requestB->public_id}/decision"), ['approve' => true])->assertNotFound();
    $this->actingAs($ownerA)->post($this->salonUrl($a, '/time-off'), ['barber' => $barberB->public_id, 'starts_on' => now()->addDay()->toDateString(), 'ends_on' => now()->addDay()->toDateString(), 'type' => 'annual'])->assertNotFound();
    expect(Tenancy::runAs($b, fn () => $requestB->refresh()->status))->toBe(TimeOffStatus::Pending);
});
