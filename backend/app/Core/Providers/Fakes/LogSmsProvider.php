<?php

namespace App\Core\Providers\Fakes;

use App\Core\Contracts\SmsProvider;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

final class LogSmsProvider implements SmsProvider
{
    /** @var list<array{phone: string, message: string}> */
    public array $sent = [];

    public function send(string $phone, string $message): string
    {
        $this->sent[] = ['phone' => $phone, 'message' => $message];
        Log::info('SMS (log driver)', ['phone' => $phone]);

        return 'log-'.Str::ulid();
    }
}
