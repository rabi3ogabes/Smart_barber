<?php

namespace App\Modules\Booking\Models;

use App\Core\Identity\Models\User;
use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use App\Core\Tenancy\Models\Branch;
use App\Modules\Customer\Models\Customer;
use App\Modules\Staff\Models\Barber;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Carbon;

/**
 * "Rate your visit": one review per completed booking (spec-review item 6). Published reviews feed
 * the barber's cached rating; moderators (review.moderate) can hide one, which removes it from it.
 *
 * @property int $id
 * @property string $public_id
 * @property int $salon_id
 * @property int $booking_id
 * @property int $branch_id
 * @property int $customer_id
 * @property int|null $barber_id
 * @property int $rating
 * @property string|null $comment
 * @property string $status
 * @property string|null $moderation_note
 * @property int|null $moderated_by_id
 * @property Carbon|null $moderated_at
 * @property Carbon $created_at
 */
class BookingReview extends Model
{
    use BelongsToSalon, HasPublicId;

    public const PUBLISHED = 'published';

    public const HIDDEN = 'hidden';

    protected $fillable = ['booking_id', 'branch_id', 'customer_id', 'barber_id', 'rating', 'comment', 'status'];

    protected $attributes = ['status' => self::PUBLISHED];

    protected function casts(): array
    {
        return ['rating' => 'integer', 'moderated_at' => 'datetime'];
    }

    /** @return BelongsTo<Booking, $this> */
    public function booking(): BelongsTo
    {
        return $this->belongsTo(Booking::class);
    }

    /** @return BelongsTo<Customer, $this> */
    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class)->withTrashed();
    }

    /** @return BelongsTo<Barber, $this> */
    public function barber(): BelongsTo
    {
        return $this->belongsTo(Barber::class)->withTrashed();
    }

    /** @return BelongsTo<Branch, $this> */
    public function branch(): BelongsTo
    {
        return $this->belongsTo(Branch::class);
    }

    /** @return BelongsTo<User, $this> */
    public function moderator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'moderated_by_id');
    }
}
