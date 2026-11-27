<?php

namespace App\Modules\Staff\Actions;

use App\Core\Contracts\StorageService;
use App\Core\Media\Media;
use App\Modules\Staff\Models\Barber;
use Illuminate\Http\UploadedFile;

final class UpdateBarberProfile
{
    public function __construct(private readonly StorageService $storage) {}

    /**
     * @param  array<string, mixed>  $data
     */
    public function __invoke(Barber $barber, array $data, ?UploadedFile $photo = null): Barber
    {
        $barber->fill($data)->save();

        if ($photo !== null) {
            $previous = $barber->photo_media_id ? Media::query()->find($barber->photo_media_id) : null;
            $media = $this->storage->store($photo, 'barber-photo', $barber);
            $barber->forceFill(['photo_media_id' => $media->id])->save();
            if ($previous !== null) {
                $this->storage->delete($previous);
            }
        }

        return $barber;
    }
}
