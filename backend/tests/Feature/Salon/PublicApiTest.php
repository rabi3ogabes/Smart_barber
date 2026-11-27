<?php

use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Salon\Actions\SetOpeningHours;
use App\Modules\Salon\Models\BranchClosure;
use App\Modules\Staff\Actions\SetWeeklySchedule;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\TimeOffRequest;
use Illuminate\Support\Str;

function hoursWeek(string $start, string $end): array
{
    return collect(range(0, 6))->mapWithKeys(fn ($d) => [$d => [['start' => $start, 'end' => $end]]])->all();
}

it('serves the public salon profile with money in minor units', function () {
    ['salon' => $salon] = $this->makeSalon();
    Salon::query()->whereKey($salon->id)->update(['no_show_fee_amount' => 2500, 'contact_phone' => '+97444123456']);

    $this->getJson('/api/v1/salons/salon-a')
        ->assertOk()
        ->assertJsonPath('data.slug', 'salon-a')
        ->assertJsonPath('data.currency', 'QAR')
        ->assertJsonPath('data.contact.phone', '+97444123456')
        ->assertJsonPath('data.booking_policy.no_show_fee.amount', 2500)
        ->assertJsonPath('data.booking_policy.no_show_fee.currency', 'QAR');

    $this->getJson('/api/v1/salons/no-such-salon')->assertNotFound()->assertJsonPath('code', 'NOT_FOUND');
});

it('hides suspended salons and inactive branches from the public API', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $closed = $this->addBranch($salon);
    Tenancy::runAs($salon, fn () => $closed->forceFill(['is_active' => false])->save());

    $this->getJson('/api/v1/salons/salon-a/branches')->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('data.0.id', $branch->public_id);
    $this->getJson("/api/v1/branches/{$closed->public_id}")->assertNotFound();

    Salon::query()->whereKey($salon->id)->update(['status' => Salon::STATUS_SUSPENDED]);
    $this->getJson('/api/v1/salons/salon-a')->assertNotFound();
    $this->getJson("/api/v1/branches/{$branch->public_id}")->assertNotFound();
});

it('returns a branch with weekly hours and upcoming closures', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    Tenancy::runAs($salon, function () use ($branch) {
        app(SetOpeningHours::class)($branch, [0 => [['start' => '10:00', 'end' => '13:00'], ['start' => '16:00', 'end' => '23:00']]]);
        BranchClosure::query()->create(['branch_id' => null, 'starts_on' => now()->addDays(10)->toDateString(), 'ends_on' => now()->addDays(12)->toDateString(), 'reason' => ['en' => 'Eid', 'ar' => 'عيد']]);
    });

    $this->getJson("/api/v1/branches/{$branch->public_id}")
        ->assertOk()
        ->assertJsonPath('data.id', $branch->public_id)
        ->assertJsonPath('data.timezone', 'Asia/Qatar')
        ->assertJsonPath('data.week.0.1.start', '16:00')
        ->assertJsonCount(1, 'data.closures');
});

it('lists only bookable, active barbers of the branch', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $visible = $this->memberOf($salon, P::BARBER, [$branch]);
    $hidden = $this->memberOf($salon, P::BARBER, [$branch]);
    $other = $this->memberOf($salon, P::BARBER, [$this->addBranch($salon)]);
    Tenancy::runAs($salon, fn () => Barber::query()->where('user_id', $hidden->id)->update(['is_bookable' => false]));

    $ids = collect($this->getJson("/api/v1/branches/{$branch->public_id}/barbers")->assertOk()->json('data'))->pluck('id');
    $expected = Tenancy::runAs($salon, fn () => Barber::query()->where('user_id', $visible->id)->value('public_id'));

    expect($ids->all())->toBe([$expected]);
    expect($other)->not->toBeNull();
});

it('gives a barber their schedule per branch in UTC, minus approved time off', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $user = $this->memberOf($salon, P::BARBER, [$branch]);
    Tenancy::runAs($salon, function () use ($branch, $user) {
        app(SetOpeningHours::class)($branch, hoursWeek('10:00', '22:00'));
        app(SetWeeklySchedule::class)(Barber::query()->where('user_id', $user->id)->firstOrFail(), $branch, hoursWeek('10:00', '18:00'), []);
    });

    $this->getJson('/api/v1/staff/schedule?from=2027-01-03&to=2027-01-04', $this->staffHeaders($user, $salon))
        ->assertOk()
        ->assertJsonPath('data.0.branch', $branch->public_id)
        ->assertJsonPath('data.0.intervals.0', ['start' => '2027-01-03T07:00:00Z', 'end' => '2027-01-03T15:00:00Z'])
        ->assertJsonCount(2, 'data.0.intervals');

    $this->getJson('/api/v1/staff/schedule?from=2027-01-01&to=2027-03-01', $this->staffHeaders($user, $salon))->assertUnprocessable()->assertJsonPath('code', 'VALIDATION_FAILED');
});

it('lets a barber request and cancel time off from the app, idempotently', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $user = $this->memberOf($salon, P::BARBER, [$branch]);
    $headers = $this->staffHeaders($user, $salon) + ['Idempotency-Key' => (string) Str::uuid()];
    $day = now('Asia/Qatar')->addDays(4)->toDateString();
    $body = ['starts_on' => $day, 'ends_on' => $day, 'type' => 'personal', 'reason' => 'Family'];

    $first = $this->postJson('/api/v1/staff/time-off', $body, $headers)->assertCreated()->assertJsonPath('data.status', 'pending');
    $this->postJson('/api/v1/staff/time-off', $body, $headers)->assertCreated()->assertJsonPath('data.id', $first->json('data.id'));
    expect(Tenancy::runAs($salon, fn () => TimeOffRequest::query()->count()))->toBe(1);

    // A different key for the same days is a real duplicate: refused.
    $this->postJson('/api/v1/staff/time-off', $body, ['Idempotency-Key' => (string) Str::uuid()] + $headers)
        ->assertUnprocessable()->assertJsonPath('code', 'TIME_OFF_OVERLAPS');

    $this->getJson('/api/v1/staff/time-off', $headers)->assertOk()->assertJsonCount(1, 'data');
    $this->postJson('/api/v1/staff/time-off/'.$first->json('data.id').'/cancel', [], $headers)->assertOk()->assertJsonPath('data.status', 'cancelled');
});

it('does not let a barber cancel someone else\'s time off or read another salon', function () {
    ['salon' => $a, 'branch' => $branchA] = $this->makeSalon('salon-a');
    ['salon' => $b, 'branch' => $branchB] = $this->makeSalon('salon-b');
    $mine = $this->memberOf($a, P::BARBER, [$branchA]);
    $colleague = $this->memberOf($a, P::BARBER, [$branchA]);
    $foreign = $this->memberOf($b, P::BARBER, [$branchB]);
    $colleagueRequest = Tenancy::runAs($a, fn () => TimeOffRequest::query()->create(['barber_id' => Barber::query()->where('user_id', $colleague->id)->value('id'), 'starts_at' => now()->addDays(3), 'ends_at' => now()->addDays(4), 'type' => 'annual', 'status' => 'pending']));
    $foreignRequest = Tenancy::runAs($b, fn () => TimeOffRequest::query()->create(['barber_id' => Barber::query()->where('user_id', $foreign->id)->value('id'), 'starts_at' => now()->addDays(3), 'ends_at' => now()->addDays(4), 'type' => 'annual', 'status' => 'pending']));

    $headers = $this->staffHeaders($mine, $a);
    $this->postJson("/api/v1/staff/time-off/{$colleagueRequest->public_id}/cancel", [], $headers)->assertNotFound();
    $this->postJson("/api/v1/staff/time-off/{$foreignRequest->public_id}/cancel", [], $headers)->assertNotFound();
    $this->getJson('/api/v1/staff/time-off', $headers)->assertOk()->assertJsonCount(0, 'data');
});
