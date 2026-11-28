<?php

namespace App\Modules\Customer\Events;

use App\Modules\Customer\Models\Customer;
use Illuminate\Foundation\Events\Dispatchable;

/**
 * One salon profile is about to be anonymised (tenant already set to its salon). Modules that keep
 * personal content about the customer clear it here: Booking cancels upcoming visits and clears
 * notes and review comments. Financial snapshots are never touched.
 */
final class CustomerAnonymising
{
    use Dispatchable;

    public function __construct(public readonly Customer $customer) {}
}
