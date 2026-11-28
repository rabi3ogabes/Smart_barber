<?php

namespace App\Core\Identity\Jobs;

use App\Core\Identity\Models\AccountMedia;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Support\Facades\Storage;

/**
 * Square-crops the avatar to 512×512 JPEG (also strips EXIF, which can hold the location). Without
 * GD the original is kept — it is already size-limited at upload.
 */
final class ResizeAvatar implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable;

    public const SIZE = 512;

    public function __construct(public readonly int $mediaId)
    {
        $this->onQueue('media');
    }

    public function handle(): void
    {
        $media = AccountMedia::query()->find($this->mediaId);
        if ($media === null || ! function_exists('imagecreatefromstring')) {
            return;
        }
        $disk = Storage::disk($media->disk);
        $raw = $disk->get($media->path);
        $source = $raw === null ? false : @imagecreatefromstring($raw);
        if ($source === false) {
            return;
        }

        $w = imagesx($source);
        $h = imagesy($source);
        $side = min($w, $h);
        $target = imagecreatetruecolor(self::SIZE, self::SIZE);
        imagecopyresampled($target, $source, 0, 0, intdiv($w - $side, 2), intdiv($h - $side, 2), self::SIZE, self::SIZE, $side, $side);

        ob_start();
        imagejpeg($target, null, 85);
        $jpeg = (string) ob_get_clean();

        $path = preg_replace('/\.[A-Za-z0-9]+$/', '', $media->path).'-512.jpg';
        $disk->put($path, $jpeg, ['visibility' => 'private']);
        if ($path !== $media->path) {
            $disk->delete($media->path);
        }
        $media->forceFill(['path' => $path, 'mime' => 'image/jpeg', 'size_bytes' => strlen($jpeg), 'width' => self::SIZE, 'height' => self::SIZE])->save();
    }
}
