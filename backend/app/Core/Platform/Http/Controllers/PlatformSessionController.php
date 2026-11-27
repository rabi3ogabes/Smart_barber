<?php

namespace App\Core\Platform\Http\Controllers;

use App\Core\Identity\Http\Controllers\Web\SessionAuthFlow;
use App\Core\Identity\Models\PlatformAdmin;
use App\Core\Identity\Services\TwoFactorUser;
use Illuminate\Contracts\Auth\Authenticatable;
use Illuminate\Database\Eloquent\Model;

/**
 * Super Admin console sign-in on admin.{domain}. 2FA is always mandatory.
 */
final class PlatformSessionController extends SessionAuthFlow
{
    protected function guard(): string
    {
        return 'platform';
    }

    protected function routePrefix(): string
    {
        return 'platform.';
    }

    protected function pagePrefix(): string
    {
        return 'Platform/Auth';
    }

    protected function findUser(string $email): (Authenticatable&Model&TwoFactorUser)|null
    {
        return PlatformAdmin::query()->where('email', $email)->first();
    }

    protected function findUserById(int $id): (Authenticatable&Model&TwoFactorUser)|null
    {
        return PlatformAdmin::query()->find($id);
    }
}
