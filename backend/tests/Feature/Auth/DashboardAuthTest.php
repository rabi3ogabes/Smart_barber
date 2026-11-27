<?php

use App\Core\Authorization\PermissionCatalog;
use App\Core\Tenancy\Models\SalonMembership;
use App\Core\Tenancy\Tenancy;
use Illuminate\Auth\Notifications\ResetPassword;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Notification;
use Inertia\Testing\AssertableInertia as Assert;

it('shows the login page on the salon subdomain and 404s for unknown salons', function () {
    ['salon' => $salon] = $this->makeSalon();

    $this->get($this->salonUrl($salon, '/login'))
        ->assertOk()
        ->assertInertia(fn (Assert $page) => $page->component('Auth/Login')->where('salon.slug', 'salon-a')->where('locale', 'ar')->where('dir', 'rtl'));

    $this->get('http://no-such-salon.'.config('smartbarber.domain').'/login')->assertNotFound();
});

it('signs a barber in and shows the dashboard shell with a permission-filtered menu', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $barber = $this->memberOf($salon, PermissionCatalog::BARBER, [$branch]);

    $this->post($this->salonUrl($salon, '/login'), ['email' => $barber->email, 'password' => 'Password123!'])
        ->assertRedirect('/');
    $this->assertAuthenticatedAs($barber, 'web');

    $this->get($this->salonUrl($salon))
        ->assertOk()
        ->assertInertia(fn (Assert $page) => $page
            ->component('Dashboard')
            ->where('auth.roles', ['barber'])
            ->where('auth.currentBranch', $branch->public_id)
            ->where('auth.menu', fn ($menu) => collect($menu)->flatMap(fn ($g) => collect($g['items'])->pluck('key'))->doesntContain('billing')
                && collect($menu)->flatMap(fn ($g) => collect($g['items'])->pluck('key'))->contains('dashboard')));
});

it('shows owners every core menu group, with future modules marked unavailable', function () {
    ['salon' => $salon, 'owner' => $owner] = $this->makeSalon();
    $this->enableTwoFactor($owner);

    $this->actingAs($owner, 'web')->get($this->salonUrl($salon))
        ->assertOk()
        ->assertInertia(fn (Assert $page) => $page->where('auth.menu', function ($menu) {
            $items = collect($menu)->flatMap(fn ($g) => $g['items'])->keyBy('key');

            return $items['dashboard']['available'] === true
                && $items['billing']['available'] === false
                && ! $items->has('ai_studio'); // feature not enabled for this salon
        }));
});

it('refuses users who are not members of this salon with the generic message', function () {
    ['salon' => $a] = $this->makeSalon('salon-a');
    ['salon' => $b, 'branch' => $branchB] = $this->makeSalon('salon-b');
    $barberB = $this->memberOf($b, PermissionCatalog::BARBER, [$branchB]);

    $this->post($this->salonUrl($a, '/login'), ['email' => $barberB->email, 'password' => 'Password123!'])
        ->assertSessionHasErrors(['email' => __('errors.INVALID_CREDENTIALS')]);
    $this->assertGuest('web');
});

it('kicks a signed-in user out when visiting another salon', function () {
    ['salon' => $a, 'branch' => $branchA] = $this->makeSalon('salon-a');
    ['salon' => $b] = $this->makeSalon('salon-b');
    $barberA = $this->memberOf($a, PermissionCatalog::BARBER, [$branchA]);

    $this->actingAs($barberA, 'web')->get($this->salonUrl($b))->assertRedirect($this->salonUrl($b, '/login'));
    $this->assertGuest('web');
});

it('signs out deactivated members on their next request', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $barber = $this->memberOf($salon, PermissionCatalog::BARBER, [$branch]);
    Tenancy::runAs($salon, fn () => SalonMembership::query()->where('user_id', $barber->id)->update(['status' => 'deactivated']));

    $this->actingAs($barber, 'web')->get($this->salonUrl($salon))->assertRedirect($this->salonUrl($salon, '/login'));
});

it('requires a TOTP code when 2FA is enabled', function () {
    ['salon' => $salon, 'owner' => $owner] = $this->makeSalon();
    $secret = $this->enableTwoFactor($owner);

    $this->post($this->salonUrl($salon, '/login'), ['email' => $owner->email, 'password' => 'Password123!'])
        ->assertRedirect($this->salonUrl($salon, '/two-factor/challenge'));
    $this->assertGuest('web');

    $this->post($this->salonUrl($salon, '/two-factor/challenge'), ['code' => '000000'])->assertSessionHasErrors('code');
    $this->post($this->salonUrl($salon, '/two-factor/challenge'), ['code' => $this->totp($secret)])->assertRedirect('/');
    $this->assertAuthenticatedAs($owner, 'web');
});

it('forces owners without 2FA to enrol before anything else', function () {
    ['salon' => $salon, 'owner' => $owner] = $this->makeSalon();

    $this->post($this->salonUrl($salon, '/login'), ['email' => $owner->email, 'password' => 'Password123!'])->assertRedirect('/');
    $this->get($this->salonUrl($salon))->assertRedirect($this->salonUrl($salon, '/two-factor/setup'));

    $this->get($this->salonUrl($salon, '/two-factor/setup'))
        ->assertOk()
        ->assertInertia(fn (Assert $page) => $page->component('Auth/TwoFactorSetup')->where('required', true)->has('qr')->has('secret'));

    $secret = $owner->fresh()->two_factor_secret;
    $this->post($this->salonUrl($salon, '/two-factor/setup'), ['code' => '123'])->assertSessionHasErrors('code');
    $this->post($this->salonUrl($salon, '/two-factor/setup'), ['code' => $this->totp($secret)])
        ->assertOk()
        ->assertInertia(fn (Assert $page) => $page->component('Auth/RecoveryCodes')->has('codes', 8));

    expect($owner->fresh()->hasTwoFactorEnabled())->toBeTrue();
    $this->get($this->salonUrl($salon))->assertOk();
});

it('lets barbers in without 2FA', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $barber = $this->memberOf($salon, PermissionCatalog::BARBER, [$branch]);

    $this->actingAs($barber, 'web')->get($this->salonUrl($salon))->assertOk();
});

it('sends reset links without revealing whether the email exists and resets the password', function () {
    Notification::fake();
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $barber = $this->memberOf($salon, PermissionCatalog::BARBER, [$branch]);

    $this->post($this->salonUrl($salon, '/forgot-password'), ['email' => 'nobody@example.com'])->assertSessionHas('success');
    $this->post($this->salonUrl($salon, '/forgot-password'), ['email' => $barber->email])->assertSessionHas('success');

    $token = null;
    Notification::assertSentTo($barber, ResetPassword::class, function ($n) use (&$token) {
        $token = $n->token;

        return true;
    });

    $this->post($this->salonUrl($salon, '/reset-password'), [
        'token' => $token, 'email' => $barber->email, 'password' => 'weak', 'password_confirmation' => 'weak',
    ])->assertSessionHasErrors('password');

    $this->post($this->salonUrl($salon, '/reset-password'), [
        'token' => $token, 'email' => $barber->email, 'password' => 'NewPassword2026', 'password_confirmation' => 'NewPassword2026',
    ])->assertRedirect($this->salonUrl($salon, '/login'));

    expect(Hash::check('NewPassword2026', $barber->fresh()->password))->toBeTrue();
});

it('switches locale and direction', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $barber = $this->memberOf($salon, PermissionCatalog::BARBER, [$branch]);

    $this->actingAs($barber, 'web')->post($this->salonUrl($salon, '/locale'), ['locale' => 'en'])->assertRedirect();
    $this->get($this->salonUrl($salon))->assertInertia(fn (Assert $page) => $page->where('locale', 'en')->where('dir', 'ltr'));
    expect($barber->fresh()->locale)->toBe('en');
});

it('only switches to branches the member can see', function () {
    ['salon' => $a, 'branch' => $branchA] = $this->makeSalon('salon-a');
    ['branch' => $branchB] = $this->makeSalon('salon-b');
    $second = $this->addBranch($a, 'Lusail');
    $barber = $this->memberOf($a, PermissionCatalog::BARBER, [$branchA]);

    $this->actingAs($barber, 'web');
    $this->post($this->salonUrl($a, '/branch'), ['branch' => $second->public_id])->assertNotFound(); // not assigned
    $this->post($this->salonUrl($a, '/branch'), ['branch' => $branchB->public_id])->assertNotFound(); // other salon
    $this->post($this->salonUrl($a, '/branch'), ['branch' => $branchA->public_id])->assertRedirect();
});

it('shows the component gallery outside production only', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $barber = $this->memberOf($salon, PermissionCatalog::BARBER, [$branch]);

    $this->actingAs($barber, 'web')->get($this->salonUrl($salon, '/dev/components'))->assertOk()->assertInertia(fn (Assert $p) => $p->component('Dev/Components'));
    app()->detectEnvironment(fn () => 'production');
    $this->get($this->salonUrl($salon, '/dev/components'))->assertNotFound();
});

it('renders a translated error page instead of a raw exception', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $barber = $this->memberOf($salon, PermissionCatalog::BARBER, [$branch]);

    $this->actingAs($barber, 'web')->get($this->salonUrl($salon, '/does-not-exist'))
        ->assertNotFound()
        ->assertInertia(fn (Assert $page) => $page->component('Error')->where('status', 404));
});
