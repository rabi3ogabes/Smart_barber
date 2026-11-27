<?php

use App\Core\Authorization\PermissionCatalog;
use App\Core\Identity\Models\Device;
use App\Core\Identity\Services\TokenService;
use App\Core\Tenancy\Models\SalonMembership;
use App\Core\Tenancy\Tenancy;

it('signs a single-salon barber straight in with salon-bound tokens', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $barber = $this->memberOf($salon, PermissionCatalog::BARBER, [$branch]);

    $response = $this->postJson('/api/v1/staff/auth/login', ['email' => $barber->email, 'password' => 'Password123!'])
        ->assertOk()
        ->assertJsonPath('data.salon', $salon->public_id);

    $this->getJson('/api/v1/staff/me', ['Authorization' => 'Bearer '.$response->json('data.tokens.access_token')])
        ->assertOk()
        ->assertJsonPath('data.salon.id', $salon->public_id)
        ->assertJsonPath('data.roles', ['barber'])
        ->assertJsonPath('data.branches.0.id', $branch->public_id);
});

it('rejects wrong passwords with a generic error and throttles', function () {
    ['salon' => $salon] = $this->makeSalon();
    $barber = $this->memberOf($salon);

    foreach (range(1, 5) as $_) {
        $this->postJson('/api/v1/staff/auth/login', ['email' => $barber->email, 'password' => 'wrong'])
            ->assertStatus(422)->assertJsonPath('code', 'INVALID_CREDENTIALS');
    }
    $this->postJson('/api/v1/staff/auth/login', ['email' => $barber->email, 'password' => 'Password123!'])
        ->assertStatus(429)->assertJsonPath('code', 'RATE_LIMITED');
});

it('asks multi-salon users to choose a salon', function () {
    ['salon' => $a] = $this->makeSalon('salon-a');
    ['salon' => $b] = $this->makeSalon('salon-b');
    $barber = $this->memberOf($a);
    $this->memberOf($b, user: $barber);

    $login = $this->postJson('/api/v1/staff/auth/login', ['email' => $barber->email, 'password' => 'Password123!'])
        ->assertStatus(409)
        ->assertJsonPath('code', 'SALON_SELECTION_REQUIRED')
        ->assertJsonCount(2, 'data.memberships');

    $selected = $this->postJson('/api/v1/staff/auth/select-salon', [
        'selection_token' => $login->json('data.selection_token'),
        'salon' => $b->public_id,
    ])->assertOk()->assertJsonPath('data.salon', $b->public_id);

    $this->getJson('/api/v1/staff/me', ['Authorization' => 'Bearer '.$selected->json('data.tokens.access_token')])
        ->assertOk()->assertJsonPath('data.salon.id', $b->public_id);

    // The selection token is single-use.
    $this->postJson('/api/v1/staff/auth/select-salon', ['selection_token' => $login->json('data.selection_token'), 'salon' => $a->public_id])
        ->assertStatus(401)->assertJsonPath('code', 'CHALLENGE_EXPIRED');
});

it('cannot select a salon the user does not belong to', function () {
    ['salon' => $a] = $this->makeSalon('salon-a');
    ['salon' => $b] = $this->makeSalon('salon-b');
    ['salon' => $c] = $this->makeSalon('salon-c');
    $barber = $this->memberOf($a);
    $this->memberOf($b, user: $barber);

    $login = $this->postJson('/api/v1/staff/auth/login', ['email' => $barber->email, 'password' => 'Password123!']);

    $this->postJson('/api/v1/staff/auth/select-salon', ['selection_token' => $login->json('data.selection_token'), 'salon' => $c->public_id])
        ->assertStatus(403)->assertJsonPath('code', 'NO_ACTIVE_MEMBERSHIP');
});

it('requires owners to enrol in 2FA before using the staff app', function () {
    ['owner' => $owner] = $this->makeSalon();

    $this->postJson('/api/v1/staff/auth/login', ['email' => $owner->email, 'password' => 'Password123!'])
        ->assertStatus(403)->assertJsonPath('code', 'TWO_FACTOR_ENROLLMENT_REQUIRED');
});

it('completes a TOTP challenge and rejects replayed codes', function () {
    ['salon' => $salon, 'owner' => $owner] = $this->makeSalon();
    $secret = $this->enableTwoFactor($owner);

    $login = $this->postJson('/api/v1/staff/auth/login', ['email' => $owner->email, 'password' => 'Password123!'])
        ->assertStatus(409)->assertJsonPath('code', 'TWO_FACTOR_REQUIRED');
    $challenge = $login->json('data.challenge_token');

    $this->postJson('/api/v1/staff/auth/2fa', ['challenge_token' => $challenge, 'code' => '000000'])
        ->assertStatus(422)->assertJsonPath('code', 'TWO_FACTOR_INVALID');

    $code = $this->totp($secret);
    $this->postJson('/api/v1/staff/auth/2fa', ['challenge_token' => $challenge, 'code' => $code])
        ->assertOk()->assertJsonPath('data.salon', $salon->public_id);

    // Same code again in a new challenge is a replay.
    $again = $this->postJson('/api/v1/staff/auth/login', ['email' => $owner->email, 'password' => 'Password123!']);
    $this->postJson('/api/v1/staff/auth/2fa', ['challenge_token' => $again->json('data.challenge_token'), 'code' => $code])
        ->assertStatus(422)->assertJsonPath('code', 'TWO_FACTOR_INVALID');
});

it('accepts a recovery code once', function () {
    ['owner' => $owner] = $this->makeSalon();
    $this->enableTwoFactor($owner);

    $challenge = fn () => $this->postJson('/api/v1/staff/auth/login', ['email' => $owner->email, 'password' => 'Password123!'])->json('data.challenge_token');

    $this->postJson('/api/v1/staff/auth/2fa', ['challenge_token' => $challenge(), 'code' => 'aaaaa-bbbbb'])->assertOk();
    $this->postJson('/api/v1/staff/auth/2fa', ['challenge_token' => $challenge(), 'code' => 'AAAAA-BBBBB'])->assertStatus(422);
});

it('stops working when the membership is deactivated, including refresh', function () {
    ['salon' => $salon] = $this->makeSalon();
    $barber = $this->memberOf($salon);
    $issued = app(TokenService::class)->issue($barber, (int) $salon->getKey(), 'test', ['staff']);

    Tenancy::runAs($salon, fn () => SalonMembership::query()->where('user_id', $barber->getKey())->update(['status' => SalonMembership::STATUS_DEACTIVATED]));

    $this->getJson('/api/v1/staff/me', ['Authorization' => 'Bearer '.$issued->accessToken])
        ->assertStatus(401)->assertJsonPath('code', 'MEMBERSHIP_INACTIVE');
    $this->postJson('/api/v1/staff/auth/refresh', ['refresh_token' => $issued->refreshToken])
        ->assertStatus(401)->assertJsonPath('code', 'MEMBERSHIP_INACTIVE');
});

it('blocks suspended salons', function () {
    ['salon' => $salon] = $this->makeSalon();
    $barber = $this->memberOf($salon);
    $headers = $this->staffHeaders($barber, $salon);
    $salon->update(['status' => 'suspended']);

    $this->getJson('/api/v1/staff/me', $headers)->assertStatus(403)->assertJsonPath('code', 'SALON_SUSPENDED');
});

it('lists the salons a user can switch to', function () {
    ['salon' => $a] = $this->makeSalon('salon-a');
    ['salon' => $b] = $this->makeSalon('salon-b');
    $barber = $this->memberOf($a);
    $this->memberOf($b, user: $barber);

    $this->getJson('/api/v1/staff/me/salons', $this->staffHeaders($barber, $a))->assertOk()->assertJsonCount(2, 'data');
});

it('registers and removes a push device', function () {
    ['salon' => $salon] = $this->makeSalon();
    $barber = $this->memberOf($salon);
    $headers = $this->staffHeaders($barber, $salon);

    $this->postJson('/api/v1/staff/devices', ['fcm_token' => 'tok-1', 'platform' => 'ios', 'app' => 'staff'], $headers)->assertStatus(201);
    $this->postJson('/api/v1/staff/devices', ['fcm_token' => 'tok-1', 'platform' => 'ios', 'app' => 'staff'], $headers)->assertOk();
    expect(Device::query()->first()->salon_id)->toBe($salon->getKey());

    $this->deleteJson('/api/v1/staff/devices/tok-1', [], $headers)->assertOk();
    expect(Device::query()->count())->toBe(0);
});
