<?php

namespace App\Modules\Catalog\Policies;

use App\Core\Authorization\Access;
use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use Illuminate\Auth\Access\Response;

/**
 * Catalog permissions (permissions.md → Catalog):
 * - service.view: everyone in the salon;
 * - service.manage: Owner, GM — categories, services, add-ons, bundles, barber assignment;
 * - service.price.update: Owner, GM everywhere; Branch Manager only branch price overrides
 *   of their own branches (footnote 5). Base, add-on, bundle and barber prices need scope "all".
 */
final class CatalogPolicy
{
    public function viewAny(User $user): bool
    {
        return Access::scope($user, 'service.view') !== null;
    }

    public function manage(User $user): bool
    {
        return Access::scope($user, 'service.manage') === P::SCOPE_ALL;
    }

    /** Base, add-on, bundle and barber prices. */
    public function updatePrices(User $user): bool
    {
        return Access::scope($user, 'service.price.update') === P::SCOPE_ALL;
    }

    /** Availability and price override at one branch; out-of-scope branches are "not found". */
    public function updateBranchPricing(User $user, Branch $branch): Response
    {
        if (Access::allowsInBranches($user, 'service.price.update', [$branch->id])) {
            return Response::allow();
        }

        return Access::allowsInBranches($user, 'branch.view', [$branch->id]) ? Response::deny() : Response::denyAsNotFound();
    }
}
