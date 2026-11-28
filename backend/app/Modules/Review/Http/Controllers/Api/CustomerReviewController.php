<?php

namespace App\Modules\Review\Http\Controllers\Api;

use App\Core\Http\ApiResponse;
use App\Modules\Booking\Support\CustomerBookings;
use App\Modules\Review\Actions\SubmitReview;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * @group Customer bookings
 */
final class CustomerReviewController
{
    /**
     * Rate a completed visit (once per booking)
     */
    public function store(Request $request, string $booking, SubmitReview $submit): JsonResponse
    {
        $model = CustomerBookings::own(CustomerBookings::account($request), $booking);
        $data = $request->validate([
            'rating' => ['required', 'integer', 'between:1,5'],
            'comment' => ['nullable', 'string', 'max:1000'],
        ]);

        $review = $submit($model, (int) $data['rating'], $data['comment'] ?? null);

        return ApiResponse::success([
            'id' => $review->public_id,
            'rating' => $review->rating,
            'comment' => $review->comment,
        ], __('messages.review_saved'), status: 201);
    }
}
