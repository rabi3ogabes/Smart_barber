<?php

namespace Tests\Support;

use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Tenancy;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Support\Facades\Cache;

final class CountBranchesJob implements ShouldQueue
{
    use Dispatchable, Queueable;

    public function handle(): void
    {
        Cache::put('job.salon', Tenancy::id());
        Cache::put('job.branches', Branch::query()->count());
    }
}
