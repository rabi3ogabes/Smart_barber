<?php

namespace App\Modules\Salon\Actions;

use App\Core\Audit\AuditLogger;
use App\Core\Tenancy\Models\Branch;
use App\Modules\Salon\Models\BranchOpeningHour;
use Illuminate\Support\Facades\DB;

/**
 * Replaces a branch's weekly opening hours. Each weekday may have several ranges.
 */
final class SetOpeningHours
{
    /**
     * @param  array<int, list<array{start: string, end: string}>>  $week  weekday (0 = Sunday) → ranges
     */
    public function __invoke(Branch $branch, array $week): void
    {
        DB::transaction(function () use ($branch, $week): void {
            $old = BranchOpeningHour::query()->where('branch_id', $branch->id)->get(['weekday', 'opens_at', 'closes_at'])->toArray();
            BranchOpeningHour::query()->where('branch_id', $branch->id)->delete();

            foreach ($week as $weekday => $ranges) {
                foreach ($ranges as $range) {
                    BranchOpeningHour::query()->create([
                        'branch_id' => $branch->id,
                        'weekday' => (int) $weekday,
                        'opens_at' => $range['start'],
                        'closes_at' => $range['end'],
                    ]);
                }
            }

            AuditLogger::record('branches.hours_changed', $branch, ['hours' => $old], ['hours' => $week]);
        });
    }
}
