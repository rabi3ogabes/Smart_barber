<?php

namespace App\Core\Providers\Fakes;

use App\Core\Contracts\AiImageProvider;

/**
 * Returns the original image unchanged so flows can be exercised without a provider.
 */
final class FakeAiImageProvider implements AiImageProvider
{
    public function generateHairstyle(string $originalImage, array $params): array
    {
        return ['image' => $originalImage, 'mime' => 'image/jpeg', 'cost_units' => 0];
    }
}
