<?php

namespace App\Core\Providers\Fakes;

use App\Core\Contracts\PushProvider;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;

final class LogPushProvider implements PushProvider
{
    /** @var list<array{token: string, title: string, body: string, data: array<string, string>}> */
    public array $sent = [];

    public function send(string $fcmToken, string $title, string $body, array $data = []): string
    {
        $this->sent[] = ['token' => $fcmToken, 'title' => $title, 'body' => $body, 'data' => $data];
        Log::info('Push (log driver)', ['title' => $title]);

        return 'log-'.Str::ulid();
    }
}
