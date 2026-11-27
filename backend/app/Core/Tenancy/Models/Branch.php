<?php

namespace App\Core\Tenancy\Models;

use App\Core\Audit\Auditable;
use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use App\Modules\Salon\Models\BranchOpeningHour;
use Database\Factories\BranchFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Translatable\HasTranslations;

/**
 * @property int $id
 * @property string $public_id
 * @property int $salon_id
 * @property string $timezone
 * @property bool $is_active
 */
class Branch extends Model
{
    /** @use HasFactory<BranchFactory> */
    use Auditable, BelongsToSalon, HasFactory, HasPublicId, HasTranslations, SoftDeletes;

    /** @var list<string> */
    public array $translatable = ['name', 'address'];

    protected $fillable = ['name', 'address', 'lat', 'lng', 'phone', 'timezone', 'is_active', 'sort_order'];

    protected function casts(): array
    {
        return ['is_active' => 'boolean', 'lat' => 'decimal:7', 'lng' => 'decimal:7'];
    }

    /**
     * @return HasMany<BranchOpeningHour, $this>
     */
    public function openingHours(): HasMany
    {
        return $this->hasMany(BranchOpeningHour::class)->orderBy('weekday')->orderBy('opens_at');
    }
}
