<?php

namespace App\Modules\Staff\Http\Controllers\Web;

use App\Core\Authorization\Access;
use App\Core\Exceptions\AppException;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Tenancy;
use App\Modules\Staff\Actions\DecideTimeOff;
use App\Modules\Staff\Actions\RequestTimeOff;
use App\Modules\Staff\Enums\TimeOffStatus;
use App\Modules\Staff\Enums\TimeOffType;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\TimeOffRequest;
use Carbon\CarbonImmutable;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

/**
 * Time-off timeline (next 8 weeks) plus requests and approvals.
 */
final class TimeOffController
{
    public function index(Request $request): Response
    {
        /** @var User $user */
        $user = $request->user();
        $tz = Tenancy::current()->timezone ?? 'UTC';
        $from = CarbonImmutable::now($tz)->startOfDay();
        $to = $from->addWeeks(8);

        $myBarber = Barber::query()->where('user_id', $user->id)->first();
        $approverBranches = Access::branchIds($user, Tenancy::membership(), 'timeoff.approve');
        $canApproveAny = Access::scope($user, 'timeoff.approve') !== null;

        $barbers = Barber::query()->with('branches:id')->orderBy('sort_order')->get()
            ->filter(fn (Barber $b) => $b->is($myBarber)
                || ($canApproveAny && ($approverBranches === null || $b->branches->pluck('id')->intersect($approverBranches)->isNotEmpty())))
            ->values();

        $requests = TimeOffRequest::query()
            ->with('barber')
            ->whereIn('barber_id', $barbers->pluck('id'))
            ->where(fn ($q) => $q->where('status', TimeOffStatus::Pending)->orWhere(fn ($q) => $q->where('ends_at', '>=', $from->utc())->where('starts_at', '<=', $to->utc())))
            ->whereIn('status', [TimeOffStatus::Pending, TimeOffStatus::Approved, TimeOffStatus::Rejected])
            ->orderBy('starts_at')->get();

        return Inertia::render('TimeOff/Index', [
            'timezone' => $tz,
            'from' => $from->toDateString(),
            'to' => $to->toDateString(),
            'barbers' => $barbers->map(fn (Barber $b) => [
                'id' => $b->public_id,
                'name' => $b->getTranslation('display_name', app()->getLocale()),
                'is_me' => $b->is($myBarber),
                'can_enter' => Gate::allows('enterTimeOff', $b),
            ]),
            'requests' => $requests->map(fn (TimeOffRequest $r) => [
                'id' => $r->public_id,
                'barber' => $barbers->firstWhere('id', $r->barber_id)?->public_id,
                'starts_at' => $r->starts_at->toIso8601String(),
                'ends_at' => $r->ends_at->toIso8601String(),
                'type' => $r->type->value,
                'status' => $r->status->value,
                'reason' => $r->reason,
                'can_decide' => $r->status === TimeOffStatus::Pending && Gate::allows('decide', $r),
                'can_cancel' => Gate::allows('cancel', $r) && ($r->status === TimeOffStatus::Pending || ($r->status === TimeOffStatus::Approved && $r->starts_at->isFuture())),
            ]),
            'types' => array_map(fn (TimeOffType $t) => $t->value, TimeOffType::cases()),
            'canRequest' => $myBarber !== null && Gate::allows('requestTimeOff', $myBarber),
        ]);
    }

    public function store(Request $request, RequestTimeOff $requestTimeOff): RedirectResponse
    {
        /** @var User $user */
        $user = $request->user();
        $data = $request->validate([
            'barber' => ['required', 'string', 'size:26'],
            'starts_on' => ['required', 'date_format:Y-m-d', 'after_or_equal:today'],
            'ends_on' => ['required', 'date_format:Y-m-d', 'after_or_equal:starts_on'],
            'type' => ['required', Rule::enum(TimeOffType::class)],
            'reason' => ['nullable', 'string', 'max:500'],
        ]);
        $barber = Barber::query()->where('public_id', $data['barber'])->firstOrFail();

        // Own request → pending; a manager entering leave for a barber → approved at once.
        $forSelf = $barber->user_id === $user->id;
        Gate::authorize($forSelf ? 'requestTimeOff' : 'enterTimeOff', $barber);

        $tz = Tenancy::current()->timezone ?? 'UTC';
        try {
            $requestTimeOff(
                $barber,
                CarbonImmutable::parse($data['starts_on'], $tz)->startOfDay(),
                CarbonImmutable::parse($data['ends_on'], $tz)->addDay()->startOfDay(),
                TimeOffType::from($data['type']),
                $data['reason'] ?? null,
                $forSelf ? null : $user,
            );
        } catch (AppException $e) {
            throw ValidationException::withMessages(['starts_on' => $e->getMessage()]);
        }

        return back()->with('success', $forSelf ? __('ui.time_off.requested') : __('ui.time_off.added'));
    }

    public function decide(Request $request, TimeOffRequest $timeOff, DecideTimeOff $decide): RedirectResponse
    {
        Gate::authorize('decide', $timeOff);
        $data = $request->validate(['approve' => ['required', 'boolean'], 'note' => ['nullable', 'string', 'max:255']]);
        try {
            $decide($timeOff, $request->user(), (bool) $data['approve'], $data['note'] ?? null);
        } catch (AppException $e) {
            throw ValidationException::withMessages(['approve' => $e->getMessage()]);
        }

        return back()->with('success', $data['approve'] ? __('ui.time_off.approved') : __('ui.time_off.rejected'));
    }

    public function cancel(TimeOffRequest $timeOff, DecideTimeOff $decide): RedirectResponse
    {
        Gate::authorize('cancel', $timeOff);
        try {
            $decide->cancel($timeOff);
        } catch (AppException $e) {
            throw ValidationException::withMessages(['status' => $e->getMessage()]);
        }

        return back()->with('success', __('ui.time_off.cancelled'));
    }
}
