<?php

namespace App\Modules\Catalog\Actions;

use App\Core\Contracts\StorageService;
use App\Core\Media\Media;
use App\Modules\Catalog\Models\Service;
use Illuminate\Http\UploadedFile;

/**
 * Stores the (already cropped, 4:3) service image privately and replaces the previous one.
 */
final class UploadServiceImage
{
    public function __construct(private readonly StorageService $storage) {}

    public function __invoke(Service $service, UploadedFile $file): Media
    {
        $previous = $service->image_media_id ? Media::query()->find($service->image_media_id) : null;
        $media = $this->storage->store($file, 'service-images', $service);
        $service->forceFill(['image_media_id' => $media->id])->save();
        if ($previous !== null) {
            $this->storage->delete($previous);
        }

        return $media;
    }
}
