<?php

use App\Core\Contracts\NotificationChannel;
use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Settings\Settings;
use App\Core\Tenancy\Models\Salon;
use App\Modules\Booking\Actions\CancelBooking;
use App\Modules\Booking\Actions\ChangeBookingStatus;
use App\Modules\Booking\Actions\CreateBooking;
use App\Modules\Booking\Actions\RescheduleBooking;
use App\Modules\Booking\Availability\AvailabilityService;
use App\Modules\Booking\Enums\BookingSource;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Events\BookingChanged;
use App\Modules\Booking\Events\BookingCreated;
use App\Modules\Booking\Events\BookingRescheduled;
use App\Modules\Booking\Jobs\SendBookingReminder;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Models\BookingStatusHistory;
use App\Modules\Booking\Support\Selection;
use App\Modules\Catalog\Models\BarberService;
use App\Modules\Customer\Models\CustomerDue;
use App\Modules\Salon\Models\BranchOpeningHour;
use App\Modules\Staff\Enums\TimeOffStatus;
use App\Modules\Staff\Enums\TimeOffType;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\BarberScheduleOverride;
use App\Modules\Staff\Models\TimeOffRequest;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Queue;
use Tests\Support\BookingFixture as F;

function book(F $f, CarbonImmutable $at, ?Barber $barber = null, ?Selection $sel = null, BookingSource $source = BookingSource::Dashboard): Booking
{
    return $f->run(fn () => app(CreateBooking::class)($f->branch, $f->customer, $sel ?? $f->haircut(), $at, $source, $barber ?? $f->barberA, $f->owner));
}

function code(callable $fn): ErrorCode
{
    try {
        $fn();
    } catch (AppException $e) {
        return $e->errorCode;
    }
    throw new RuntimeException('Expected an AppException');
}

it('creates a confirmed booking with price and line snapshots and a history row', function () {
    Event::fake([BookingCreated::class]);
    $f = F::make($this);
    $booking = book($f, F::at('10:00'));

    expect($booking->status)->toBe(BookingStatus::Confirmed)
        ->and($booking->ends_at->toIso8601ZuluString())->toBe(F::at('10:30')->toIso8601ZuluString())
        ->and($booking->blocked_until->toIso8601ZuluString())->toBe(F::at('10:35')->toIso8601ZuluString())
        ->and($booking->total_amount)->toBe(6000)
        ->and($booking->currency)->toBe('QAR')
        ->and($f->run(fn () => $booking->items()->sole()->getTranslation('name', 'en')))->toBe('Haircut')
        ->and($f->run(fn () => BookingStatusHistory::query()->where('booking_id', $booking->id)->sole()->to_status))->toBe('confirmed');
    Event::assertDispatched(BookingCreated::class);
});

it('allows touching blocked ranges and refuses overlaps, buffers included', function () {
    $f = F::make($this);
    book($f, F::at('10:00')); // blocked 10:00–10:35

    expect(code(fn () => book($f, F::at('10:30'))))->toBe(ErrorCode::BookingSlotTaken) // inside the buffer
        ->and(code(fn () => book($f, F::at('09:45', 3)->addMinutes(0)->setTime(6, 45))))->toBe(ErrorCode::BookingOutsideHours);
    $touching = book($f, F::at('10:35'));
    expect($touching->exists)->toBeTrue();

    // A 20-min beard ending exactly at 10:00 + 35? Starting 9:40 is outside hours; ending at a booking start is fine:
    $before = book($f, F::at('11:10'), sel: new Selection([$f->beard])); // 11:10–11:30, blocked till 11:30
    expect(book($f, F::at('11:30'))->exists)->toBeTrue()
        ->and($before->exists)->toBeTrue();
});

it('returns alternatives when the slot is taken', function () {
    $f = F::make($this);
    book($f, F::at('10:00'));
    try {
        book($f, F::at('10:15'));
        $this->fail('expected conflict');
    } catch (AppException $e) {
        expect($e->errorCode)->toBe(ErrorCode::BookingSlotTaken)
            ->and($e->status())->toBe(409)
            ->and($e->data['alternatives'])->toHaveCount(3)
            ->and($e->data['alternatives'][0])->toBe(F::at('10:45')->toIso8601ZuluString());
    }
});

it('respects breaks, multi-range days and approved time off', function () {
    $f = F::make($this);
    expect(code(fn () => book($f, F::at('12:45'))))->toBe(ErrorCode::BookingOutsideHours) // runs into the 13:00 break
        ->and(book($f, F::at('13:30'))->exists)->toBeTrue()
        ->and(code(fn () => book($f, F::at('17:45'))))->toBe(ErrorCode::BookingOutsideHours); // past 18:00

    $f->run(fn () => TimeOffRequest::query()->create(['barber_id' => $f->barberA->id, 'starts_at' => F::at('15:00'), 'ends_at' => F::at('16:00'), 'type' => TimeOffType::Personal, 'status' => TimeOffStatus::Approved]));
    expect(code(fn () => book($f, F::at('15:15'))))->toBe(ErrorCode::BookingOutsideHours)
        ->and(book($f, F::at('16:00'))->exists)->toBeTrue();
});

it('falls through to the next barber for "any", and fails only when nobody is free', function () {
    $f = F::make($this);
    $first = book($f, F::at('11:00'));
    $second = $f->run(fn () => app(CreateBooking::class)($f->branch, $f->customer, $f->haircut(), F::at('11:00'), BookingSource::Dashboard, null, $f->owner));

    expect($first->barber_id)->toBe($f->barberA->id)
        ->and($second->barber_id)->toBe($f->barberB->id)
        ->and(code(fn () => $f->run(fn () => app(CreateBooking::class)($f->branch, $f->customer, $f->haircut(), F::at('11:00'), BookingSource::Dashboard, null))))
        ->toBe(ErrorCode::BookingSlotTaken);
});

it('orders "any" by fewest bookings that day', function () {
    $f = F::make($this);
    book($f, F::at('10:00'));
    $any = $f->run(fn () => app(CreateBooking::class)($f->branch, $f->customer, $f->haircut(), F::at('15:00'), BookingSource::Dashboard));
    expect($any->barber_id)->toBe($f->barberB->id);
});

it('refuses a barber who does not perform the service', function () {
    $f = F::make($this);
    $f->run(fn () => BarberService::query()->where('barber_id', $f->barberA->id)->where('service_id', $f->beard->id)->delete());

    expect(code(fn () => book($f, F::at('10:00'), sel: new Selection([$f->beard]))))->toBe(ErrorCode::BarberNotEligible);
});

it('applies lead time, days ahead and auto-confirm to app bookings', function () {
    $f = F::make($this);
    Salon::query()->whereKey($f->salon->id)->update(['lead_time_minutes' => 120, 'max_days_ahead' => 7]);
    $f->salon->refresh();

    $soon = CarbonImmutable::now('UTC')->addMinutes(30);
    expect(code(fn () => book($f, $soon, source: BookingSource::App)))->toBe(ErrorCode::BookingLeadTime)
        ->and(code(fn () => book($f, F::at('10:00', 10), source: BookingSource::App)))->toBe(ErrorCode::BookingTooFarAhead)
        ->and(code(fn () => book($f, CarbonImmutable::now('UTC')->subHour())))->toBe(ErrorCode::BookingInPast);

    $f->run(fn () => Settings::set($f->salon, 'booking.auto_confirm', false));
    expect(book($f, F::at('10:00'), source: BookingSource::App)->status)->toBe(BookingStatus::Pending)
        ->and(book($f, F::at('11:00'))->status)->toBe(BookingStatus::Confirmed); // staff bookings are always confirmed
});

it('lists slots honouring bookings, buffers, breaks and the grid', function () {
    $f = F::make($this);
    book($f, F::at('10:00')); // A busy 10:00–10:35
    $slots = $f->run(fn () => app(AvailabilityService::class)->slots($f->branch, $f->haircut(), $f->barberA, F::day(), false));
    $times = array_column($slots, 'time');

    expect($times)->not->toContain('10:00')->not->toContain('10:15')->not->toContain('12:45')
        ->toContain('10:45')->toContain('12:30')->toContain('13:30')->toContain('17:30')
        ->not->toContain('17:45');

    $any = $f->run(fn () => app(AvailabilityService::class)->slots($f->branch, $f->haircut(), null, F::day(), false));
    $ten = collect($any)->firstWhere('time', '10:00');
    expect($ten['barbers'])->toBe([$f->barberB->public_id]);
});

it('reschedules in place, logs old and new times, and refuses conflicts', function () {
    Event::fake([BookingRescheduled::class]);
    $f = F::make($this);
    $booking = book($f, F::at('10:00'));
    book($f, F::at('12:00'));

    $moved = $f->run(fn () => app(RescheduleBooking::class)($booking, F::at('11:00'), null, $f->owner));
    expect($moved->public_id)->toBe($booking->public_id)
        ->and($moved->starts_at->toIso8601ZuluString())->toBe(F::at('11:00')->toIso8601ZuluString())
        ->and($moved->reschedule_count)->toBe(1)
        ->and($moved->status)->toBe(BookingStatus::Confirmed);
    $meta = $f->run(fn () => BookingStatusHistory::query()->where('booking_id', $booking->id)->latest('id')->first()->meta);
    expect($meta['from']['starts_at'])->toBe(F::at('10:00')->toIso8601ZuluString())
        ->and($meta['to']['starts_at'])->toBe(F::at('11:00')->toIso8601ZuluString());
    Event::assertDispatched(BookingRescheduled::class);

    // Onto itself (overlapping its own old range) is fine; onto another booking is not.
    expect($f->run(fn () => app(RescheduleBooking::class)($moved, F::at('11:15'), null, $f->owner))->exists)->toBeTrue()
        ->and(code(fn () => $f->run(fn () => app(RescheduleBooking::class)($moved->fresh(), F::at('11:45'), null, $f->owner))))->toBe(ErrorCode::BookingSlotTaken);

    // To the other barber at the same time.
    $other = $f->run(fn () => app(RescheduleBooking::class)($moved->fresh(), F::at('12:00'), $f->barberB, $f->owner));
    expect($other->barber_id)->toBe($f->barberB->id);
});

it('enforces the status machine', function () {
    $f = F::make($this);
    $booking = book($f, F::at('10:00'));
    $status = app(ChangeBookingStatus::class);

    expect(code(fn () => $f->run(fn () => $status->complete($booking, $f->owner))))->toBe(ErrorCode::BookingInvalidTransition);
    $f->run(function () use ($status, $booking, $f) {
        $status->markArrived($booking, $f->owner);
        $status->startService($booking, $f->owner);
        $status->complete($booking, $f->owner);
    });
    expect($booking->fresh()->status)->toBe(BookingStatus::Completed)
        ->and($f->customer->fresh()->visits_count)->toBe(1)
        ->and(code(fn () => $f->run(fn () => app(CancelBooking::class)($booking->fresh(), $f->owner, 'x', true))))->toBe(ErrorCode::BookingInvalidTransition)
        ->and(code(fn () => $f->run(fn () => app(RescheduleBooking::class)($booking->fresh(), F::at('15:00'), null, $f->owner))))->toBe(ErrorCode::BookingInvalidTransition)
        ->and($f->run(fn () => BookingStatusHistory::query()->where('booking_id', $booking->id)->pluck('to_status')->all()))->toBe(['confirmed', 'arrived', 'in_service', 'completed']);

    // Cancelled and completed bookings free the chair.
    expect(book($f, F::at('10:00'))->exists)->toBeTrue();
});

it('enforces the cancellation window unless the policy is overridden', function () {
    $f = F::make($this);
    Salon::query()->whereKey($f->salon->id)->update(['cancellation_window_minutes' => 180]);
    $soon = CarbonImmutable::now('Asia/Qatar')->addHours(2)->startOfHour();
    $f->run(fn () => BarberScheduleOverride::query()->create(['barber_id' => $f->barberA->id, 'branch_id' => $f->branch->id, 'date' => $soon->toDateString(), 'type' => 'custom_hours', 'starts_at' => '00:00', 'ends_at' => '23:59']));
    BranchOpeningHour::query()->withoutGlobalScopes()->where('branch_id', $f->branch->id)->update(['opens_at' => '00:00', 'closes_at' => '23:59']);
    $near = book($f, $soon->utc());
    $far = book($f, F::at('10:00'));

    expect(code(fn () => $f->run(fn () => app(CancelBooking::class)($near, null, 'late'))))->toBe(ErrorCode::BookingCancelWindowPassed)
        ->and($f->run(fn () => app(CancelBooking::class)($near, $f->owner, 'late', true))->status)->toBe(BookingStatus::Cancelled)
        ->and($f->run(fn () => app(CancelBooking::class)($far, null, 'plans changed'))->cancel_reason)->toBe('plans changed');
});

it('records a no-show fee as an append-only amount owed, only after the start', function () {
    $f = F::make($this);
    Salon::query()->whereKey($f->salon->id)->update(['no_show_fee_amount' => 2500]);
    $future = book($f, F::at('10:00'));
    expect(code(fn () => $f->run(fn () => app(ChangeBookingStatus::class)->markNoShow($future, $f->owner))))->toBe(ErrorCode::BookingNotStarted);

    $past = $f->run(function () use ($f) {
        $b = book($f, F::at('11:00'));
        $b->forceFill(['starts_at' => now()->subHour(), 'ends_at' => now()->subMinutes(30), 'blocked_until' => now()->subMinutes(25)])->save();

        return app(ChangeBookingStatus::class)->markNoShow($b, $f->owner);
    });

    $due = $f->run(fn () => CustomerDue::query()->sole());
    expect($past->status)->toBe(BookingStatus::NoShow)
        ->and($due->amount)->toBe(2500)
        ->and($due->type)->toBe('no_show_fee')
        ->and($f->customer->fresh()->no_show_count)->toBe(1)
        ->and($f->run(fn () => $f->customer->fresh()->balanceOwed()))->toBe(2500);
    expect(fn () => $f->run(fn () => $due->forceFill(['amount' => 1])->save()))->toThrow(LogicException::class);
});

it('queues 24h and 2h reminders that ignore moved bookings', function () {
    Queue::fake();
    $f = F::make($this);
    $booking = book($f, F::at('10:00'));

    Queue::assertPushed(SendBookingReminder::class, 2);
    $f->run(fn () => app(RescheduleBooking::class)($booking, F::at('11:00'), null, $f->owner));
    Queue::assertPushed(SendBookingReminder::class, 4);

    $stale = new SendBookingReminder($booking->id, F::at('10:00')->toIso8601ZuluString(), '24h');
    $channel = Mockery::mock(NotificationChannel::class);
    $channel->shouldNotReceive('notify');
    $f->run(fn () => $stale->handle($channel));

    $current = new SendBookingReminder($booking->id, F::at('11:00')->toIso8601ZuluString(), '2h');
    $channel2 = Mockery::mock(NotificationChannel::class);
    $channel2->shouldReceive('notify')->once();
    $f->run(fn () => $current->handle($channel2));
});

it('broadcasts calendar changes on the branch channel after commit', function () {
    Event::fake([BookingChanged::class]);
    $f = F::make($this);
    $booking = book($f, F::at('10:00'));
    $f->run(fn () => app(ChangeBookingStatus::class)->markArrived($booking, $f->owner));

    Event::assertDispatched(BookingChanged::class, fn ($e) => $e->action === 'created'
        && $e->broadcastOn()[0]->name === "private-salon.{$f->salon->public_id}.branch.{$f->branch->public_id}"
        && $e->broadcastWith() === ['booking' => $booking->public_id, 'action' => 'created']);
    Event::assertDispatched(BookingChanged::class, fn ($e) => $e->action === 'arrived');
});
