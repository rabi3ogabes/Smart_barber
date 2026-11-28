<?php

namespace App\Core\Identity\Http\Controllers\Api;

use App\Core\Http\ApiResponse;
use App\Core\Identity\Actions\RequestAccountDeletion;
use App\Core\Identity\Actions\UploadAvatar;
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

    /**
     * Upload my photo (resized in the background)
     */
    public function avatar(Request $request, UploadAvatar $upload): JsonResponse
    {
        $request->validate(['avatar' => ['required', 'image', 'mimes:jpg,jpeg,png,webp,heic', 'max:5120', 'dimensions:min_width=96,min_height=96']]);
        /** @var CustomerAccount $account */
        $account = $request->user('customer');
        $upload($account, $request->file('avatar'));

        return ApiResponse::success(new CustomerAccountResource($account->refresh()), __('messages.avatar_updated'));
    }

    /**
     * My notification settings
     */
    public function notificationPreferences(Request $request): JsonResponse
    {
        /** @var CustomerAccount $account */
        $account = $request->user('customer');

        return ApiResponse::success($account->notificationPreferences());
    }

    /**
     * Change my notification settings
     */
    public function updateNotificationPreferences(Request $request): JsonResponse
    {
        /** @var CustomerAccount $account */
        $account = $request->user('customer');
        $rules = [];
        foreach (array_keys(CustomerAccount::NOTIFICATION_DEFAULTS) as $key) {
            $rules[$key] = ['sometimes', 'boolean'];
        }
        $data = array_map(fn ($v) => (bool) $v, $request->validate($rules));

        $account->forceFill(['notification_preferences' => array_merge($account->notificationPreferences(), $data)])->save();

        return ApiResponse::success($account->notificationPreferences(), __('messages.preferences_saved'));
    }

    /**
     * Delete my account (store requirement). Signs out everywhere; salon records are anonymised.
     */
    public function requestDeletion(Request $request, RequestAccountDeletion $delete): JsonResponse
    {
        $reason = $request->validate(['reason' => ['nullable', 'string', 'max:500']])['reason'] ?? null;
        /** @var CustomerAccount $account */
        $account = $request->user('customer');
        $delete($account, $reason);

        return ApiResponse::success(null, __('messages.deletion_requested'), status: 202);
    }
}
