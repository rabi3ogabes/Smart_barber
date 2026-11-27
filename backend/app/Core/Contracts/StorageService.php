<?php

namespace App\Core\Contracts;

use App\Core\Media\Media;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\UploadedFile;

/**
 * Stores files as `media` rows on a private disk and hands out temporary signed URLs.
 */
interface StorageService
{
    public function store(UploadedFile $file, string $collection, ?Model $owner = null, bool $containsPii = false): Media;

    public function temporaryUrl(Media $media, int $minutes = 10): string;

    public function delete(Media $media): void;
}
