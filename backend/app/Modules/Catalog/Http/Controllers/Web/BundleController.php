<?php

namespace App\Modules\Catalog\Http\Controllers\Web;

use App\Modules\Catalog\Actions\SaveBundle;
use App\Modules\Catalog\Enums\TaxClass;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceBundle;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;

final class BundleController
{
    public function store(Request $request, SaveBundle $save): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $save(null, $this->validated($request), true);

        return back()->with('success', __('ui.catalog.bundle_saved'));
    }

    public function update(Request $request, ServiceBundle $bundle, SaveBundle $save): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $save($bundle, $this->validated($request), Gate::allows('updatePrices', Service::class));

        return back()->with('success', __('ui.catalog.bundle_saved'));
    }

    /**
     * @return array<string, mixed>
     */
    private function validated(Request $request): array
    {
        return $request->validate([
            'name.ar' => ['required', 'string', 'max:120'],
            'name.en' => ['required', 'string', 'max:120'],
            'description.ar' => ['nullable', 'string', 'max:500'],
            'description.en' => ['nullable', 'string', 'max:500'],
            'price' => ['required', 'numeric', 'min:0', 'max:1000000', 'decimal:0,3'],
            'tax_class' => ['required', Rule::enum(TaxClass::class)],
            'is_active' => ['required', 'boolean'],
            'services' => ['required', 'array', 'min:2', 'max:10'],
            'services.*' => ['string', 'size:26', 'distinct'],
        ]);
    }
}
