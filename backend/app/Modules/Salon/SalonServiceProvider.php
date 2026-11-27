<?php

namespace App\Modules\Salon;

use App\Core\Tenancy\Models\Branch;
use App\Modules\Salon\Models\BranchClosure;
use App\Modules\Salon\Policies\BranchPolicy;
use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;

/**
 * Salon module (L1): profile, booking policy, branches, opening hours, closures.
 */
final class SalonServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        Gate::policy(Branch::class, BranchPolicy::class);
        Relation::morphMap(['branch_closure' => BranchClosure::class]);
    }
}
