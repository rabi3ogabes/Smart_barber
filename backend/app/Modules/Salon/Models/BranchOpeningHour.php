<?php

namespace App\Modules\Salon\Models;

use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;

/**
 * One opening range of a branch on a weekday (several rows = several ranges). Branch-local time.
 *
 * @property int $branch_id
 * @property int $weekday 0 = Sunday … 6 = Saturday
 * @property string $opens_at
 * @property string $closes_at
 */
class BranchOpeningHour extends Model
{
    use BelongsToSalon;

    protected $fillable = ['branch_id', 'weekday', 'opens_at', 'closes_at'];

    protected function casts(): array
    {
        return ['weekday' => 'integer'];
    }
}
