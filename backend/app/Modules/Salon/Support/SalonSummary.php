<?php

namespace App\Modules\Salon\Support;

use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;

/**
 * The compact salon card the customer app lists (search, resolve, "my salons").
 */
final class SalonSummary
{
    /**
     * @return array<string, mixed>
     */
    public static function for(Salon $salon): array
    {
        $branches = Tenancy::bypass(fn () => Branch::query()->where('salon_id', $salon->id)->where('is_active', true)->orderBy('sort_order')->orderBy('id')->get(['id', 'public_id', 'salon_id', 'name', 'address']));
        $first = $branches->first();

        return [
            'id' => $salon->public_id,
            'slug' => $salon->slug,
            'name' => $salon->getTranslations('name'),
            'logo_url' => Tenancy::runAs($salon, fn () => MediaUrl::for($salon->logo_media_id)),
            'currency' => $salon->currency,
            'branches_count' => $branches->count(),
            'address' => $first?->getTranslations('address'),
        ];
    }
}
