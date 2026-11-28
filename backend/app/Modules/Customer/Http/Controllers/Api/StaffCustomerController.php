<?php

namespace App\Modules\Customer\Http\Controllers\Api;

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

final class StaffCustomerController
{
    public function index(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user('staff');
        Gate::forUser($user)->authorize('viewAny', Customer::class);

        return ApiResponse::success(CustomerSearch::run($user, (string) $request->query('q', '')));
    }

    /** Quick create; returns the existing customer when the phone is already known. */
    public function store(Request $request, FindOrCreateCustomer $find): JsonResponse
    {
        /** @var User $user */
        $user = $request->user('staff');
        Gate::forUser($user)->authorize('create', Customer::class);
        $data = $request->validate(['name' => ['required', 'string', 'max:120'], 'phone' => ['required', 'string', 'max:32']]);
        $phone = PhoneNumber::normalize($data['phone']) ?? throw ValidationException::withMessages(['phone' => __('validation.regex', ['attribute' => 'phone'])]);
        $customer = $find($phone, $data['name'], 'phone');

        return ApiResponse::success(['id' => $customer->public_id, 'name' => $customer->name, 'phone' => $customer->phone, 'existing' => ! $customer->wasRecentlyCreated], status: $customer->wasRecentlyCreated ? 201 : 200);
    }
}
