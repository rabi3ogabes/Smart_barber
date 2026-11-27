<?php

namespace App\Modules\Catalog\Support;

use App\Core\Money\Money;
use App\Core\Tenancy\Tenancy;

/**
 * Converts dashboard input (a decimal string in major units, e.g. "60.00") to minor units of the
 * current salon's currency, and back for forms. Never floats.
 */
final class CatalogMoney
{
    public static function currency(): string
    {
        return Tenancy::current()->currency ?? throw new \LogicException('No salon set.');
    }

    public static function toMinor(string|int|null $major): ?int
    {
        if ($major === null || $major === '') {
            return null;
        }

        return Money::ofMajor((string) $major, self::currency())->minor();
    }

    public static function toDecimal(?int $minor): ?string
    {
        return $minor === null ? null : Money::ofMinor($minor, self::currency())->toDecimal();
    }

    /**
     * @return array{amount: int, currency: string, formatted: string}|null
     */
    public static function present(?int $minor): ?array
    {
        return $minor === null ? null : Money::ofMinor($minor, self::currency())->toArray();
    }
}
