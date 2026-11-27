<?php

namespace App\Core\Tenancy;

use RuntimeException;

/**
 * Thrown when a tenant-owned model is queried or written without a current salon.
 * The scope fails closed instead of returning every salon's rows.
 */
final class TenantNotResolved extends RuntimeException
{
    public static function forModel(string $model): self
    {
        return new self("No current salon is set while accessing tenant model [{$model}].");
    }

    public static function crossTenantWrite(string $model): self
    {
        return new self("Refusing to write [{$model}] for a salon other than the current one.");
    }
}
