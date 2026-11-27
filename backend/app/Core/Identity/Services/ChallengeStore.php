<?php

namespace App\Core\Identity\Services;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Str;

/**
 * Short-lived, single-use tokens for multi-step staff sign-in (2FA challenge, salon selection).
 */
final class ChallengeStore
{
    public const PURPOSE_TWO_FACTOR = '2fa';

    public const PURPOSE_SALON_SELECTION = 'select';

    /**
     * @param  array<string, mixed>  $payload
     */
    public function put(string $purpose, array $payload): string
    {
        $token = Str::random(64);
        Cache::put($this->key($purpose, $token), $payload + ['attempts' => 0], now()->addMinutes((int) config('smartbarber.tokens.challenge_ttl_minutes')));

        return $token;
    }

    /**
     * @return array<string, mixed>
     */
    public function get(string $purpose, string $token): array
    {
        $payload = Cache::get($this->key($purpose, $token));
        if (! is_array($payload)) {
            throw new AppException(ErrorCode::ChallengeExpired);
        }

        return $payload;
    }

    /**
     * Count a failed attempt; the challenge dies after 5 failures.
     */
    public function fail(string $purpose, string $token): void
    {
        $payload = $this->get($purpose, $token);
        $payload['attempts'] = (int) $payload['attempts'] + 1;

        if ($payload['attempts'] >= 5) {
            $this->forget($purpose, $token);

            return;
        }

        Cache::put($this->key($purpose, $token), $payload, now()->addMinutes((int) config('smartbarber.tokens.challenge_ttl_minutes')));
    }

    public function forget(string $purpose, string $token): void
    {
        Cache::forget($this->key($purpose, $token));
    }

    private function key(string $purpose, string $token): string
    {
        return 'challenge:'.$purpose.':'.hash('sha256', $token);
    }
}
