<?php

namespace App\Core\Http\Middleware;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Identity\Models\PersonalAccessToken;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Staff API tenant resolution: the access token is bound to one salon (ADR-001/002).
 */
final class ResolveSalonFromToken
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user('staff');
        $token = $user instanceof User ? $user->currentAccessToken() : null;

        if (! $token instanceof PersonalAccessToken || $token->salon_id === null) {
            throw new AppException(ErrorCode::Unauthenticated);
        }

        $salon = Salon::query()->find($token->salon_id);
        if ($salon === null || $salon->status === Salon::STATUS_CLOSED) {
            throw new AppException(ErrorCode::Unauthenticated);
        }
        if (! $salon->isActive()) {
            throw new AppException(ErrorCode::SalonSuspended);
        }

        $membership = $user->membershipIn((int) $salon->getKey());
        if ($membership === null || ! $membership->isActive()) {
            throw new AppException(ErrorCode::MembershipInactive);
        }

        Tenancy::set($salon, $membership);

        try {
            return $next($request);
        } finally {
            Tenancy::clear();
        }
    }
}
