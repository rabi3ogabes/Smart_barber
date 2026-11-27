<?php

namespace App\Core\Identity\Jobs;

use App\Core\Contracts\OtpProvider;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeEncrypted;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;

/**
 * Sends a sign-in code outside the HTTP request (rule 9). Encrypted on the queue.
 */
final class SendOtpJob implements ShouldBeEncrypted, ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable;

    public int $tries = 3;

    public int $timeout = 20;

    public function __construct(
        public readonly string $phone,
        public readonly string $code,
        public readonly string $locale,
    ) {
        $this->onQueue('notifications');
    }

    public function handle(OtpProvider $provider): void
    {
        $provider->send($this->phone, $this->code, $this->locale);
    }

    /** @return list<int> */
    public function backoff(): array
    {
        return [5, 15];
    }
}
