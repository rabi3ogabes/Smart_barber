<?php

namespace App\Modules\Staff\Models;

use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;

/**
 * Weekly recurring range for a barber at a branch, in branch-local time.
 *
 * @property int $barber_id
 * @property int $branch_id
 * @property int $weekday 0 = Sunday … 6 = Saturday
 * @property string $starts_at
 * @property string $ends_at
 */
class BarberBreak extends Model
{
    use BelongsToSalon;

    protected $fillable = ['barber_id', 'branch_id', 'weekday', 'starts_at', 'ends_at', 'label'];

    protected function casts(): array
    {
        return ['weekday' => 'integer'];
    }
}
