<?php

namespace App\Core\Audit\Http;

use App\Core\Audit\AuditLog;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Tenancy;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

/**
 * Read-only audit trail of the current salon (who changed what, when, from where).
 */
final class AuditLogController
{
    public function __invoke(Request $request): Response
    {
        $filter = $request->validate(['event' => ['nullable', 'string', 'max:60']])['event'] ?? null;

        $logs = AuditLog::query()
            ->where('salon_id', Tenancy::id())
            ->when($filter, fn ($q) => $q->where('event', 'like', $filter.'%'))
            ->latest('id')
            ->cursorPaginate(30)
            ->withQueryString();

        $actors = User::query()->whereIn('id', collect($logs->items())->where('actor_type', 'user')->pluck('actor_id'))->pluck('name', 'id');

        return Inertia::render('AuditLog/Index', [
            'logs' => collect($logs->items())->map(fn (AuditLog $l) => [
                'id' => $l->id,
                'event' => $l->event,
                'actor' => $l->actor_type === 'user' ? ($actors[$l->actor_id] ?? null) : $l->actor_type,
                'subject' => $l->auditable_type,
                'old' => $l->old_values,
                'new' => $l->new_values,
                'ip' => $l->ip,
                'at' => $l->created_at->toIso8601String(),
            ]),
            'next' => $logs->nextPageUrl(),
            'prev' => $logs->previousPageUrl(),
            'filter' => $filter,
        ]);
    }
}
