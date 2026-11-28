<?php

use App\Core\Contracts\NotificationChannel;
use App\Core\Identity\Models\AccountMedia;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Identity\Models\Device;
use App\Core\Identity\Models\PersonalAccessToken;
use App\Modules\Booking\Actions\CreateBooking;
use App\Modules\Booking\Enums\BookingSource;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Jobs\SendBookingReminder;
use App\Modules\Booking\Models\Booking;
use App\Modules\Customer\Actions\FindOrCreateCustomer;
use App\Modules\Customer\Models\Customer;
use App\Modules\Review\Models\BookingReview;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Tests\Support\BookingFixture as F;

function profileAccount(string $phone = '+97455111222'): CustomerAccount
{
    return CustomerAccount::query()->create(['phone' => $phone, 'name' => 'Omar', 'email' => 'omar@example.com', 'locale' => 'en']);
}

it('uploads an avatar, square-crops it in a job and replaces the previous one', function () {
    Storage::fake('media');
    $account = profileAccount();
    $h = $this->customerHeaders($account);

    $this->post('/api/v1/customer/me/avatar', ['avatar' => UploadedFile::fake()->image('me.png', 800, 600)], $h)->assertOk()
        ->assertJsonPath('data.avatar_url', fn ($url) => is_string($url) && $url !== '');
    $first = AccountMedia::query()->sole();
    expect([$first->width, $first->height, $first->mime])->toBe([512, 512, 'image/jpeg']);
    Storage::disk('media')->assertExists($first->path);

    $this->post('/api/v1/customer/me/avatar', ['avatar' => UploadedFile::fake()->image('me2.jpg', 400, 400)], $h)->assertOk();
    expect(AccountMedia::query()->count())->toBe(1);
    Storage::disk('media')->assertMissing($first->path);

    $this->post('/api/v1/customer/me/avatar', ['avatar' => UploadedFile::fake()->create('x.pdf', 10, 'application/pdf')], $h)->assertUnprocessable();
});

it('reads and saves notification preferences with safe defaults', function () {
    $account = profileAccount();
    $h = $this->customerHeaders($account);

    $this->getJson('/api/v1/customer/me/notification-preferences', $h)->assertOk()
        ->assertJsonPath('data', ['booking_updates' => true, 'reminders' => true, 'offers' => false]);
    $this->putJson('/api/v1/customer/me/notification-preferences', ['reminders' => false, 'offers' => true, 'unknown' => true], $h)->assertOk()
        ->assertJsonPath('data', ['booking_updates' => true, 'reminders' => false, 'offers' => true]);
    $this->putJson('/api/v1/customer/me/notification-preferences', ['reminders' => 'maybe'], $h)->assertUnprocessable();
});

it('skips reminders the customer turned off', function () {
    $f = F::make($this);
    $account = profileAccount();
    $account->forceFill(['notification_preferences' => ['reminders' => false]])->save();
    $booking = $f->run(function () use ($f, $account) {
        $customer = app(FindOrCreateCustomer::class)($account->phone, 'Omar', 'app', $account);

        return app(CreateBooking::class)($f->branch, $customer, $f->haircut(), F::at('10:00'), BookingSource::App, $f->barberA);
    });

    $channel = Mockery::mock(NotificationChannel::class);
    $channel->shouldNotReceive('notify');
    $f->run(fn () => (new SendBookingReminder($booking->id, $booking->starts_at->toIso8601ZuluString(), '24h'))->handle($channel));
});

it('deletes the account: signs out everywhere, anonymises every salon profile and keeps the financial history', function () {
    Storage::fake('media');
    $a = F::make($this, 'salon-a');
    $b = F::make($this, 'salon-b');
    $account = profileAccount();
    $h = $this->customerHeaders($account);
    $this->post('/api/v1/customer/me/avatar', ['avatar' => UploadedFile::fake()->image('me.png', 300, 300)], $h)->assertOk();
    Device::query()->forceCreate(['owner_type' => $account->getMorphClass(), 'owner_id' => $account->id, 'app' => 'customer', 'platform' => 'android', 'fcm_token' => 'tok-1']);

    $book = fn (F $f, string $time) => $f->run(function () use ($f, $account, $time) {
        $customer = app(FindOrCreateCustomer::class)($account->phone, 'Omar', 'app', $account);
        $customer->forceFill(['internal_notes' => 'likes short sides'])->save();

        return app(CreateBooking::class)($f->branch, $customer, $f->haircut(), F::at($time), BookingSource::App, $f->barberA, customerNotes: 'call me');
    });
    $upcoming = $book($a, '10:00');
    $done = $book($b, '11:00');
    $b->run(function () use ($done) {
        $done->forceFill(['status' => BookingStatus::Completed])->save();
        BookingReview::query()->create(['booking_id' => $done->id, 'branch_id' => $done->branch_id, 'customer_id' => $done->customer_id, 'barber_id' => $done->barber_id, 'rating' => 5, 'comment' => 'Omar was happy']);
    });

    $this->postJson('/api/v1/customer/me/deletion-request', ['reason' => 'moving away'], $h)->assertStatus(202);

    // Signed out everywhere.
    expect(PersonalAccessToken::query()->where('tokenable_id', $account->id)->count())->toBe(0)
        ->and(Device::query()->count())->toBe(0);
    app('auth')->forgetGuards();
    $this->getJson('/api/v1/customer/me', $h)->assertUnauthorized();

    // Account anonymised; avatar gone.
    $gone = CustomerAccount::withTrashed()->findOrFail($account->id);
    expect($gone->trashed())->toBeTrue()
        ->and($gone->name)->toBeNull()->and($gone->email)->toBeNull()
        ->and($gone->phone)->toStartWith('del-')->and($gone->anonymised_at)->not->toBeNull()
        ->and(AccountMedia::query()->count())->toBe(0);

    // Each salon profile anonymised, unlinked; the upcoming booking cancelled, the completed one kept.
    foreach ([$a, $b] as $f) {
        $profile = $f->run(fn () => Customer::query()->where('name', 'Deleted customer')->sole());
        expect($profile->phone)->toStartWith('del-')->not->toContain('55111222')
            ->and($profile->customer_account_id)->toBeNull()
            ->and($profile->email)->toBeNull()
            ->and($f->run(fn () => DB::table('customers')->where('id', $profile->id)->value('internal_notes')))->toBeNull();
    }
    expect($a->run(fn () => $upcoming->fresh()->status))->toBe(BookingStatus::Cancelled);
    $kept = $b->run(fn () => Booking::query()->findOrFail($done->id));
    expect($kept->status)->toBe(BookingStatus::Completed)
        ->and($kept->total_amount)->toBe(6000)
        ->and($kept->customer_notes)->toBeNull()
        ->and($b->run(fn () => BookingReview::query()->sole()))->rating->toBe(5)->comment->toBeNull();

    // No personal value survives in the profiles' audit trail.
    $audit = DB::table('audit_logs')->where('auditable_type', 'customer')->get()->map(fn ($r) => $r->old_values.$r->new_values)->implode(' ');
    expect($audit)->not->toContain('+97455111222')->not->toContain('likes short sides')->not->toContain('omar@example.com');

    // The same phone can sign up again as a brand-new account.
    expect(CustomerAccount::query()->where('phone', '+97455111222')->exists())->toBeFalse();
    $this->postJson('/api/v1/customer/auth/otp', ['phone' => '+97455111222'])->assertOk();
});
