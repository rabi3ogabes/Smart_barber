<?php

namespace App\Modules\Catalog\Enums;

/**
 * How a catalog item is taxed: "standard" uses the salon's VAT rate; "zero" and "exempt"
 * are both untaxed (kept apart because invoices must show which one applies).
 */
enum TaxClass: string
{
    case Standard = 'standard';
    case Zero = 'zero';
    case Exempt = 'exempt';

    public function rateBp(int $salonRateBp): int
    {
        return $this === self::Standard ? $salonRateBp : 0;
    }
}
