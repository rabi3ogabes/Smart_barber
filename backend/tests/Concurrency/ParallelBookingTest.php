<?php

use App\Core\Authorization\SyncRolesAndPermissions;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Models\Booking;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Process;
use Tests\Support\BookingFixture as F;

/*
| ADR-004 gate: 10 simultaneous CreateBooking calls for the same barber and slot, each in its own
| OS process with its own MySQL connection, must produce exactly ONE booking and nine
| BOOKING_SLOT_TAKEN. Runs against the real test database with committed data (a transaction
| wrapper would hide the rows from the other processes), and leaves it empty afterwards.
*/

beforeEach(function () {
    Artisan::call('migrate:fresh');
    app(SyncRolesAndPermissions::class)();
});

afterEach(function () {
    Tenancy::clear();
    Artisan::call('migrate:fresh');
});

it('lets exactly one of 10 parallel bookings for the same chair succeed', function () {
    $f = F::make($this, 'race');
    $startsAt = F::at('11:00')->toIso8601ZuluString();
    $goAt = sprintf('%.3f', microtime(true) + 3.0);
    $env = [
        'APP_ENV' => 'testing',
        'DB_CONNECTION' => 'mysql',
        'DB_DATABASE' => config('database.connections.mysql.database'),
        'QUEUE_CONNECTION' => 'sync',
        'BROADCAST_CONNECTION' => 'null',
        'CACHE_STORE' => 'array',
    ];
    $args = [$f->salon->id, $f->branch->id, $f->customer->id, $f->barberA->id, $f->haircut->id, $startsAt, $goAt];

    $results = Process::pool(function ($pool) use ($args, $env) {
        for ($i = 0; $i < 10; $i++) {
            $pool->as("p{$i}")->env($env)->timeout(60)->command(array_merge([PHP_BINARY, base_path('tests/Support/book_once.php')], array_map('strval', $args)));
        }
    })->start()->wait();

    $outcomes = collect($results)->map(function ($r) {
        expect($r->successful())->toBeTrue($r->errorOutput());

        return json_decode(trim($r->output()), true);
    });

    expect($outcomes->where('ok', true))->toHaveCount(1)
        ->and($outcomes->where('ok', false)->pluck('code')->unique()->values()->all())->toBe(['BOOKING_SLOT_TAKEN'])
        ->and(Tenancy::runAs($f->salon, fn () => Booking::query()->where('barber_id', $f->barberA->id)->count()))->toBe(1);
});

it('serialises overlapping (not identical) requests too', function () {
    $f = F::make($this, 'race');
    $goAt = sprintf('%.3f', microtime(true) + 3.0);
    $env = ['APP_ENV' => 'testing', 'DB_CONNECTION' => 'mysql', 'DB_DATABASE' => config('database.connections.mysql.database'), 'QUEUE_CONNECTION' => 'sync', 'BROADCAST_CONNECTION' => 'null', 'CACHE_STORE' => 'array'];

    // Starts 10:00, 10:05 … 10:45 with a 30-minute haircut + 5-minute buffer: at most two of
    // them fit side by side (e.g. 10:00 and 10:35), whichever process wins the lock first.
    $results = Process::pool(function ($pool) use ($f, $env, $goAt) {
        for ($i = 0; $i < 10; $i++) {
            $start = F::at('10:00')->addMinutes($i * 5)->toIso8601ZuluString();
            $pool->as("p{$i}")->env($env)->timeout(60)->command([PHP_BINARY, base_path('tests/Support/book_once.php'), (string) $f->salon->id, (string) $f->branch->id, (string) $f->customer->id, (string) $f->barberA->id, (string) $f->haircut->id, $start, $goAt]);
        }
    })->start()->wait();

    expect(collect($results)->every(fn ($r) => $r->successful()))->toBeTrue();
    $rows = Tenancy::runAs($f->salon, fn () => Booking::query()->where('barber_id', $f->barberA->id)->orderBy('starts_at')->get());

    // Whatever the winners are, no two stored bookings may overlap on the blocked range.
    foreach ($rows as $i => $a) {
        foreach ($rows->slice($i + 1) as $b) {
            expect($a->starts_at->lt($b->blocked_until) && $b->starts_at->lt($a->blocked_until))->toBeFalse();
        }
    }
    expect($rows->count())->toBeGreaterThanOrEqual(1)->toBeLessThanOrEqual(2);
});
