<?php

namespace App\Core\Contracts;

/**
 * Delivers one-time sign-in codes (SMS or WhatsApp authentication template — spec-review Q10).
 */
interface OtpProvider
{
    public function send(string $phone, string $code, string $locale): void;
}
