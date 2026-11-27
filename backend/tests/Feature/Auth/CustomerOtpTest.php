<?php

use App\Core\Contracts\OtpProvider;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Identity\Models\RefreshToken;
use App\Core\Identity\Services\TokenService;
use Illuminate\Support\Facades\DB;

beforeEach(function () {
    $this->phone = '+97455123456';
});

function lastCode(string $phone): string
{
    return (string) app(OtpProvider::class)->lastCodeFor($phone);
}

it('sends a code and signs in, creating the account on first login', function () {
    $this->postJson('/api/v1/customer/auth/otp', ['phone' => $this->phone])
        ->assertOk()
        ->assertJsonPath('success', true)
        ->assertJsonPath('data.expires_in', 300);

    $code = lastCode($this->phone);
    expect($code)->toMatch('/^\d{6}$/');

    $response = $this->postJson('/api/v1/customer/auth/otp/verify', ['phone' => $this->phone, 'code' => $code, 'device_name' => 'iPhone'])
        ->assertOk()
        ->assertJsonPath('data.is_new', true)
        ->assertJsonPath('data.account.phone', $this->phone)
        ->assertJsonStructure(['data' => ['tokens' => ['access_token', 'refresh_token', 'expires_in', 'refresh_expires_in']]]);

    $access = $response->json('data.tokens.access_token');
    $this->getJson('/api/v1/customer/me', ['Authorization' => 'Bearer '.$access])
        ->assertOk()
        ->assertJsonPath('data.phone', $this->phone);

    expect(CustomerAccount::query()->count())->toBe(1);
});

it('stores codes hashed, never in plain text', function () {
    $this->postJson('/api/v1/customer/auth/otp', ['phone' => $this->phone])->assertOk();
    $row = DB::table('otp_codes')->first();

    expect($row->code_hash)->not->toBe(lastCode($this->phone))->and(strlen($row->code_hash))->toBe(64);
});

it('rejects a wrong code and locks the code after five attempts', function () {
    $this->postJson('/api/v1/customer/auth/otp', ['phone' => $this->phone])->assertOk();
    $wrong = lastCode($this->phone) === '000000' ? '111111' : '000000';

    foreach (range(1, 4) as $_) {
        $this->postJson('/api/v1/customer/auth/otp/verify', ['phone' => $this->phone, 'code' => $wrong])
            ->assertStatus(422)->assertJsonPath('code', 'OTP_INVALID');
    }
    $this->postJson('/api/v1/customer/auth/otp/verify', ['phone' => $this->phone, 'code' => $wrong])
        ->assertStatus(429)->assertJsonPath('code', 'OTP_TOO_MANY_ATTEMPTS');

    // Even the right code no longer works.
    $this->postJson('/api/v1/customer/auth/otp/verify', ['phone' => $this->phone, 'code' => lastCode($this->phone)])
        ->assertStatus(422)->assertJsonPath('code', 'OTP_EXPIRED');
});

it('expires codes after five minutes', function () {
    $this->postJson('/api/v1/customer/auth/otp', ['phone' => $this->phone])->assertOk();
    $this->travel(6)->minutes();

    $this->postJson('/api/v1/customer/auth/otp/verify', ['phone' => $this->phone, 'code' => lastCode($this->phone)])
        ->assertStatus(422)->assertJsonPath('code', 'OTP_EXPIRED');
});

it('enforces a resend delay and a send limit per phone', function () {
    $this->postJson('/api/v1/customer/auth/otp', ['phone' => $this->phone])->assertOk();
    $this->postJson('/api/v1/customer/auth/otp', ['phone' => $this->phone])
        ->assertStatus(429)->assertJsonPath('code', 'RATE_LIMITED')->assertJsonStructure(['data' => ['retry_after']]);

    $this->travel(61)->seconds();
    $this->postJson('/api/v1/customer/auth/otp', ['phone' => $this->phone])->assertOk();
    $this->travel(61)->seconds();
    $this->postJson('/api/v1/customer/auth/otp', ['phone' => $this->phone])->assertOk();
    $this->travel(61)->seconds();
    $this->postJson('/api/v1/customer/auth/otp', ['phone' => $this->phone])->assertStatus(429);
});

it('validates the phone format with a translated message', function () {
    $this->postJson('/api/v1/customer/auth/otp', ['phone' => '55123456'], ['Accept-Language' => 'ar'])
        ->assertStatus(422)
        ->assertJsonPath('code', 'VALIDATION_FAILED')
        ->assertJsonPath('message', 'يرجى مراجعة الحقول المحددة.')
        ->assertJsonStructure(['errors' => ['phone']]);
});

it('rotates refresh tokens and kills the family on reuse', function () {
    $account = CustomerAccount::factory()->create();
    $issued = app(TokenService::class)->issue($account, null, 'test', ['customer']);

    $first = $this->postJson('/api/v1/customer/auth/refresh', ['refresh_token' => $issued->refreshToken])->assertOk();
    $newAccess = $first->json('data.tokens.access_token');
    $newRefresh = $first->json('data.tokens.refresh_token');

    // The old access token died with the rotation; the new one works.
    $this->getJson('/api/v1/customer/me', ['Authorization' => 'Bearer '.$issued->accessToken])->assertStatus(401);
    $this->app['auth']->forgetGuards();
    $this->getJson('/api/v1/customer/me', ['Authorization' => 'Bearer '.$newAccess])->assertOk();

    // Replaying the first refresh token revokes everything from that login.
    $this->postJson('/api/v1/customer/auth/refresh', ['refresh_token' => $issued->refreshToken])
        ->assertStatus(401)->assertJsonPath('code', 'REFRESH_TOKEN_REUSED');
    $this->app['auth']->forgetGuards();
    $this->getJson('/api/v1/customer/me', ['Authorization' => 'Bearer '.$newAccess])->assertStatus(401);
    $this->postJson('/api/v1/customer/auth/refresh', ['refresh_token' => $newRefresh])->assertStatus(401);

    expect(RefreshToken::query()->whereNull('revoked_at')->count())->toBe(0);
});

it('rejects expired access tokens', function () {
    $account = CustomerAccount::factory()->create();
    $headers = $this->customerHeaders($account);
    $this->travel(61)->minutes();

    $this->getJson('/api/v1/customer/me', $headers)->assertStatus(401)->assertJsonPath('code', 'UNAUTHENTICATED');
});

it('does not accept a staff token on customer routes', function () {
    ['salon' => $salon, 'owner' => $owner] = $this->makeSalon();

    $this->getJson('/api/v1/customer/me', $this->staffHeaders($owner, $salon))->assertStatus(401);
});

it('logs out by revoking the token family', function () {
    $account = CustomerAccount::factory()->create();
    $headers = $this->customerHeaders($account);

    $this->postJson('/api/v1/customer/auth/logout', [], $headers)->assertOk();
    $this->app['auth']->forgetGuards();
    $this->getJson('/api/v1/customer/me', $headers)->assertStatus(401);
});

it('updates the profile', function () {
    $account = CustomerAccount::factory()->create(['name' => null]);

    $this->patchJson('/api/v1/customer/me', ['name' => 'Rashid', 'locale' => 'en'], $this->customerHeaders($account))
        ->assertOk()
        ->assertJsonPath('data.name', 'Rashid')
        ->assertJsonPath('data.locale', 'en')
        ->assertJsonPath('data.profile_complete', true);
});

it('returns field errors in Arabic', function () {
    $this->postJson('/api/v1/customer/auth/otp', ['phone' => '55123456'], ['Accept-Language' => 'ar'])
        ->assertStatus(422)
        ->assertJsonPath('errors.phone.0', 'أدخل رقم الجوال بالصيغة الدولية، مثل ‎+97455123456.');

    $this->postJson('/api/v1/customer/auth/otp', [], ['Accept-Language' => 'ar'])
        ->assertJsonPath('errors.phone.0', 'حقل رقم الجوال مطلوب.');
});
