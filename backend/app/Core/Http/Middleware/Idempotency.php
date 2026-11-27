<?php

namespace App\Core\Http\Middleware;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Tenancy\Tenancy;
use Closure;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\Response;

/**
 * Route middleware `idempotent` (key required) or `idempotent:optional` (rule 6, ADR-004).
 *
 * The key is reserved as `processing` before the action runs; a concurrent duplicate gets 409,
 * a completed duplicate replays the stored response, the same key with a different body gets 422.
 * Server errors (5xx) release the key so the client can retry.
 */
final class Idempotency
{
    public const HEADER = 'Idempotency-Key';

    public function handle(Request $request, Closure $next, string $mode = 'required'): Response
    {
        $key = $request->header(self::HEADER);

        if ($key === null || $key === '') {
            if ($mode === 'optional') {
                return $next($request);
            }
            throw new AppException(ErrorCode::IdempotencyKeyRequired);
        }

        if (strlen($key) > (int) config('smartbarber.idempotency.max_key_length') || ! preg_match('/^[A-Za-z0-9\-_:.]+$/', $key)) {
            throw new AppException(ErrorCode::IdempotencyKeyInvalid);
        }

        $actor = $request->user();
        if (! $actor instanceof Model) {
            throw new AppException(ErrorCode::Unauthenticated);
        }

        $scope = ['actor_type' => $actor->getMorphClass(), 'actor_id' => $actor->getKey(), 'key' => $key];
        $hash = $this->fingerprint($request);

        $existing = DB::table('idempotency_keys')->where($scope)->where('expires_at', '>', now())->first();
        if ($existing !== null) {
            return $this->replay($existing, $hash);
        }

        DB::table('idempotency_keys')->where($scope)->where('expires_at', '<=', now())->delete();

        try {
            DB::table('idempotency_keys')->insert($scope + [
                'salon_id' => Tenancy::id(),
                'method' => $request->method(),
                'route' => substr($request->path(), 0, 190),
                'request_hash' => $hash,
                'status' => 'processing',
                'expires_at' => now()->addHours((int) config('smartbarber.idempotency.ttl_hours')),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        } catch (UniqueConstraintViolationException) {
            throw new AppException(ErrorCode::IdempotencyInProgress);
        }

        try {
            $response = $next($request);
        } catch (\Throwable $e) {
            DB::table('idempotency_keys')->where($scope)->delete();
            throw $e;
        }

        if ($response->getStatusCode() >= 500) {
            DB::table('idempotency_keys')->where($scope)->delete();

            return $response;
        }

        DB::table('idempotency_keys')->where($scope)->update([
            'status' => 'completed',
            'response_status' => $response->getStatusCode(),
            'response_body' => (string) $response->getContent(),
            'updated_at' => now(),
        ]);

        return $response;
    }

    private function replay(object $existing, string $hash): Response
    {
        if (! hash_equals((string) $existing->request_hash, $hash)) {
            throw new AppException(ErrorCode::IdempotencyKeyReused);
        }

        if ($existing->status !== 'completed') {
            throw new AppException(ErrorCode::IdempotencyInProgress);
        }

        $response = new JsonResponse(json_decode((string) $existing->response_body, true), (int) $existing->response_status);
        $response->headers->set('Idempotent-Replayed', 'true');

        return $response;
    }

    private function fingerprint(Request $request): string
    {
        $body = $request->all();
        $this->sortRecursive($body);

        return hash('sha256', $request->method().'|'.$request->path().'|'.json_encode($body));
    }

    /**
     * @param  array<mixed>  $data
     */
    private function sortRecursive(array &$data): void
    {
        ksort($data);
        foreach ($data as &$value) {
            if (is_array($value)) {
                $this->sortRecursive($value);
            }
        }
    }
}
