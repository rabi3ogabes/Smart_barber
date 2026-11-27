<?php

use App\Core\Http\ApiResponse;
use App\Core\Identity\Models\CustomerAccount;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

beforeEach(function () {
    $this->counter = 0;
    Route::middleware(['api', 'auth:customer', 'idempotent'])->post('/api/v1/_test/charge', function (Request $request) {
        $this->counter++;

        return ApiResponse::success(['charge' => $this->counter, 'amount' => $request->input('amount')], status: 201);
    });
    Route::middleware(['api', 'auth:customer', 'idempotent'])->post('/api/v1/_test/boom', function () {
        $this->counter++;
        abort(500);
    });
    $this->headers = $this->customerHeaders(CustomerAccount::factory()->create());
});

it('requires the header', function () {
    $this->postJson('/api/v1/_test/charge', ['amount' => 10], $this->headers)
        ->assertStatus(428)->assertJsonPath('code', 'IDEMPOTENCY_KEY_REQUIRED');
});

it('replays the stored response for a retry with the same key and body', function () {
    $headers = $this->headers + ['Idempotency-Key' => 'k-1'];

    $this->postJson('/api/v1/_test/charge', ['amount' => 10], $headers)->assertStatus(201)->assertJsonPath('data.charge', 1);
    $this->postJson('/api/v1/_test/charge', ['amount' => 10], $headers)
        ->assertStatus(201)
        ->assertHeader('Idempotent-Replayed', 'true')
        ->assertJsonPath('data.charge', 1);

    expect($this->counter)->toBe(1);
});

it('refuses the same key with a different body', function () {
    $headers = $this->headers + ['Idempotency-Key' => 'k-2'];
    $this->postJson('/api/v1/_test/charge', ['amount' => 10], $headers)->assertStatus(201);

    $this->postJson('/api/v1/_test/charge', ['amount' => 99], $headers)
        ->assertStatus(422)->assertJsonPath('code', 'IDEMPOTENCY_KEY_REUSED');
});

it('reports a request still in progress', function () {
    DB::table('idempotency_keys')->insert([
        'key' => 'k-3', 'actor_type' => 'customer_account', 'actor_id' => CustomerAccount::query()->first()->getKey(),
        'method' => 'POST', 'route' => 'api/v1/_test/charge',
        'request_hash' => hash('sha256', 'POST|api/v1/_test/charge|'.json_encode(['amount' => 10])),
        'status' => 'processing', 'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now(),
    ]);

    $this->postJson('/api/v1/_test/charge', ['amount' => 10], $this->headers + ['Idempotency-Key' => 'k-3'])
        ->assertStatus(409)->assertJsonPath('code', 'IDEMPOTENCY_IN_PROGRESS');
});

it('releases the key after a server error so the client can retry', function () {
    $headers = $this->headers + ['Idempotency-Key' => 'k-4'];
    $this->postJson('/api/v1/_test/boom', [], $headers)->assertStatus(500)->assertJsonPath('code', 'SERVER_ERROR');
    $this->postJson('/api/v1/_test/boom', [], $headers)->assertStatus(500);

    expect($this->counter)->toBe(2)->and(DB::table('idempotency_keys')->count())->toBe(0);
});

it('scopes keys per actor', function () {
    $other = $this->customerHeaders(CustomerAccount::factory()->create());
    $this->postJson('/api/v1/_test/charge', ['amount' => 10], $this->headers + ['Idempotency-Key' => 'same'])->assertJsonPath('data.charge', 1);
    $this->app['auth']->forgetGuards();
    $this->postJson('/api/v1/_test/charge', ['amount' => 10], $other + ['Idempotency-Key' => 'same'])->assertJsonPath('data.charge', 2);
});

it('expires keys after 24 hours', function () {
    $headers = $this->headers + ['Idempotency-Key' => 'k-5'];
    $this->postJson('/api/v1/_test/charge', ['amount' => 10], $headers)->assertJsonPath('data.charge', 1);
    $this->travel(25)->hours();
    $this->app['auth']->forgetGuards();
    $this->headers = $this->customerHeaders(CustomerAccount::query()->first());
    $this->postJson('/api/v1/_test/charge', ['amount' => 10], $this->headers + ['Idempotency-Key' => 'k-5'])->assertJsonPath('data.charge', 2);
});

it('prunes expired keys', function () {
    $this->postJson('/api/v1/_test/charge', ['amount' => 10], $this->headers + ['Idempotency-Key' => 'k-6']);
    $this->travel(25)->hours();
    $this->artisan('idempotency:prune')->assertSuccessful();

    expect(DB::table('idempotency_keys')->count())->toBe(0);
});
