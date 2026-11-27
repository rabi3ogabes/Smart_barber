<?php

namespace App\Modules\Staff\Listeners;

use App\Core\Authorization\PermissionCatalog;
use App\Core\Tenancy\Events\MemberAccessChanged;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Staff\Models\Barber;

/**
 * Members with the Barber role get a bookable profile working at their assigned branches.
 * Losing the role keeps the profile (history) but makes it unbookable.
 */
final class SyncBarberProfile
{
    public function handle(MemberAccessChanged $event): void
    {
        $membership = $event->membership;
        $salon = Salon::query()->find($membership->salon_id);
        if ($salon === null) {
            return;
        }

        Tenancy::runAs($salon, function () use ($membership, $event): void {
            $barber = Barber::withTrashed()->where('user_id', $membership->user_id)->first();
            $isBarber = in_array(PermissionCatalog::BARBER, $event->roles, true);

            if (! $isBarber) {
                $barber?->forceFill(['is_bookable' => false])->save();

                return;
            }

            if ($barber === null) {
                $name = (string) $membership->user?->name;
                $barber = Barber::query()->create([
                    'user_id' => $membership->user_id,
                    'salon_user_id' => $membership->id,
                    'display_name' => ['ar' => $name, 'en' => $name],
                    'is_bookable' => true,
                ]);
            } elseif ($barber->trashed()) {
                $barber->restore();
            }

            $barber->syncBranches(array_map('intval', $membership->branches()->pluck('branches.id')->all()));
        });
    }
}
