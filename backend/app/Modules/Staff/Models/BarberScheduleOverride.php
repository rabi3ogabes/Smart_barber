<?php

namespace App\Modules\Staff\Models;

use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

/**
 * One-off change to a barber's day at a branch: a day off or custom hours.
 *
 * @property int $barber_id
 * @property int $branch_id
 * @property Carbon $date
 * @property string $type
 * @property string|null $starts_at
 * @property string|null $ends_at
 */
class BarberScheduleOverride extends Model
{
    use BelongsToSalon, HasPublicId;

    public const DAY_OFF = 'day_off';

    public const CUSTOM_HOURS = 'custom_hours';

    protected $fillable = ['barber_id', 'branch_id', 'date', 'type', 'starts_at', 'ends_at', 'reason'];

    protected function casts(): array
    {
        return ['date' => 'date'];
    }
}
