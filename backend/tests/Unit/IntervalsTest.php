<?php

use App\Modules\Staff\Schedule\Interval;
use App\Modules\Staff\Schedule\Intervals;
use Carbon\CarbonImmutable;

$i = fn (string $from, string $to) => Interval::local('2027-01-03', $from, $to, 'Asia/Qatar');
$pairs = fn (array $list) => array_map(fn (Interval $x) => [$x->start->setTimezone('Asia/Qatar')->format('H:i'), $x->end->setTimezone('Asia/Qatar')->format('H:i')], $list);

it('converts branch-local wall-clock times to UTC', function () use ($i) {
    $x = $i('10:00', '13:00');
    expect($x->start->toIso8601ZuluString())->toBe('2027-01-03T07:00:00Z')
        ->and($x->minutes())->toBe(180);
});

it('rejects empty or inverted intervals', function () {
    new Interval(CarbonImmutable::parse('2027-01-03 10:00'), CarbonImmutable::parse('2027-01-03 10:00'));
})->throws(InvalidArgumentException::class);

it('merges overlapping and touching intervals', function () use ($i, $pairs) {
    expect($pairs(Intervals::normalize([$i('14:00', '16:00'), $i('10:00', '12:00'), $i('12:00', '13:00'), $i('15:00', '18:00')])))
        ->toBe([['10:00', '13:00'], ['14:00', '18:00']]);
});

it('intersects multi-range days', function () use ($i, $pairs) {
    $open = [$i('10:00', '13:00'), $i('16:00', '23:00')];
    $work = [$i('09:00', '20:00')];
    expect($pairs(Intervals::intersect($work, $open)))->toBe([['10:00', '13:00'], ['16:00', '20:00']]);
});

it('subtracts breaks, splitting a range in two', function () use ($i, $pairs) {
    $result = Intervals::subtract([$i('10:00', '18:00')], [$i('13:00', '13:30'), $i('17:30', '19:00')]);
    expect($pairs($result))->toBe([['10:00', '13:00'], ['13:30', '17:30']])
        ->and(Intervals::totalMinutes($result))->toBe(420);
});

it('returns nothing when a break covers the whole range', function () use ($i) {
    expect(Intervals::subtract([$i('10:00', '11:00')], [$i('09:00', '12:00')]))->toBe([]);
});
