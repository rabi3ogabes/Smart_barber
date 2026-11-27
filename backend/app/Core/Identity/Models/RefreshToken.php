<?php

namespace App\Core\Identity\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;
use Illuminate\Support\Carbon;

/**
 * Single-use rotating refresh token (ADR-002). Stored hashed.
 *
 * @property int $id
 * @property string $tokenable_type
 * @property int $tokenable_id
 * @property int|null $salon_id
 * @property string $family
 * @property string $token_hash
 * @property string|null $device_name
 * @property Carbon $expires_at
 * @property Carbon|null $used_at
 * @property Carbon|null $revoked_at
 */
class RefreshToken extends Model
{
    protected $fillable = ['family', 'token_hash', 'device_name', 'expires_at', 'used_at', 'revoked_at'];

    protected $hidden = ['token_hash'];

    protected function casts(): array
    {
        return ['expires_at' => 'datetime', 'used_at' => 'datetime', 'revoked_at' => 'datetime'];
    }

    /**
     * @return MorphTo<Model, $this>
     */
    public function tokenable(): MorphTo
    {
        return $this->morphTo();
    }
}
