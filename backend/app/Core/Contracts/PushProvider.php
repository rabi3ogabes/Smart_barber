<?php

namespace App\Core\Contracts;

interface PushProvider
{
    /**
     * @param  array<string, string>  $data  Deep-link payload
     * @return string Provider message id
     */
    public function send(string $fcmToken, string $title, string $body, array $data = []): string;
}
