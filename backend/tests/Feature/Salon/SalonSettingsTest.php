<?php

use App\Core\Audit\AuditLog;
use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Inertia\Testing\AssertableInertia as Assert;

function salonPayload(array $overrides = []): array
{
    return array_replace_recursive([
        'name' => ['ar' => 'صالون النخبة', 'en' => 'Elite Barbers'],
        'legal_name' => 'Elite Grooming W.L.L.',
        'timezone' => 'Asia/Qatar',
        'default_locale' => 'ar',
        'tax_number' => '123456789',
        'tax_rate' => '5',
        'prices_include_tax' => true,
        'contact_phone' => '+97444123456',
        'contact_email' => 'hello@elite.test',
        'social_links' => ['instagram' => 'https://instagram.com/elite'],
        'lead_time_minutes' => 90,
        'max_days_ahead' => 45,
        'cancellation_window_minutes' => 180,
        'no_show_fee' => '25.50',
    ], $overrides);
}

it('shows the salon profile to the owner', function () {
    ['salon' => $salon, 'owner' => $owner] = $this->makeSalon();
    $this->enableTwoFactor($owner);

    $this->actingAs($owner)->get($this->salonUrl($salon, '/settings/salon'))
        ->assertOk()
        ->assertInertia(fn (Assert $page) => $page->component('Settings/Salon')->where('canUpdate', true)->where('profile.currency', 'QAR'));
});

it('updates the profile, storing money in minor units and VAT in basis points, and audits it', function () {
    ['salon' => $salon, 'owner' => $owner] = $this->makeSalon();
    $this->enableTwoFactor($owner);

    $this->actingAs($owner)->put($this->salonUrl($salon, '/settings/salon'), salonPayload())
        ->assertRedirect()->assertSessionHasNoErrors();

    $raw = Salon::query()->findOrFail($salon->id)->getAttributes();
    expect((int) $raw['no_show_fee_amount'])->toBe(2550)
        ->and((int) $raw['tax_rate_bp'])->toBe(500)
        ->and((int) $raw['lead_time_minutes'])->toBe(90)
        ->and(json_decode($raw['social_links'], true))->toBe(['instagram' => 'https://instagram.com/elite']);

    expect(AuditLog::query()->where('salon_id', $salon->id)->where('event', 'salons.updated')->exists())->toBeTrue();
});

it('validates the profile', function () {
    ['salon' => $salon, 'owner' => $owner] = $this->makeSalon();
    $this->enableTwoFactor($owner);

    $this->actingAs($owner)->put($this->salonUrl($salon, '/settings/salon'), salonPayload([
        'name' => ['en' => ''], 'timezone' => 'Mars/Base', 'contact_phone' => '5512', 'no_show_fee' => '-1', 'tax_rate' => '45', 'social_links' => ['website' => 'not a url'],
    ]))->assertSessionHasErrors(['name.en', 'timezone', 'contact_phone', 'no_show_fee', 'tax_rate', 'social_links.website']);
});

it('lets an accountant read but not change the salon settings', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $accountant = $this->memberOf($salon, P::ACCOUNTANT, [$branch]);
    $this->enableTwoFactor($accountant);

    $this->actingAs($accountant)->get($this->salonUrl($salon, '/settings/salon'))
        ->assertInertia(fn (Assert $page) => $page->where('canUpdate', false));
    $this->actingAs($accountant)->put($this->salonUrl($salon, '/settings/salon'), salonPayload())->assertForbidden();
});

it('uploads a logo through the storage service', function () {
    Storage::fake('media');
    ['salon' => $salon, 'owner' => $owner] = $this->makeSalon();
    $this->enableTwoFactor($owner);

    $this->actingAs($owner)->post($this->salonUrl($salon, '/settings/salon/images/logo'), ['image' => UploadedFile::fake()->image('logo.png', 400, 400)])
        ->assertRedirect()->assertSessionHasNoErrors();
    expect(Salon::query()->findOrFail($salon->id)->logo_media_id)->not->toBeNull();

    $this->actingAs($owner)->post($this->salonUrl($salon, '/settings/salon/images/logo'), ['image' => UploadedFile::fake()->image('tiny.png', 50, 50)])
        ->assertSessionHasErrors('image');
    $this->actingAs($owner)->post($this->salonUrl($salon, '/settings/salon/images/banner'), ['image' => UploadedFile::fake()->image('x.png', 400, 400)])
        ->assertNotFound();
});

it('never lets salon B change salon A through a forged salon id', function () {
    ['salon' => $a] = $this->makeSalon('salon-a');
    ['salon' => $b, 'owner' => $ownerB] = $this->makeSalon('salon-b');
    $this->enableTwoFactor($ownerB);

    $this->actingAs($ownerB)->put($this->salonUrl($b, '/settings/salon'), salonPayload(['salon_id' => $a->id, 'name' => ['en' => 'Hijacked']]))
        ->assertRedirect();

    expect(Salon::query()->findOrFail($a->id)->getTranslation('name', 'en'))->toBe('Salon salon-a')
        ->and(Salon::query()->findOrFail($b->id)->getTranslation('name', 'en'))->toBe('Hijacked');

    // Owner B is not a member of A: A's dashboard signs them out and sends them to A's login.
    $this->actingAs($ownerB)->get($this->salonUrl($a, '/settings/salon'))->assertRedirect();
    $this->assertGuest('web');
    expect(Tenancy::id())->toBeNull();
});
