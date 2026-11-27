<?php

namespace App\Core\Identity\Http\Controllers\Api;

use App\Core\Audit\AuditLogger;
use App\Core\Http\ApiResponse;
use App\Core\Identity\Http\Resources\CustomerAccountResource;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Identity\Models\OtpCode;
use App\Core\Identity\Models\PersonalAccessToken;
use App\Core\Identity\Services\OtpService;
use App\Core\Identity\Services\TokenService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * @group Customer auth
 */
final class CustomerAuthController
{
    public const PHONE_RULE = 'regex:/^\+[1-9]\d{7,14}$/';

    public function __construct(
        private readonly OtpService $otp,
        private readonly TokenService $tokens,
    ) {}

    /**
     * Request a sign-in code
     *
     * Sends a 6-digit code to the phone. Limited to 3 sends per 15 minutes per phone.
     *
     * @unauthenticated
     *
     * @bodyParam phone string required E.164 phone number. Example: +97455123456
     */
    public function requestOtp(Request $request): JsonResponse
    {
        $data = $request->validate(['phone' => ['required', 'string', self::PHONE_RULE]]);

        $result = $this->otp->send($data['phone'], OtpCode::PURPOSE_CUSTOMER_LOGIN, app()->getLocale(), $request->ip());

        return ApiResponse::success($result, __('messages.otp_sent'));
    }

    /**
     * Verify the code and sign in
     *
     * Creates the customer account on first sign-in and returns access + refresh tokens.
     *
     * @unauthenticated
     *
     * @bodyParam phone string required Example: +97455123456
     * @bodyParam code string required Example: 123456
     * @bodyParam device_name string Device label shown in sessions. Example: iPhone 15
     */
    public function verifyOtp(Request $request): JsonResponse
    {
        $data = $request->validate([
            'phone' => ['required', 'string', self::PHONE_RULE],
            'code' => ['required', 'string', 'digits:'.config('smartbarber.otp.length')],
            'device_name' => ['nullable', 'string', 'max:100'],
        ]);

        $this->otp->verify($data['phone'], OtpCode::PURPOSE_CUSTOMER_LOGIN, $data['code']);

        $account = CustomerAccount::query()->firstOrCreate(
            ['phone' => $data['phone']],
            ['locale' => app()->getLocale()],
        );
        $account->forceFill(['phone_verified_at' => $account->phone_verified_at ?? now()])->save();

        $tokens = $this->tokens->issue($account, null, $data['device_name'] ?? 'customer-app', ['customer']);
        AuditLogger::record('auth.customer_login', $account, actor: $account);

        return ApiResponse::success([
            'tokens' => $tokens->toArray(),
            'account' => (new CustomerAccountResource($account))->resolve($request),
            'is_new' => $account->wasRecentlyCreated,
        ], __('messages.signed_in'));
    }

    /**
     * Refresh tokens
     *
     * Rotates the refresh token. Reusing an old refresh token signs out that login everywhere.
     *
     * @unauthenticated
     */
    public function refresh(Request $request): JsonResponse
    {
        $data = $request->validate(['refresh_token' => ['required', 'string', 'max:200']]);

        $tokens = $this->tokens->rotate($data['refresh_token'], CustomerAccount::class, ['customer']);

        return ApiResponse::success(['tokens' => $tokens->toArray()]);
    }

    /**
     * Sign out
     */
    public function logout(Request $request): JsonResponse
    {
        /** @var CustomerAccount $account */
        $account = $request->user('customer');
        $token = $account->currentAccessToken();
        $this->tokens->revokeCurrent($token instanceof PersonalAccessToken ? $token : null);

        return ApiResponse::success(null, __('messages.signed_out'));
    }
}
