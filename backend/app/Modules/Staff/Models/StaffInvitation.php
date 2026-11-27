<?php

namespace App\Modules\Staff\Models;

use App\Core\Identity\Models\User;
use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Carbon;

/**
 * @property int $id
 * @property string $public_id
 * @property int $salon_id
 * @property string|null $email
 * @property string|null $phone
 * @property string|null $name
 * @property list<string> $role_names
 * @property list<int> $branch_ids
 * @property string $token_hash
 * @property Carbon $expires_at
 * @property Carbon|null $accepted_at
 * @property Carbon|null $revoked_at
 */
class StaffInvitation extends Model
{
    use BelongsToSalon, HasPublicId;

    protected $fillable = ['email', 'phone', 'name', 'role_names', 'branch_ids', 'token_hash', 'invited_by', 'expires_at'];

    protected $hidden = ['token_hash'];

    protected function casts(): array
    {
        return [
            'role_names' => 'array',
            'branch_ids' => 'array',
            'expires_at' => 'datetime',
            'accepted_at' => 'datetime',
            'revoked_at' => 'datetime',
        ];
    }

    public function isPending(): bool
    {
        return $this->accepted_at === null && $this->revoked_at === null && $this->expires_at->isFuture();
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function inviter(): BelongsTo
    {
        return $this->belongsTo(User::class, 'invited_by');
    }
}
