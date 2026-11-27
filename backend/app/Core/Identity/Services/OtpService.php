<?php

namespace App\Core\Identity\Services;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Identity\Jobs\SendOtpJob;
use App\Core\Identity\Models\OtpCode;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\RateLimiter;

/**
 * Phone one-time codes (ADR-002): 6 digits, hashed, short expiry, limited attempts and sends.
 */
final class OtpService
{
    /**
     * @return array{expires_in: int, retry_after: int}
     */
    public function send(string $phone, string $purpose, string $locale, ?string $ip): array
    {
        $config = config('smartbarber.otp');
        $window = (int) $config['send_window_minutes'] * 60;

        foreach (["otp:phone:{$phone}" => (int) $config['max_sends'], 'otp:ip:'.($ip ?? 'none') => 10] as $key => $max) {
            if (RateLimiter::tooManyAttempts($key, $max)) {
                throw AppException::of(ErrorCode::RateLimited, ['retry_after' => RateLimiter::availableIn($key)]);
            }
        }

        $resendKey = "otp:resend:{$phone}";
        if (RateLimiter::tooManyAttempts($resendKey, 1)) {
            throw AppException::of(ErrorCode::RateLimited, ['retry_after' => RateLimiter::availableIn($resendKey)]);
        }

        RateLimiter::hit("otp:phone:{$phone}", $window);
        RateLimiter::hit('otp:ip:'.($ip ?? 'none'), $window);
        RateLimiter::hit($resendKey, (int) $config['resend_after_seconds']);

        $code = str_pad((string) random_int(0, 10 ** (int) $config['length'] - 1), (int) $config['length'], '0', STR_PAD_LEFT);

        DB::transaction(function () use ($phone, $purpose, $code, $config, $ip): void {
            // Only the newest code is valid.
            OtpCode::query()->where('phone', $phone)->where('purpose', $purpose)->whereNull('consumed_at')
                ->update(['consumed_at' => now()]);

            OtpCode::query()->create([
                'phone' => $phone,
                'purpose' => $purpose,
                'code_hash' => $this->hash($code),
                'expires_at' => now()->addMinutes((int) $config['ttl_minutes']),
                'ip' => $ip,
            ]);
        });

        SendOtpJob::dispatch($phone, $code, $locale);

        return ['expires_in' => (int) $config['ttl_minutes'] * 60, 'retry_after' => (int) $config['resend_after_seconds']];
    }

    public function verify(string $phone, string $purpose, string $code): void
    {
        // The transaction returns the failure instead of throwing, so a failed attempt is committed.
        $failure = DB::transaction(function () use ($phone, $purpose, $code): ?ErrorCode {
            $otp = OtpCode::query()
                ->where('phone', $phone)
                ->where('purpose', $purpose)
                ->whereNull('consumed_at')
                ->latest('id')
                ->lockForUpdate()
                ->first();

            if ($otp === null || $otp->expires_at->isPast()) {
                return ErrorCode::OtpExpired;
            }

            $max = (int) config('smartbarber.otp.max_attempts');
            if ($otp->attempts >= $max) {
                return ErrorCode::OtpTooManyAttempts;
            }

            if (! hash_equals($otp->code_hash, $this->hash($code))) {
                $attempts = $otp->attempts + 1;
                $otp->forceFill(['attempts' => $attempts, 'consumed_at' => $attempts >= $max ? now() : null])->save();

                return $attempts >= $max ? ErrorCode::OtpTooManyAttempts : ErrorCode::OtpInvalid;
            }

            $otp->forceFill(['consumed_at' => now()])->save();

            return null;
        });

        if ($failure !== null) {
            throw new AppException($failure);
        }
    }

    private function hash(string $code): string
    {
        return hash_hmac('sha256', $code, (string) config('app.key'));
    }
}
