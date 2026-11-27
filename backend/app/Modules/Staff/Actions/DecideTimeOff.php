<?php

namespace App\Modules\Staff\Actions;

use App\Core\Contracts\NotificationChannel;
use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Identity\Models\User;
use App\Modules\Staff\Enums\TimeOffStatus;
use App\Modules\Staff\Models\TimeOffRequest;

final class DecideTimeOff
{
    public function __construct(private readonly NotificationChannel $notify) {}

    public function __invoke(TimeOffRequest $request, User $decider, bool $approve, ?string $note = null): TimeOffRequest
    {
        if ($request->status !== TimeOffStatus::Pending) {
            throw new AppException(ErrorCode::TimeOffNotPending);
        }

        $request->forceFill([
            'status' => $approve ? TimeOffStatus::Approved : TimeOffStatus::Rejected,
            'decided_by' => $decider->id,
            'decided_at' => now(),
            'decision_note' => $note,
        ])->save();

        if ($request->barber !== null) {
            $this->notify->notify($request->barber, 'staff.time_off_decided', ['request' => $request->public_id, 'status' => $request->status->value]);
        }

        return $request;
    }

    /**
     * The requester withdraws a pending request, or an approved one that has not started.
     */
    public function cancel(TimeOffRequest $request): TimeOffRequest
    {
        $cancellable = $request->status === TimeOffStatus::Pending
            || ($request->status === TimeOffStatus::Approved && $request->starts_at->isFuture());
        if (! $cancellable) {
            throw new AppException(ErrorCode::TimeOffNotPending);
        }
        $request->forceFill(['status' => TimeOffStatus::Cancelled])->save();

        return $request;
    }
}
