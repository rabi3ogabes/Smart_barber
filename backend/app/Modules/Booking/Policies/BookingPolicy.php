<?php

namespace App\Modules\Booking\Policies;

use App\Core\Authorization\Access;
use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Identity\Models\User;
use App\Modules\Booking\Models\Booking;
use App\Modules\Staff\Models\Barber;
use Illuminate\Auth\Access\Response;

/**
 * Booking permissions (permissions.md → Bookings): scope "all" = whole salon, "branch" = the
 * member's branches, "own" = bookings in the barber's own chair. A booking outside the user's
 * scope is reported as not found (404), not forbidden.
 */
final class BookingPolicy
{
    public function viewAny(User $user): bool
    {
        return Access::scope($user, 'booking.view') !== null;
    }

    public function view(User $user, Booking $booking): Response
    {
        return $this->inScope($user, 'booking.view', $booking->branch_id, $booking->barber_id) ? Response::allow() : Response::denyAsNotFound();
    }

    /** Create in this branch, for this barber (null = "any"; barbers must book themselves). */
    public function create(User $user, int $branchId, ?int $barberId): bool
    {
        if (Access::scope($user, 'booking.create') === P::SCOPE_OWN) {
            return $barberId !== null && $this->inScope($user, 'booking.create', $branchId, $barberId);
        }

        return $this->inScope($user, 'booking.create', $branchId, $barberId);
    }

    public function reschedule(User $user, Booking $booking, ?int $targetBarberId = null): Response
    {
        if (! $this->inScope($user, 'booking.view', $booking->branch_id, $booking->barber_id)) {
            return Response::denyAsNotFound();
        }

        return $this->inScope($user, 'booking.reschedule', $booking->branch_id, $booking->barber_id)
            && $this->inScope($user, 'booking.reschedule', $booking->branch_id, $targetBarberId ?? $booking->barber_id)
            ? Response::allow() : Response::deny();
    }

    public function cancel(User $user, Booking $booking): Response
    {
        return $this->scoped($user, 'booking.cancel', $booking);
    }

    public function overridePolicy(User $user, Booking $booking): bool
    {
        return $this->inScope($user, 'booking.cancel.override_policy', $booking->branch_id, $booking->barber_id);
    }

    public function updateStatus(User $user, Booking $booking): Response
    {
        return $this->scoped($user, 'booking.status.update', $booking);
    }

    public function noShow(User $user, Booking $booking): Response
    {
        return $this->scoped($user, 'booking.no_show', $booking);
    }

    private function scoped(User $user, string $permission, Booking $booking): Response
    {
        if (! $this->inScope($user, 'booking.view', $booking->branch_id, $booking->barber_id)) {
            return Response::denyAsNotFound();
        }

        return $this->inScope($user, $permission, $booking->branch_id, $booking->barber_id) ? Response::allow() : Response::deny();
    }

    private function inScope(User $user, string $permission, int $branchId, ?int $barberId): bool
    {
        return match (Access::scope($user, $permission)) {
            P::SCOPE_ALL => true,
            P::SCOPE_BRANCH => Access::allowsInBranches($user, $permission, [$branchId]),
            P::SCOPE_OWN => $barberId !== null && Barber::query()->whereKey($barberId)->where('user_id', $user->id)->exists(),
            default => false,
        };
    }
}
