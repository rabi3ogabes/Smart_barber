<?php

namespace App\Modules\Salon\Support;

/**
 * Reads the salon key out of whatever a QR code or deep link carries:
 *   https://{slug}.{APP_DOMAIN}/…   https://{host}/s/{slug}   smartbarber://salon/{slug}
 *   a bare slug or salon public id.
 * Returns null when nothing usable is found. The key is only a lookup; the salon must still exist
 * and be active.
 */
final class SalonCode
{
    public static function key(string $code): ?string
    {
        $code = trim($code);
        if ($code === '' || strlen($code) > 300) {
            return null;
        }

        if (str_contains($code, '://')) {
            $parts = parse_url($code);
            if ($parts === false) {
                return null;
            }
            $scheme = strtolower($parts['scheme'] ?? '');
            $host = strtolower($parts['host'] ?? '');
            $segments = array_values(array_filter(explode('/', $parts['path'] ?? ''), fn ($s) => $s !== ''));

            if ($scheme === 'smartbarber') {
                $candidate = $host === 'salon' ? ($segments[0] ?? null) : null;
            } elseif (in_array($segments[0] ?? null, ['s', 'salon'], true)) {
                $candidate = $segments[1] ?? null;
            } else {
                $domain = strtolower((string) config('smartbarber.domain'));
                $candidate = $domain !== '' && str_ends_with($host, '.'.$domain) ? substr($host, 0, -strlen($domain) - 1) : null;
            }

            return self::clean($candidate);
        }

        return self::clean($code);
    }

    private static function clean(?string $candidate): ?string
    {
        if ($candidate === null) {
            return null;
        }
        $candidate = strtolower(rawurldecode($candidate));

        return preg_match('/^[a-z0-9][a-z0-9-]{1,62}$/', $candidate) === 1 ? $candidate : null;
    }
}
