<?php

namespace App\Modules\Review\Actions;

use App\Core\Audit\AuditLogger;
use App\Core\Identity\Models\User;
use App\Modules\Review\Models\BookingReview;
use App\Modules\Review\Support\BarberRating;
use Illuminate\Support\Facades\DB;

/**
 * Hides or re-publishes a review and refreshes the barber rating. Audited.
 */
final class ModerateReview
{
    public function __invoke(BookingReview $review, string $status, User $moderator, ?string $note): BookingReview
    {
        $before = $review->status;
        DB::transaction(function () use ($review, $status, $moderator, $note): void {
            $review->forceFill([
                'status' => $status,
                'moderation_note' => $note,
                'moderated_by_id' => $moderator->id,
                'moderated_at' => now(),
            ])->save();
            BarberRating::recalculate($review->barber_id);
        });
        AuditLogger::record('review.moderated', $review, ['status' => $before], ['status' => $status, 'note' => $note], actor: $moderator);

        return $review;
    }
}
