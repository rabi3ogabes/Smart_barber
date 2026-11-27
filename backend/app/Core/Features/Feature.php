<?php

namespace App\Core\Features;

use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;

/**
 * Per-salon module gating (salon_features). From Phase 14 rows are computed from
 * plan + add-ons + overrides; the API here stays the same.
 */
final class Feature
{
    public const AI_STUDIO = 'ai_studio';

    public const LOYALTY = 'loyalty';

    public const MEMBERSHIP = 'membership';

    public const WHATSAPP = 'whatsapp';

    public const MARKETING = 'marketing';

    public const ADVANCED_POS = 'advanced_pos';

    public const INVENTORY = 'inventory';

    public const COMMISSION = 'commission';

    public const ASSISTANT = 'assistant';

    public const SMART_QUEUE = 'smart_queue';

    public const REBOOKING = 'rebooking';

    /** @return list<string> */
    public static function all(): array
    {
        return [
            self::AI_STUDIO, self::LOYALTY, self::MEMBERSHIP, self::WHATSAPP, self::MARKETING,
            self::ADVANCED_POS, self::INVENTORY, self::COMMISSION, self::ASSISTANT,
            self::SMART_QUEUE, self::REBOOKING,
        ];
    }

    public static function enabled(Salon|int $salon, string $key): bool
    {
        return in_array($key, self::enabledFor($salon), true);
    }

    /**
     * @return list<string>
     */
    public static function enabledFor(Salon|int $salon): array
    {
        $salonId = $salon instanceof Salon ? (int) $salon->getKey() : $salon;

        return array_values(Tenancy::bypass(fn () => SalonFeature::query()
            ->where('salon_id', $salonId)
            ->where('enabled', true)
            ->where(fn ($q) => $q->whereNull('expires_at')->orWhere('expires_at', '>', now()))
            ->pluck('feature_key')
            ->all()));
    }

    public static function enable(Salon $salon, string $key, string $source = 'manual'): void
    {
        Tenancy::runAs($salon, fn () => SalonFeature::query()->updateOrCreate(
            ['feature_key' => $key],
            ['enabled' => true, 'source' => $source],
        ));
    }

    public static function disable(Salon $salon, string $key): void
    {
        Tenancy::runAs($salon, fn () => SalonFeature::query()->where('feature_key', $key)->update(['enabled' => false]));
    }
}
