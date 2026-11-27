<?php

namespace App\Core\Audit;

use App\Core\Tenancy\Tenancy;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

final class AuditLogger
{
    private const GUARDS = ['web', 'staff', 'customer', 'platform'];

    /**
     * @param  array<string, mixed>  $old
     * @param  array<string, mixed>  $new
     */
    public static function record(string $event, ?Model $auditable = null, array $old = [], array $new = [], ?int $salonId = null, ?Model $actor = null): AuditLog
    {
        $actor ??= self::actor();
        $request = request();

        $auditableSalon = $auditable?->getAttributes()['salon_id'] ?? null;

        return AuditLog::query()->create([
            'salon_id' => $salonId ?? ($auditableSalon !== null ? (int) $auditableSalon : Tenancy::id()),
            'actor_type' => $actor?->getMorphClass(),
            'actor_id' => $actor?->getKey(),
            'impersonator_id' => session()->isStarted() ? session('impersonator_id') : null,
            'event' => $event,
            'auditable_type' => $auditable?->getMorphClass(),
            'auditable_id' => $auditable?->getKey(),
            'old_values' => $old === [] ? null : $old,
            'new_values' => $new === [] ? null : $new,
            'ip' => $request->ip(),
            'user_agent' => Str::limit((string) $request->userAgent(), 250, ''),
            'device' => Str::limit((string) $request->header('X-Device-Name'), 100, '') ?: null,
        ]);
    }

    private static function actor(): ?Model
    {
        foreach (self::GUARDS as $guard) {
            if (Auth::guard($guard)->hasUser()) {
                $user = Auth::guard($guard)->user();

                return $user instanceof Model ? $user : null;
            }
        }

        return null;
    }
}
