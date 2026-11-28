<?php

namespace App\Modules\Booking\Actions;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Models\BookingReview;
use App\Modules\Booking\Support\BarberRating;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\DB;

/**
 * Rates a completed booking, once. The unique booking_id index makes a double submit impossible
 * even under a race; the second one gets REVIEW_ALREADY_SUBMITTED.
 */
final class SubmitReview
{
    public function __invoke(Booking $booking, int $rating, ?string $comment): BookingReview
    {
        if ($booking->status !== BookingStatus::Completed) {
            throw new AppException(ErrorCode::ReviewNotAllowed);
        }
        if (BookingReview::query()->where('booking_id', $booking->id)->exists()) {
            throw new AppException(ErrorCode::ReviewAlreadySubmitted);
        }
        $comment = $comment === null ? null : (trim($comment) === '' ? null : trim($comment));

        try {
            $review = DB::transaction(function () use ($booking, $rating, $comment) {
                $review = BookingReview::query()->create([
                    'booking_id' => $booking->id,
                    'branch_id' => $booking->branch_id,
                    'customer_id' => $booking->customer_id,
                    'barber_id' => $booking->barber_id,
                    'rating' => $rating,
                    'comment' => $comment,
                ]);
                BarberRating::recalculate($booking->barber_id);

                return $review;
            });
        } catch (QueryException $e) {
            if (($e->errorInfo[1] ?? null) === 1062) {
                throw new AppException(ErrorCode::ReviewAlreadySubmitted);
            }
            throw $e;
        }

        return $review;
    }
}
