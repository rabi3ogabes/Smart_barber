<?php

namespace App\Core\Providers\Fakes;

use App\Core\Contracts\WhatsAppProvider;
use Illuminate\Support\Str;

final class FakeWhatsAppProvider implements WhatsAppProvider
{
    /** @var list<array{to: string, template: string, language: string, parameters: list<string>}> */
    public array $sent = [];

    public function sendTemplate(string $toPhone, string $templateName, string $language, array $parameters = []): string
    {
        $this->sent[] = ['to' => $toPhone, 'template' => $templateName, 'language' => $language, 'parameters' => $parameters];

        return 'wamid.fake.'.Str::ulid();
    }
}
