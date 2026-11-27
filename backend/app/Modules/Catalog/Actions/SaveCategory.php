<?php

namespace App\Modules\Catalog\Actions;

use App\Modules\Catalog\Models\ServiceCategory;

final class SaveCategory
{
    /**
     * @param  array{name: array<string, string>, icon?: string|null, is_active?: bool}  $data
     */
    public function __invoke(?ServiceCategory $category, array $data): ServiceCategory
    {
        $category ??= new ServiceCategory(['sort_order' => (int) ServiceCategory::query()->max('sort_order') + 1]);
        $category->fill([
            'name' => $data['name'],
            'icon' => $data['icon'] ?? null,
            'is_active' => $data['is_active'] ?? true,
        ])->save();

        return $category;
    }
}
