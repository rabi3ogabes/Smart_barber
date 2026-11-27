<?php

namespace App\Core\Providers\Fakes;

use App\Core\Contracts\OtpProvider;
use Illuminate\Support\Facades\Log;

/**
 * Development driver: writes the code to the log instead of sending it.
 * Tests can read sent codes from $sent.
 */
final class LogOtpProvider implements OtpProvider
{
    /** @var list<array{phone: string, code: string, locale: string}> */
    public array $sent = [];

    public function send(string $phone, string $code, string $locale): void
    {
        $this->sent[] = ['phone' => $phone, 'code' => $code, 'locale' => $locale];

        if (! app()->environment('production')) {
            Log::info('OTP code (log driver)', ['phone' => $phone, 'code' => $code]);
        }
    }

    public function lastCodeFor(string $phone): ?string
    {
        foreach (array_reverse($this->sent) as $entry) {
            if ($entry['phone'] === $phone) {
                return $entry['code'];
            }
        }

        return null;
    }
}
