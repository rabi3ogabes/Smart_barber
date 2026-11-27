<?php

namespace App\Modules\Salon\Models;

use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use App\Core\Tenancy\Models\Branch;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Carbon;
use Spatie\Translatable\HasTranslations;

/**
 * A closed date range for one branch, or for every branch when branch_id is null.
 *
 * @property int|null $branch_id
 * @property Carbon $starts_on
 * @property Carbon $ends_on
 */
class BranchClosure extends Model
{
    use BelongsToSalon, HasPublicId, HasTranslations;

    /** @var list<string> */
    public array $translatable = ['reason'];

    protected $fillable = ['branch_id', 'starts_on', 'ends_on', 'reason'];

    protected function casts(): array
    {
        return ['starts_on' => 'date', 'ends_on' => 'date'];
    }

    /**
     * @return BelongsTo<Branch, $this>
     */
    public function branch(): BelongsTo
    {
        return $this->belongsTo(Branch::class);
    }
}
