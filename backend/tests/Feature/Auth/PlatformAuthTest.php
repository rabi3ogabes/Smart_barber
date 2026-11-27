<?php

use App\Core\Identity\Models\PlatformAdmin;
use App\Core\Tenancy\Models\Salon;
use Inertia\Testing\AssertableInertia as Assert;

it('never treats the admin host as a salon', function () {
    expect(Salon::RESERVED_SLUGS)->toContain('admin');

    $this->get($this->adminUrl('/login'))->assertOk()->assertInertia(fn (Assert $p) => $p->component('Platform/Auth/Login')->where('salon', null));
});

it('requires super admins to enrol in 2FA before reaching the console', function () {
    $admin = PlatformAdmin::factory()->create();

    $this->post($this->adminUrl('/login'), ['email' => $admin->email, 'password' => 'Password123!'])->assertRedirect('/');
    $this->assertAuthenticatedAs($admin, 'platform');
    $this->get($this->adminUrl('/'))->assertRedirect($this->adminUrl('/two-factor/setup'));

    $this->get($this->adminUrl('/two-factor/setup'))->assertInertia(fn (Assert $p) => $p->component('Platform/Auth/TwoFactorSetup'));
    $this->post($this->adminUrl('/two-factor/setup'), ['code' => $this->totp($admin->fresh()->two_factor_secret)])->assertOk();

    $this->get($this->adminUrl('/'))->assertOk()->assertInertia(fn (Assert $p) => $p->component('Platform/Home')->where('auth.type', 'platform'));
});

it('challenges enrolled admins and keeps staff out of the console', function () {
    $admin = PlatformAdmin::factory()->create();
    $secret = $this->enableTwoFactor($admin);
    ['owner' => $owner] = $this->makeSalon();

    $this->post($this->adminUrl('/login'), ['email' => $owner->email, 'password' => 'Password123!'])->assertSessionHasErrors('email');

    $this->post($this->adminUrl('/login'), ['email' => $admin->email, 'password' => 'Password123!'])->assertRedirect($this->adminUrl('/two-factor/challenge'));
    $this->post($this->adminUrl('/two-factor/challenge'), ['code' => $this->totp($secret)])->assertRedirect('/');
    $this->get($this->adminUrl('/'))->assertOk();
});

it('does not let a platform session into a salon dashboard', function () {
    ['salon' => $salon] = $this->makeSalon();
    $admin = PlatformAdmin::factory()->create();
    $this->enableTwoFactor($admin);

    $this->actingAs($admin, 'platform')->get($this->salonUrl($salon))->assertRedirect($this->salonUrl($salon, '/login'));
});
