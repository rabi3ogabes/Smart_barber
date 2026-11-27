<?php

namespace App\Modules\Staff\Models;

use App\Core\Audit\Auditable;
use App\Core\Identity\Models\User;
use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\SalonMembership;
use Database\Factories\BarberFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Translatable\HasTranslations;

/**
 * Bookable staff profile. Its row is the booking lock key for the chair (ADR-004).
 *
 * @property int $id
 * @property string $public_id
 * @property int $salon_id
 * @property int $user_id
 * @property int $salon_user_id
 * @property list<string>|null $specialties
 * @property int|null $years_experience
 * @property int $sort_order
 * @property bool $is_bookable
 * @property int|null $photo_media_id
 */
class Barber extends Model
{
    /** @use HasFactory<BarberFactory> */
    use Auditable, BelongsToSalon, HasFactory, HasPublicId, HasTranslations, SoftDeletes;

    /** Specialty tags offered in the profile editor. */
    public const SPECIALTIES = ['fade', 'classic_cut', 'beard', 'shave', 'kids', 'long_hair', 'coloring', 'styling', 'facial'];

    /** @var list<string> */
    public array $translatable = ['display_name', 'bio'];

    protected $fillable = ['user_id', 'salon_user_id', 'display_name', 'bio', 'specialties', 'years_experience', 'sort_order', 'is_bookable'];

    protected function casts(): array
    {
        return ['specialties' => 'array', 'is_bookable' => 'boolean', 'years_experience' => 'integer', 'sort_order' => 'integer'];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * @return BelongsTo<SalonMembership, $this>
     */
    public function membership(): BelongsTo
    {
        return $this->belongsTo(SalonMembership::class, 'salon_user_id');
    }

    /**
     * @return BelongsToMany<Branch, $this>
     */
    public function branches(): BelongsToMany
    {
        return $this->belongsToMany(Branch::class, 'barber_branches')->withPivot('salon_id')->withTimestamps();
    }

    /**
     * @return HasMany<BarberWorkingHour, $this>
     */
    public function workingHours(): HasMany
    {
        return $this->hasMany(BarberWorkingHour::class);
    }

    /**
     * @return HasMany<BarberBreak, $this>
     */
    public function breaks(): HasMany
    {
        return $this->hasMany(BarberBreak::class);
    }

    /**
     * @return HasMany<TimeOffRequest, $this>
     */
    public function timeOffRequests(): HasMany
    {
        return $this->hasMany(TimeOffRequest::class);
    }

    /**
     * @param  list<int>  $branchIds
     */
    public function syncBranches(array $branchIds): void
    {
        $this->branches()->sync(collect($branchIds)->mapWithKeys(fn (int $id) => [$id => ['salon_id' => $this->salon_id]])->all());
    }
}
