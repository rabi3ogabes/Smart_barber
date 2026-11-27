<?php

namespace App\Modules\Salon\Actions;

use App\Core\Contracts\StorageService;
use App\Core\Media\Media;
use App\Core\Tenancy\Models\Salon;
use Illuminate\Http\UploadedFile;

/**
 * Replaces the salon logo or cover image.
 */
final class UploadSalonImage
{
    public function __construct(private readonly StorageService $storage) {}

    /**
     * @param  'logo'|'cover'  $kind
     */
    public function __invoke(Salon $salon, string $kind, UploadedFile $file): Media
    {
        $column = $kind === 'logo' ? 'logo_media_id' : 'cover_media_id';
        $previous = $salon->{$column} ? Media::query()->find($salon->{$column}) : null;

        $media = $this->storage->store($file, "salon-{$kind}", $salon);
        $salon->forceFill([$column => $media->id])->save();

        if ($previous !== null) {
            $this->storage->delete($previous);
        }

        return $media;
    }
}
