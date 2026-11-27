<?php

namespace App\Modules\Catalog\Pricing;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Money\Money;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Modules\Catalog\Contracts\PriceAdjuster;
use App\Modules\Catalog\Models\BarberService;
use App\Modules\Catalog\Models\BranchService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Staff\Models\Barber;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * The ONLY place customer prices are computed (CLAUDE.md rule 1, modules.md → Catalog).
 *
 * Unit price precedence for a service: barber override > branch override > base price.
 * Bundles and add-ons have one salon-wide price. Duration: barber duration override >
 * service duration; a bundle lasts as long as its services; add-ons add extra minutes.
 * The buffer after the appointment is the largest buffer among the services.
 *
 * Rules enforced here because they change the price:
 * - every service (also inside bundles) must be active and available at the branch;
 * - with a barber, the barber must work at the branch and perform every service;
 * - an add-on must belong to one of the chosen services;
 * - nothing may be chosen twice.
 */
final class PricingService
{
    /** @var list<PriceAdjuster>|null */
    private ?array $adjusters = null;

    /**
     * @param  iterable<Service>  $services
     * @param  iterable<ServiceAddon>  $addons
     * @param  iterable<ServiceBundle>  $bundles
     */
    public function quote(
        Branch $branch,
        iterable $services,
        iterable $addons = [],
        ?Barber $barber = null,
        ?Model $customer = null,
        iterable $bundles = [],
    ): Quote {
        $services = collect($services)->values();
        $addons = collect($addons)->values();
        $bundles = collect($bundles)->values();

        if ($services->isEmpty() && $bundles->isEmpty()) {
            throw new AppException(ErrorCode::CatalogSelectionInvalid, errors: ['services' => [ErrorCode::CatalogSelectionInvalid->message()]]);
        }

        /** @var Collection<int, Service> $bundleServices */
        $bundleServices = new Collection;
        foreach ($bundles as $bundle) {
            if (! $bundle->is_active) {
                throw new AppException(ErrorCode::CatalogSelectionInvalid);
            }
            $bundleServices = $bundleServices->concat($bundle->services);
        }

        $allServiceIds = $services->pluck('id')->concat($bundleServices->pluck('id'));
        if ($allServiceIds->duplicates()->isNotEmpty()
            || $addons->pluck('id')->duplicates()->isNotEmpty()
            || $bundles->pluck('id')->duplicates()->isNotEmpty()) {
            throw new AppException(ErrorCode::CatalogSelectionInvalid);
        }

        $salon = Salon::query()->findOrFail($branch->salon_id);
        $includesTax = (bool) $salon->prices_include_tax;
        $rateBp = (int) $salon->tax_rate_bp;

        $branchRows = BranchService::query()->where('branch_id', $branch->id)->whereIn('service_id', $allServiceIds)->get()->keyBy('service_id');
        $barberRows = $barber === null ? collect() : BarberService::query()->where('barber_id', $barber->id)->whereIn('service_id', $allServiceIds)->get()->keyBy('service_id');

        if ($barber !== null && ! $barber->branches()->whereKey($branch->id)->exists()) {
            throw new AppException(ErrorCode::BarberNotEligible);
        }

        foreach ($services->concat($bundleServices) as $service) {
            $this->assertOffered($service, $branchRows->get($service->id), $barber, $barberRows->get($service->id));
        }

        $lines = [];
        foreach ($services as $service) {
            /** @var BranchService|null $branchRow */
            $branchRow = $branchRows->get($service->id);
            /** @var BarberService|null $barberRow */
            $barberRow = $barberRows->get($service->id);
            [$price, $source] = $this->servicePrice($service, $branchRow, $barberRow);

            $lines[] = new QuoteLine(
                'service', $service->id, $service->public_id, $service->getTranslations('name'), $price, $source,
                $this->serviceDuration($service, $barberRow), $service->tax_class->rateBp($rateBp), $includesTax,
            );
        }

        foreach ($bundles as $bundle) {
            $duration = $bundle->services->sum(fn (Service $s) => $this->serviceDuration($s, $barberRows->get($s->id)));
            $lines[] = new QuoteLine(
                'bundle', $bundle->id, $bundle->public_id, $bundle->getTranslations('name'), $bundle->priceMoney(), 'bundle',
                (int) $duration, $bundle->tax_class->rateBp($rateBp), $includesTax, includes: $bundle->services->pluck('public_id')->values()->all(),
            );
        }

        if ($addons->isNotEmpty()) {
            $allowed = ServiceAddon::query()->whereIn('id', $addons->pluck('id'))
                ->with(['services' => fn ($q) => $q->select('services.id')])->get()->keyBy('id');
            foreach ($addons as $addon) {
                $linked = $allowed->get($addon->id)?->services->pluck('id') ?? collect();
                if (! $addon->is_active || $linked->intersect($allServiceIds)->isEmpty()) {
                    throw new AppException(ErrorCode::CatalogSelectionInvalid, errors: ['addons' => [ErrorCode::CatalogSelectionInvalid->message()]]);
                }
                $lines[] = new QuoteLine(
                    'addon', $addon->id, $addon->public_id, $addon->getTranslations('name'), $addon->priceMoney(), 'addon',
                    $addon->extra_minutes, $addon->tax_class->rateBp($rateBp), $includesTax,
                );
            }
        }

        $buffer = (int) $services->concat($bundleServices)->max('buffer_minutes');
        $quote = new Quote($salon->currency, $includesTax, $lines, $buffer, $barber?->id, $branch->id);

        $context = new QuoteContext($branch, $barber, $customer);
        foreach ($this->adjusters() as $adjuster) {
            $quote = $adjuster->adjust($quote, $context);
        }

        return $quote;
    }

    /**
     * The price a barber (or, without a barber, the branch) charges for one service — for
     * catalog listings. Throws when the service is not offered there.
     */
    public function servicePriceAt(Service $service, Branch $branch, ?Barber $barber = null): Money
    {
        return $this->quote($branch, [$service], barber: $barber)->lines[0]->unitPrice;
    }

    /**
     * Branch prices for many services at once (catalog lists), without quote validation.
     * Services unavailable at the branch are left out.
     *
     * @param  iterable<Service>  $services
     * @return array<int, Money> keyed by service id
     */
    public function branchPrices(Branch $branch, iterable $services): array
    {
        $services = collect($services);
        $rows = BranchService::query()->where('branch_id', $branch->id)->whereIn('service_id', $services->pluck('id'))->get()->keyBy('service_id');
        $out = [];
        foreach ($services as $service) {
            /** @var BranchService|null $row */
            $row = $rows->get($service->id);
            if ($service->is_active && ($row === null || $row->is_available)) {
                $out[$service->id] = $this->servicePrice($service, $row, null)[0];
            }
        }

        return $out;
    }

    /**
     * @return array{0: Money, 1: 'base'|'branch'|'barber'}
     */
    private function servicePrice(Service $service, ?BranchService $branchRow, ?BarberService $barberRow): array
    {
        if ($barberRow?->price_override !== null) {
            return [$barberRow->priceOverride() ?? $service->basePrice(), 'barber'];
        }
        if ($branchRow?->price_override !== null) {
            return [$branchRow->priceOverride() ?? $service->basePrice(), 'branch'];
        }

        return [$service->basePrice(), 'base'];
    }

    private function serviceDuration(Service $service, ?BarberService $barberRow): int
    {
        return $barberRow->duration_override ?? $service->duration_minutes;
    }

    private function assertOffered(Service $service, ?BranchService $branchRow, ?Barber $barber, ?BarberService $barberRow): void
    {
        if (! $service->is_active || $service->trashed() || ($branchRow !== null && ! $branchRow->is_available)) {
            throw new AppException(ErrorCode::ServiceUnavailableAtBranch, data: ['service' => $service->public_id]);
        }
        if ($barber !== null && $barberRow === null) {
            throw new AppException(ErrorCode::BarberNotEligible, data: ['service' => $service->public_id]);
        }
    }

    /**
     * @return list<PriceAdjuster>
     */
    private function adjusters(): array
    {
        return $this->adjusters ??= array_values(iterator_to_array(app()->tagged(PriceAdjuster::TAG)));
    }
}
