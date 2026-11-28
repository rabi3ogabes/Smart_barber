<?php

use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Identity\Models\User;
use App\Modules\Booking\Actions\CreateBooking;
use App\Modules\Booking\Enums\BookingSource;
use Inertia\Testing\AssertableInertia as Assert;
use Tests\Support\BookingFixture as F;

function dashBook(F $f, string $time, $barber = null)
{
    return $f->run(fn () => app(CreateBooking::class)($f->branch, $f->customer, $f->haircut(), F::at($time), BookingSource::Dashboard, $barber ?? $f->barberA));
}

it('renders the calendar page and returns bookings plus working hours for the range', function () {
    $f = F::make($this);
    $booking = dashBook($f, '10:00');

    $this->actingAs($f->owner)->get($this->salonUrl($f->salon, '/calendar?date='.F::day()))
        ->assertInertia(fn (Assert $page) => $page->component('Calendar/Index')->has('barbers', 2)->where('can.create', true)->where('date', F::day()));

    $res = $this->actingAs($f->owner)->getJson($this->salonUrl($f->salon, "/calendar/events?branch={$f->branch->public_id}&from=".F::day().'&to='.F::day()))->assertOk();
    expect($res->json('data.bookings.0.id'))->toBe($booking->public_id)
        ->and($res->json('data.bookings.0.actions'))->toContain('reschedule')
        ->and($res->json("data.hours.{$f->barberA->public_id}"))->toHaveCount(2); // 10–13 and 13:30–18
});

it('creates a booking with a new walk-in customer from the drawer', function () {
    $f = F::make($this);
    $res = $this->actingAs($f->owner)->postJson($this->salonUrl($f->salon, '/bookings'), [
        'branch' => $f->branch->public_id, 'services' => [$f->haircut->public_id], 'barber' => 'any',
        'starts_at' => F::at('12:00')->toIso8601ZuluString(), 'new_customer' => ['name' => 'Saad', 'phone' => '٥٥١٢٣٤٥٦'], 'source' => 'walk_in',
    ])->assertCreated();

    expect($res->json('data.customer.phone'))->toBe('+97455123456')->and($res->json('data.source'))->toBe('walk_in');
    $this->actingAs($f->owner)->getJson($this->salonUrl($f->salon, '/customers/search?q=saad'))->assertOk()->assertJsonPath('data.0.name', 'Saad');
});

it('reverts a drag with 409 and alternatives when the target is taken', function () {
    $f = F::make($this);
    $moving = dashBook($f, '10:00');
    dashBook($f, '12:00');

    $this->actingAs($f->owner)->putJson($this->salonUrl($f->salon, "/bookings/{$moving->public_id}/reschedule"), ['starts_at' => F::at('12:15')->toIso8601ZuluString(), 'barber' => $f->barberA->public_id])
        ->assertStatus(409)->assertJsonPath('code', 'BOOKING_SLOT_TAKEN')->assertJsonCount(3, 'data.alternatives');
    $this->actingAs($f->owner)->putJson($this->salonUrl($f->salon, "/bookings/{$moving->public_id}/reschedule"), ['starts_at' => F::at('12:00')->toIso8601ZuluString(), 'barber' => $f->barberB->public_id])
        ->assertOk()->assertJsonPath('data.barber.id', $f->barberB->public_id);
});

it('runs status actions and refuses invalid transitions with 409', function () {
    $f = F::make($this);
    $b = dashBook($f, '10:00');
    $url = fn (string $a) => $this->salonUrl($f->salon, "/bookings/{$b->public_id}/{$a}");

    $this->actingAs($f->owner)->putJson($url('complete'))->assertStatus(409)->assertJsonPath('code', 'BOOKING_INVALID_TRANSITION');
    $this->actingAs($f->owner)->putJson($url('arrive'))->assertOk()->assertJsonPath('data.status', 'arrived');
    $this->actingAs($f->owner)->putJson($url('cancel'), ['reason' => 'left'])->assertOk()->assertJsonPath('data.status', 'cancelled');
    $this->actingAs($f->owner)->getJson($this->salonUrl($f->salon, "/bookings/{$b->public_id}"))->assertJsonCount(3, 'data.history');
});

it('lists bookings with filters', function () {
    $f = F::make($this);
    dashBook($f, '10:00');
    dashBook($f, '10:00', $f->barberB);

    $this->actingAs($f->owner)->get($this->salonUrl($f->salon, '/bookings?from='.F::day().'&to='.F::day()."&barber={$f->barberB->public_id}"))
        ->assertInertia(fn (Assert $page) => $page->component('Bookings/Index')->has('bookings', 1)->where('pagination.total', 1));
    $this->actingAs($f->owner)->get($this->salonUrl($f->salon, '/bookings?from='.F::day().'&to='.F::day().'&q=ali'))
        ->assertInertia(fn (Assert $page) => $page->has('bookings', 2));
});

it('limits branch managers to their branches and barbers to their chair', function () {
    $f = F::make($this);
    $other = $this->addBranch($f->salon);
    $manager = $this->memberOf($f->salon, P::BRANCH_MANAGER, [$other]);
    $b = dashBook($f, '10:00');

    $this->actingAs($manager)->getJson($this->salonUrl($f->salon, "/bookings/{$b->public_id}"))->assertNotFound();
    $this->actingAs($manager)->putJson($this->salonUrl($f->salon, "/bookings/{$b->public_id}/cancel"))->assertNotFound();
    $this->actingAs($manager)->getJson($this->salonUrl($f->salon, "/calendar/events?branch={$f->branch->public_id}&from=".F::day().'&to='.F::day()))->assertNotFound();

    $barberUser = User::query()->findOrFail($f->barberB->user_id);
    $this->actingAs($barberUser)->getJson($this->salonUrl($f->salon, "/calendar/events?branch={$f->branch->public_id}&from=".F::day().'&to='.F::day()))
        ->assertOk()->assertJsonCount(0, 'data.bookings');
    $this->actingAs($barberUser)->putJson($this->salonUrl($f->salon, "/bookings/{$b->public_id}/arrive"))->assertNotFound();
});
