<?php

namespace App\Modules\Booking\Support;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Models\Booking;
use App\Modules\Customer\Models\Customer;
use Illuminate\Http\Request;

/**
 * Customer-app access to bookings across salons (ADR-001): a booking is found only through the
 * account's own salon profiles, then the tenant is set to that booking's salon. Someone else's
 * booking is "not found".
 */
final class CustomerBookings
{
    public static function account(Request $request): CustomerAccount
    {
        $account = $request->user('customer');

        return $account instanceof CustomerAccount ? $account : throw new AppException(ErrorCode::Unauthenticated);
    }

    public static function own(CustomerAccount $account, string $publicId): Booking
    {
        $booking = Tenancy::bypass(fn () => Booking::query()->where('public_id', $publicId)
            ->whereIn('customer_id', Customer::query()->where('customer_account_id', $account->id)->select('id'))
            ->first());
        if ($booking === null) {
            throw new AppException(ErrorCode::NotFound);
        }
        Tenancy::set(Salon::query()->findOrFail($booking->salon_id));

        return Booking::query()->findOrFail($booking->id);
    }
}
