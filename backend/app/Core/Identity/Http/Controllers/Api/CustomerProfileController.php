<?php

namespace App\Core\Identity\Http\Controllers\Api;

use App\Core\Http\ApiResponse;
use App\Core\Identity\Http\Resources\CustomerAccountResource;
use App\Core\Identity\Models\CustomerAccount;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/**
 * @group Customer profile
 */
final class CustomerProfileController
{
    /**
     * My account
     */
    public function show(Request $request): JsonResponse
    {
        return ApiResponse::success(new CustomerAccountResource($request->user('customer')));
    }

    /**
     * Update my account
     */
    public function update(Request $request): JsonResponse
    {
        /** @var CustomerAccount $account */
        $account = $request->user('customer');

        $data = $request->validate([
            'name' => ['sometimes', 'nullable', 'string', 'max:120'],
            'email' => ['sometimes', 'nullable', 'email', 'max:190'],
            'locale' => ['sometimes', Rule::in(config('smartbarber.locales'))],
        ]);

        $account->fill($data)->save();

        return ApiResponse::success(new CustomerAccountResource($account), __('messages.profile_updated'));
    }
}
