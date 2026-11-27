<?php

namespace App\Core\Identity\Http\Controllers\Api;

use App\Core\Http\ApiResponse;
use Illuminate\Http\JsonResponse;

final class AppConfigController
{
    /**
     * App configuration
     *
     * Minimum supported app versions, maintenance flag and supported locales.
     *
     * @group Meta
     *
     * @unauthenticated
     */
    public function __invoke(): JsonResponse
    {
        return ApiResponse::success([
            'min_versions' => [
                'customer' => config('smartbarber.min_app_versions.customer', '1.0.0'),
                'staff' => config('smartbarber.min_app_versions.staff', '1.0.0'),
            ],
            'maintenance' => app()->isDownForMaintenance(),
            'locales' => config('smartbarber.locales'),
            'default_locale' => config('smartbarber.default_locale'),
        ]);
    }
}
