<?php

namespace App\Core\Http\Middleware;

use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\URL;
use Symfony\Component\HttpFoundation\Response;

/**
 * Dashboard tenant resolution: {slug}.{domain} → salon (ADR-001). Unknown or closed → 404.
 */
final class ResolveSalonFromSubdomain
{
    public function handle(Request $request, Closure $next): Response
    {
        $route = $request->route();
        $slug = $route?->parameter('salon_slug');
        $route?->forgetParameter('salon_slug');

        $salon = is_string($slug)
            ? Salon::query()->where('slug', strtolower($slug))->where('status', '!=', Salon::STATUS_CLOSED)->first()
            : null;

        abort_if($salon === null, 404);

        Tenancy::set($salon);
        URL::defaults(['salon_slug' => $salon->slug]);

        try {
            return $next($request);
        } finally {
            Tenancy::clear();
        }
    }
}
