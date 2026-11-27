<?php

namespace App\Modules\Booking\Availability;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use Carbon\CarbonImmutable;

/**
 * When a booking may start. Customers (app) must respect the salon's minimum notice and
 * "days ahead"; staff may book from a few minutes ago (a walk-in already in the chair) onwards.
 */
final class BookingWindow
{
    /** Staff may record a walk-in that started up to this many minutes ago. */
    public const STAFF_GRACE_MINUTES = 15;

    public static function earliest(Salon $salon, bool $customer): CarbonImmutable
    {
        $now = CarbonImmutable::now('UTC');

        return $customer ? $now->addMinutes((int) $salon->lead_time_minutes) : $now->subMinutes(self::STAFF_GRACE_MINUTES);
    }

    /** Last branch-local date a customer may book. */
    public static function lastDate(Salon $salon, Branch $branch): string
    {
        return CarbonImmutable::now($branch->timezone)->addDays((int) $salon->max_days_ahead)->toDateString();
    }

    public static function assert(Salon $salon, Branch $branch, CarbonImmutable $startsAt, bool $customer): void
    {
        if (! $customer) {
            if ($startsAt->lessThan(self::earliest($salon, false))) {
                throw new AppException(ErrorCode::BookingInPast);
            }

            return;
        }
        if ($startsAt->lessThan(CarbonImmutable::now('UTC'))) {
            throw new AppException(ErrorCode::BookingInPast);
        }
        if ($startsAt->lessThan(self::earliest($salon, true))) {
            throw new AppException(ErrorCode::BookingLeadTime);
        }
        if ($startsAt->setTimezone($branch->timezone)->toDateString() > self::lastDate($salon, $branch)) {
            throw new AppException(ErrorCode::BookingTooFarAhead);
        }
    }
}
