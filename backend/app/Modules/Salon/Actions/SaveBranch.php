<?php

namespace App\Modules\Salon\Actions;

use App\Core\Tenancy\Models\Branch;

final class SaveBranch
{
    /**
     * @param  array<string, mixed>  $data
     */
    public function __invoke(?Branch $branch, array $data): Branch
    {
        $branch ??= new Branch;
        $branch->fill($data)->save();

        return $branch;
    }
}
