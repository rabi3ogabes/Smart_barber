<?php

namespace App\Core\Contracts;

interface SmsProvider
{
    /**
     * @return string Provider message id
     */
    public function send(string $phone, string $message): string;
}
