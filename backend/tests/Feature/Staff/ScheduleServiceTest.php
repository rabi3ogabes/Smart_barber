<?php

use App\Core\Exceptions\AppException;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Tenancy;
use App\Modules\Salon\Actions\SetOpeningHours;
use App\Modules\Salon\Models\BranchClosure;
use App\Modules\Staff\Actions\SetWeeklySchedule;
use App\Modules\Staff\Enums\TimeOffStatus;
use App\Modules\Staff\Enums\TimeOffType;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\BarberScheduleOverride;
use App\Modules\Staff\Models\TimeOffRequest;
use App\Modules\Staff\Schedule\Interval;
use App\Modules\Staff\Schedule\ScheduleService;

/*
| ScheduleService: branch hours ∩ barber hours (or a one-off override) − breaks − closures −
| approved time off. Dates: 2027-01-03 is a Sunday (weekday 0).
*/

function scheduleFixture(object $test, string $tz = 'Asia/Qatar'): array
{
    ['salon' => $salon, 'branch' => $branch] = $test->makeSalon();
    $user = $test->memberOf($salon, 'barber', [$branch]);

    return Tenancy::runAs($salon, function () use ($salon, $branch, $user, $tz) {
        $branch->forceFill(['timezone' => $tz])->save();
        $barber = Barber::query()->where('user_id', $user->id)->firstOrFail();

        return ['salon' => $salon, 'branch' => $branch->refresh(), 'barber' => $barber];
    });
}

function sbWeek(array $ranges): array
{
    return collect(range(0, 6))->mapWithKeys(fn (int $d) => [$d => $ranges])->all();
}

function sbLocal(array $intervals, string $tz): array
{
    return array_map(fn (Interval $i) => $i->start->setTimezone($tz)->format('D H:i').'-'.$i->end->setTimezone($tz)->format('H:i'), $intervals);
}

it('creates a barber profile when someone gets the barber role', function () {
    ['salon' => $salon, 'branch' => $branch, 'barber' => $barber] = scheduleFixture($this);

    expect($barber->is_bookable)->toBeTrue()
        ->and(Tenancy::runAs($salon, fn () => $barber->branches()->pluck('branches.id')->all()))->toBe([$branch->id]);
});

it('intersects multi-range branch hours with barber hours and removes breaks', function () {
    ['salon' => $salon, 'branch' => $branch, 'barber' => $barber] = scheduleFixture($this);

    $result = Tenancy::runAs($salon, function () use ($branch, $barber) {
        app(SetOpeningHours::class)($branch, sbWeek([['start' => '10:00', 'end' => '13:00'], ['start' => '16:00', 'end' => '23:00']]));
        app(SetWeeklySchedule::class)($barber, $branch, [0 => [['start' => '09:00', 'end' => '20:00']]], [0 => [['start' => '18:00', 'end' => '18:30']]]);

        return app(ScheduleService::class)->workingIntervals($barber, $branch, '2027-01-03', '2027-01-04');
    });

    // Sunday only (Monday has no barber hours); 10–13, 16–18, 18:30–20.
    expect(sbLocal($result, 'Asia/Qatar'))->toBe(['Sun 10:00-13:00', 'Sun 16:00-18:00', 'Sun 18:30-20:00'])
        ->and($result[0]->start->toIso8601ZuluString())->toBe('2027-01-03T07:00:00Z');
});

it('applies day-off and custom-hours overrides', function () {
    ['salon' => $salon, 'branch' => $branch, 'barber' => $barber] = scheduleFixture($this);

    $result = Tenancy::runAs($salon, function () use ($branch, $barber) {
        app(SetOpeningHours::class)($branch, sbWeek([['start' => '10:00', 'end' => '22:00']]));
        app(SetWeeklySchedule::class)($barber, $branch, sbWeek([['start' => '10:00', 'end' => '18:00']]), []);
        BarberScheduleOverride::query()->create(['barber_id' => $barber->id, 'branch_id' => $branch->id, 'date' => '2027-01-03', 'type' => 'day_off']);
        BarberScheduleOverride::query()->create(['barber_id' => $barber->id, 'branch_id' => $branch->id, 'date' => '2027-01-04', 'type' => 'custom_hours', 'starts_at' => '15:00', 'ends_at' => '23:00']);

        return app(ScheduleService::class)->workingIntervals($barber, $branch, '2027-01-03', '2027-01-05');
    });

    // Sunday off; Monday 15–22 (clipped to opening); Tuesday normal.
    expect(sbLocal($result, 'Asia/Qatar'))->toBe(['Mon 15:00-22:00', 'Tue 10:00-18:00']);
});

it('skips branch and salon-wide closures', function () {
    ['salon' => $salon, 'branch' => $branch, 'barber' => $barber] = scheduleFixture($this);

    $result = Tenancy::runAs($salon, function () use ($branch, $barber) {
        app(SetOpeningHours::class)($branch, sbWeek([['start' => '10:00', 'end' => '22:00']]));
        app(SetWeeklySchedule::class)($barber, $branch, sbWeek([['start' => '10:00', 'end' => '18:00']]), []);
        BranchClosure::query()->create(['branch_id' => $branch->id, 'starts_on' => '2027-01-03', 'ends_on' => '2027-01-03', 'reason' => ['en' => 'Renovation']]);
        BranchClosure::query()->create(['branch_id' => null, 'starts_on' => '2027-01-05', 'ends_on' => '2027-01-05', 'reason' => ['en' => 'Holiday']]);

        return app(ScheduleService::class)->workingIntervals($barber, $branch, '2027-01-03', '2027-01-05');
    });

    expect(sbLocal($result, 'Asia/Qatar'))->toBe(['Mon 10:00-18:00']);
});

it('removes approved time off but ignores pending and rejected requests', function () {
    ['salon' => $salon, 'branch' => $branch, 'barber' => $barber] = scheduleFixture($this);

    $result = Tenancy::runAs($salon, function () use ($branch, $barber) {
        app(SetOpeningHours::class)($branch, sbWeek([['start' => '10:00', 'end' => '22:00']]));
        app(SetWeeklySchedule::class)($barber, $branch, sbWeek([['start' => '10:00', 'end' => '18:00']]), []);
        $make = fn (string $from, string $to, TimeOffStatus $status) => TimeOffRequest::query()->create([
            'barber_id' => $barber->id, 'starts_at' => $from, 'ends_at' => $to, 'type' => TimeOffType::Annual, 'status' => $status,
        ]);
        // Monday whole day (Qatar midnight = 21:00 UTC the day before), approved.
        $make('2027-01-03 21:00:00', '2027-01-04 21:00:00', TimeOffStatus::Approved);
        // Sunday afternoon, approved — partial day.
        $make('2027-01-03 11:00:00', '2027-01-03 15:00:00', TimeOffStatus::Approved);
        $make('2027-01-05 00:00:00', '2027-01-06 00:00:00', TimeOffStatus::Pending);
        $make('2027-01-05 00:00:00', '2027-01-06 00:00:00', TimeOffStatus::Rejected);

        return app(ScheduleService::class)->workingIntervals($barber, $branch, '2027-01-03', '2027-01-05');
    });

    expect(sbLocal($result, 'Asia/Qatar'))->toBe(['Sun 10:00-14:00', 'Tue 10:00-18:00']);
});

it('keeps wall-clock hours across a DST change while Gulf zones stay fixed', function () {
    ['salon' => $salon, 'branch' => $branch, 'barber' => $barber] = scheduleFixture($this, 'Europe/London');

    $result = Tenancy::runAs($salon, function () use ($branch, $barber) {
        app(SetOpeningHours::class)($branch, sbWeek([['start' => '09:00', 'end' => '17:00']]));
        app(SetWeeklySchedule::class)($barber, $branch, sbWeek([['start' => '09:00', 'end' => '17:00']]), []);

        return app(ScheduleService::class)->workingIntervals($barber, $branch, '2027-03-27', '2027-03-28');
    });

    // Saturday GMT → 09:00Z; Sunday BST (UTC+1) → 08:00Z. Both are 8 hours.
    expect(array_map(fn (Interval $i) => $i->toArray(), $result))->toBe([
        ['start' => '2027-03-27T09:00:00Z', 'end' => '2027-03-27T17:00:00Z'],
        ['start' => '2027-03-28T08:00:00Z', 'end' => '2027-03-28T16:00:00Z'],
    ]);

    $qatar = [Interval::local('2027-03-27', '09:00', '17:00', 'Asia/Qatar'), Interval::local('2027-03-28', '09:00', '17:00', 'Asia/Qatar')];
    expect($qatar[0]->start->format('H:i'))->toBe('06:00')->and($qatar[1]->start->format('H:i'))->toBe('06:00');
});

it('returns intervals per branch for barbers working at several branches', function () {
    ['salon' => $salon, 'branch' => $branch, 'barber' => $barber] = scheduleFixture($this);
    $second = $this->addBranch($salon);

    $result = Tenancy::runAs($salon, function () use ($branch, $second, $barber) {
        $barber->syncBranches([$branch->id, $second->id]);
        foreach ([$branch, $second] as $b) {
            app(SetOpeningHours::class)($b, sbWeek([['start' => '10:00', 'end' => '22:00']]));
        }
        app(SetWeeklySchedule::class)($barber, $branch, [0 => [['start' => '10:00', 'end' => '14:00']]], []);
        app(SetWeeklySchedule::class)($barber, $second, [0 => [['start' => '16:00', 'end' => '20:00']]], []);

        return app(ScheduleService::class)->workingIntervalsAllBranches($barber, '2027-01-03', '2027-01-03');
    });

    expect(array_map(fn ($list) => sbLocal($list, 'Asia/Qatar'), $result))->toBe([
        $branch->public_id => ['Sun 10:00-14:00'],
        $second->public_id => ['Sun 16:00-20:00'],
    ]);
});

it('refuses a schedule for a branch the barber does not work at', function () {
    ['salon' => $salon, 'barber' => $barber] = scheduleFixture($this);
    $other = $this->addBranch($salon);

    Tenancy::runAs($salon, fn () => app(SetWeeklySchedule::class)($barber, Branch::query()->findOrFail($other->id), sbWeek([['start' => '10:00', 'end' => '12:00']]), []));
})->throws(AppException::class);
