<?php

namespace App\Modules\Review\Http\Controllers\Web;

use App\Core\Authorization\Access;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Tenancy;
use App\Modules\Review\Actions\ModerateReview;
use App\Modules\Review\Models\BookingReview;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Inertia\Response;

/**
 * Review moderation (review.moderate): newest first, filter by status and rating; hide or publish.
 */
final class ReviewController
{
    public function index(Request $request): Response
    {
        /** @var User $user */
        $user = $request->user();
        Gate::authorize('viewAny', BookingReview::class);
        $f = $request->validate([
            'status' => ['nullable', Rule::in([BookingReview::PUBLISHED, BookingReview::HIDDEN])],
            'rating' => ['nullable', 'integer', 'between:1,5'],
        ]);
        $branchIds = Access::branchIds($user, Tenancy::membership(), 'review.moderate');

        $base = BookingReview::query()->when($branchIds !== null, fn ($q) => $q->whereIn('branch_id', $branchIds));
        $page = (clone $base)
            ->when($f['status'] ?? null, fn ($q, $s) => $q->where('status', $s))
            ->when($f['rating'] ?? null, fn ($q, $r) => $q->where('rating', $r))
            ->with(['customer', 'barber', 'branch', 'booking', 'moderator'])
            ->latest('id')
            ->paginate(20)->withQueryString();
        $published = (clone $base)->where('status', BookingReview::PUBLISHED);
        $tz = Tenancy::current()->timezone ?? 'Asia/Qatar';

        return Inertia::render('Reviews/Index', [
            'reviews' => collect($page->items())->map(fn (BookingReview $r) => [
                'id' => $r->public_id,
                'rating' => $r->rating,
                'comment' => $r->comment,
                'status' => $r->status,
                'created_at' => $r->created_at->toIso8601ZuluString(),
                'visit_at' => $r->booking?->starts_at->toIso8601ZuluString(),
                'customer' => $r->customer?->name,
                'barber' => $r->barber?->getTranslations('display_name'),
                'branch' => $r->branch?->getTranslations('name'),
                'moderation' => $r->moderated_at === null ? null : [
                    'note' => $r->moderation_note,
                    'by' => $r->moderator?->name,
                    'at' => $r->moderated_at->toIso8601ZuluString(),
                ],
            ])->all(),
            'summary' => [
                'average' => ($avg = (clone $published)->avg('rating')) === null ? null : round((float) $avg, 2),
                'published' => (clone $published)->count(),
                'hidden' => (clone $base)->where('status', BookingReview::HIDDEN)->count(),
            ],
            'pagination' => ['current' => $page->currentPage(), 'last' => $page->lastPage(), 'total' => $page->total(), 'prev' => $page->previousPageUrl(), 'next' => $page->nextPageUrl()],
            'filters' => ['status' => $f['status'] ?? null, 'rating' => isset($f['rating']) ? (int) $f['rating'] : null],
            'timezone' => $tz,
        ]);
    }

    public function update(Request $request, BookingReview $review, ModerateReview $moderate): RedirectResponse
    {
        Gate::authorize('moderate', $review);
        $data = $request->validate([
            'status' => ['required', Rule::in([BookingReview::PUBLISHED, BookingReview::HIDDEN])],
            'note' => ['nullable', 'string', 'max:255'],
        ]);
        /** @var User $user */
        $user = $request->user();
        $moderate($review, $data['status'], $user, $data['note'] ?? null);

        return back()->with('success', __($data['status'] === BookingReview::HIDDEN ? 'ui.reviews.hidden_done' : 'ui.reviews.published_done'));
    }
}
