<?php

namespace App\Modules\Booking\Enums;

/**
 * The booking status machine (ADR-004, spec-review item 5: rescheduling is not a status).
 *
 *   pending ──► confirmed ──► arrived ──► in_service ──► completed
 *      │            │  │          │
 *      └──► cancelled ◄┘  └──► no_show   (arrived may still be cancelled)
 */
enum BookingStatus: string
{
    case Pending = 'pending';
    case Confirmed = 'confirmed';
    case Arrived = 'arrived';
    case InService = 'in_service';
    case Completed = 'completed';
    case Cancelled = 'cancelled';
    case NoShow = 'no_show';

    /** Statuses that occupy the chair (used by the overlap check). */
    public const ACTIVE = ['pending', 'confirmed', 'arrived', 'in_service'];

    /**
     * @return list<self>
     */
    public function allowedNext(): array
    {
        return match ($this) {
            self::Pending => [self::Confirmed, self::Cancelled],
            self::Confirmed => [self::Arrived, self::Cancelled, self::NoShow],
            self::Arrived => [self::InService, self::Cancelled],
            self::InService => [self::Completed],
            self::Completed, self::Cancelled, self::NoShow => [],
        };
    }

    public function canBecome(self $next): bool
    {
        return in_array($next, $this->allowedNext(), true);
    }

    public function isActive(): bool
    {
        return in_array($this->value, self::ACTIVE, true);
    }

    public function isReschedulable(): bool
    {
        return $this === self::Pending || $this === self::Confirmed;
    }
}
