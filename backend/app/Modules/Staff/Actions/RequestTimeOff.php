<?php

namespace App\Modules\Staff\Actions;

use App\Core\Contracts\NotificationChannel;
use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Identity\Models\User;
use App\Modules\Staff\Enums\TimeOffStatus;
use App\Modules\Staff\Enums\TimeOffType;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\TimeOffRequest;
use Carbon\CarbonImmutable;

final class RequestTimeOff
{
    public function __construct(private readonly NotificationChannel $notify) {}

    /**
     * @param  User|null  $approvedBy  a manager entering leave directly (auto-approved)
     */
    public function __invoke(Barber $barber, CarbonImmutable $startsAt, CarbonImmutable $endsAt, TimeOffType $type, ?string $reason, ?User $approvedBy = null): TimeOffRequest
    {
        $overlap = TimeOffRequest::query()
            ->where('barber_id', $barber->id)
            ->whereIn('status', [TimeOffStatus::Pending, TimeOffStatus::Approved])
            ->where('starts_at', '<', $endsAt->utc())
            ->where('ends_at', '>', $startsAt->utc())
            ->exists();
        if ($overlap) {
            throw new AppException(ErrorCode::TimeOffOverlaps);
        }

        $request = TimeOffRequest::query()->create([
            'barber_id' => $barber->id,
            'starts_at' => $startsAt->utc(),
            'ends_at' => $endsAt->utc(),
            'type' => $type,
            'status' => $approvedBy ? TimeOffStatus::Approved : TimeOffStatus::Pending,
            'reason' => $reason,
            'decided_by' => $approvedBy?->id,
            'decided_at' => $approvedBy ? now() : null,
        ]);

        if ($approvedBy === null) {
            $this->notify->notify($barber, 'staff.time_off_requested', ['request' => $request->public_id]);
        }

        return $request;
    }
}
