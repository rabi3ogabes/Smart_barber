<?php

namespace App\Modules\Customer;

use App\Core\Identity\Events\CustomerAccountErasing;
use App\Modules\Customer\Listeners\AnonymiseAccountProfiles;
use App\Modules\Customer\Models\Customer;
use App\Modules\Customer\Models\CustomerDue;
use App\Modules\Customer\Policies\CustomerPolicy;
use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\ServiceProvider;

/**
 * Customer module (L2), minimal in Phase 4: salon-scoped profiles, search, quick create, and the
 * append-only dues ledger used for no-show fees. Phase 5: anonymises every salon profile of an
 * app account that is being deleted (spec-review item 12).
 */
final class CustomerServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        Gate::policy(Customer::class, CustomerPolicy::class);
        Relation::morphMap(['customer' => Customer::class, 'customer_due' => CustomerDue::class]);
        Event::listen(CustomerAccountErasing::class, AnonymiseAccountProfiles::class);
    }
}
