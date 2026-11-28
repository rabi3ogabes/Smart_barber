<?php

namespace App\Modules\Booking\Http\Controllers\Api;

use App\Core\Http\ApiResponse;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Support\BookingPresenter;
use App\Modules\Booking\Support\StaffBookingOps;
use Carbon\CarbonImmutable;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;

/**
 * The staff app's day view and reception actions (staff token, salon from the token).
 */
final class StaffBookingController
{
    public function __construct(private readonly StaffBookingOps $ops) {}

    public function index(Request $request): JsonResponse
    {
        $user = $this->user($request);
        $data = $request->validate(['date' => ['nullable', 'date_format:Y-m-d'], 'branch' => ['nullable', 'string', 'size:26'], 'barber' => ['nullable', 'string', 'size:26']]);
        Gate::forUser($user)->authorize('viewAny', Booking::class);
        $branch = isset($data['branch']) ? Branch::query()->where('public_id', $data['branch'])->firstOrFail() : null;
        $tz = $branch->timezone ?? Tenancy::current()->timezone ?? 'Asia/Qatar';
        $day = CarbonImmutable::parse($data['date'] ?? now($tz)->toDateString(), $tz)->startOfDay();

        $bookings = StaffBookingOps::visible($user, $branch, $day->utc(), $day->addDay()->utc())
            ->when(isset($data['barber']), fn ($q) => $q->whereHas('barber', fn ($q) => $q->where('public_id', $data['barber'])))
            ->get();

        return ApiResponse::success($bookings->map(fn (Booking $b) => BookingPresenter::forStaff($b, $user))->all());
    }

    public function show(Request $request, Booking $booking): JsonResponse
    {
        Gate::forUser($this->user($request))->authorize('view', $booking);

        return ApiResponse::success(BookingPresenter::forStaff($booking, $this->user($request), true));
    }

    public function store(Request $request): JsonResponse
    {
        $booking = $this->ops->create($request, $this->user($request));

        return ApiResponse::success(BookingPresenter::forStaff($booking, $this->user($request), true), status: 201);
    }

    public function reschedule(Request $request, Booking $booking): JsonResponse
    {
        return ApiResponse::success(BookingPresenter::forStaff($this->ops->reschedule($request, $booking, $this->user($request)), $this->user($request), true));
    }

    public function cancel(Request $request, Booking $booking): JsonResponse
    {
        return ApiResponse::success(BookingPresenter::forStaff($this->ops->cancel($request, $booking, $this->user($request)), $this->user($request), true));
    }

    public function transition(Request $request, Booking $booking, string $action): JsonResponse
    {
        abort_unless(in_array($action, ['confirm', 'arrive', 'start', 'complete', 'no-show'], true), 404);
        $result = $this->ops->transition($request, $booking, $this->user($request), $action === 'no-show' ? 'no_show' : $action);

        return ApiResponse::success(BookingPresenter::forStaff($result, $this->user($request), true));
    }

    private function user(Request $request): User
    {
        /** @var User $user */
        $user = $request->user('staff');

        return $user;
    }
}
