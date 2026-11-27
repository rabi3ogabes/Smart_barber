<?php

namespace App\Core\Providers\Fakes;

use App\Core\Contracts\NotificationChannel;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Log;

/**
 * Phase 1–10 stub. Phase 11 replaces the binding with the real NotificationService.
 */
final class LogNotificationChannel implements NotificationChannel
{
    /** @var list<array{notifiable: string, event: string, variables: array<string, mixed>}> */
    public array $sent = [];

    public function notify(Model $notifiable, string $eventKey, array $variables = []): void
    {
        $this->sent[] = ['notifiable' => $notifiable::class.':'.$notifiable->getKey(), 'event' => $eventKey, 'variables' => $variables];
        Log::info('Notification (log stub)', ['event' => $eventKey]);
    }
}
