<?php

namespace App\Modules\Catalog\Actions;

use App\Core\Tenancy\Models\Branch;
use App\Modules\Catalog\Models\BranchService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Support\PriceAudit;

/**
 * Availability and optional price override of one service at one branch. Clearing both (available,
 * no override) removes the row, which means "base price".
 */
final class SetBranchPricing
{
    public function __invoke(Service $service, Branch $branch, bool $available, ?int $priceOverride): void
    {
        $row = BranchService::query()->where('service_id', $service->id)->where('branch_id', $branch->id)->first();
        $old = ['branch' => $branch->public_id, 'is_available' => $row === null ? true : $row->is_available, 'price_override' => $row?->price_override];

        if ($available && $priceOverride === null) {
            $row?->delete();
        } else {
            $row ??= new BranchService(['service_id' => $service->id, 'branch_id' => $branch->id]);
            $row->fill(['is_available' => $available, 'price_override' => $priceOverride])->save();
        }

        PriceAudit::record($service, 'branch', $old, ['branch' => $branch->public_id, 'is_available' => $available, 'price_override' => $priceOverride]);
    }
}
