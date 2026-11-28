<?php

namespace App\Modules\Booking\Http\Controllers\Web;

use App\Core\Authorization\Access;
use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Http\ApiResponse;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Availability\AvailabilityService;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Events\BookingChanged;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Support\BookingInput;
use App\Modules\Booking\Support\BookingPresenter;
use App\Modules\Booking\Support\StaffBookingOps;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Pricing\PricingService;
use App\Modules\Customer\Models\Customer;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Schedule\Interval;
use App\Modules\Staff\Schedule\ScheduleService;
use Carbon\CarbonImmutable;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Inertia\Inertia;
use Inertia\Response;

/**
 * The dashboard calendar: the page shell (Inertia) plus JSON endpoints the page calls for the
 * visible range (bookings + working hours), free slots and quotes. Prices and availability always
 * come from the server.
 */
final class CalendarController
{
    public function index(Request $request): Response
    {
        /** @var User $user */
        $user = $request->user();
        Gate::authorize('viewAny', Booking::class);
        $branches = Access::visibleBranches($user);
        $branch = $branches->firstWhere('public_id', $request->query('branch')) ?? $branches->first();
        $tz = $branch->timezone ?? 'Asia/Qatar';
        $date = (string) ($request->query('date') ?: now($tz)->toDateString());
        $own = Access::scope($user, 'booking.view') === P::SCOPE_OWN;
        $locale = app()->getLocale();

        $barbers = $branch === null ? collect() : Barber::query()
            ->whereHas('branches', fn ($q) => $q->whereKey($branch->id))
            ->whereHas('membership', fn ($q) => $q->where('status', 'active'))
            ->when($own, fn ($q) => $q->where('user_id', $user->id))
            ->orderBy('sort_order')->orderBy('id')->get();

        return Inertia::render('Calendar/Index', [
            'branches' => $branches->map(fn (Branch $b) => ['id' => $b->public_id, 'name' => $b->getTranslation('name', $locale), 'timezone' => $b->timezone])->values(),
            'branch' => $branch?->public_id,
            'timezone' => $tz,
            'date' => $date,
            'view' => $request->query('view') === 'week' ? 'week' : 'day',
            'barbers' => $barbers->map(fn (Barber $b) => ['id' => $b->public_id, 'name' => $b->getTranslation('display_name', $locale), 'is_bookable' => $b->is_bookable])->values(),
            'services' => Service::query()->where('is_active', true)->with('category:id,name')->orderBy('sort_order')->get()->map(fn (Service $s) => [
                'id' => $s->public_id,
                'name' => $s->getTranslations('name'),
                'category' => $s->category?->getTranslations('name'),
                'duration_minutes' => $s->duration_minutes,
                'price' => $s->basePrice(),
            ])->values(),
            'bundles' => ServiceBundle::query()->where('is_active', true)->get()->map(fn (ServiceBundle $b) => ['id' => $b->public_id, 'name' => $b->getTranslations('name'), 'price' => $b->priceMoney()])->values(),
            'statuses' => array_map(fn (BookingStatus $s) => $s->value, BookingStatus::cases()),
            'can' => [
                'create' => $branch !== null && Access::scope($user, 'booking.create') !== null,
                'createCustomer' => Gate::allows('create', Customer::class),
                'any' => Access::scope($user, 'booking.create') !== P::SCOPE_OWN,
            ],
            'channel' => $branch === null ? null : BookingChanged::channelName((string) Salon::query()->whereKey(Tenancy::id())->value('public_id'), $branch->public_id),
            'broadcasting' => config('broadcasting.default') === 'reverb',
        ]);
    }

    /** Bookings and working hours for the visible days. */
    public function events(Request $request, ScheduleService $schedules): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        Gate::authorize('viewAny', Booking::class);
        $data = $request->validate(['branch' => ['required', 'string', 'size:26'], 'from' => ['required', 'date_format:Y-m-d'], 'to' => ['required', 'date_format:Y-m-d', 'after_or_equal:from']]);
        $branch = $this->branch($user, $data['branch']);
        $from = CarbonImmutable::parse($data['from'], $branch->timezone)->startOfDay();
        $to = CarbonImmutable::parse($data['to'], $branch->timezone)->addDay()->startOfDay();
        abort_if($from->diffInDays($to) > 8, 422);

        $bookings = StaffBookingOps::visible($user, $branch, $from->utc(), $to->utc())->get();
        $own = Access::scope($user, 'booking.view') === P::SCOPE_OWN;
        $barbers = Barber::query()->whereHas('branches', fn ($q) => $q->whereKey($branch->id))->when($own, fn ($q) => $q->where('user_id', $user->id))->get();

        $hours = [];
        foreach ($barbers as $barber) {
            $hours[$barber->public_id] = array_map(fn (Interval $i) => $i->toArray(), $schedules->workingIntervals($barber, $branch, $from->toDateString(), $to->subDay()->toDateString()));
        }

        return ApiResponse::success([
            'bookings' => $bookings->map(fn (Booking $b) => BookingPresenter::forStaff($b, $user))->all(),
            'hours' => $hours,
            'now' => now()->toIso8601ZuluString(),
        ]);
    }

    public function slots(Request $request, AvailabilityService $availability): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $request->validate(BookingInput::rules(false) + ['branch' => ['required', 'string', 'size:26'], 'date' => ['required', 'date_format:Y-m-d']]);
        $branch = $this->branch($user, (string) $request->input('branch'));

        return ApiResponse::success($availability->slots($branch, BookingInput::selection($request), BookingInput::barber($request, $branch), (string) $request->input('date'), false));
    }

    public function quote(Request $request, PricingService $pricing): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        $request->validate(BookingInput::rules(false) + ['branch' => ['required', 'string', 'size:26']]);
        $branch = $this->branch($user, (string) $request->input('branch'));
        $selection = BookingInput::selection($request);

        return ApiResponse::success($pricing->quote($branch, $selection->services, $selection->addons, BookingInput::barber($request, $branch), null, $selection->bundles)->toArray());
    }

    private function branch(User $user, string $publicId): Branch
    {
        $branch = Branch::query()->where('public_id', $publicId)->firstOrFail();
        abort_unless(Access::visibleBranches($user)->contains('id', $branch->id), 404);

        return $branch;
    }
}
