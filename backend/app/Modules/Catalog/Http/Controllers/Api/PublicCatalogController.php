<?php

namespace App\Modules\Catalog\Http\Controllers\Api;

use App\Core\Http\ApiResponse;
use App\Core\Tenancy\Models\Branch;
use App\Modules\Catalog\Models\BarberService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Models\ServiceCategory;
use App\Modules\Catalog\Pricing\PricingService;
use App\Modules\Salon\Http\Controllers\Api\PublicSalonController;
use App\Modules\Salon\Support\MediaUrl;
use App\Modules\Staff\Models\Barber;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * What a customer can book at one branch: active, online-bookable services that are available
 * there, at the branch price computed by PricingService.
 */
final class PublicCatalogController
{
    public function __construct(
        private readonly PublicSalonController $salons,
        private readonly PricingService $pricing,
    ) {}

    /**
     * Categories with at least one bookable service at this branch
     *
     * @unauthenticated
     */
    public function categories(string $branch): JsonResponse
    {
        $model = $this->salons->resolveBranch($branch);
        $services = $this->bookable($model);
        $counts = $services->countBy('category_id');

        $categories = ServiceCategory::query()->where('is_active', true)->whereIn('id', $counts->keys())->orderBy('sort_order')->get();

        return ApiResponse::success($categories->map(fn (ServiceCategory $c) => [
            'id' => $c->public_id,
            'name' => $c->getTranslations('name'),
            'icon' => $c->icon,
            'services_count' => $counts[$c->id] ?? 0,
        ])->values());
    }

    /**
     * Bookable services with the branch price, add-ons and bundles
     *
     * @unauthenticated
     */
    public function services(Request $request, string $branch): JsonResponse
    {
        $model = $this->salons->resolveBranch($branch);
        $category = $request->validate(['category' => ['nullable', 'string', 'size:26']])['category'] ?? null;
        $all = $this->bookable($model);
        $services = $all;
        if ($category !== null) {
            $categoryId = ServiceCategory::query()->where('public_id', $category)->value('id');
            $services = $services->where('category_id', $categoryId)->values();
        }
        $prices = $this->pricing->branchPrices($model, $services);
        $categoryKeys = ServiceCategory::query()->pluck('public_id', 'id');

        $bundles = ServiceBundle::query()->where('is_active', true)->with('services')->orderBy('sort_order')->get()
            // Every service of the bundle must be bookable here; with a category, show bundles touching it.
            ->filter(fn (ServiceBundle $b) => $b->services->every(fn (Service $s) => $all->contains('id', $s->id)))
            ->filter(fn (ServiceBundle $b) => $category === null || $b->services->contains(fn (Service $s) => $services->contains('id', $s->id)));

        return ApiResponse::success([
            'services' => $services->map(fn (Service $s) => $this->present($s, $prices[$s->id] ?? null, $categoryKeys[$s->category_id] ?? null))->values(),
            'bundles' => $bundles->map(fn (ServiceBundle $b) => [
                'id' => $b->public_id,
                'name' => $b->getTranslations('name'),
                'description' => $b->getTranslations('description'),
                'price' => $b->priceMoney(),
                'duration_minutes' => (int) $b->services->sum('duration_minutes'),
                'services' => $b->services->pluck('public_id')->values(),
            ])->values(),
        ]);
    }

    /**
     * One service with the barbers who perform it at this branch and their price when it differs
     *
     * @unauthenticated
     */
    public function service(string $branch, string $service): JsonResponse
    {
        $model = $this->salons->resolveBranch($branch);
        $item = $this->bookable($model)->firstWhere('public_id', $service) ?? abort(404);
        $branchPrice = $this->pricing->servicePriceAt($item, $model);

        $barbers = Barber::query()
            ->where('is_bookable', true)
            ->whereHas('branches', fn ($q) => $q->whereKey($model->id))
            ->whereHas('membership', fn ($q) => $q->where('status', 'active'))
            ->whereIn('id', BarberService::query()->where('service_id', $item->id)->select('barber_id'))
            ->orderBy('sort_order')->get();
        $rows = BarberService::query()->where('service_id', $item->id)->get()->keyBy('barber_id');

        return ApiResponse::success($this->present($item, $branchPrice, ServiceCategory::query()->whereKey($item->category_id)->value('public_id')) + [
            'barbers' => $barbers->map(function (Barber $b) use ($item, $model, $branchPrice, $rows) {
                $price = $this->pricing->servicePriceAt($item, $model, $b);
                /** @var BarberService|null $row */
                $row = $rows->get($b->id);

                return [
                    'id' => $b->public_id,
                    'display_name' => $b->getTranslations('display_name'),
                    'photo_url' => MediaUrl::for($b->photo_media_id),
                    'price' => $price->equals($branchPrice) ? null : $price,
                    'duration_minutes' => $row?->duration_override,
                ];
            })->values(),
        ]);
    }

    /**
     * @return Collection<int, Service>
     */
    private function bookable(Branch $branch): Collection
    {
        return Service::query()
            ->where('is_active', true)->where('is_bookable_online', true)
            ->whereHas('category', fn ($q) => $q->where('is_active', true))
            ->whereDoesntHave('branchSettings', fn ($q) => $q->where('branch_id', $branch->id)->where('is_available', false))
            ->with(['addons' => fn ($q) => $q->where('is_active', true)])
            ->orderBy('sort_order')->orderBy('id')->get();
    }

    /**
     * @return array<string, mixed>
     */
    private function present(Service $s, mixed $price, ?string $category): array
    {
        return [
            'id' => $s->public_id,
            'category' => $category,
            'name' => $s->getTranslations('name'),
            'description' => $s->getTranslations('description'),
            'image_url' => MediaUrl::for($s->image_media_id),
            'price' => $price,
            'duration_minutes' => $s->duration_minutes,
            'addons' => $s->addons->map(fn (ServiceAddon $a) => [
                'id' => $a->public_id,
                'name' => $a->getTranslations('name'),
                'price' => $a->priceMoney(),
                'extra_minutes' => $a->extra_minutes,
            ])->values(),
        ];
    }
}
