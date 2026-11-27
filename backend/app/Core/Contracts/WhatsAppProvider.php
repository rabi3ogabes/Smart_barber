<?php

namespace App\Core\Contracts;

/**
 * Official WhatsApp Business Platform (Cloud API or BSP). Implemented in Phase 11.
 */
interface WhatsAppProvider
{
    /**
     * @param  list<string>  $parameters
     * @return string Provider message id
     */
    public function sendTemplate(string $toPhone, string $templateName, string $language, array $parameters = []): string;
}
