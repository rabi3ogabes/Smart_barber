<?php

namespace App\Modules\Booking\Http\Controllers\Web;

use App\Core\Authorization\Access;
use App\Core\Http\ApiResponse;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Support\BookingPresenter;
use App\Modules\Booking\Support\StaffBookingOps;
use App\Modules\Staff\Models\Barber;
use Carbon\CarbonImmutable;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Inertia\Response;

/**
 * Bookings list page + the JSON actions the calendar and the booking drawer call.
 */
final class BookingController
{
    public function __construct(private readonly StaffBookingOps $ops) {}

    public function index(Request $request): Response
    {
        /** @var User $user */
        $user = $request->user();
        Gate::authorize('viewAny', Booking::class);
        $f = $request->validate([
            'from' => ['nullable', 'date_format:Y-m-d'],
            'to' => ['nullable', 'date_format:Y-m-d'],
            'status' => ['nullable', Rule::in(array_map(fn ($s) => $s->value, BookingStatus::cases()))],
            'barber' => ['nullable', 'string', 'size:26'],
            'q' => ['nullable', 'string', 'max:60'],
        ]);
        $tz = Tenancy::current()->timezone ?? 'Asia/Qatar';
        $from = CarbonImmutable::parse($f['from'] ?? now($tz)->toDateString(), $tz)->startOfDay();
        $to = CarbonImmutable::parse($f['to'] ?? $from->addDays(6)->toDateString(), $tz)->addDay()->startOfDay();

        $page = StaffBookingOps::visible($user, null, $from->utc(), $to->utc())
            ->when($f['status'] ?? null, fn ($q, $s) => $q->where('status', $s))
            ->when($f['barber'] ?? null, fn ($q, $b) => $q->whereHas('barber', fn ($q) => $q->where('public_id', $b)))
            ->when($f['q'] ?? null, fn ($q, $s) => $q->whereHas('customer', fn ($q) => $q->where(fn ($w) => $w
                ->where('name', 'like', '%'.addcslashes($s, '%_').'%')
                ->when(strlen((string) preg_replace('/\D/', '', $s)) >= 3, fn ($w) => $w->orWhere('phone', 'like', '%'.preg_replace('/\D/', '', $s).'%')))))
            ->paginate(25)->withQueryString();

        return Inertia::render('Bookings/Index', [
            'bookings' => collect($page->items())->map(fn (Booking $b) => BookingPresenter::forStaff($b, $user))->all(),
            'pagination' => ['current' => $page->currentPage(), 'last' => $page->lastPage(), 'total' => $page->total(), 'prev' => $page->previousPageUrl(), 'next' => $page->nextPageUrl()],
            'filters' => ['from' => $from->toDateString(), 'to' => $to->subDay()->toDateString(), 'status' => $f['status'] ?? null, 'barber' => $f['barber'] ?? null, 'q' => $f['q'] ?? null],
            'barbers' => Barber::query()->whereHas('branches', fn ($q) => $q->whereIn('branches.id', Access::visibleBranches($user)->pluck('id')))->orderBy('sort_order')->get()
                ->map(fn (Barber $b) => ['id' => $b->public_id, 'name' => $b->getTranslation('display_name', app()->getLocale())])->values(),
            'statuses' => array_map(fn (BookingStatus $s) => $s->value, BookingStatus::cases()),
            'timezone' => $tz,
        ]);
    }

    public function show(Request $request, Booking $booking): JsonResponse
    {
        Gate::authorize('view', $booking);

        return ApiResponse::success(BookingPresenter::forStaff($booking, $this->user($request), true));
    }

    public function store(Request $request): JsonResponse
    {
        return ApiResponse::success(BookingPresenter::forStaff($this->ops->create($request, $this->user($request)), $this->user($request), true), status: 201);
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
        $user = $request->user();

        return $user;
    }
}
