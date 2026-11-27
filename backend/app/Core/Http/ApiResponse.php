<?php

namespace App\Core\Http;

use App\Core\Exceptions\ErrorCode;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * The one response envelope for /api/v1 (laravel.md, API conventions).
 */
final class ApiResponse
{
    /**
     * @param  array<string, mixed>  $meta
     */
    public static function success(mixed $data = null, ?string $message = null, array $meta = [], int $status = 200): JsonResponse
    {
        // ResourceCollection extends JsonResource, so this covers single resources and collections.
        if ($data instanceof JsonResource) {
            $data = $data->resolve(request());
        }

        return new JsonResponse([
            'success' => true,
            'message' => $message ?? __('messages.ok'),
            'data' => $data ?? (object) [],
            'meta' => (object) $meta,
        ], $status);
    }

    /**
     * @param  array<string, mixed>  $errors
     * @param  array<string, mixed>  $data
     */
    public static function error(ErrorCode $code, ?string $message = null, array $errors = [], array $data = [], ?int $status = null): JsonResponse
    {
        $body = [
            'success' => false,
            'message' => $message ?? $code->message(),
            'code' => $code->value,
            'errors' => (object) $errors,
        ];

        if ($data !== []) {
            $body['data'] = $data;
        }

        return new JsonResponse($body, $status ?? $code->status());
    }
}
