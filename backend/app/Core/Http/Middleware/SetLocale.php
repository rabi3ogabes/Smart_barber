<?php

namespace App\Core\Http\Middleware;

use App\Core\Tenancy\Tenancy;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * API: Accept-Language (ar|en). Web: session → user → salon default → Arabic.
 */
final class SetLocale
{
    public function handle(Request $request, Closure $next): Response
    {
        $supported = config('smartbarber.locales');
        $locale = null;

        if ($request->is('api/*')) {
            $header = strtolower(substr((string) $request->header('Accept-Language'), 0, 2));
            $locale = in_array($header, $supported, true) ? $header : null;
        } else {
            $candidates = [
                $request->hasSession() ? $request->session()->get('locale') : null,
                $request->user()?->getAttributes()['locale'] ?? null,
                Tenancy::current()?->default_locale,
            ];
            foreach ($candidates as $candidate) {
                if (is_string($candidate) && in_array($candidate, $supported, true)) {
                    $locale = $candidate;
                    break;
                }
            }
        }

        app()->setLocale($locale ?? config('smartbarber.default_locale'));

        $response = $next($request);
        $response->headers->set('Content-Language', app()->getLocale());

        return $response;
    }
}
