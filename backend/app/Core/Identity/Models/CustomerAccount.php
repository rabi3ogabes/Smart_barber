<?php

namespace App\Core\Identity\Models;

use App\Core\Support\HasPublicId;
use Database\Factories\CustomerAccountFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Support\Carbon;
use Laravel\Sanctum\HasApiTokens;

/**
 * Customer app login identity (global, phone unique). Each salon keeps its own
 * `customers` profile linked to it (Phase 4, ADR-002).
 *
 * @property int $id
 * @property string $public_id
 * @property string $phone
 * @property string|null $name
 * @property string|null $email
 * @property string $locale
 * @property Carbon|null $phone_verified_at
 * @property int|null $avatar_media_id
 * @property array<string, bool>|null $notification_preferences
 * @property Carbon|null $deletion_requested_at
 * @property Carbon|null $anonymised_at
 */
class CustomerAccount extends Authenticatable
{
    /** @use HasFactory<CustomerAccountFactory> */
    use HasApiTokens, HasFactory, HasPublicId, SoftDeletes;

    protected $fillable = ['phone', 'name', 'email', 'locale'];

    protected $hidden = ['remember_token'];

    /** What the app may send; offers are opt-in. Unknown keys are ignored. */
    public const NOTIFICATION_DEFAULTS = ['booking_updates' => true, 'reminders' => true, 'offers' => false];

    protected function casts(): array
    {
        return [
            'phone_verified_at' => 'datetime',
            'deletion_requested_at' => 'datetime',
            'anonymised_at' => 'datetime',
            'notification_preferences' => 'array',
        ];
    }

    /**
     * @return array<string, bool>
     */
    public function notificationPreferences(): array
    {
        $saved = $this->notification_preferences ?? [];

        return array_map(fn (string $key) => (bool) ($saved[$key] ?? self::NOTIFICATION_DEFAULTS[$key]), array_combine(array_keys(self::NOTIFICATION_DEFAULTS), array_keys(self::NOTIFICATION_DEFAULTS)));
    }

    public function getAuthPassword(): string
    {
        return '';
    }
}
