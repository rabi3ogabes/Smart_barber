<?php

namespace App\Core\Providers;

use App\Core\Contracts\UsageMeter;
use DateTimeInterface;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

/**
 * Appends to usage_records.
 */
final class DatabaseUsageMeter implements UsageMeter
{
    public function record(int $salonId, string $meter, int $quantity, ?Model $source = null): void
    {
        DB::table('usage_records')->insert([
            'salon_id' => $salonId,
            'meter' => $meter,
            'quantity' => $quantity,
            'source_type' => $source?->getMorphClass(),
            'source_id' => $source?->getKey(),
            'occurred_at' => now(),
            'created_at' => now(),
        ]);
    }

    public function usedSince(int $salonId, string $meter, DateTimeInterface $since): int
    {
        return (int) DB::table('usage_records')
            ->where('salon_id', $salonId)
            ->where('meter', $meter)
            ->where('occurred_at', '>=', $since)
            ->sum('quantity');
    }
}
