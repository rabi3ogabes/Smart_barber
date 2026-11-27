<?php

use App\Core\Contracts\StorageService;
use App\Core\Media\Media;
use App\Core\Tenancy\Tenancy;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

it('stores private media under the salon folder and signs temporary URLs', function () {
    Storage::fake('media');
    ['salon' => $a, 'branch' => $branch] = $this->makeSalon('salon-a');
    ['salon' => $b] = $this->makeSalon('salon-b');

    $media = Tenancy::runAs($a, fn () => app(StorageService::class)->store(UploadedFile::fake()->image('logo.jpg', 320, 200), 'logos', $branch));

    expect($media->path)->toStartWith('salons/'.$a->getKey().'/logos/')
        ->and($media->visibility)->toBe('private')
        ->and([$media->width, $media->height])->toBe([320, 200]);
    Storage::disk('media')->assertExists($media->path);

    expect(Tenancy::runAs($a, fn () => app(StorageService::class)->temporaryUrl($media)))->toContain('expiration=') // Storage::fake() does not sign; the real local/S3 disks do
        ->and(Tenancy::runAs($b, fn () => Media::query()->whereKey($media->getKey())->exists()))->toBeFalse();

    Tenancy::runAs($a, fn () => app(StorageService::class)->delete($media));
    Storage::disk('media')->assertMissing($media->path);
});
