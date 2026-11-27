<?php

namespace App\Modules\Catalog\Actions;

use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Support\CatalogMoney;
use App\Modules\Catalog\Support\PriceAudit;
use Illuminate\Support\Facades\DB;

final class SaveAddon
{
    /**
     * @param  array<string, mixed>  $data  validated: name, price (major), extra_minutes, tax_class, is_active, services (public ids)
     */
    public function __invoke(?ServiceAddon $addon, array $data, bool $canChangePrice): ServiceAddon
    {
        return DB::transaction(function () use ($addon, $data, $canChangePrice) {
            $isNew = $addon === null;
            $addon ??= new ServiceAddon;
            $old = $addon->price;
            $addon->fill([
                'name' => $data['name'],
                'extra_minutes' => (int) $data['extra_minutes'],
                'tax_class' => $data['tax_class'],
                'is_active' => (bool) $data['is_active'],
            ]);
            if ($isNew || $canChangePrice) {
                $addon->price = (int) CatalogMoney::toMinor($data['price']);
            }
            $addon->save();
            $addon->syncServices(Service::query()->whereIn('public_id', $data['services'] ?? [])->pluck('id')->map(fn ($id) => (int) $id)->all());

            if (! $isNew) {
                PriceAudit::record($addon, 'addon', ['price' => $old], ['price' => $addon->price]);
            }

            return $addon;
        });
    }
}
