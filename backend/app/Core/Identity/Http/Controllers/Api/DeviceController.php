<?php

namespace App\Core\Identity\Http\Controllers\Api;

use App\Core\Http\ApiResponse;
use App\Core\Identity\Models\Device;
use App\Core\Tenancy\Tenancy;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

/**
 * @group Devices
 */
final class DeviceController
{
    /**
     * Register a device for push
     *
     * Upserts by FCM token; a token moves to the latest owner.
     */
    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'fcm_token' => ['required', 'string', 'max:255'],
            'platform' => ['required', Rule::in(['ios', 'android'])],
            'app' => ['required', Rule::in(['customer', 'staff'])],
            'locale' => ['nullable', Rule::in(config('smartbarber.locales'))],
            'app_version' => ['nullable', 'string', 'max:20'],
        ]);

        /** @var Model $owner */
        $owner = $request->user();

        $device = Device::query()->firstOrNew(['fcm_token' => $data['fcm_token']]);
        $device->forceFill([
            'owner_type' => $owner->getMorphClass(),
            'owner_id' => $owner->getKey(),
            'salon_id' => Tenancy::id(),
            'app' => $data['app'],
            'platform' => $data['platform'],
            'locale' => $data['locale'] ?? app()->getLocale(),
            'app_version' => $data['app_version'] ?? null,
            'last_seen_at' => now(),
        ])->save();

        return ApiResponse::success(null, __('messages.device_registered'), status: $device->wasRecentlyCreated ? 201 : 200);
    }

    /**
     * Remove a device
     */
    public function destroy(Request $request, string $fcmToken): JsonResponse
    {
        /** @var Model $owner */
        $owner = $request->user();

        Device::query()
            ->where('fcm_token', $fcmToken)
            ->where('owner_type', $owner->getMorphClass())
            ->where('owner_id', $owner->getKey())
            ->delete();

        return ApiResponse::success(null, __('messages.device_removed'));
    }
}
