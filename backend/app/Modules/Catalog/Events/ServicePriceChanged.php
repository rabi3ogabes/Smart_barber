<?php

namespace App\Modules\Catalog\Events;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Foundation\Events\Dispatchable;

/**
 * A catalog price changed (base, branch, barber, add-on or bundle). Already audited; listeners
 * (e.g. Marketing in Phase 11) may react.
 */
final class ServicePriceChanged
{
    use Dispatchable;

    /**
     * @param  'base'|'branch'|'barber'|'addon'|'bundle'  $scope
     * @param  array<string, mixed>  $old
     * @param  array<string, mixed>  $new
     */
    public function __construct(
        public readonly Model $item,
        public readonly string $scope,
        public readonly array $old,
        public readonly array $new,
    ) {}
}
