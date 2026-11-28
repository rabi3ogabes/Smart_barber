<?php

use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Features\Feature;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Settings\Settings;
use App\Core\Tenancy\Models\Salon;
use App\Modules\Booking\Actions\CreateBooking;
use App\Modules\Booking\Enums\BookingSource;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Customer\Actions\FindOrCreateCustomer;
use Tests\Support\BookingFixture as F;

function homeAccount(string $phone = '+97455111222'): CustomerAccount
{
    return CustomerAccount::query()->create(['phone' => $phone, 'name' => 'Omar', 'locale' => 'en']);
}

/** Books for the app account in the fixture's salon; optionally marks it completed. */
function appBooking(F $f, CustomerAccount $account, string $time, int $daysAhead = 3, bool $completed = false): Booking
{
    return $f->run(function () use ($f, $account, $time, $daysAhead, $completed) {
        $customer = app(FindOrCreateCustomer::class)($account->phone, (string) $account->name, 'app', $account);
        // Past visits are booked in the future, then moved back: the booking window forbids the past.
        $booking = app(CreateBooking::class)($f->branch, $customer, $f->haircut(), F::at($time, max($daysAhead, 3)), BookingSource::Dashboard, $f->barberA);
        if ($daysAhead < 3) {
            $shift = 3 - $daysAhead;
            $booking->forceFill(['starts_at' => $booking->starts_at->subDays($shift), 'ends_at' => $booking->ends_at->subDays($shift), 'blocked_until' => $booking->blocked_until->subDays($shift)])->save();
        }
        if ($completed) {
            $booking->forceFill(['status' => BookingStatus::Completed])->save();
        }

        return $booking->fresh();
    });
}

describe('salon entry', function () {
    it('finds only salons that opted into the listing', function () {
        $a = F::make($this, 'luxe-cuts');
        $b = F::make($this, 'luxe-hidden');
        $a->run(fn () => Settings::set($a->salon, 'listing.enabled', true));

        $res = $this->getJson('/api/v1/salons/search?q=luxe')->assertOk();
        expect(collect($res->json('data'))->pluck('slug')->all())->toBe(['luxe-cuts']);

        $this->getJson('/api/v1/salons/search?q=l')->assertUnprocessable();
        $b->run(fn () => Settings::set($b->salon, 'listing.enabled', false));
        $this->getJson('/api/v1/salons/search?q=hidden')->assertOk()->assertJsonCount(0, 'data');
    });

    it('resolves QR codes and deep links, and refuses unknown or suspended salons', function () {
        $f = F::make($this, 'luxe-cuts');
        $domain = config('smartbarber.domain');

        foreach (['luxe-cuts', 'LUXE-CUTS', "https://luxe-cuts.{$domain}/", "https://{$domain}/s/luxe-cuts", 'smartbarber://salon/luxe-cuts', $f->salon->public_id] as $code) {
            $this->getJson('/api/v1/salons/resolve?code='.urlencode($code))->assertOk()
                ->assertJsonPath('data.slug', 'luxe-cuts')
                ->assertJsonPath('data.branches_count', 1);
        }

        $this->getJson('/api/v1/salons/resolve?code=nope-salon')->assertNotFound()->assertJsonPath('code', 'INVALID_SALON_CODE');
        $this->getJson('/api/v1/salons/resolve?code='.urlencode('https://evil.example.com/x'))->assertNotFound();
        $f->salon->forceFill(['status' => Salon::STATUS_SUSPENDED])->save();
        $this->getJson('/api/v1/salons/resolve?code=luxe-cuts')->assertNotFound();
    });

    it('lists only the salons this account has booked with', function () {
        $a = F::make($this, 'salon-a');
        F::make($this, 'salon-b');
        $mine = homeAccount();
        appBooking($a, $mine, '10:00');

        $this->getJson('/api/v1/customer/salons', $this->customerHeaders($mine))->assertOk()
            ->assertJsonCount(1, 'data')->assertJsonPath('data.0.slug', 'salon-a');
        app('auth')->forgetGuards();
        $this->getJson('/api/v1/customer/salons', $this->customerHeaders(homeAccount('+97455333444')))->assertOk()->assertJsonCount(0, 'data');
    });
});

describe('home', function () {
    it('shows next appointment, book again, a review prompt, popular services and feature flags', function () {
        $f = F::make($this);
        $account = homeAccount();
        appBooking($f, $account, '11:00', daysAhead: -2, completed: true);
        $next = appBooking($f, $account, '10:00');
        Feature::enable($f->salon, Feature::LOYALTY);

        $res = $this->getJson("/api/v1/customer/home?salon={$f->salon->slug}", $this->customerHeaders($account))->assertOk();

        expect($res->json('data.next_appointment.id'))->toBe($next->public_id)
            ->and($res->json('data.next_appointment.branch.timezone'))->toBe('Asia/Qatar')
            ->and($res->json('data.book_again.services'))->toBe([$f->haircut->public_id])
            ->and($res->json('data.book_again.barber.id'))->toBe($f->barberA->public_id)
            ->and($res->json('data.review_prompt.booking'))->not->toBeNull()
            ->and($res->json('data.popular_services.0.id'))->toBe($f->haircut->public_id)
            ->and($res->json('data.popular_services.0.price.amount'))->toBe(6000)
            ->and($res->json('data.features'))->toBe(['ai_studio' => false, 'loyalty' => true]);
    });

    it('never shows another customer or another salon', function () {
        $a = F::make($this, 'salon-a');
        $b = F::make($this, 'salon-b');
        $mine = homeAccount();
        appBooking($b, $mine, '10:00'); // my booking is at salon B

        $res = $this->getJson('/api/v1/customer/home?salon=salon-a', $this->customerHeaders($mine))->assertOk();
        expect($res->json('data.next_appointment'))->toBeNull()->and($res->json('data.book_again'))->toBeNull();

        app('auth')->forgetGuards();
        $other = homeAccount('+97455333444');
        $this->getJson('/api/v1/customer/home?salon=salon-b', $this->customerHeaders($other))->assertOk()->assertJsonPath('data.next_appointment', null);
        app('auth')->forgetGuards();
        $this->getJson('/api/v1/customer/home?salon=salon-a')->assertUnauthorized();
    });
});

describe('reviews', function () {
    it('rates a completed visit once and keeps the barber rating derived', function () {
        $f = F::make($this);
        $account = homeAccount();
        $done = appBooking($f, $account, '11:00', daysAhead: -2, completed: true);
        $upcoming = appBooking($f, $account, '10:00');
        $h = $this->customerHeaders($account);

        $this->postJson("/api/v1/customer/bookings/{$upcoming->public_id}/review", ['rating' => 5], $h)->assertUnprocessable()->assertJsonPath('code', 'REVIEW_NOT_ALLOWED');
        $this->postJson("/api/v1/customer/bookings/{$done->public_id}/review", ['rating' => 6], $h)->assertUnprocessable();
        $this->postJson("/api/v1/customer/bookings/{$done->public_id}/review", ['rating' => 4, 'comment' => ' Great fade '], $h)->assertCreated()->assertJsonPath('data.comment', 'Great fade');
        $this->postJson("/api/v1/customer/bookings/{$done->public_id}/review", ['rating' => 1], $h)->assertStatus(409)->assertJsonPath('code', 'REVIEW_ALREADY_SUBMITTED');

        expect($f->run(fn () => $f->barberA->fresh()))->rating_count->toBe(1)->rating_avg->toEqual('4.00');
        $this->getJson("/api/v1/customer/bookings/{$done->public_id}", $h)->assertJsonPath('data.review.rating', 4)->assertJsonPath('data.can_review', false);
        $this->getJson("/api/v1/branches/{$f->branch->public_id}/barbers")->assertJsonPath('data.0.rating', ['average' => 4, 'count' => 1]);

        app('auth')->forgetGuards();
        $this->postJson("/api/v1/customer/bookings/{$done->public_id}/review", ['rating' => 1], $this->customerHeaders(homeAccount('+97455333444')))->assertNotFound();
    });

    it('lets managers hide and re-publish a review, recomputing the rating; barbers cannot moderate', function () {
        $f = F::make($this);
        $account = homeAccount();
        $one = appBooking($f, $account, '11:00', daysAhead: -2, completed: true);
        $two = appBooking($f, $account, '12:00', daysAhead: -2, completed: true);
        $h = $this->customerHeaders($account);
        $this->postJson("/api/v1/customer/bookings/{$one->public_id}/review", ['rating' => 5], $h)->assertCreated();
        $id = $this->postJson("/api/v1/customer/bookings/{$two->public_id}/review", ['rating' => 1, 'comment' => 'rude'], $h)->json('data.id');
        app('auth')->forgetGuards();
        app('auth')->shouldUse('web');

        $this->actingAs($f->owner)->get($this->salonUrl($f->salon, '/reviews'))->assertOk()
            ->assertInertia(fn ($p) => $p->component('Reviews/Index')->has('reviews', 2)->where('summary.average', 3));
        $this->actingAs($f->owner)->put($this->salonUrl($f->salon, "/reviews/{$id}"), ['status' => 'hidden', 'note' => 'abusive'])->assertRedirect();
        expect($f->run(fn () => $f->barberA->fresh()))->rating_count->toBe(1)->rating_avg->toEqual('5.00');

        $this->actingAs($f->owner)->put($this->salonUrl($f->salon, "/reviews/{$id}"), ['status' => 'published'])->assertRedirect();
        expect($f->run(fn () => $f->barberA->fresh()))->rating_count->toBe(2);

        $barber = $this->memberOf($f->salon, P::BARBER, [$f->branch]);
        $this->enableTwoFactor($barber);
        $this->actingAs($barber)->get($this->salonUrl($f->salon, '/reviews'))->assertForbidden();
        $this->actingAs($barber)->put($this->salonUrl($f->salon, "/reviews/{$id}"), ['status' => 'hidden'])->assertForbidden();

        // Another salon's owner cannot see or touch it.
        $other = F::make($this, 'salon-b');
        $this->actingAs($other->owner)->put($this->salonUrl($other->salon, "/reviews/{$id}"), ['status' => 'hidden'])->assertNotFound();
    });
});

it('exports a booking as an iCalendar file for its owner only', function () {
    $f = F::make($this);
    $account = homeAccount();
    $booking = appBooking($f, $account, '10:00');

    $res = $this->get("/api/v1/customer/bookings/{$booking->public_id}/calendar.ics", $this->customerHeaders($account))->assertOk();
    expect($res->headers->get('Content-Type'))->toStartWith('text/calendar')
        ->and($res->getContent())->toContain('BEGIN:VEVENT')
        ->toContain('DTSTART:'.F::at('10:00')->format('Ymd\THis\Z'))
        ->toContain('UID:booking-'.$booking->public_id);

    app('auth')->forgetGuards();
    $this->getJson("/api/v1/customer/bookings/{$booking->public_id}/calendar.ics", $this->customerHeaders(homeAccount('+97455333444')))->assertNotFound();
});

it('lets the salon opt into app search from settings', function () {
    $f = F::make($this);
    $page = $this->actingAs($f->owner)->get($this->salonUrl($f->salon, '/settings/salon'))->assertOk();
    $profile = $page->viewData('page')['props']['profile'];
    expect($profile['listing_enabled'])->toBeFalse()->and($profile['app_link'])->toBe('smartbarber://salon/salon-a');

    $body = array_merge(array_intersect_key($profile, array_flip(['name', 'timezone', 'default_locale', 'tax_rate', 'prices_include_tax', 'lead_time_minutes', 'max_days_ahead', 'cancellation_window_minutes', 'no_show_fee'])), ['listing_enabled' => true]);
    $this->actingAs($f->owner)->put($this->salonUrl($f->salon, '/settings/salon'), $body)->assertSessionHasNoErrors();

    expect($f->run(fn () => Settings::get($f->salon, 'listing.enabled')))->toBeTrue();
    $this->getJson('/api/v1/salons/search?q=salon')->assertJsonPath('data.0.slug', 'salon-a');
});
