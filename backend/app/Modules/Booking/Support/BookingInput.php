<?php

namespace App\Modules\Booking\Support;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Tenancy\Models\Branch;
use App\Modules\Staff\Models\Barber;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;

/**
 * Parses the booking fields shared by every create/slots/quote endpoint. Ids are public ids of the
 * current salon (resolved through SalonScope, so another salon's ids are 404).
 */
final class BookingInput
{
    /**
     * @return array<string, list<mixed>>
     */
    public static function rules(bool $withStart = true): array
    {
        return [
            'services' => ['nullable', 'array', 'max:10'],
            'services.*' => ['string', 'size:26'],
            'addons' => ['nullable', 'array', 'max:10'],
            'addons.*' => ['string', 'size:26'],
            'bundles' => ['nullable', 'array', 'max:5'],
            'bundles.*' => ['string', 'size:26'],
            'barber' => ['nullable', 'string', 'max:26'],
        ] + ($withStart ? ['starts_at' => ['required', 'date']] : []);
    }

    public static function selection(Request $request): Selection
    {
        return Selection::fromPublicIds(
            array_values((array) $request->input('services', [])),
            array_values((array) $request->input('addons', [])),
            array_values((array) $request->input('bundles', [])),
        );
    }

    /** null = "any" barber. The barber must work at the branch. */
    public static function barber(Request $request, Branch $branch): ?Barber
    {
        $id = $request->input('barber');
        if ($id === null || $id === '' || $id === 'any') {
            return null;
        }
        $barber = Barber::query()->where('public_id', $id)->whereHas('branches', fn ($q) => $q->whereKey($branch->id))->first();

        return $barber ?? throw new AppException(ErrorCode::BarberNotEligible);
    }

    public static function startsAt(Request $request): CarbonImmutable
    {
        return CarbonImmutable::parse((string) $request->input('starts_at'))->utc();
    }
}
