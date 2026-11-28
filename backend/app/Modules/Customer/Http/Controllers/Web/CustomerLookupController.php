<?php

namespace App\Modules\Customer\Http\Controllers\Web;

use App\Core\Http\ApiResponse;
use App\Core\Identity\Models\User;
use App\Core\Support\PhoneNumber;
use App\Modules\Customer\Actions\FindOrCreateCustomer;
use App\Modules\Customer\Models\Customer;
use App\Modules\Customer\Support\CustomerSearch;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\ValidationException;

/**
 * JSON for the booking drawer's customer combobox and quick create.
 */
final class CustomerLookupController
{
    public function search(Request $request): JsonResponse
    {
        Gate::authorize('viewAny', Customer::class);
        /** @var User $user */
        $user = $request->user();

        return ApiResponse::success(CustomerSearch::run($user, (string) $request->query('q', '')));
    }

    public function store(Request $request, FindOrCreateCustomer $find): JsonResponse
    {
        Gate::authorize('create', Customer::class);
        $data = $request->validate(['name' => ['required', 'string', 'max:120'], 'phone' => ['required', 'string', 'max:32']]);
        $phone = PhoneNumber::normalize($data['phone']);
        if ($phone === null) {
            throw ValidationException::withMessages(['phone' => __('ui.bookings.phone_invalid')]);
        }
        $customer = $find($phone, $data['name']);

        return ApiResponse::success(['id' => $customer->public_id, 'name' => $customer->name, 'phone' => $customer->phone, 'visits' => $customer->visits_count, 'no_shows' => $customer->no_show_count, 'existing' => ! $customer->wasRecentlyCreated]);
    }
}
