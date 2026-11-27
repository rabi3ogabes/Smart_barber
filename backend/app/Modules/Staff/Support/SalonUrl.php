<?php

namespace App\Modules\Staff\Support;

use App\Core\Tenancy\Models\Salon;

/**
 * Absolute URL on a salon's own sub-domain (used in invitations).
 */
final class SalonUrl
{
    public static function to(Salon $salon, string $path): string
    {
        $base = parse_url((string) config('app.url'));
        $scheme = $base['scheme'] ?? 'https';
        $port = isset($base['port']) ? ':'.$base['port'] : '';

        return "{$scheme}://{$salon->slug}.".config('smartbarber.domain').$port.'/'.ltrim($path, '/');
    }
}
