<?php

namespace App\Core\Contracts;

use Illuminate\Database\Eloquent\Model;

/**
 * Thin contract lower modules use to notify people (modules.md). Phase 1 binds a log
 * stub; Phase 11 binds the real NotificationService. Implementations must queue.
 */
interface NotificationChannel
{
    /**
     * @param  array<string, mixed>  $variables
     */
    public function notify(Model $notifiable, string $eventKey, array $variables = []): void;
}
