<?php

namespace App\Modules\Salon\Support;

use App\Core\Contracts\StorageService;
use App\Core\Media\Media;

/**
 * Temporary signed URL for a media id (private files, never public paths).
 */
final class MediaUrl
{
    public static function for(?int $mediaId, int $minutes = 60): ?string
    {
        if ($mediaId === null) {
            return null;
        }
        $media = Media::query()->find($mediaId);

        return $media === null ? null : app(StorageService::class)->temporaryUrl($media, $minutes);
    }
}
