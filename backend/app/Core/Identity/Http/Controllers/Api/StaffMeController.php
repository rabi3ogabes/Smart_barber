<?php

namespace App\Core\Identity\Http\Controllers\Api;

use App\Core\Http\ApiResponse;
use App\Core\Identity\Http\Resources\StaffMeResource;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\SalonMembership;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * @group Staff profile
 */
final class StaffMeController
{
    /**
     * Me in the current salon
     *
     * User, salon, roles, permissions, visible branches and enabled features.
     */
    public function show(Request $request): JsonResponse
    {
        return ApiResponse::success(new StaffMeResource($request->user('staff')));
    }

    /**
     * My salons
     *
     * Salons this user can switch to (each switch signs in again with select-salon).
     */
    public function salons(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user('staff');

        return ApiResponse::success($user->activeMemberships()->map(fn (SalonMembership $m) => [
            'salon' => $m->salon?->public_id,
            'name' => $m->salon?->getTranslations('name'),
            'slug' => $m->salon?->slug,
        ])->values()->all());
    }
}
