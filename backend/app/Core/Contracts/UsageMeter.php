<?php

namespace App\Core\Contracts;

use Illuminate\Database\Eloquent\Model;

/**
 * Records metered usage (AI generations, WhatsApp messages …) for plan limits and billing.
 */
interface UsageMeter
{
    public function record(int $salonId, string $meter, int $quantity, ?Model $source = null): void;

    public function usedSince(int $salonId, string $meter, \DateTimeInterface $since): int;
}
