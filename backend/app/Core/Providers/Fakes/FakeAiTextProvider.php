<?php

namespace App\Core\Providers\Fakes;

use App\Core\Contracts\AiTextProvider;

final class FakeAiTextProvider implements AiTextProvider
{
    public function chat(array $messages, array $tools = []): array
    {
        return ['content' => '', 'tool_calls' => []];
    }
}
