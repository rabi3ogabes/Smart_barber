<?php

namespace App\Core\Identity\Services;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Identity\Models\PersonalAccessToken;
use App\Core\Identity\Models\RefreshToken;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Short-lived Sanctum access tokens + rotating single-use refresh tokens (ADR-002).
 * Reusing a refresh token revokes its whole family (all devices signed in from that login).
 */
final class TokenService
{
    /**
     * @param  Model  $tokenable  A model using HasApiTokens
     * @param  list<string>  $abilities
     */
    public function issue(Model $tokenable, ?int $salonId, string $deviceName, array $abilities, ?string $family = null): IssuedTokens
    {
        $family ??= (string) Str::ulid();
        $accessTtl = (int) config('smartbarber.tokens.access_ttl_minutes') * 60;
        $refreshTtl = (int) config('smartbarber.tokens.refresh_ttl_days') * 86400;

        $plainAccess = Str::random(48);
        $token = new PersonalAccessToken;
        $token->forceFill([
            'tokenable_type' => $tokenable->getMorphClass(),
            'tokenable_id' => $tokenable->getKey(),
            'name' => Str::limit($deviceName, 100, ''),
            'token' => hash('sha256', $plainAccess),
            'abilities' => $abilities,
            'expires_at' => now()->addSeconds($accessTtl),
            'salon_id' => $salonId,
            'refresh_family' => $family,
        ])->save();

        $plainRefresh = Str::random(64);
        $refresh = new RefreshToken;
        $refresh->forceFill([
            'tokenable_type' => $tokenable->getMorphClass(),
            'tokenable_id' => $tokenable->getKey(),
            'salon_id' => $salonId,
            'family' => $family,
            'token_hash' => hash('sha256', $plainRefresh),
            'device_name' => Str::limit($deviceName, 100, ''),
            'expires_at' => now()->addSeconds($refreshTtl),
        ])->save();

        return new IssuedTokens($token->getKey().'|'.$plainAccess, $accessTtl, $plainRefresh, $refreshTtl);
    }

    /**
     * Rotate a refresh token. $expectedType limits which identity type may use it.
     *
     * @param  class-string<Model>  $expectedType
     * @param  (callable(Model $tokenable, ?int $salonId): void)|null  $guard  Extra checks (e.g. membership still active)
     * @param  list<string>  $abilities
     */
    public function rotate(string $plainRefresh, string $expectedType, array $abilities, ?callable $guard = null): IssuedTokens
    {
        $hash = hash('sha256', $plainRefresh);

        /** @var array{0: RefreshToken, 1: Model}|AppException $result */
        $result = DB::transaction(function () use ($hash, $expectedType) {
            $refresh = RefreshToken::query()->where('token_hash', $hash)->lockForUpdate()->first();

            if ($refresh === null || $refresh->tokenable_type !== (new $expectedType)->getMorphClass()) {
                return new AppException(ErrorCode::RefreshTokenInvalid);
            }

            if ($refresh->used_at !== null || $refresh->revoked_at !== null) {
                // Reuse of a rotated token: assume theft, kill the family.
                $this->revokeFamily($refresh->family);

                return new AppException($refresh->used_at !== null ? ErrorCode::RefreshTokenReused : ErrorCode::RefreshTokenInvalid);
            }

            if ($refresh->expires_at->isPast()) {
                return new AppException(ErrorCode::RefreshTokenInvalid);
            }

            $tokenable = $refresh->tokenable;
            if ($tokenable === null) {
                return new AppException(ErrorCode::RefreshTokenInvalid);
            }

            $refresh->forceFill(['used_at' => now()])->save();
            PersonalAccessToken::query()->where('refresh_family', $refresh->family)->delete();

            return [$refresh, $tokenable];
        });

        if ($result instanceof AppException) {
            throw $result;
        }

        [$refresh, $tokenable] = $result;

        if ($guard !== null) {
            $guard($tokenable, $refresh->salon_id);
        }

        return $this->issue($tokenable, $refresh->salon_id, (string) $refresh->device_name, $abilities, $refresh->family);
    }

    public function revokeFamily(string $family): void
    {
        RefreshToken::query()->where('family', $family)->whereNull('revoked_at')->update(['revoked_at' => now()]);
        PersonalAccessToken::query()->where('refresh_family', $family)->delete();
    }

    public function revokeCurrent(?PersonalAccessToken $token): void
    {
        if ($token === null) {
            return;
        }

        $token->refresh_family ? $this->revokeFamily($token->refresh_family) : $token->delete();
    }
}
