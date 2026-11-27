<?php

namespace App\Modules\Staff\Models;

use App\Core\Audit\Auditable;
use App\Core\Identity\Models\User;
use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use App\Modules\Staff\Enums\TimeOffStatus;
use App\Modules\Staff\Enums\TimeOffType;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Carbon;

/**
 * @property int $id
 * @property string $public_id
 * @property int $barber_id
 * @property Carbon $starts_at UTC
 * @property Carbon $ends_at UTC
 * @property TimeOffType $type
 * @property TimeOffStatus $status
 * @property string|null $reason
 * @property Carbon|null $decided_at
 */
class TimeOffRequest extends Model
{
    use Auditable, BelongsToSalon, HasPublicId;

    protected $fillable = ['barber_id', 'starts_at', 'ends_at', 'type', 'status', 'reason', 'decided_by', 'decided_at', 'decision_note'];

    protected function casts(): array
    {
        return [
            'starts_at' => 'datetime',
            'ends_at' => 'datetime',
            'decided_at' => 'datetime',
            'type' => TimeOffType::class,
            'status' => TimeOffStatus::class,
        ];
    }

    /**
     * @return BelongsTo<Barber, $this>
     */
    public function barber(): BelongsTo
    {
        return $this->belongsTo(Barber::class);
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function decider(): BelongsTo
    {
        return $this->belongsTo(User::class, 'decided_by');
    }
}
