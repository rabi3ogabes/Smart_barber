<?php

namespace App\Modules\Staff\Policies;

use App\Core\Authorization\Access;
use App\Core\Identity\Models\User;
use App\Modules\Staff\Models\TimeOffRequest;

final class TimeOffPolicy
{
    public function decide(User $user, TimeOffRequest $request): bool
    {
        $barber = $request->barber;

        return $barber !== null && Access::allowsInAnyBranch($user, 'timeoff.approve', $barber->branches()->pluck('branches.id')->all());
    }

    public function cancel(User $user, TimeOffRequest $request): bool
    {
        return $request->barber?->user_id === $user->id || $this->decide($user, $request);
    }
}
