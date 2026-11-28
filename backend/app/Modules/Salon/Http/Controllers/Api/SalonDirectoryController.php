<?php

namespace App\Modules\Salon\Http\Controllers\Api;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Http\ApiResponse;
use App\Core\Settings\Setting;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Salon\Support\SalonCode;
use App\Modules\Salon\Support\SalonSummary;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * How the customer app finds a salon (spec-review item 2): QR / deep link first; name search only
 * returns salons that opted in with the `listing.enabled` setting (default off).
 *
 * @group Public salon
 */
final class SalonDirectoryController
{
    public const LISTING_KEY = 'listing.enabled';

    /**
     * Search listed salons by name
     *
     * @unauthenticated
     */
    public function search(Request $request): JsonResponse
    {
        $q = trim((string) $request->validate(['q' => ['required', 'string', 'min:2', 'max:60']])['q']);
        $like = '%'.addcslashes(mb_strtolower($q), '%_\\').'%';

        $listed = Tenancy::bypass(fn () => Setting::query()
            ->where('settable_type', (new Salon)->getMorphClass())
            ->where('key', self::LISTING_KEY)
            ->get(['settable_id', 'value'])
            ->filter(fn (Setting $s) => $s->value === true)
            ->pluck('settable_id')
            ->all());

        $salons = Salon::query()
            ->whereIn('id', $listed)
            ->where('status', Salon::STATUS_ACTIVE)
            ->where(fn ($w) => $w
                ->whereRaw('LOWER(JSON_UNQUOTE(JSON_EXTRACT(name, "$.en"))) LIKE ?', [$like])
                ->orWhereRaw('JSON_UNQUOTE(JSON_EXTRACT(name, "$.ar")) LIKE ?', [$like])
                ->orWhere('slug', 'like', $like))
            ->orderBy('slug')
            ->limit(20)
            ->get();

        return ApiResponse::success($salons->map(fn (Salon $s) => SalonSummary::for($s))->values());
    }

    /**
     * Resolve a QR code or deep link to a salon
     *
     * @unauthenticated
     */
    public function resolve(Request $request): JsonResponse
    {
        $code = (string) $request->validate(['code' => ['required', 'string', 'max:300']])['code'];
        $key = SalonCode::key($code);

        $salon = $key === null ? null : Salon::query()
            ->where(fn ($w) => $w->where('slug', $key)->orWhere('public_id', strtoupper($key)))
            ->where('status', Salon::STATUS_ACTIVE)
            ->first();

        if ($salon === null) {
            throw new AppException(ErrorCode::InvalidSalonCode);
        }

        return ApiResponse::success(SalonSummary::for($salon));
    }
}
