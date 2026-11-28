<?php

namespace App\Modules\Review;

use App\Modules\Review\Models\BookingReview;
use App\Modules\Review\Policies\BookingReviewPolicy;
use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;

/**
 * Review module (Phase 5): "Rate your visit", moderation and the derived barber rating.
 */
final class ReviewServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        Gate::policy(BookingReview::class, BookingReviewPolicy::class);
        Relation::morphMap(['booking_review' => BookingReview::class]);
    }
}
