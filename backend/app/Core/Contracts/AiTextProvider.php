<?php

namespace App\Core\Contracts;

/**
 * Text model for recommendations and the business assistant (Phases 9 and 12).
 * It explains data; it never produces business numbers itself (rule 10).
 */
interface AiTextProvider
{
    /**
     * @param  list<array{role: string, content: string}>  $messages
     * @param  list<array<string, mixed>>  $tools
     * @return array{content: string, tool_calls: list<array<string, mixed>>}
     */
    public function chat(array $messages, array $tools = []): array;
}
