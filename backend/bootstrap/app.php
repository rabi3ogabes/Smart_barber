<?php

use App\Core\Exceptions\ApiExceptionRenderer;
use App\Core\Exceptions\AppException;
use App\Core\Http\Middleware\EnsureFeature;
use App\Core\Http\Middleware\EnsureSalonMember;
use App\Core\Http\Middleware\EnsureTwoFactorEnrolled;
use App\Core\Http\Middleware\HandleInertiaRequests;
use App\Core\Http\Middleware\Idempotency;
use App\Core\Http\Middleware\ResolveSalonFromSubdomain;
use App\Core\Http\Middleware\ResolveSalonFromToken;
use App\Core\Http\Middleware\SetLocale;
use App\Core\Http\WebAppExceptionRenderer;
use App\Core\Http\WebExceptionRenderer;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
use Illuminate\Routing\Middleware\SubstituteBindings;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        apiPrefix: 'api/v1',
        commands: __DIR__.'/../routes/console.php',
        channels: __DIR__.'/../routes/channels.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->alias([
            'tenant.subdomain' => ResolveSalonFromSubdomain::class,
            'tenant.member' => EnsureSalonMember::class,
            'tenant.token' => ResolveSalonFromToken::class,
            'feature' => EnsureFeature::class,
            'idempotent' => Idempotency::class,
            'two-factor.enrolled' => EnsureTwoFactorEnrolled::class,
        ]);

        $middleware->web(append: [SetLocale::class, HandleInertiaRequests::class]);
        $middleware->api(prepend: [SetLocale::class]);

        // The tenant must be resolved before route model binding runs.
        $middleware->prependToPriorityList(
            before: SubstituteBindings::class,
            prepend: ResolveSalonFromSubdomain::class,
        );
        $middleware->prependToPriorityList(
            before: SubstituteBindings::class,
            prepend: ResolveSalonFromToken::class,
        );

        // Built from the host: auth runs before the tenant middleware has set URL defaults.
        $middleware->redirectGuestsTo(fn (Request $request) => $request->is('api/*') ? null : $request->getSchemeAndHttpHost().'/login');
        $middleware->redirectUsersTo(fn () => '/');
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->shouldRenderJsonWhen(fn (Request $request) => $request->is('api/*') || $request->expectsJson());
        $exceptions->render(new ApiExceptionRenderer);
        $exceptions->render(new WebAppExceptionRenderer);
        $exceptions->dontReport([AppException::class]);
        $exceptions->respond(new WebExceptionRenderer);
    })->create();
