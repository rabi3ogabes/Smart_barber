<?php

namespace App\Core\Identity\Http\Controllers\Api;

use App\Core\Audit\AuditLogger;
use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Http\ApiResponse;
use App\Core\Identity\Models\PersonalAccessToken;
use App\Core\Identity\Models\User;
use App\Core\Identity\Services\ChallengeStore;
use App\Core\Identity\Services\TokenService;
use App\Core\Identity\Services\TwoFactor;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Models\SalonMembership;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\RateLimiter;

/**
 * Staff app sign-in: password → optional 2FA → salon selection → salon-bound tokens (ADR-002).
 *
 * @group Staff auth
 */
final class StaffAuthController
{
    public function __construct(
        private readonly TokenService $tokens,
        private readonly ChallengeStore $challenges,
        private readonly TwoFactor $twoFactor,
    ) {}

    /**
     * Sign in with email and password
     *
     * Returns tokens, or a `challenge_token` (2FA) or a `selection_token` (several salons).
     *
     * @unauthenticated
     */
    public function login(Request $request): JsonResponse
    {
        $data = $request->validate([
            'email' => ['required', 'email', 'max:190'],
            'password' => ['required', 'string', 'max:200'],
            'device_name' => ['nullable', 'string', 'max:100'],
        ]);

        $throttleKey = 'staff-login:'.strtolower($data['email']).'|'.$request->ip();
        if (RateLimiter::tooManyAttempts($throttleKey, 5)) {
            throw AppException::of(ErrorCode::RateLimited, ['retry_after' => RateLimiter::availableIn($throttleKey)]);
        }

        $user = User::query()->where('email', strtolower($data['email']))->first();
        if ($user === null || ! Hash::check($data['password'], $user->getAuthPassword())) {
            RateLimiter::hit($throttleKey, 60);
            throw new AppException(ErrorCode::InvalidCredentials);
        }
        RateLimiter::clear($throttleKey);

        $deviceName = $data['device_name'] ?? 'staff-app';

        if ($user->activeMemberships()->isEmpty()) {
            throw new AppException(ErrorCode::NoActiveMembership);
        }

        if ($user->requiresTwoFactor() && ! $user->hasTwoFactorEnabled()) {
            throw new AppException(ErrorCode::TwoFactorEnrollmentRequired);
        }

        if ($user->hasTwoFactorEnabled()) {
            $challenge = $this->challenges->put(ChallengeStore::PURPOSE_TWO_FACTOR, ['user_id' => $user->getKey(), 'device' => $deviceName]);

            return ApiResponse::error(ErrorCode::TwoFactorRequired, data: ['challenge_token' => $challenge]);
        }

        return $this->afterAuthentication($user, $deviceName);
    }

    /**
     * Complete two-factor sign-in
     *
     * @unauthenticated
     */
    public function twoFactor(Request $request): JsonResponse
    {
        $data = $request->validate([
            'challenge_token' => ['required', 'string', 'max:100'],
            'code' => ['required', 'string', 'max:20'],
        ]);

        $payload = $this->challenges->get(ChallengeStore::PURPOSE_TWO_FACTOR, $data['challenge_token']);
        $user = User::query()->findOrFail($payload['user_id']);

        if (! $this->twoFactor->verify($user, $data['code'])) {
            $this->challenges->fail(ChallengeStore::PURPOSE_TWO_FACTOR, $data['challenge_token']);
            throw new AppException(ErrorCode::TwoFactorInvalid);
        }

        $this->challenges->forget(ChallengeStore::PURPOSE_TWO_FACTOR, $data['challenge_token']);

        return $this->afterAuthentication($user, (string) $payload['device']);
    }

    /**
     * Choose a salon
     *
     * Exchanges a `selection_token` for tokens bound to the chosen salon.
     *
     * @unauthenticated
     *
     * @bodyParam salon string required Salon public id from the memberships list.
     */
    public function selectSalon(Request $request): JsonResponse
    {
        $data = $request->validate([
            'selection_token' => ['required', 'string', 'max:100'],
            'salon' => ['required', 'string', 'max:26'],
        ]);

        $payload = $this->challenges->get(ChallengeStore::PURPOSE_SALON_SELECTION, $data['selection_token']);
        $user = User::query()->findOrFail($payload['user_id']);

        $membership = $user->activeMemberships()->first(fn (SalonMembership $m) => $m->salon?->public_id === $data['salon']);
        if ($membership === null) {
            throw new AppException(ErrorCode::NoActiveMembership);
        }

        $this->challenges->forget(ChallengeStore::PURPOSE_SALON_SELECTION, $data['selection_token']);

        return $this->issueFor($user, $membership, (string) $payload['device']);
    }

    /**
     * Refresh tokens
     *
     * @unauthenticated
     */
    public function refresh(Request $request): JsonResponse
    {
        $data = $request->validate(['refresh_token' => ['required', 'string', 'max:200']]);

        $tokens = $this->tokens->rotate($data['refresh_token'], User::class, ['staff'], function ($user, ?int $salonId): void {
            if (! $user instanceof User) {
                throw new AppException(ErrorCode::RefreshTokenInvalid);
            }
            $membership = $salonId === null ? null : $user->membershipIn($salonId);
            $salon = $salonId === null ? null : Salon::query()->find($salonId);
            if ($membership === null || ! $membership->isActive() || $salon === null || ! $salon->isActive()) {
                throw new AppException(ErrorCode::MembershipInactive);
            }
        });

        return ApiResponse::success(['tokens' => $tokens->toArray()]);
    }

    /**
     * Sign out
     */
    public function logout(Request $request): JsonResponse
    {
        /** @var User $user */
        $user = $request->user('staff');
        $token = $user->currentAccessToken();
        $this->tokens->revokeCurrent($token instanceof PersonalAccessToken ? $token : null);

        return ApiResponse::success(null, __('messages.signed_out'));
    }

    private function afterAuthentication(User $user, string $deviceName): JsonResponse
    {
        $memberships = $user->activeMemberships();

        if ($memberships->count() === 1) {
            return $this->issueFor($user, $memberships->first(), $deviceName);
        }

        $selection = $this->challenges->put(ChallengeStore::PURPOSE_SALON_SELECTION, ['user_id' => $user->getKey(), 'device' => $deviceName]);

        return ApiResponse::error(ErrorCode::SalonSelectionRequired, data: [
            'selection_token' => $selection,
            'memberships' => $memberships->map(fn (SalonMembership $m) => [
                'salon' => $m->salon?->public_id,
                'name' => $m->salon?->getTranslations('name'),
                'slug' => $m->salon?->slug,
            ])->values()->all(),
        ]);
    }

    private function issueFor(User $user, SalonMembership $membership, string $deviceName): JsonResponse
    {
        $tokens = $this->tokens->issue($user, (int) $membership->salon_id, $deviceName, ['staff']);
        $user->forceFill(['last_login_at' => now()])->save();
        AuditLogger::record('auth.staff_login', $user, salonId: (int) $membership->salon_id, actor: $user);

        return ApiResponse::success([
            'tokens' => $tokens->toArray(),
            'salon' => $membership->salon?->public_id,
        ], __('messages.signed_in'));
    }
}
