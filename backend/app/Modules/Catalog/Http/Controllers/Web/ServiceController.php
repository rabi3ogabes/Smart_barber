<?php

namespace App\Modules\Catalog\Http\Controllers\Web;

use App\Core\Tenancy\Models\Branch;
use App\Modules\Catalog\Actions\AssignBarberServices;
use App\Modules\Catalog\Actions\SaveService;
use App\Modules\Catalog\Actions\SetBranchPricing;
use App\Modules\Catalog\Actions\UploadServiceImage;
use App\Modules\Catalog\Enums\TaxClass;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Support\CatalogMoney;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;

/**
 * Service drawer: Details, Pricing per branch, Barbers, Add-ons.
 */
final class ServiceController
{
    public function store(Request $request, SaveService $save): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $save(null, $this->validated($request), true);

        return back()->with('success', __('ui.catalog.service_saved'));
    }

    public function update(Request $request, Service $service, SaveService $save): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $save($service, $this->validated($request), Gate::allows('updatePrices', Service::class));

        return back()->with('success', __('ui.catalog.service_saved'));
    }

    public function image(Request $request, Service $service, UploadServiceImage $upload): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $request->validate(['image' => ['required', 'image', 'mimes:jpg,jpeg,png,webp', 'max:4096', 'dimensions:min_width=400,min_height=300']]);
        $upload($service, $request->file('image'));

        return back()->with('success', __('ui.catalog.image_saved'));
    }

    public function branchPricing(Request $request, Service $service, Branch $branch, SetBranchPricing $set): RedirectResponse
    {
        Gate::authorize('updateBranchPricing', [Service::class, $branch]);
        $data = $request->validate([
            'is_available' => ['required', 'boolean'],
            'price_override' => ['nullable', 'numeric', 'min:0', 'max:1000000', 'decimal:0,3'],
        ]);
        $set($service, $branch, (bool) $data['is_available'], CatalogMoney::toMinor($data['price_override'] ?? null));

        return back()->with('success', __('ui.catalog.pricing_saved'));
    }

    public function barbers(Request $request, Service $service, AssignBarberServices $assign): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $data = $request->validate([
            'barbers' => ['present', 'array', 'max:200'],
            'barbers.*.barber' => ['required', 'string', 'size:26', 'distinct'],
            'barbers.*.price_override' => ['nullable', 'numeric', 'min:0', 'max:1000000', 'decimal:0,3'],
            'barbers.*.duration_override' => ['nullable', 'integer', 'min:5', 'max:600'],
        ]);
        $assign($service, array_map(fn (array $r) => [
            'barber' => $r['barber'],
            'price_override' => CatalogMoney::toMinor($r['price_override'] ?? null),
            'duration_override' => isset($r['duration_override']) ? (int) $r['duration_override'] : null,
        ], array_values($data['barbers'])), Gate::allows('updatePrices', Service::class));

        return back()->with('success', __('ui.catalog.barbers_saved'));
    }

    public function addons(Request $request, Service $service): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $ids = $request->validate(['addons' => ['present', 'array'], 'addons.*' => ['string', 'size:26']])['addons'];
        $addonIds = ServiceAddon::query()->whereIn('public_id', $ids)->pluck('id');
        abort_if($addonIds->count() !== count(array_unique($ids)), 404);
        $service->addons()->sync($addonIds->mapWithKeys(fn ($id) => [(int) $id => ['salon_id' => $service->salon_id]])->all());

        return back()->with('success', __('ui.catalog.addons_saved'));
    }

    /**
     * @return array<string, mixed>
     */
    private function validated(Request $request): array
    {
        return $request->validate([
            'category' => ['required', 'string', 'size:26'],
            'name.ar' => ['required', 'string', 'max:120'],
            'name.en' => ['required', 'string', 'max:120'],
            'description.ar' => ['nullable', 'string', 'max:1000'],
            'description.en' => ['nullable', 'string', 'max:1000'],
            'base_price' => ['required', 'numeric', 'min:0', 'max:1000000', 'decimal:0,3'],
            'duration_minutes' => ['required', 'integer', 'min:5', 'max:600'],
            'buffer_minutes' => ['nullable', 'integer', 'min:0', 'max:120'],
            'tax_class' => ['required', Rule::enum(TaxClass::class)],
            'is_active' => ['required', 'boolean'],
            'is_bookable_online' => ['required', 'boolean'],
        ]);
    }
}
