<?php

namespace App\Core\Http\Middleware;

use App\Core\Identity\Services\TwoFactorUser;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Web/platform: identities that must use 2FA can reach only the setup page until enrolled.
 */
final class EnsureTwoFactorEnrolled
{
    public function handle(Request $request, Closure $next, string $setupRoute = 'two-factor.setup'): Response
    {
        $user = $request->user();

        if ($user instanceof TwoFactorUser && $user->requiresTwoFactor() && ! $user->hasTwoFactorEnabled()) {
            return redirect()->route($setupRoute);
        }

        return $next($request);
    }
}
