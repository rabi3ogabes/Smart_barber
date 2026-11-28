<?php

namespace App\Modules\Customer\Listeners;

use App\Core\Identity\Events\CustomerAccountErasing;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Customer\Actions\AnonymiseCustomer;
use App\Modules\Customer\Models\Customer;

/**
 * Every salon profile linked to an account being erased is anonymised inside its own tenant.
 */
final class AnonymiseAccountProfiles
{
    public function __construct(private readonly AnonymiseCustomer $anonymise) {}

    public function handle(CustomerAccountErasing $event): void
    {
        $profiles = Tenancy::bypass(fn () => Customer::withTrashed()->where('customer_account_id', $event->account->id)->get());
        foreach ($profiles as $profile) {
            $salon = Salon::query()->find($profile->salon_id);
            if ($salon !== null) {
                Tenancy::runAs($salon, fn () => ($this->anonymise)($profile));
            }
        }
    }
}
