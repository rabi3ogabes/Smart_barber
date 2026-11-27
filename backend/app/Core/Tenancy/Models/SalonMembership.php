<?php

namespace App\Core\Tenancy\Models;

use App\Core\Audit\Auditable;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

/**
 * A user's membership in one salon (table salon_user).
 *
 * @property int $id
 * @property int $salon_id
 * @property int $user_id
 * @property string $status
 */
class SalonMembership extends Model
{
    use Auditable, BelongsToSalon;

    public const STATUS_INVITED = 'invited';

    public const STATUS_ACTIVE = 'active';

    public const STATUS_DEACTIVATED = 'deactivated';

    protected $table = 'salon_user';

    protected $fillable = ['user_id', 'status', 'invited_by', 'invited_at', 'joined_at', 'deactivated_at'];

    protected function casts(): array
    {
        return [
            'invited_at' => 'datetime',
            'joined_at' => 'datetime',
            'deactivated_at' => 'datetime',
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Branches explicitly assigned to this membership.
     *
     * @return BelongsToMany<Branch, $this>
     */
    public function branches(): BelongsToMany
    {
        return $this->belongsToMany(Branch::class, 'salon_user_branches', 'salon_user_id', 'branch_id')
            ->withPivot('salon_id')
            ->withTimestamps();
    }

    public function isActive(): bool
    {
        return $this->status === self::STATUS_ACTIVE;
    }

    public function assignBranch(Branch $branch): void
    {
        $this->branches()->syncWithoutDetaching([$branch->getKey() => ['salon_id' => $this->salon_id]]);
    }
}
