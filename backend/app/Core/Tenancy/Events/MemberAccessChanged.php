<?php

namespace App\Core\Tenancy\Events;

use App\Core\Tenancy\Models\SalonMembership;
use Illuminate\Foundation\Events\Dispatchable;

/**
 * A membership was created, reactivated or had its roles changed. Modules react
 * (e.g. Staff creates the barber profile) without Core depending on them.
 */
final class MemberAccessChanged
{
    use Dispatchable;

    /**
     * @param  list<string>  $roles
     */
    public function __construct(public readonly SalonMembership $membership, public readonly array $roles) {}
}
