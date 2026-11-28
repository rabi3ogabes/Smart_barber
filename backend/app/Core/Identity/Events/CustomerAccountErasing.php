<?php

namespace App\Core\Identity\Events;

use App\Core\Identity\Models\CustomerAccount;
use Illuminate\Foundation\Events\Dispatchable;

/**
 * Dispatched (synchronously, inside AnonymiseCustomerAccount) before the account itself is erased,
 * while its salon profiles are still linked to it. Modules erase what they own (spec-review item 12):
 * Customer anonymises each salon profile and announces CustomerAnonymising for the modules above it.
 */
final class CustomerAccountErasing
{
    use Dispatchable;

    public function __construct(public readonly CustomerAccount $account) {}
}
