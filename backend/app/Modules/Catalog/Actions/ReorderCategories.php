<?php

namespace App\Modules\Catalog\Actions;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Modules\Catalog\Models\ServiceCategory;
use Illuminate\Support\Facades\DB;

final class ReorderCategories
{
    /**
     * @param  list<string>  $publicIds  every category of the salon, in the new order
     */
    public function __invoke(array $publicIds): void
    {
        $categories = ServiceCategory::query()->get()->keyBy('public_id');
        if (count($publicIds) !== $categories->count() || array_diff($publicIds, $categories->keys()->all()) !== []) {
            throw new AppException(ErrorCode::ValidationFailed, errors: ['order' => [__('validation.in', ['attribute' => 'order'])]]);
        }

        DB::transaction(function () use ($publicIds, $categories): void {
            foreach ($publicIds as $i => $id) {
                $category = $categories->get($id);
                if ($category !== null && $category->sort_order !== $i) {
                    $category->forceFill(['sort_order' => $i])->saveQuietly(); // ordering is not audited
                }
            }
        });
    }
}
