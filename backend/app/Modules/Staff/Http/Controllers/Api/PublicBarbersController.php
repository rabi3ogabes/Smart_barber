<?php

namespace App\Modules\Staff\Http\Controllers\Api;

use App\Core\Http\ApiResponse;
use App\Modules\Salon\Http\Controllers\Api\PublicSalonController;
use App\Modules\Salon\Support\MediaUrl;
use App\Modules\Staff\Models\Barber;
use Illuminate\Http\JsonResponse;

/**
 * @group Public salon
 */
final class PublicBarbersController
{
    /**
     * Bookable barbers at a branch
     *
     * @unauthenticated
     */
    public function __invoke(string $branch, PublicSalonController $salons): JsonResponse
    {
        $model = $salons->resolveBranch($branch);

        $barbers = Barber::query()
            ->where('is_bookable', true)
            ->whereHas('branches', fn ($q) => $q->whereKey($model->id))
            ->whereHas('membership', fn ($q) => $q->where('status', 'active'))
            ->orderBy('sort_order')->orderBy('id')
            ->get();

        return ApiResponse::success($barbers->map(fn (Barber $b) => [
            'id' => $b->public_id,
            'display_name' => $b->getTranslations('display_name'),
            'bio' => $b->getTranslations('bio'),
            'specialties' => $b->specialties ?? [],
            'years_experience' => $b->years_experience,
            'photo_url' => MediaUrl::for($b->photo_media_id),
            'rating' => $b->rating_count > 0 ? ['average' => (float) $b->rating_avg, 'count' => $b->rating_count] : null,
        ])->values());
    }
}
