<?php

namespace App\Modules\Customer\Policies;

use App\Core\Authorization\Access;
use App\Core\Identity\Models\User;

/**
 * Minimal Phase 4 rules: search and quick create from the booking drawer. Full customer
 * profiles (branch-scoped visibility, notes, merge, export) arrive with the CRM phase.
 */
final class CustomerPolicy
{
    public function viewAny(User $user): bool
    {
        return Access::scope($user, 'customer.view') !== null;
    }

    public function create(User $user): bool
    {
        return Access::scope($user, 'customer.create') !== null;
    }

    public function viewContact(User $user): bool
    {
        return Access::scope($user, 'customer.contact.view') !== null;
    }
}
