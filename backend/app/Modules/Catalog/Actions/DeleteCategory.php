<?php

namespace App\Modules\Catalog\Actions;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Modules\Catalog\Models\ServiceCategory;

/**
 * Soft-deletes an empty category. Categories that still hold services are refused, so no service
 * ever loses its category.
 */
final class DeleteCategory
{
    public function __invoke(ServiceCategory $category): void
    {
        if ($category->services()->exists()) {
            throw new AppException(ErrorCode::CategoryNotEmpty);
        }
        $category->delete();
    }
}
