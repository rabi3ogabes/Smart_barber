<?php

namespace App\Modules\Salon\Actions;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Tenancy\Models\Branch;

/**
 * Branches are deactivated, never deleted. A salon keeps at least one active branch.
 */
final class DeactivateBranch
{
    public function __invoke(Branch $branch, bool $active): Branch
    {
        if (! $active && Branch::query()->where('is_active', true)->whereKeyNot($branch->id)->doesntExist()) {
            throw new AppException(ErrorCode::LastActiveBranch);
        }

        $branch->forceFill(['is_active' => $active])->save();

        return $branch;
    }
}
