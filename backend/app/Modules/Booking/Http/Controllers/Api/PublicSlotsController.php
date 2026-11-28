<?php

namespace App\Modules\Booking\Http\Controllers\Api;

use App\Core\Http\ApiResponse;
use App\Modules\Booking\Availability\AvailabilityService;
use App\Modules\Booking\Support\BookingInput;
use App\Modules\Salon\Http\Controllers\Api\PublicSalonController;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * Free start times for the customer app (display only; booking re-checks under the lock).
 */
final class PublicSlotsController
{
    /**
     * Available slots for a selection on one date
     *
     * @unauthenticated
     */
    public function __invoke(Request $request, string $branch, PublicSalonController $salons, AvailabilityService $availability): JsonResponse
    {
        $model = $salons->resolveBranch($branch);
        $request->validate(BookingInput::rules(false) + ['date' => ['required', 'date_format:Y-m-d']]);

        $slots = $availability->slots($model, BookingInput::selection($request), BookingInput::barber($request, $model), (string) $request->input('date'), true);

        return ApiResponse::success(['date' => $request->input('date'), 'timezone' => $model->timezone, 'slots' => $slots]);
    }
}
