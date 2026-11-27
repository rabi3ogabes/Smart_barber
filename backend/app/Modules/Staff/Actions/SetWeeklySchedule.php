<?php

namespace App\Modules\Staff\Actions;

use App\Core\Audit\AuditLogger;
use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Tenancy\Models\Branch;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\BarberBreak;
use App\Modules\Staff\Models\BarberWorkingHour;
use Illuminate\Support\Facades\DB;

/**
 * Replaces a barber's weekly hours and breaks at one branch (branch-local times).
 */
final class SetWeeklySchedule
{
    /**
     * @param  array<int, list<array{start: string, end: string}>>  $hours
     * @param  array<int, list<array{start: string, end: string}>>  $breaks
     */
    public function __invoke(Barber $barber, Branch $branch, array $hours, array $breaks): void
    {
        if (! $barber->branches()->whereKey($branch->id)->exists()) {
            throw new AppException(ErrorCode::NotFound);
        }

        DB::transaction(function () use ($barber, $branch, $hours, $breaks): void {
            BarberWorkingHour::query()->where('barber_id', $barber->id)->where('branch_id', $branch->id)->delete();
            BarberBreak::query()->where('barber_id', $barber->id)->where('branch_id', $branch->id)->delete();

            foreach ([[$hours, BarberWorkingHour::class], [$breaks, BarberBreak::class]] as [$week, $model]) {
                foreach ($week as $weekday => $ranges) {
                    foreach ($ranges as $r) {
                        $model::query()->create([
                            'barber_id' => $barber->id,
                            'branch_id' => $branch->id,
                            'weekday' => $weekday,
                            'starts_at' => $r['start'],
                            'ends_at' => $r['end'],
                        ]);
                    }
                }
            }

            AuditLogger::record('barbers.schedule_changed', $barber, new: ['branch' => $branch->public_id, 'hours' => $hours, 'breaks' => $breaks]);
        });
    }
}
