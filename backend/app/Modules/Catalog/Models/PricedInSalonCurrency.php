<?php

namespace App\Modules\Catalog\Models;

use App\Core\Money\Money;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;

/**
 * Catalog prices are stored as minor units without a currency column; the currency is always
 * the salon's (erd.md, "Catalog prices use salons.currency").
 */
trait PricedInSalonCurrency
{
    protected function money(?int $minor): ?Money
    {
        if ($minor === null) {
            return null;
        }

        return Money::ofMinor($minor, self::salonCurrency((int) $this->getAttribute('salon_id')));
    }

    public static function salonCurrency(int $salonId): string
    {
        $current = Tenancy::current();
        if ($current !== null && (int) $current->id === $salonId) {
            return $current->currency;
        }

        return (string) Salon::query()->whereKey($salonId)->value('currency');
    }
}
