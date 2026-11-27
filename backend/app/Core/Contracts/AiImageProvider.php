<?php

namespace App\Core\Contracts;

/**
 * Hairstyle image generation (Phase 9). Always called from a queued job.
 */
interface AiImageProvider
{
    /**
     * @param  array<string, string>  $params  hairstyle, beard, length, fade, colour
     * @return array{image: string, mime: string, cost_units: int}
     */
    public function generateHairstyle(string $originalImage, array $params): array;
}
