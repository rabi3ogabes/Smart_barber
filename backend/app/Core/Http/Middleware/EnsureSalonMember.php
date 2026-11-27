<?php

namespace App\Core\Http\Middleware;

use App\Core\Identity\Models\User;
use App\Core\Tenancy\Tenancy;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

/**
 * Web: the signed-in user must hold an active membership in the subdomain's salon.
 */
final class EnsureSalonMember
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();
        $salon = Tenancy::current();

        if (! $user instanceof User || $salon === null) {
            return redirect()->route('login');
        }

        $membership = $user->membershipIn((int) $salon->getKey());

        if ($membership === null || ! $membership->isActive()) {
            Auth::guard('web')->logout();
            $request->session()->invalidate();

            return redirect()->route('login')->withErrors(['email' => __('errors.MEMBERSHIP_INACTIVE')]);
        }

        Tenancy::set($salon, $membership);

        return $next($request);
    }
}
