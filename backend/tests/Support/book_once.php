<?php

/*
| One booking attempt in its own OS process (ADR-004 verification). Waits until a shared start
| instant so all processes hit the lock together, then prints one JSON line.
| argv: salonId branchId customerId barberId serviceId startsAtIso goAtUnixFloat
*/

use App\Core\Exceptions\AppException;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Actions\CreateBooking;
use App\Modules\Booking\Enums\BookingSource;
use App\Modules\Booking\Support\Selection;
use App\Modules\Catalog\Models\Service;
use App\Modules\Customer\Models\Customer;
use App\Modules\Staff\Models\Barber;
use Carbon\CarbonImmutable;
use Illuminate\Contracts\Console\Kernel;
use Illuminate\Support\Facades\DB;

require __DIR__.'/../../vendor/autoload.php';
$app = require __DIR__.'/../../bootstrap/app.php';
$app->make(Kernel::class)->bootstrap();

[, $salonId, $branchId, $customerId, $barberId, $serviceId, $startsAt, $goAt] = $argv;
$salon = Salon::query()->findOrFail((int) $salonId);

$result = Tenancy::runAs($salon, function () use ($branchId, $customerId, $barberId, $serviceId, $startsAt, $goAt) {
    $branch = Branch::query()->findOrFail((int) $branchId);
    $customer = Customer::query()->findOrFail((int) $customerId);
    $barber = Barber::query()->findOrFail((int) $barberId);
    $selection = new Selection([Service::query()->findOrFail((int) $serviceId)]);
    DB::connection()->getPdo(); // connect before the barrier

    while (microtime(true) < (float) $goAt) {
        usleep(500);
    }

    try {
        $booking = app(CreateBooking::class)($branch, $customer, $selection, CarbonImmutable::parse($startsAt), BookingSource::Dashboard, $barber);

        return ['ok' => true, 'booking' => $booking->public_id];
    } catch (AppException $e) {
        return ['ok' => false, 'code' => $e->errorCode->value];
    }
});

echo json_encode($result).PHP_EOL;
