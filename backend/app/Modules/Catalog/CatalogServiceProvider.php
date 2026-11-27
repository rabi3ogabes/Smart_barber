<?php

namespace App\Modules\Catalog;

use App\Modules\Catalog\Models\BarberService;
use App\Modules\Catalog\Models\BranchService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Models\ServiceCategory;
use App\Modules\Catalog\Policies\CatalogPolicy;
use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;

/**
 * Catalog module (L3): categories, services, add-ons, bundles, branch and barber overrides,
 * and PricingService — the only place prices are computed.
 */
final class CatalogServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        foreach ([ServiceCategory::class, Service::class, ServiceAddon::class, ServiceBundle::class] as $model) {
            Gate::policy($model, CatalogPolicy::class);
        }

        Relation::morphMap([
            'service_category' => ServiceCategory::class,
            'service' => Service::class,
            'service_addon' => ServiceAddon::class,
            'service_bundle' => ServiceBundle::class,
            'branch_service' => BranchService::class,
            'barber_service' => BarberService::class,
        ]);
    }
}
