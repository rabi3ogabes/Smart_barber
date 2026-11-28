<?php

namespace App\Modules\Review\Policies;

use App\Core\Authorization\Access;
use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Identity\Models\User;
use App\Modules\Review\Models\BookingReview;
use Illuminate\Auth\Access\Response;

/**
 * review.moderate (owner, manager). A branch-scoped moderator only sees reviews of their branches;
 * anything else is "not found".
 */
final class BookingReviewPolicy
{
    public function viewAny(User $user): bool
    {
        return Access::scope($user, 'review.moderate') !== null;
    }

    public function moderate(User $user, BookingReview $review): Response
    {
        return match (Access::scope($user, 'review.moderate')) {
            P::SCOPE_ALL => Response::allow(),
            P::SCOPE_BRANCH => Access::allowsInBranches($user, 'review.moderate', [$review->branch_id]) ? Response::allow() : Response::denyAsNotFound(),
            default => Response::deny(),
        };
    }
}
