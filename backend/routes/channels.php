<?php

use App\Core\Identity\Models\CustomerAccount;
use Illuminate\Support\Facades\Broadcast;

/*
| Private Reverb channels. Salon channels (salon.{salon}.branch.{branch}) are added with
| the calendar in Phase 4; authorisation reuses the Policies.
*/
Broadcast::channel('customer.{accountId}', function ($user, string $accountId) {
    return $user instanceof CustomerAccount && $user->public_id === $accountId;
});
