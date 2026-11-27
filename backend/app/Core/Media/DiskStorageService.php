<?php

namespace App\Core\Media;

use App\Core\Contracts\StorageService;
use App\Core\Tenancy\Tenancy;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

/**
 * Stores media on the configured private disk (local in dev, S3-compatible in production).
 */
final class DiskStorageService implements StorageService
{
    public function store(UploadedFile $file, string $collection, ?Model $owner = null, bool $containsPii = false): Media
    {
        $disk = (string) config('filesystems.media_disk', 'media');
        $directory = 'salons/'.Tenancy::id().'/'.$collection.'/'.now()->format('Y/m');
        $name = Str::ulid().'.'.($file->guessExtension() ?? 'bin');
        $path = Storage::disk($disk)->putFileAs($directory, $file, $name, ['visibility' => 'private']);

        $dimensions = str_starts_with((string) $file->getMimeType(), 'image/') ? @getimagesize($file->getRealPath()) : false;

        $media = new Media([
            'collection' => $collection,
            'disk' => $disk,
            'path' => (string) $path,
            'mime' => (string) $file->getMimeType(),
            'size_bytes' => (int) $file->getSize(),
            'width' => $dimensions ? $dimensions[0] : null,
            'height' => $dimensions ? $dimensions[1] : null,
            'visibility' => 'private',
            'contains_pii' => $containsPii,
        ]);

        if ($owner !== null) {
            $media->owner()->associate($owner);
        }

        $media->save();

        return $media;
    }

    public function temporaryUrl(Media $media, int $minutes = 10): string
    {
        return Storage::disk($media->disk)->temporaryUrl($media->path, now()->addMinutes($minutes));
    }

    public function delete(Media $media): void
    {
        Storage::disk($media->disk)->delete($media->path);
        $media->delete();
    }
}
