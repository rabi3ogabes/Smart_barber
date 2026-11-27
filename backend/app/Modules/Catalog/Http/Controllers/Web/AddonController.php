<?php

namespace App\Modules\Catalog\Http\Controllers\Web;

use App\Modules\Catalog\Actions\SaveAddon;
use App\Modules\Catalog\Enums\TaxClass;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;

final class AddonController
{
    public function store(Request $request, SaveAddon $save): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $save(null, $this->validated($request), true);

        return back()->with('success', __('ui.catalog.addon_saved'));
    }

    public function update(Request $request, ServiceAddon $addon, SaveAddon $save): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $save($addon, $this->validated($request), Gate::allows('updatePrices', Service::class));

        return back()->with('success', __('ui.catalog.addon_saved'));
    }

    /**
     * @return array<string, mixed>
     */
    private function validated(Request $request): array
    {
        return $request->validate([
            'name.ar' => ['required', 'string', 'max:80'],
            'name.en' => ['required', 'string', 'max:80'],
            'price' => ['required', 'numeric', 'min:0', 'max:1000000', 'decimal:0,3'],
            'extra_minutes' => ['required', 'integer', 'min:0', 'max:240'],
            'tax_class' => ['required', Rule::enum(TaxClass::class)],
            'is_active' => ['required', 'boolean'],
            'services' => ['present', 'array'],
            'services.*' => ['string', 'size:26'],
        ]);
    }
}
