<?php

namespace App\Core\Http;

use Illuminate\Http\Request;
use Inertia\Inertia;
use Symfony\Component\HttpFoundation\Response;

/**
 * Renders friendly, translated Inertia error pages for the dashboard (rule 11).
 * Debug pages stay available locally for 500s.
 */
final class WebExceptionRenderer
{
    public function __invoke(Response $response, \Throwable $e, Request $request): Response
    {
        $status = $response->getStatusCode();

        if ($request->is('api/*') || $request->expectsJson() && ! $request->header('X-Inertia')) {
            return $response;
        }

        if ($status === 419) {
            return back()->with('error', __('ui.errors.page_expired'));
        }

        if (! in_array($status, [403, 404, 429, 500, 503], true) || ($status === 500 && config('app.debug'))) {
            return $response;
        }

        return Inertia::render('Error', ['status' => $status])
            ->toResponse($request)
            ->setStatusCode($status);
    }
}
