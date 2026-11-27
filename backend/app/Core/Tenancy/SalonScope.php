<?php

namespace App\Core\Tenancy;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Scope;

/**
 * @template TModel of Model
 *
 * @implements Scope<TModel>
 */
final class SalonScope implements Scope
{
    /**
     * @param  Builder<covariant TModel>  $builder
     * @param  TModel  $model
     */
    public function apply(Builder $builder, Model $model): void
    {
        if (Tenancy::isBypassed()) {
            return;
        }

        $salonId = Tenancy::id();

        if ($salonId === null) {
            throw TenantNotResolved::forModel($model::class);
        }

        $builder->where($model->qualifyColumn('salon_id'), $salonId);
    }
}
