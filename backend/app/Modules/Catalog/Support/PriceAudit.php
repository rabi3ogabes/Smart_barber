<?php

namespace App\Modules\Catalog\Support;

use App\Core\Audit\AuditLogger;
use App\Modules\Catalog\Events\ServicePriceChanged;
use Illuminate\Database\Eloquent\Model;

/**
 * Records "<item>.price_changed" audit entries (in minor units) and emits ServicePriceChanged.
 * Called only when a price really changed.
 */
final class PriceAudit
{
    /**
     * @param  'base'|'branch'|'barber'|'addon'|'bundle'  $scope
     * @param  array<string, mixed>  $old
     * @param  array<string, mixed>  $new
     */
    public static function record(Model $item, string $scope, array $old, array $new): void
    {
        if ($old == $new) {
            return;
        }
        AuditLogger::record('catalog.price_changed', $item, ['scope' => $scope] + $old, ['scope' => $scope] + $new);
        event(new ServicePriceChanged($item, $scope, $old, $new));
    }
}
