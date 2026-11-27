<?php

namespace App\Modules\Customer\Models;

use App\Core\Audit\Auditable;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Carbon;

/**
 * A salon's customer profile (one per salon and phone). Linked to a global CustomerAccount when
 * the person uses the app; walk-ins have none. Visit counters are caches derived from bookings.
 *
 * @property int $id
 * @property string $public_id
 * @property int $salon_id
 * @property int|null $customer_account_id
 * @property string $name
 * @property string $phone
 * @property string|null $email
 * @property string $locale
 * @property string $source
 * @property Carbon|null $first_visit_at
 * @property Carbon|null $last_visit_at
 * @property int $visits_count
 * @property int $no_show_count
 */
class Customer extends Model
{
    use Auditable, BelongsToSalon, HasPublicId, SoftDeletes;

    public const SOURCES = ['app', 'dashboard', 'walk_in', 'phone', 'import'];

    protected $attributes = ['locale' => 'ar', 'source' => 'dashboard', 'visits_count' => 0, 'no_show_count' => 0, 'total_spent_amount' => 0];

    protected $fillable = ['customer_account_id', 'name', 'phone', 'email', 'locale', 'source', 'internal_notes'];

    protected function casts(): array
    {
        return [
            'first_visit_at' => 'datetime',
            'last_visit_at' => 'datetime',
            'visits_count' => 'integer',
            'no_show_count' => 'integer',
            'tags' => 'array',
        ];
    }

    /**
     * @return BelongsTo<CustomerAccount, $this>
     */
    public function account(): BelongsTo
    {
        return $this->belongsTo(CustomerAccount::class, 'customer_account_id');
    }

    /**
     * @return HasMany<CustomerDue, $this>
     */
    public function dues(): HasMany
    {
        return $this->hasMany(CustomerDue::class);
    }

    /** Outstanding amount in minor units, derived from the append-only ledger. */
    public function balanceOwed(): int
    {
        return (int) $this->dues()->sum('amount');
    }

    public function maskedPhone(): string
    {
        return substr($this->phone, 0, 4).str_repeat('•', max(0, strlen($this->phone) - 7)).substr($this->phone, -3);
    }
}
