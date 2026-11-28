<?php

namespace App\Modules\Booking\Http\Controllers\Api;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Http\ApiResponse;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Actions\CancelBooking;
use App\Modules\Booking\Actions\CreateBooking;
use App\Modules\Booking\Actions\RescheduleBooking;
use App\Modules\Booking\Enums\BookingSource;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Support\BookingInput;
use App\Modules\Booking\Support\BookingPresenter;
use App\Modules\Catalog\Pricing\PricingService;
use App\Modules\Customer\Actions\FindOrCreateCustomer;
use App\Modules\Customer\Models\Customer;
use App\Modules\Salon\Http\Controllers\Api\PublicSalonController;
use Carbon\CarbonImmutable;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * The customer app's bookings, across salons. The salon is always taken from the branch (create,
 * quote) or the booking (everything else) — never from the client (ADR-001).
 */
final class CustomerBookingController
{
    public function __construct(private readonly PublicSalonController $salons) {}

    /** Server-side price for a selection (line items, tax, total). */
    public function quote(Request $request, PricingService $pricing): JsonResponse
    {
        $request->validate(BookingInput::rules(false) + ['branch' => ['required', 'string', 'size:26']]);
        $branch = $this->salons->resolveBranch((string) $request->input('branch'));
        $selection = BookingInput::selection($request);

        return ApiResponse::success($pricing->quote($branch, $selection->services, $selection->addons, BookingInput::barber($request, $branch), null, $selection->bundles)->toArray());
    }

    public function store(Request $request, CreateBooking $create, FindOrCreateCustomer $customers): JsonResponse
    {
        $request->validate(BookingInput::rules() + ['branch' => ['required', 'string', 'size:26'], 'notes' => ['nullable', 'string', 'max:500']]);
        $branch = $this->salons->resolveBranch((string) $request->input('branch'));
        $account = $this->account($request);
        $customer = $customers($account->phone, $account->name ?? $account->phone, 'app', $account);

        $booking = $create($branch, $customer, BookingInput::selection($request), BookingInput::startsAt($request), BookingSource::App,
            BookingInput::barber($request, $branch), $account, customerNotes: $request->input('notes'));

        return ApiResponse::success(BookingPresenter::forCustomer($booking, true), status: 201);
    }

    public function index(Request $request): JsonResponse
    {
        $scope = $request->validate(['scope' => ['nullable', 'in:upcoming,past']])['scope'] ?? 'upcoming';
        $account = $this->account($request);

        $bookings = Tenancy::bypass(fn () => Booking::query()
            ->whereIn('customer_id', Customer::query()->where('customer_account_id', $account->id)->select('id'))
            ->when($scope === 'upcoming', fn ($q) => $q->where('starts_at', '>=', now()->subHours(2))->whereIn('status', BookingStatus::ACTIVE)->orderBy('starts_at'))
            ->when($scope === 'past', fn ($q) => $q->where(fn ($q) => $q->where('starts_at', '<', now()->subHours(2))->orWhereNotIn('status', BookingStatus::ACTIVE))->orderByDesc('starts_at'))
            ->with(['barber', 'items', 'branch'])
            ->cursorPaginate(20));

        return ApiResponse::success(
            collect($bookings->items())->map(fn (Booking $b) => BookingPresenter::forCustomer($b))->all(),
            meta: ['next_cursor' => $bookings->nextCursor()?->encode()],
        );
    }

    public function show(Request $request, string $booking): JsonResponse
    {
        return ApiResponse::success(BookingPresenter::forCustomer($this->own($request, $booking), true) + [
            'policy' => ['cancellation_window_minutes' => (int) Salon::query()->whereKey(Tenancy::id())->value('cancellation_window_minutes')],
        ]);
    }

    public function reschedule(Request $request, string $booking, RescheduleBooking $reschedule): JsonResponse
    {
        $model = $this->own($request, $booking);
        $request->validate(['starts_at' => ['required', 'date'], 'barber' => ['nullable', 'string', 'max:26']]);
        $branch = Branch::query()->findOrFail($model->branch_id);
        $barber = $request->filled('barber') ? BookingInput::barber($request, $branch) : null;

        $result = $reschedule($model, CarbonImmutable::parse((string) $request->input('starts_at')), $barber, $this->account($request), byCustomer: true);

        return ApiResponse::success(BookingPresenter::forCustomer($result, true));
    }

    public function cancel(Request $request, string $booking, CancelBooking $cancel): JsonResponse
    {
        $model = $this->own($request, $booking);
        $reason = $request->validate(['reason' => ['nullable', 'string', 'max:255']])['reason'] ?? null;

        return ApiResponse::success(BookingPresenter::forCustomer($cancel($model, $this->account($request), $reason), true));
    }

    private function account(Request $request): CustomerAccount
    {
        $account = $request->user('customer');

        return $account instanceof CustomerAccount ? $account : throw new AppException(ErrorCode::Unauthenticated);
    }

    /**
     * Finds the booking across salons, proves it belongs to this account, then sets the tenant
     * to the booking's salon. Someone else's booking is "not found".
     */
    private function own(Request $request, string $publicId): Booking
    {
        $account = $this->account($request);
        $booking = Tenancy::bypass(fn () => Booking::query()->where('public_id', $publicId)
            ->whereIn('customer_id', Customer::query()->where('customer_account_id', $account->id)->select('id'))
            ->first());
        if ($booking === null) {
            throw new AppException(ErrorCode::NotFound);
        }
        Tenancy::set(Salon::query()->findOrFail($booking->salon_id));

        return Booking::query()->findOrFail($booking->id);
    }
}
