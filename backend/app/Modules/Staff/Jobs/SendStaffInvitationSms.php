<?php

namespace App\Modules\Staff\Jobs;

use App\Core\Contracts\SmsProvider;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeEncrypted;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;

/**
 * Invitation by SMS (the link carries the secret token, so the payload is encrypted).
 */
final class SendStaffInvitationSms implements ShouldBeEncrypted, ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable;

    public int $tries = 3;

    public function __construct(public readonly string $phone, public readonly string $message)
    {
        $this->onQueue('notifications');
    }

    public function handle(SmsProvider $sms): void
    {
        $sms->send($this->phone, $this->message);
    }
}
