<?php

namespace App\Core\Identity\Actions;

use App\Core\Identity\Jobs\ResizeAvatar;
use App\Core\Identity\Models\AccountMedia;
use App\Core\Identity\Models\CustomerAccount;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

/**
 * Stores a new avatar privately, points the account at it, removes the previous one and queues the
 * resize (rule 9: image work never runs inside the request).
 */
final class UploadAvatar
{
    public function __invoke(CustomerAccount $account, UploadedFile $file): AccountMedia
    {
        $disk = (string) config('filesystems.media_disk', 'media');
        $name = Str::ulid().'.'.($file->guessExtension() ?? 'jpg');
        $path = (string) Storage::disk($disk)->putFileAs('accounts/'.$account->public_id.'/avatar', $file, $name, ['visibility' => 'private']);
        $size = @getimagesize($file->getRealPath());

        $media = new AccountMedia([
            'collection' => 'avatar',
            'disk' => $disk,
            'path' => $path,
            'mime' => (string) $file->getMimeType(),
            'size_bytes' => (int) $file->getSize(),
            'width' => $size ? $size[0] : null,
            'height' => $size ? $size[1] : null,
        ]);
        $media->account()->associate($account);
        $media->save();

        $previous = $account->avatar_media_id;
        $account->forceFill(['avatar_media_id' => $media->id])->save();
        if ($previous !== null) {
            self::remove(AccountMedia::query()->find($previous));
        }

        ResizeAvatar::dispatch($media->id);

        return $media;
    }

    public static function remove(?AccountMedia $media): void
    {
        if ($media === null) {
            return;
        }
        Storage::disk($media->disk)->delete($media->path);
        $media->delete();
    }

    public static function url(?int $mediaId, int $minutes = 60): ?string
    {
        $media = $mediaId === null ? null : AccountMedia::query()->find($mediaId);

        return $media === null ? null : Storage::disk($media->disk)->temporaryUrl($media->path, now()->addMinutes($minutes));
    }
}
