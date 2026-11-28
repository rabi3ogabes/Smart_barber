<?php

namespace App\Modules\Booking\Support;

use App\Core\Authorization\Access;
use App\Core\Authorization\PermissionCatalog;
use App\Core\Identity\Models\User;
use App\Core\Support\PhoneNumber;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Actions\CancelBooking;
use App\Modules\Booking\Actions\ChangeBookingStatus;
use App\Modules\Booking\Actions\CreateBooking;
use App\Modules\Booking\Actions\RescheduleBooking;
use App\Modules\Booking\Enums\BookingSource;
use App\Modules\Booking\Models\Booking;
use App\Modules\Customer\Actions\FindOrCreateCustomer;
use App\Modules\Customer\Models\Customer;
use App\Modules\Staff\Models\Barber;
use Carbon\CarbonImmutable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

/**
 * Staff booking operations shared by the dashboard (web guard) and the staff app (staff guard):
 * validation, authorisation and the calls into the Booking actions.
 */
final class StaffBookingOps
{
    public function __construct(
        private readonly CreateBooking $create,
        private readonly RescheduleBooking $reschedule,
        private readonly CancelBooking $cancel,
        private readonly ChangeBookingStatus $status,
        private readonly FindOrCreateCustomer $customers,
    ) {}

    public function create(Request $request, User $actor): Booking
    {
        $request->validate(BookingInput::rules() + [
            'branch' => ['required', 'string', 'size:26'],
            'customer' => ['nullable', 'required_without:new_customer', 'string', 'size:26'],
            'new_customer.name' => ['nullable', 'required_without:customer', 'string', 'max:120'],
            'new_customer.phone' => ['nullable', 'required_without:customer', 'string', 'max:32'],
            'source' => ['nullable', Rule::in(['dashboard', 'walk_in', 'phone'])],
            'customer_notes' => ['nullable', 'string', 'max:500'],
            'internal_notes' => ['nullable', 'string', 'max:1000'],
        ]);
        $branch = Branch::query()->where('public_id', $request->input('branch'))->firstOrFail();
        $barber = BookingInput::barber($request, $branch);
        Gate::forUser($actor)->authorize('create', [Booking::class, $branch->id, $barber?->id]);

        $customer = $this->customer($request, $actor);

        return ($this->create)($branch, $customer, BookingInput::selection($request), BookingInput::startsAt($request),
            BookingSource::from((string) $request->input('source', 'dashboard')), $barber, $actor,
            $request->input('customer_notes'), $request->input('internal_notes'));
    }

    public function reschedule(Request $request, Booking $booking, User $actor): Booking
    {
        $request->validate(['starts_at' => ['required', 'date'], 'barber' => ['nullable', 'string', 'max:26']]);
        $branch = Branch::query()->findOrFail($booking->branch_id);
        $barber = $request->filled('barber') ? BookingInput::barber($request, $branch) : null;
        Gate::forUser($actor)->authorize('reschedule', [$booking, $barber?->id]);

        return ($this->reschedule)($booking, CarbonImmutable::parse((string) $request->input('starts_at')), $barber, $actor);
    }

    public function cancel(Request $request, Booking $booking, User $actor): Booking
    {
        $data = $request->validate(['reason' => ['nullable', 'string', 'max:255'], 'override_policy' => ['nullable', 'boolean']]);
        Gate::forUser($actor)->authorize('cancel', $booking);
        $override = (bool) ($data['override_policy'] ?? false);
        if ($override) {
            Gate::forUser($actor)->authorize('overridePolicy', $booking);
        }

        return ($this->cancel)($booking, $actor, $data['reason'] ?? null, $override);
    }

    /**
     * @param  'confirm'|'arrive'|'start'|'complete'|'no_show'  $action
     */
    public function transition(Request $request, Booking $booking, User $actor, string $action): Booking
    {
        $gate = Gate::forUser($actor);
        if ($action === 'no_show') {
            $gate->authorize('noShow', $booking);
            $waive = (bool) $request->boolean('waive_fee');
            if ($waive) {
                $gate->authorize('overridePolicy', $booking);
            }

            return $this->status->markNoShow($booking, $actor, $waive);
        }
        $gate->authorize('updateStatus', $booking);

        return match ($action) {
            'confirm' => $this->status->confirm($booking, $actor),
            'arrive' => $this->status->markArrived($booking, $actor),
            'start' => $this->status->startService($booking, $actor),
            'complete' => $this->status->complete($booking, $actor),
        };
    }

    /**
     * Bookings visible to the user for a branch-local day range (calendar, staff app).
     *
     * @return Builder<Booking>
     */
    public static function visible(User $user, ?Branch $branch, CarbonImmutable $from, CarbonImmutable $to): Builder
    {
        $scope = Access::scope($user, 'booking.view');
        $branchIds = Access::branchIds($user, Tenancy::membership(), 'booking.view');

        return Booking::query()
            ->where('starts_at', '<', $to)->where('blocked_until', '>', $from)
            ->when($branch !== null, fn ($q) => $q->where('branch_id', $branch->id))
            ->when($scope === PermissionCatalog::SCOPE_BRANCH, fn ($q) => $q->whereIn('branch_id', $branchIds ?? []))
            ->when($scope === PermissionCatalog::SCOPE_OWN, fn ($q) => $q->whereIn('barber_id', Barber::query()->where('user_id', $user->id)->select('id')))
            ->when($scope === null, fn ($q) => $q->whereRaw('1 = 0'))
            ->with(['customer', 'barber', 'items'])
            ->orderBy('starts_at');
    }

    private function customer(Request $request, User $actor): Customer
    {
        if ($request->filled('customer')) {
            return Customer::query()->where('public_id', $request->input('customer'))->firstOrFail();
        }
        Gate::forUser($actor)->authorize('create', Customer::class);
        $phone = PhoneNumber::normalize((string) $request->input('new_customer.phone'), self::countryCode());
        if ($phone === null) {
            throw ValidationException::withMessages(['new_customer.phone' => __('validation.regex', ['attribute' => __('ui.bookings.phone')])]);
        }

        return ($this->customers)($phone, (string) $request->input('new_customer.name'), $request->input('source') === 'walk_in' ? 'walk_in' : 'dashboard');
    }

    private static function countryCode(): string
    {
        return match (Tenancy::current()->country ?? 'QA') {
            'SA' => '966', 'AE' => '971', 'KW' => '965', 'BH' => '973', 'OM' => '968', default => '974',
        };
    }
}
