<?php

namespace App\Modules\Booking\Http\Controllers\Api;

use App\Core\Features\Feature;
use App\Core\Http\ApiResponse;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Models\BookingItem;
use App\Modules\Booking\Models\BookingReview;
use App\Modules\Booking\Support\BookingPresenter;
use App\Modules\Booking\Support\CustomerBookings;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Pricing\PricingService;
use App\Modules\Customer\Models\Customer;
use App\Modules\Salon\Http\Controllers\Api\PublicSalonController;
use App\Modules\Salon\Support\MediaUrl;
use App\Modules\Salon\Support\SalonSummary;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * The customer app's salon list and per-salon home screen (api-map.md → Phase 5). Everything is
 * computed here — the app only lays it out (rule 1).
 *
 * @group Customer app
 */
final class CustomerHomeController
{
    private const POPULAR_LIMIT = 6;

    private const REVIEW_PROMPT_DAYS = 14;

    public function __construct(private readonly PublicSalonController $salons, private readonly PricingService $pricing) {}

    /**
     * Salons I have visited or booked, most recent first
     */
    public function salons(Request $request): JsonResponse
    {
        $account = CustomerBookings::account($request);
        $rows = Tenancy::bypass(fn () => Customer::query()->where('customer_account_id', $account->id)
            ->orderByDesc('last_visit_at')->orderByDesc('updated_at')->get(['salon_id', 'last_visit_at']));
        $salons = Salon::query()->whereIn('id', $rows->pluck('salon_id'))->where('status', Salon::STATUS_ACTIVE)->get()->keyBy('id');

        return ApiResponse::success($rows
            ->filter(fn (Customer $c) => $salons->has($c->salon_id))
            ->map(fn (Customer $c) => SalonSummary::for($salons[$c->salon_id]) + ['last_visit_at' => $c->last_visit_at?->toIso8601ZuluString()])
            ->values());
    }

    /**
     * Home screen for one salon
     */
    public function home(Request $request): JsonResponse
    {
        $data = $request->validate(['salon' => ['required', 'string', 'max:63'], 'branch' => ['nullable', 'string', 'size:26']]);
        $account = CustomerBookings::account($request);
        $salon = $this->salons->resolve($data['salon']);
        $customer = Customer::query()->where('customer_account_id', $account->id)->first();
        $features = Feature::enabledFor($salon);

        $branch = isset($data['branch'])
            ? Branch::query()->where('public_id', $data['branch'])->where('is_active', true)->firstOrFail()
            : Branch::query()->where('is_active', true)->orderBy('sort_order')->orderBy('id')->first();

        return ApiResponse::success([
            'salon' => SalonSummary::for($salon) + [
                'cover_url' => MediaUrl::for($salon->cover_media_id),
                'booking_policy' => [
                    'lead_time_minutes' => $salon->lead_time_minutes,
                    'max_days_ahead' => $salon->max_days_ahead,
                    'cancellation_window_minutes' => $salon->cancellation_window_minutes,
                ],
            ],
            'branch' => $branch?->public_id,
            'next_appointment' => $customer === null ? null : $this->next($customer),
            'book_again' => $customer === null ? null : $this->bookAgain($customer),
            'review_prompt' => $customer === null ? null : $this->reviewPrompt($customer),
            'popular_services' => $branch === null ? [] : $this->popular($branch),
            'features' => [
                'ai_studio' => in_array(Feature::AI_STUDIO, $features, true),
                'loyalty' => in_array(Feature::LOYALTY, $features, true),
            ],
        ]);
    }

    /**
     * @return array<string, mixed>|null
     */
    private function next(Customer $customer): ?array
    {
        $booking = Booking::query()->where('customer_id', $customer->id)
            ->whereIn('status', BookingStatus::ACTIVE)
            ->where('starts_at', '>=', now()->subHours(2))
            ->orderBy('starts_at')->first();

        return $booking === null ? null : BookingPresenter::forCustomer($booking);
    }

    /**
     * "Book again": the last completed visit as a ready selection. The app pre-fills the stepper;
     * the server re-prices and re-checks everything when the customer books.
     *
     * @return array<string, mixed>|null
     */
    private function bookAgain(Customer $customer): ?array
    {
        $last = Booking::query()->where('customer_id', $customer->id)->where('status', BookingStatus::Completed)
            ->with(['items', 'barber', 'branch'])->latest('starts_at')->first();
        if ($last === null || $last->branch === null || ! $last->branch->is_active) {
            return null;
        }

        $ids = fn (string $type, string $column, string $model) => $last->items->where('type', $type)->pluck($column)->filter()
            ->map(fn ($id) => $model::query()->whereKey($id)->value('public_id'))->filter()->values()->all();
        $services = $ids('service', 'service_id', Service::class);
        $addons = $ids('addon', 'addon_id', ServiceAddon::class);
        $bundles = $ids('bundle', 'bundle_id', ServiceBundle::class);
        if ($services === [] && $bundles === []) {
            return null;
        }
        $barber = $last->barber !== null && $last->barber->is_bookable && $last->barber->trashed() === false ? $last->barber : null;

        return [
            'booking' => $last->public_id,
            'branch' => $last->branch->public_id,
            'barber' => $barber === null ? null : ['id' => $barber->public_id, 'name' => $barber->getTranslations('display_name')],
            'services' => $services,
            'addons' => $addons,
            'bundles' => $bundles,
            'names' => $last->items->map(fn (BookingItem $i) => $i->getTranslations('name'))->values(),
            'last_visit_at' => $last->starts_at->toIso8601ZuluString(),
        ];
    }

    /**
     * @return array<string, mixed>|null
     */
    private function reviewPrompt(Customer $customer): ?array
    {
        $booking = Booking::query()->where('customer_id', $customer->id)->where('status', BookingStatus::Completed)
            ->where('starts_at', '>=', now()->subDays(self::REVIEW_PROMPT_DAYS))
            ->whereNotIn('id', BookingReview::query()->select('booking_id'))
            ->with('barber')->latest('starts_at')->first();

        return $booking === null ? null : [
            'booking' => $booking->public_id,
            'starts_at' => $booking->starts_at->toIso8601ZuluString(),
            'barber' => $booking->barber?->getTranslations('display_name'),
        ];
    }

    /**
     * Most booked services of the last 90 days at this salon, topped up by the catalog order.
     *
     * @return list<array<string, mixed>>
     */
    private function popular(Branch $branch): array
    {
        $bookable = Service::query()
            ->where('is_active', true)->where('is_bookable_online', true)
            ->whereHas('category', fn ($q) => $q->where('is_active', true))
            ->whereDoesntHave('branchSettings', fn ($q) => $q->where('branch_id', $branch->id)->where('is_available', false))
            ->orderBy('sort_order')->orderBy('id')->get();

        $counts = BookingItem::query()->where('type', 'service')
            ->whereIn('booking_id', Booking::query()->where('starts_at', '>=', now()->subDays(90))->whereNotIn('status', [BookingStatus::Cancelled->value])->select('id'))
            ->groupBy('service_id')->select('service_id', DB::raw('COUNT(*) as c'))->pluck('c', 'service_id');

        $top = $bookable->sortBy(fn (Service $s) => [-(int) ($counts[$s->id] ?? 0), $s->sort_order, $s->id])->take(self::POPULAR_LIMIT)->values();
        $prices = $this->pricing->branchPrices($branch, $top);

        return $top->filter(fn (Service $s) => isset($prices[$s->id]))->map(fn (Service $s) => [
            'id' => $s->public_id,
            'name' => $s->getTranslations('name'),
            'duration_minutes' => $s->duration_minutes,
            'price' => $prices[$s->id],
            'image_url' => MediaUrl::for($s->image_media_id),
        ])->values()->all();
    }
}
