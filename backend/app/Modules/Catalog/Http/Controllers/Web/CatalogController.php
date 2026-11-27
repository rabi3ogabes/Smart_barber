<?php

namespace App\Modules\Catalog\Http\Controllers\Web;

use App\Core\Authorization\Access;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Modules\Catalog\Actions\DeleteCategory;
use App\Modules\Catalog\Actions\ReorderCategories;
use App\Modules\Catalog\Actions\SaveCategory;
use App\Modules\Catalog\Enums\TaxClass;
use App\Modules\Catalog\Models\BarberService;
use App\Modules\Catalog\Models\BranchService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Models\ServiceCategory;
use App\Modules\Catalog\Support\CatalogMoney;
use App\Modules\Salon\Support\MediaUrl;
use App\Modules\Staff\Models\Barber;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Inertia\Response;

/**
 * The Services page: categories (reorderable), services, add-ons and bundles in one screen.
 * Amounts go to the page as {amount, currency, formatted} plus a decimal string for forms; the
 * page never computes a price (bundle savings come from here).
 */
final class CatalogController
{
    public function index(Request $request): Response
    {
        /** @var User $user */
        $user = $request->user();
        Gate::authorize('viewAny', Service::class);

        $categories = ServiceCategory::query()->withCount('services')->orderBy('sort_order')->get();
        $services = Service::query()->with('addons:id,public_id')->orderBy('sort_order')->orderBy('id')->get();
        $branchRows = BranchService::query()->get()->groupBy('service_id');
        $barberRows = BarberService::query()->get()->groupBy('service_id');
        $branches = Access::visibleBranches($user);
        $allBranchIds = Branch::query()->pluck('public_id', 'id');
        $barbers = Barber::query()->with('branches:id')->orderBy('sort_order')->get();
        $barberKeys = $barbers->pluck('public_id', 'id');
        $categoryKeys = $categories->pluck('public_id', 'id');
        $serviceKeys = $services->pluck('public_id', 'id');
        $locale = app()->getLocale();

        return Inertia::render('Services/Index', [
            'currency' => CatalogMoney::currency(),
            'categories' => $categories->map(fn (ServiceCategory $c) => [
                'id' => $c->public_id,
                'name' => $c->getTranslations('name'),
                'icon' => $c->icon,
                'is_active' => $c->is_active,
                'services_count' => $c->getAttribute('services_count'),
            ])->values(),
            'services' => $services->map(fn (Service $s) => [
                'id' => $s->public_id,
                'category' => $categoryKeys[$s->category_id] ?? null,
                'name' => $s->getTranslations('name'),
                'description' => $s->getTranslations('description'),
                'image_url' => MediaUrl::for($s->image_media_id),
                'price' => CatalogMoney::present($s->base_price),
                'base_price' => CatalogMoney::toDecimal($s->base_price),
                'duration_minutes' => $s->duration_minutes,
                'buffer_minutes' => $s->buffer_minutes,
                'tax_class' => $s->tax_class->value,
                'is_active' => $s->is_active,
                'is_bookable_online' => $s->is_bookable_online,
                'addons' => $s->addons->pluck('public_id')->values(),
                'branches' => collect($branchRows->get($s->id, []))->map(fn (BranchService $r) => [
                    'branch' => $allBranchIds[$r->branch_id] ?? null,
                    'is_available' => $r->is_available,
                    'price_override' => CatalogMoney::toDecimal($r->price_override),
                    'price' => CatalogMoney::present($r->price_override),
                ])->values(),
                'barbers' => collect($barberRows->get($s->id, []))->map(fn (BarberService $r) => [
                    'barber' => $barberKeys[$r->barber_id] ?? null,
                    'price_override' => CatalogMoney::toDecimal($r->price_override),
                    'duration_override' => $r->duration_override,
                ])->filter(fn ($r) => $r['barber'] !== null)->values(),
            ])->values(),
            'addons' => ServiceAddon::query()->with('services:id')->orderBy('id')->get()->map(fn (ServiceAddon $a) => [
                'id' => $a->public_id,
                'name' => $a->getTranslations('name'),
                'price' => CatalogMoney::present($a->price),
                'price_decimal' => CatalogMoney::toDecimal($a->price),
                'extra_minutes' => $a->extra_minutes,
                'tax_class' => $a->tax_class->value,
                'is_active' => $a->is_active,
                'services' => $a->services->map(fn (Service $s) => $serviceKeys[$s->id] ?? null)->filter()->values(),
            ])->values(),
            'bundles' => ServiceBundle::query()->with('services')->orderBy('sort_order')->orderBy('id')->get()->map(function (ServiceBundle $b) {
                $regular = (int) $b->services->sum('base_price');

                return [
                    'id' => $b->public_id,
                    'name' => $b->getTranslations('name'),
                    'description' => $b->getTranslations('description'),
                    'price' => CatalogMoney::present($b->price),
                    'price_decimal' => CatalogMoney::toDecimal($b->price),
                    'regular_price' => CatalogMoney::present($regular),
                    'saving' => $regular > $b->price ? CatalogMoney::present($regular - $b->price) : null,
                    'duration_minutes' => (int) $b->services->sum('duration_minutes'),
                    'tax_class' => $b->tax_class->value,
                    'is_active' => $b->is_active,
                    'services' => $b->services->pluck('public_id')->values(),
                ];
            })->values(),
            'branches' => $branches->map(fn (Branch $b) => [
                'id' => $b->public_id,
                'name' => $b->getTranslation('name', $locale),
                'can_price' => Gate::allows('updateBranchPricing', [Service::class, $b]),
            ])->values(),
            'barbers' => $barbers->map(fn (Barber $b) => [
                'id' => $b->public_id,
                'name' => $b->getTranslation('display_name', $locale),
                'branches' => $b->branches->map(fn (Branch $br) => $allBranchIds[$br->id] ?? null)->filter()->values(),
                'is_bookable' => $b->is_bookable,
            ])->values(),
            'taxClasses' => array_map(fn (TaxClass $t) => $t->value, TaxClass::cases()),
            'icons' => ServiceCategory::ICONS,
            'can' => [
                'manage' => Gate::allows('manage', Service::class),
                'updatePrices' => Gate::allows('updatePrices', Service::class),
            ],
        ]);
    }

    public function storeCategory(Request $request, SaveCategory $save): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $save(null, $this->categoryData($request));

        return back()->with('success', __('ui.catalog.category_saved'));
    }

    public function updateCategory(Request $request, ServiceCategory $category, SaveCategory $save): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $save($category, $this->categoryData($request));

        return back()->with('success', __('ui.catalog.category_saved'));
    }

    public function reorderCategories(Request $request, ReorderCategories $reorder): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $order = $request->validate(['order' => ['required', 'array', 'max:200'], 'order.*' => ['string', 'size:26']])['order'];
        $reorder(array_values($order));

        return back();
    }

    public function destroyCategory(ServiceCategory $category, DeleteCategory $delete): RedirectResponse
    {
        Gate::authorize('manage', Service::class);
        $delete($category);

        return back()->with('success', __('ui.catalog.category_deleted'));
    }

    /**
     * @return array{name: array<string, string>, icon: string|null, is_active: bool}
     */
    private function categoryData(Request $request): array
    {
        $data = $request->validate([
            'name.ar' => ['required', 'string', 'max:80'],
            'name.en' => ['required', 'string', 'max:80'],
            'icon' => ['nullable', Rule::in(ServiceCategory::ICONS)],
            'is_active' => ['required', 'boolean'],
        ]);

        return ['name' => $data['name'], 'icon' => $data['icon'] ?? null, 'is_active' => (bool) $data['is_active']];
    }
}
