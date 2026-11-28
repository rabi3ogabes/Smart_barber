<?php

use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Actions\CreateBooking;
use App\Modules\Booking\Enums\BookingSource;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Customer\Models\Customer;
use Illuminate\Support\Str;
use Tests\Support\BookingFixture as F;

function appAccount(): CustomerAccount
{
    return CustomerAccount::query()->create(['phone' => '+97455111222', 'name' => 'Omar', 'locale' => 'ar']);
}

function bookingBody(F $f, array $over = []): array
{
    return array_replace(['branch' => $f->branch->public_id, 'services' => [$f->haircut->public_id], 'barber' => $f->barberA->public_id, 'starts_at' => F::at('10:00')->toIso8601ZuluString()], $over);
}

it('lists public slots for a selection', function () {
    $f = F::make($this);
    $res = $this->getJson("/api/v1/branches/{$f->branch->public_id}/slots?services[]={$f->haircut->public_id}&barber=any&date=".F::day())->assertOk();

    expect($res->json('data.timezone'))->toBe('Asia/Qatar')
        ->and(collect($res->json('data.slots'))->firstWhere('time', '10:00')['barbers'])->toHaveCount(2)
        ->and(collect($res->json('data.slots'))->pluck('time'))->not->toContain('13:00');

    $this->getJson("/api/v1/branches/{$f->branch->public_id}/slots?date=".F::day())->assertUnprocessable();
});

it('quotes, books with a required idempotency key, and replays a retry', function () {
    $f = F::make($this);
    $account = appAccount();
    $headers = $this->customerHeaders($account);

    $this->postJson('/api/v1/customer/quotes', bookingBody($f), $headers)->assertOk()->assertJsonPath('data.total.amount', 6000);
    $this->postJson('/api/v1/customer/bookings', bookingBody($f), $headers)->assertStatus(428)->assertJsonPath('code', 'IDEMPOTENCY_KEY_REQUIRED');

    $key = ['Idempotency-Key' => (string) Str::uuid()];
    $first = $this->postJson('/api/v1/customer/bookings', bookingBody($f), $headers + $key)->assertCreated();
    $retry = $this->postJson('/api/v1/customer/bookings', bookingBody($f), $headers + $key)->assertCreated();

    expect($retry->json('data.id'))->toBe($first->json('data.id'))
        ->and($first->json('data.status'))->toBe('confirmed')
        ->and(Tenancy::runAs($f->salon, fn () => Booking::query()->count()))->toBe(1);

    // The customer profile was created once and linked to the account.
    $customer = Tenancy::runAs($f->salon, fn () => Customer::query()->where('customer_account_id', $account->id)->sole());
    expect($customer->source)->toBe('app');
});

it('answers 409 with alternatives when the slot was taken', function () {
    $f = F::make($this);
    $headers = $this->customerHeaders(appAccount());
    $this->postJson('/api/v1/customer/bookings', bookingBody($f), $headers + ['Idempotency-Key' => (string) Str::uuid()])->assertCreated();

    $this->postJson('/api/v1/customer/bookings', bookingBody($f, ['starts_at' => F::at('10:15')->toIso8601ZuluString()]), $headers + ['Idempotency-Key' => (string) Str::uuid()])
        ->assertStatus(409)
        ->assertJsonPath('code', 'BOOKING_SLOT_TAKEN')
        ->assertJsonCount(3, 'data.alternatives');
});

it('lists, shows, reschedules and cancels own bookings, and hides others', function () {
    $f = F::make($this);
    $mine = appAccount();
    $other = CustomerAccount::query()->create(['phone' => '+97455999888', 'name' => 'Other', 'locale' => 'en']);
    $h = $this->customerHeaders($mine);
    $id = $this->postJson('/api/v1/customer/bookings', bookingBody($f), $h + ['Idempotency-Key' => (string) Str::uuid()])->json('data.id');

    $this->getJson('/api/v1/customer/bookings', $h)->assertOk()->assertJsonCount(1, 'data');
    $this->getJson("/api/v1/customer/bookings/{$id}", $h)->assertOk()->assertJsonPath('data.history.0.to', 'confirmed');
    app('auth')->forgetGuards(); // the test app keeps the last resolved user between requests
    $this->getJson("/api/v1/customer/bookings/{$id}", $this->customerHeaders($other))->assertNotFound();
    $this->postJson("/api/v1/customer/bookings/{$id}/cancel", [], $this->customerHeaders($other))->assertNotFound();
    app('auth')->forgetGuards();

    $this->postJson("/api/v1/customer/bookings/{$id}/reschedule", ['starts_at' => F::at('11:00')->toIso8601ZuluString()], $h + ['Idempotency-Key' => (string) Str::uuid()])
        ->assertOk()->assertJsonPath('data.starts_at', F::at('11:00')->toIso8601ZuluString());
    $this->postJson("/api/v1/customer/bookings/{$id}/cancel", ['reason' => 'travel'], $h)->assertOk()->assertJsonPath('data.status', 'cancelled');
    $this->getJson('/api/v1/customer/bookings?scope=past', $h)->assertJsonCount(1, 'data');
});

it('lets staff run the reception flow through the staff API', function () {
    $f = F::make($this);
    $receptionist = $this->memberOf($f->salon, P::RECEPTIONIST, [$f->branch]);
    $h = $this->staffHeaders($receptionist, $f->salon);

    $created = $this->postJson('/api/v1/staff/bookings', bookingBody($f, ['new_customer' => ['name' => 'Walk In', 'phone' => '5512 3456'], 'source' => 'walk_in']), $h + ['Idempotency-Key' => (string) Str::uuid()])
        ->assertCreated();
    $id = $created->json('data.id');
    expect($created->json('data.customer.phone'))->toBe('+97455123456')
        ->and($created->json('data.actions'))->toContain('arrive')->toContain('cancel')->toContain('reschedule');

    $this->getJson('/api/v1/staff/bookings?date='.F::day(), $h)->assertOk()->assertJsonCount(1, 'data');
    $this->postJson("/api/v1/staff/bookings/{$id}/arrive", [], $h)->assertOk()->assertJsonPath('data.status', 'arrived');
    $this->postJson("/api/v1/staff/bookings/{$id}/start", [], $h)->assertOk();
    $this->postJson("/api/v1/staff/bookings/{$id}/complete", [], $h)->assertOk()->assertJsonPath('data.status', 'completed');
    $this->postJson("/api/v1/staff/bookings/{$id}/complete", [], $h)->assertStatus(409)->assertJsonPath('code', 'BOOKING_INVALID_TRANSITION');

    $this->getJson('/api/v1/staff/customers?q=walk', $h)->assertOk()->assertJsonPath('data.0.visits', 1);
});

it('gives barbers only their own chair and masked phone numbers', function () {
    $f = F::make($this);
    $f->run(fn () => app(CreateBooking::class)($f->branch, $f->customer, $f->haircut(), F::at('10:00'), BookingSource::Dashboard, $f->barberB));
    $barberUser = User::query()->findOrFail($f->barberA->user_id);
    $h = $this->staffHeaders($barberUser, $f->salon);

    $this->getJson('/api/v1/staff/bookings?date='.F::day(), $h)->assertOk()->assertJsonCount(0, 'data');
    // A barber may book only into their own chair.
    $this->postJson('/api/v1/staff/bookings', bookingBody($f, ['customer' => $f->customer->public_id, 'barber' => $f->barberB->public_id, 'starts_at' => F::at('15:00')->toIso8601ZuluString()]), $h + ['Idempotency-Key' => (string) Str::uuid()])->assertForbidden();
    $own = $this->postJson('/api/v1/staff/bookings', bookingBody($f, ['customer' => $f->customer->public_id, 'starts_at' => F::at('15:00')->toIso8601ZuluString()]), $h + ['Idempotency-Key' => (string) Str::uuid()])->assertCreated();
    expect($own->json('data.customer.phone'))->toContain('•')
        ->and($own->json('data.actions'))->not->toContain('cancel');
});

it('keeps salon B out of salon A bookings', function () {
    $a = F::make($this, 'salon-a');
    $booking = $a->run(fn () => app(CreateBooking::class)($a->branch, $a->customer, $a->haircut(), F::at('10:00'), BookingSource::Dashboard, $a->barberA));
    ['salon' => $b, 'branch' => $branchB] = $this->makeSalon('salon-b');
    $staffB = $this->memberOf($b, P::RECEPTIONIST, [$branchB]);
    $h = $this->staffHeaders($staffB, $b);

    $this->getJson("/api/v1/staff/bookings/{$booking->public_id}", $h)->assertNotFound();
    $this->postJson("/api/v1/staff/bookings/{$booking->public_id}/cancel", [], $h)->assertNotFound();
    $this->postJson('/api/v1/staff/bookings', bookingBody($a, ['customer' => $a->customer->public_id]), $h + ['Idempotency-Key' => (string) Str::uuid()])->assertNotFound();
    expect($booking->fresh()->status)->toBe(BookingStatus::Confirmed);
});
