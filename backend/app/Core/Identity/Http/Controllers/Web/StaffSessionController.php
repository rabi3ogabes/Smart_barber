<?php

namespace App\Core\Identity\Http\Controllers\Web;

use App\Core\Identity\Models\User;
use App\Core\Identity\Services\TwoFactorUser;
use App\Core\Tenancy\Tenancy;
use Illuminate\Contracts\Auth\Authenticatable;
use Illuminate\Database\Eloquent\Model;

/**
 * Dashboard sign-in on {slug}.{domain}: the user needs an active membership in this salon.
 */
final class StaffSessionController extends SessionAuthFlow
{
    protected function guard(): string
    {
        return 'web';
    }

    protected function routePrefix(): string
    {
        return '';
    }

    protected function pagePrefix(): string
    {
        return 'Auth';
    }

    protected function findUser(string $email): (Authenticatable&Model&TwoFactorUser)|null
    {
        return User::query()->where('email', $email)->first();
    }

    protected function findUserById(int $id): (Authenticatable&Model&TwoFactorUser)|null
    {
        return User::query()->find($id);
    }

    protected function refuse(Authenticatable&Model $user): ?string
    {
        $salon = Tenancy::current();
        $membership = $user instanceof User && $salon !== null ? $user->membershipIn((int) $salon->getKey()) : null;

        // Same message as wrong credentials: do not reveal which salons an email belongs to.
        return $membership?->isActive() ? null : __('errors.INVALID_CREDENTIALS');
    }
}
