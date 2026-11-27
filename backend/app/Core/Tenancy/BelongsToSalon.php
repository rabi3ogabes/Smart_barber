<?php

namespace App\Core\Tenancy;

use App\Core\Tenancy\Models\Salon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Marks a model as tenant-owned (ADR-001): every query is filtered by the current
 * salon and salon_id is filled on create. salon_id must never be in $fillable
 * (enforced by tests/Architecture).
 *
 * @mixin Model
 */
trait BelongsToSalon
{
    public static function bootBelongsToSalon(): void
    {
        static::addGlobalScope(new SalonScope);

        static::creating(function (Model $model): void {
            $current = Tenancy::id();

            if ($model->getAttribute('salon_id') === null) {
                if ($current === null) {
                    throw TenantNotResolved::forModel($model::class);
                }
                $model->setAttribute('salon_id', $current);

                return;
            }

            if (! Tenancy::isBypassed() && (int) $model->getAttribute('salon_id') !== $current) {
                throw TenantNotResolved::crossTenantWrite($model::class);
            }
        });

        static::updating(function (Model $model): void {
            if ($model->isDirty('salon_id')) {
                throw TenantNotResolved::crossTenantWrite($model::class);
            }
        });
    }

    /**
     * @return BelongsTo<Salon, $this>
     */
    public function salon(): BelongsTo
    {
        return $this->belongsTo(Salon::class);
    }
}
