<?php

namespace App\Core\Audit;

use Illuminate\Database\Eloquent\Model;

/**
 * Writes created/updated/deleted events to audit_logs. Hidden attributes and
 * anything listed in $auditExclude are never recorded.
 *
 * @mixin Model
 */
trait Auditable
{
    public static function bootAuditable(): void
    {
        static::created(function (Model $model): void {
            AuditLogger::record($model->getTable().'.created', $model, [], self::auditFilter($model, $model->getAttributes()));
        });

        static::updated(function (Model $model): void {
            $changes = self::auditFilter($model, $model->getChanges());
            unset($changes['updated_at']);
            if ($changes === []) {
                return;
            }
            $old = array_intersect_key(self::auditFilter($model, $model->getOriginal()), $changes);
            AuditLogger::record($model->getTable().'.updated', $model, $old, $changes);
        });

        static::deleted(function (Model $model): void {
            AuditLogger::record($model->getTable().'.deleted', $model, self::auditFilter($model, $model->getOriginal()));
        });
    }

    /**
     * @param  array<string, mixed>  $attributes
     * @return array<string, mixed>
     */
    private static function auditFilter(Model $model, array $attributes): array
    {
        $exclude = array_merge($model->getHidden(), property_exists($model, 'auditExclude') ? $model->auditExclude : []);

        return array_diff_key($attributes, array_flip($exclude));
    }
}
