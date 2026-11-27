<?php

use App\Core\Authorization\Access;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use Illuminate\Support\Facades\Broadcast;

/*
| Private Reverb channels. Authorisation reuses the permission rules; payloads carry ids only.
*/
Broadcast::channel('customer.{accountId}', function ($user, string $accountId) {
    return $user instanceof CustomerAccount && $user->public_id === $accountId;
});

// Calendar updates: active members who may see bookings in that branch (barbers: their branches).
Broadcast::channel('salon.{salonId}.branch.{branchId}', function ($user, string $salonId, string $branchId) {
    if (! $user instanceof User) {
        return false;
    }
    $salon = Salon::query()->where('public_id', $salonId)->where('status', Salon::STATUS_ACTIVE)->first();
    $membership = $salon ? $user->membershipIn((int) $salon->id) : null;
    if ($salon === null || $membership === null || ! $membership->isActive()) {
        return false;
    }

    return Tenancy::runAs($salon, function () use ($salon, $membership, $user, $branchId) {
        Tenancy::set($salon, $membership);
        $branch = Branch::query()->where('public_id', $branchId)->first();

        return $branch !== null && ($membership->branches()->whereKey($branch->id)->exists() || Access::allowsInBranches($user, 'booking.view', [$branch->id]));
    });
});
