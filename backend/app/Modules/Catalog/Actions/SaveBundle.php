<?php

namespace App\Modules\Catalog\Actions;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Support\CatalogMoney;
use App\Modules\Catalog\Support\PriceAudit;
use Illuminate\Support\Facades\DB;

final class SaveBundle
{
    /**
     * @param  array<string, mixed>  $data  validated: name, description, price (major), tax_class, is_active, services (≥ 2 public ids, ordered)
     */
    public function __invoke(?ServiceBundle $bundle, array $data, bool $canChangePrice): ServiceBundle
    {
        return DB::transaction(function () use ($bundle, $data, $canChangePrice) {
            $ids = Service::query()->whereIn('public_id', $data['services'])->pluck('id', 'public_id');
            if ($ids->count() !== count(array_unique($data['services'])) || $ids->count() < 2) {
                throw new AppException(ErrorCode::CatalogSelectionInvalid, errors: ['services' => [ErrorCode::CatalogSelectionInvalid->message()]]);
            }

            $isNew = $bundle === null;
            $bundle ??= new ServiceBundle;
            $old = $bundle->price;
            $bundle->fill([
                'name' => $data['name'],
                'description' => array_filter($data['description'] ?? [], fn ($v) => $v !== null && $v !== ''),
                'tax_class' => $data['tax_class'],
                'is_active' => (bool) $data['is_active'],
            ]);
            if ($isNew || $canChangePrice) {
                $bundle->price = (int) CatalogMoney::toMinor($data['price']);
            }
            $bundle->save();
            $bundle->syncServices(array_map(fn (string $pid) => (int) $ids[$pid], array_values($data['services'])));

            if (! $isNew) {
                PriceAudit::record($bundle, 'bundle', ['price' => $old], ['price' => $bundle->price]);
            }

            return $bundle;
        });
    }
}
