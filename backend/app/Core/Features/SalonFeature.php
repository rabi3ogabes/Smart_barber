<?php

namespace App\Core\Features;

use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

/**
 * @property string $feature_key
 * @property bool $enabled
 * @property string $source
 * @property Carbon|null $expires_at
 */
class SalonFeature extends Model
{
    use BelongsToSalon;

    protected $fillable = ['feature_key', 'enabled', 'source', 'limits', 'expires_at'];

    protected function casts(): array
    {
        return ['enabled' => 'boolean', 'limits' => 'array', 'expires_at' => 'datetime'];
    }
}
