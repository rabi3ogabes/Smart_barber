<?php

namespace App\Modules\Salon\Http\Controllers\Api;

use App\Core\Features\Feature;
use App\Core\Http\ApiResponse;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Salon\Models\BranchClosure;
use App\Modules\Salon\Models\BranchOpeningHour;
use App\Modules\Salon\Support\MediaUrl;
use App\Modules\Salon\Support\WeekRanges;
use Illuminate\Http\JsonResponse;

/**
 * Public, read-only salon and branch data for the customer app (api-map.md, Phase 2).
 * The salon comes from the path (slug or public id); its tenant is then set for the request.
 *
 * @group Public salon
 */
final class PublicSalonController
{
    /**
     * Salon profile
     *
     * @unauthenticated
     */
    public function show(string $salon): JsonResponse
    {
        $model = $this->resolve($salon);

        return ApiResponse::success([
            'id' => $model->public_id,
            'slug' => $model->slug,
            'name' => $model->getTranslations('name'),
            'logo_url' => MediaUrl::for($model->logo_media_id),
            'cover_url' => MediaUrl::for($model->cover_media_id),
            'currency' => $model->currency,
            'contact' => ['phone' => $model->contact_phone, 'email' => $model->contact_email],
            'social_links' => $model->social_links ?? (object) [],
            'booking_policy' => [
                'lead_time_minutes' => $model->lead_time_minutes,
                'max_days_ahead' => $model->max_days_ahead,
                'cancellation_window_minutes' => $model->cancellation_window_minutes,
                'no_show_fee' => $model->no_show_fee_amount,
            ],
            'features' => Feature::enabledFor($model),
        ]);
    }

    /**
     * Active branches with today's hours
     *
     * @unauthenticated
     */
    public function branches(string $salon): JsonResponse
    {
        $this->resolve($salon);
        $branches = Branch::query()->where('is_active', true)->orderBy('sort_order')->orderBy('id')->get();

        return ApiResponse::success($branches->map(fn (Branch $b) => $this->presentBranch($b, withWeek: false))->values());
    }

    /**
     * Branch details with weekly hours and upcoming closures
     *
     * @unauthenticated
     */
    public function branch(string $branch): JsonResponse
    {
        $model = $this->resolveBranch($branch);

        return ApiResponse::success($this->presentBranch($model, withWeek: true));
    }

    public function resolve(string $key): Salon
    {
        $salon = Salon::query()
            ->where(fn ($q) => $q->where('slug', $key)->orWhere('public_id', $key))
            ->where('status', Salon::STATUS_ACTIVE)
            ->firstOrFail();
        Tenancy::set($salon);

        return $salon;
    }

    public function resolveBranch(string $key): Branch
    {
        $branch = Tenancy::bypass(fn () => Branch::query()->where('public_id', $key)->where('is_active', true)->first());
        $salon = $branch ? Salon::query()->whereKey($branch->salon_id)->where('status', Salon::STATUS_ACTIVE)->first() : null;
        abort_if($branch === null || $salon === null, 404);
        Tenancy::set($salon);

        return $branch;
    }

    /**
     * @return array<string, mixed>
     */
    private function presentBranch(Branch $b, bool $withWeek): array
    {
        $tz = $b->timezone;
        $today = now($tz);
        $hours = BranchOpeningHour::query()->where('branch_id', $b->id)->get();
        $week = WeekRanges::fromRows($hours, 'opens_at', 'closes_at');
        $closures = BranchClosure::query()
            ->where(fn ($q) => $q->whereNull('branch_id')->orWhere('branch_id', $b->id))
            ->where('ends_on', '>=', $today->toDateString())
            ->orderBy('starts_on')->limit(10)->get();
        $closedToday = $closures->contains(fn (BranchClosure $c) => $c->starts_on->toDateString() <= $today->toDateString());

        $data = [
            'id' => $b->public_id,
            'name' => $b->getTranslations('name'),
            'address' => $b->getTranslations('address'),
            'location' => $b->lat === null ? null : ['lat' => (float) $b->lat, 'lng' => (float) $b->lng],
            'phone' => $b->phone,
            'timezone' => $tz,
            'today' => $closedToday ? [] : $week[$today->dayOfWeek],
        ];

        if ($withWeek) {
            $data['week'] = $week;
            $data['closures'] = $closures->map(fn (BranchClosure $c) => [
                'starts_on' => $c->starts_on->toDateString(),
                'ends_on' => $c->ends_on->toDateString(),
                'reason' => $c->getTranslations('reason'),
            ])->values();
        }

        return $data;
    }
}
