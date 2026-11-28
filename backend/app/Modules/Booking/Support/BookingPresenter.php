<?php

namespace App\Modules\Booking\Support;

use App\Core\Authorization\Access;
use App\Core\Identity\Models\User;
use App\Core\Money\Money;
use App\Core\Tenancy\Models\Salon;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Models\BookingItem;
use App\Modules\Booking\Models\BookingReview;
use App\Modules\Booking\Models\BookingStatusHistory;
use App\Modules\Catalog\Models\Service;
use Illuminate\Support\Facades\Gate;

/**
 * One booking as the dashboard and the apps see it. Staff get the actions they may take now;
 * barbers (no customer.contact.view) see masked phone numbers; customers never see internal notes.
 */
final class BookingPresenter
{
    /**
     * @return array<string, mixed>
     */
    public static function forStaff(Booking $b, User $viewer, bool $withHistory = false): array
    {
        $b->loadMissing(['customer', 'barber', 'items']);
        $canSeeContact = Access::scope($viewer, 'customer.contact.view') !== null;

        return self::base($b) + [
            'customer' => $b->customer === null ? null : [
                'id' => $b->customer->public_id,
                'name' => $b->customer->name,
                'phone' => $canSeeContact ? $b->customer->phone : $b->customer->maskedPhone(),
                'visits' => $b->customer->visits_count,
                'no_shows' => $b->customer->no_show_count,
            ],
            'internal_notes' => $b->internal_notes,
            'actions' => self::actions($b, $viewer),
            'history' => $withHistory ? self::history($b) : null,
        ];
    }

    /**
     * @return array<string, mixed>
     */
    public static function forCustomer(Booking $b, bool $withHistory = false): array
    {
        $b->loadMissing(['barber', 'items', 'branch']);

        $branch = $b->branch;
        $review = BookingReview::query()->where('booking_id', $b->id)->first();

        return self::base($b) + [
            'branch_name' => $branch?->getTranslations('name'),
            'branch' => $branch === null ? null : [
                'id' => $branch->public_id,
                'name' => $branch->getTranslations('name'),
                'address' => $branch->getTranslations('address'),
                'location' => $branch->lat === null ? null : ['lat' => (float) $branch->lat, 'lng' => (float) $branch->lng],
                'phone' => $branch->phone,
                'timezone' => $branch->timezone,
            ],
            'salon' => self::salon($b->salon_id),
            'can_change' => $b->status->isReschedulable(),
            'review' => $review === null ? null : ['rating' => $review->rating, 'comment' => $review->comment],
            'can_review' => $review === null && $b->status === BookingStatus::Completed,
            'history' => $withHistory ? self::history($b) : null,
        ];
    }

    /**
     * @return list<string>
     */
    public static function actions(Booking $b, User $viewer): array
    {
        $user = Gate::forUser($viewer);
        $out = [];
        $next = $b->status->allowedNext();
        $map = [
            'confirm' => [BookingStatus::Confirmed, 'updateStatus'],
            'arrive' => [BookingStatus::Arrived, 'updateStatus'],
            'start' => [BookingStatus::InService, 'updateStatus'],
            'complete' => [BookingStatus::Completed, 'updateStatus'],
            'cancel' => [BookingStatus::Cancelled, 'cancel'],
            'no_show' => [BookingStatus::NoShow, 'noShow'],
        ];
        foreach ($map as $action => [$status, $ability]) {
            if (in_array($status, $next, true) && $user->allows($ability, $b)) {
                if ($action === 'no_show' && $b->starts_at->isFuture()) {
                    continue;
                }
                $out[] = $action;
            }
        }
        if ($b->status->isReschedulable() && $user->allows('reschedule', $b)) {
            $out[] = 'reschedule';
        }
        if (in_array('cancel', $out, true) && $user->allows('overridePolicy', $b)) {
            $out[] = 'override_policy';
        }

        return $out;
    }

    /**
     * @return array<string, mixed>
     */
    private static function base(Booking $b): array
    {
        return [
            'id' => $b->public_id,
            'status' => $b->status->value,
            'source' => $b->source->value,
            'starts_at' => $b->starts_at->toIso8601ZuluString(),
            'ends_at' => $b->ends_at->toIso8601ZuluString(),
            'blocked_until' => $b->blocked_until->toIso8601ZuluString(),
            'barber' => $b->barber === null ? null : ['id' => $b->barber->public_id, 'name' => $b->barber->getTranslations('display_name')],
            'items' => $b->items->map(fn (BookingItem $i) => [
                'type' => $i->type,
                'service' => $i->service_id !== null ? self::servicePublicId($i->service_id) : null,
                'name' => $i->getTranslations('name'),
                'duration_minutes' => $i->duration_minutes,
                'total' => Money::ofMinor($i->total_amount, $b->currency),
            ])->values()->all(),
            'subtotal' => Money::ofMinor($b->subtotal_amount, $b->currency),
            'discount' => Money::ofMinor($b->discount_amount, $b->currency),
            'tax' => Money::ofMinor($b->tax_amount, $b->currency),
            'total' => $b->total(),
            'customer_notes' => $b->customer_notes,
            'cancel_reason' => $b->cancel_reason,
            'reschedule_count' => $b->reschedule_count,
        ];
    }

    /** @var array<int, string> */
    private static array $servicePublicIds = [];

    /**
     * @return array<string, mixed>|null
     */
    private static function salon(int $salonId): ?array
    {
        $salon = Salon::query()->find($salonId);

        return $salon === null ? null : ['id' => $salon->public_id, 'slug' => $salon->slug, 'name' => $salon->getTranslations('name')];
    }

    private static function servicePublicId(int $id): ?string
    {
        if (! array_key_exists($id, self::$servicePublicIds)) {
            self::$servicePublicIds += Service::withTrashed()->pluck('public_id', 'id')->all();
        }

        return self::$servicePublicIds[$id] ?? null;
    }

    /**
     * @return list<array<string, mixed>>
     */
    private static function history(Booking $b): array
    {
        return $b->history()->get()->map(fn (BookingStatusHistory $h) => [
            'from' => $h->from_status,
            'to' => $h->to_status,
            'at' => $h->created_at->toIso8601ZuluString(),
            'actor' => $h->actor_type,
            'reason' => $h->reason,
            'rescheduled' => (bool) ($h->meta['rescheduled'] ?? false),
            'meta' => $h->meta,
        ])->all();
    }
}
