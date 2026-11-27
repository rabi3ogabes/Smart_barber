<?php

namespace App\Core\Identity\Services;

use BaconQrCode\Renderer\Image\SvgImageBackEnd;
use BaconQrCode\Renderer\ImageRenderer;
use BaconQrCode\Renderer\RendererStyle\RendererStyle;
use BaconQrCode\Writer;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Str;
use PragmaRX\Google2FA\Google2FA;

/**
 * TOTP (RFC 6238) enrolment and verification with replay protection and recovery codes.
 */
final class TwoFactor
{
    public function __construct(private readonly Google2FA $google2fa) {}

    public function generateSecret(): string
    {
        return $this->google2fa->generateSecretKey(32);
    }

    public function qrSvg(string $label, string $secret): string
    {
        $uri = $this->google2fa->getQRCodeUrl(config('app.name'), $label, $secret);
        $writer = new Writer(new ImageRenderer(new RendererStyle(192, 1), new SvgImageBackEnd));

        return $writer->writeString($uri);
    }

    /**
     * Start enrolment: store an unconfirmed secret on the identity.
     */
    public function begin(TwoFactorUser&Model $user): string
    {
        $secret = $this->generateSecret();
        $user->forceFill([
            'two_factor_secret' => $secret,
            'two_factor_confirmed_at' => null,
        ])->save();

        return $secret;
    }

    /**
     * Confirm enrolment with a first valid code. Returns the plain recovery codes (shown once).
     *
     * @return list<string>|null
     */
    public function confirm(TwoFactorUser&Model $user, string $code): ?array
    {
        $secret = $user->getAttribute('two_factor_secret');
        if (! is_string($secret) || ! $this->verifyTotp($user, $secret, $code)) {
            return null;
        }

        $codes = $this->newRecoveryCodes();
        $user->forceFill([
            'two_factor_confirmed_at' => now(),
            'two_factor_recovery_codes' => json_encode($codes),
        ])->save();

        return $codes;
    }

    /**
     * Verify a TOTP code or a single-use recovery code for an enrolled identity.
     */
    public function verify(TwoFactorUser&Model $user, string $code): bool
    {
        if (! $user->hasTwoFactorEnabled()) {
            return false;
        }

        $code = trim($code);

        if (preg_match('/^\d{6}$/', $code)) {
            $secret = $user->getAttribute('two_factor_secret');

            return is_string($secret) && $this->verifyTotp($user, $secret, $code);
        }

        return $this->consumeRecoveryCode($user, $code);
    }

    public function disable(TwoFactorUser&Model $user): void
    {
        $user->forceFill([
            'two_factor_secret' => null,
            'two_factor_recovery_codes' => null,
            'two_factor_confirmed_at' => null,
        ])->save();
    }

    private function verifyTotp(Model $user, string $secret, string $code): bool
    {
        $cacheKey = 'totp:last:'.$user->getMorphClass().':'.$user->getKey();
        $last = Cache::get($cacheKey);

        // verifyKeyNewer returns the matched timestamp and rejects codes at or before $last (replay).
        $timestamp = $this->google2fa->verifyKeyNewer($secret, $code, is_int($last) ? $last : null, 1);

        if ($timestamp === false) {
            return false;
        }

        Cache::put($cacheKey, $timestamp === true ? $this->google2fa->getTimestamp() : $timestamp, now()->addMinutes(5));

        return true;
    }

    private function consumeRecoveryCode(Model $user, string $code): bool
    {
        $codes = json_decode((string) $user->getAttribute('two_factor_recovery_codes'), true);
        if (! is_array($codes)) {
            return false;
        }

        $normalized = strtoupper($code);
        foreach ($codes as $index => $candidate) {
            if (is_string($candidate) && hash_equals($candidate, $normalized)) {
                unset($codes[$index]);
                $user->forceFill(['two_factor_recovery_codes' => json_encode(array_values($codes))])->save();

                return true;
            }
        }

        return false;
    }

    /**
     * @return list<string>
     */
    private function newRecoveryCodes(): array
    {
        return array_map(
            fn () => strtoupper(Str::random(5).'-'.Str::random(5)),
            range(1, 8),
        );
    }
}
