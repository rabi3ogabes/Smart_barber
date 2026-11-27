<?php

namespace App\Modules\Catalog\Actions;

use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceCategory;
use App\Modules\Catalog\Support\CatalogMoney;
use App\Modules\Catalog\Support\PriceAudit;
use Illuminate\Support\Facades\DB;

/**
 * Creates or updates a service's details. The base price may only be changed by someone with
 * salon-wide price rights ($canChangePrice); other callers keep the stored price.
 */
final class SaveService
{
    /**
     * @param  array<string, mixed>  $data  validated: category, name, description, base_price (major units string),
     *                                      duration_minutes, buffer_minutes, tax_class, is_active, is_bookable_online
     */
    public function __invoke(?Service $service, array $data, bool $canChangePrice): Service
    {
        return DB::transaction(function () use ($service, $data, $canChangePrice) {
            $category = ServiceCategory::query()->where('public_id', $data['category'])->firstOrFail();
            $isNew = $service === null;
            $service ??= new Service(['sort_order' => (int) Service::query()->where('category_id', $category->id)->max('sort_order') + 1]);
            $oldPrice = $service->base_price;

            $service->fill([
                'category_id' => $category->id,
                'name' => $data['name'],
                'description' => array_filter($data['description'] ?? [], fn ($v) => $v !== null && $v !== ''),
                'duration_minutes' => (int) $data['duration_minutes'],
                'buffer_minutes' => (int) ($data['buffer_minutes'] ?? 0),
                'tax_class' => $data['tax_class'],
                'is_active' => (bool) $data['is_active'],
                'is_bookable_online' => (bool) $data['is_bookable_online'],
            ]);
            if ($isNew || $canChangePrice) {
                $service->base_price = (int) CatalogMoney::toMinor($data['base_price']);
            }
            $service->save();

            if (! $isNew) {
                PriceAudit::record($service, 'base', ['base_price' => $oldPrice], ['base_price' => $service->base_price]);
            }

            return $service;
        });
    }
}
