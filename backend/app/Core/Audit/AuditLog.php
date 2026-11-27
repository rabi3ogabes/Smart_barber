<?php

namespace App\Core\Audit;

use Illuminate\Database\Eloquent\Model;
use LogicException;

/**
 * Append-only audit trail. salon_id is nullable for platform events, so this model
 * is not tenant-scoped; read it through AuditLog::forCurrentSalon().
 *
 * @property int $id
 * @property int|null $salon_id
 * @property string $event
 * @property array<string, mixed>|null $old_values
 * @property array<string, mixed>|null $new_values
 */
class AuditLog extends Model
{
    public const UPDATED_AT = null;

    protected $guarded = ['id'];

    protected function casts(): array
    {
        return ['old_values' => 'array', 'new_values' => 'array', 'created_at' => 'datetime'];
    }

    protected static function booted(): void
    {
        static::updating(fn () => throw new LogicException('Audit logs are append-only.'));
        static::deleting(fn () => throw new LogicException('Audit logs are append-only.'));
    }
}
