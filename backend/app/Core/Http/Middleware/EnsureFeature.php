<?php

namespace App\Core\Http\Middleware;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Features\Feature;
use App\Core\Tenancy\Tenancy;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Route middleware `feature:{key}` — 403 FEATURE_NOT_AVAILABLE when the salon lacks the module.
 */
final class EnsureFeature
{
    public function handle(Request $request, Closure $next, string $feature): Response
    {
        $salon = Tenancy::current();

        if ($salon === null || ! Feature::enabled($salon, $feature)) {
            throw new AppException(ErrorCode::FeatureNotAvailable);
        }

        return $next($request);
    }
}
