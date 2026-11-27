<?php

namespace App\Core\Exceptions;

use App\Core\Http\ApiResponse;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Exceptions\ThrottleRequestsException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Spatie\Permission\Exceptions\UnauthorizedException as SpatieUnauthorized;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;
use Symfony\Component\HttpKernel\Exception\MethodNotAllowedHttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Throwable;

/**
 * Maps every exception on /api/* to the envelope with a machine-readable code.
 * Raw exception messages and SQL never reach the client (rule 11).
 */
final class ApiExceptionRenderer
{
    public function __invoke(Throwable $e, Request $request): ?JsonResponse
    {
        if (! $request->is('api/*')) {
            return null;
        }

        return match (true) {
            $e instanceof AppException => ApiResponse::error($e->errorCode, $e->getMessage(), $e->errors, $e->data),
            $e instanceof ValidationException => ApiResponse::error(ErrorCode::ValidationFailed, errors: $e->errors()),
            $e instanceof AuthenticationException => ApiResponse::error(ErrorCode::Unauthenticated),
            $e instanceof AuthorizationException, $e instanceof AccessDeniedHttpException,
            $e instanceof SpatieUnauthorized => ApiResponse::error(ErrorCode::Forbidden),
            $e instanceof ModelNotFoundException, $e instanceof NotFoundHttpException => ApiResponse::error(ErrorCode::NotFound),
            $e instanceof MethodNotAllowedHttpException => ApiResponse::error(ErrorCode::MethodNotAllowed),
            $e instanceof ThrottleRequestsException => ApiResponse::error(
                ErrorCode::RateLimited,
                data: ['retry_after' => (int) ($e->getHeaders()['Retry-After'] ?? 60)],
            ),
            $e instanceof HttpExceptionInterface && $e->getStatusCode() === 503 => ApiResponse::error(ErrorCode::ServiceUnavailable),
            default => ApiResponse::error(ErrorCode::ServerError),
        };
    }
}
