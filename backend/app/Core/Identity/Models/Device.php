<?php

namespace App\Core\Identity\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;

/**
 * A push-capable app install. Not tenant-scoped: owned by a user or customer account.
 *
 * @property int $id
 * @property string $owner_type
 * @property int $owner_id
 * @property int|null $salon_id
 * @property string $app
 * @property string $platform
 * @property string $fcm_token
 */
class Device extends Model
{
    protected $fillable = ['app', 'platform', 'fcm_token', 'locale', 'app_version', 'last_seen_at'];

    protected function casts(): array
    {
        return ['last_seen_at' => 'datetime'];
    }

    /**
     * @return MorphTo<Model, $this>
     */
    public function owner(): MorphTo
    {
        return $this->morphTo();
    }
}
