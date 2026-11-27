<?php

namespace App\Modules\Staff\Http\Controllers\Api;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Http\ApiResponse;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Tenancy;
use App\Modules\Staff\Actions\DecideTimeOff;
use App\Modules\Staff\Actions\RequestTimeOff;
use App\Modules\Staff\Enums\TimeOffType;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\TimeOffRequest;
use App\Modules\Staff\Schedule\Interval;
use App\Modules\Staff\Schedule\ScheduleService;
use Carbon\CarbonImmutable;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;

/**
 * Staff app: my working times and my time off (api-map.md, Phase 2).
 *
 * @group Staff schedule
 */
final class StaffScheduleApiController
{
    /**
     * My schedule
     *
     * Working intervals (UTC) per branch for a date range of at most 31 days.
     */
    public function schedule(Request $request, ScheduleService $schedules): JsonResponse
    {
        $data = $request->validate([
            'from' => ['required', 'date_format:Y-m-d'],
            'to' => ['required', 'date_format:Y-m-d', 'after_or_equal:from', 'before_or_equal:'.CarbonImmutable::parse((string) $request->input('from'))->addDays(30)->toDateString()],
        ]);
        $barber = $this->me($request);

        $byBranch = $schedules->workingIntervalsAllBranches($barber, $data['from'], $data['to']);

        return ApiResponse::success(collect($byBranch)->map(fn (array $intervals, string $branch) => [
            'branch' => $branch,
            'intervals' => array_map(fn (Interval $i) => $i->toArray(), $intervals),
        ])->values());
    }

    /**
     * My time-off requests
     */
    public function timeOff(Request $request): JsonResponse
    {
        $barber = $this->me($request);

        return ApiResponse::success(TimeOffRequest::query()->where('barber_id', $barber->id)->latest('starts_at')->limit(50)->get()->map(fn (TimeOffRequest $r) => $this->present($r)));
    }

    /**
     * Request time off
     *
     * Whole days in the salon's time zone; ends_on is inclusive.
     */
    public function requestTimeOff(Request $request, RequestTimeOff $requestTimeOff): JsonResponse
    {
        $barber = $this->me($request);
        Gate::forUser($request->user('staff'))->authorize('requestTimeOff', $barber);
        $data = $request->validate([
            'starts_on' => ['required', 'date_format:Y-m-d', 'after_or_equal:today'],
            'ends_on' => ['required', 'date_format:Y-m-d', 'after_or_equal:starts_on'],
            'type' => ['required', Rule::enum(TimeOffType::class)],
            'reason' => ['nullable', 'string', 'max:500'],
        ]);
        $tz = Tenancy::current()->timezone ?? 'UTC';

        $created = $requestTimeOff(
            $barber,
            CarbonImmutable::parse($data['starts_on'], $tz)->startOfDay(),
            CarbonImmutable::parse($data['ends_on'], $tz)->addDay()->startOfDay(),
            TimeOffType::from($data['type']),
            $data['reason'] ?? null,
        );

        return ApiResponse::success($this->present($created), status: 201);
    }

    /**
     * Cancel my request
     */
    public function cancel(Request $request, TimeOffRequest $timeOff, DecideTimeOff $decide): JsonResponse
    {
        if ($timeOff->barber_id !== $this->me($request)->id) {
            throw new AppException(ErrorCode::NotFound);
        }

        return ApiResponse::success($this->present($decide->cancel($timeOff)));
    }

    private function me(Request $request): Barber
    {
        /** @var User $user */
        $user = $request->user('staff');

        return Barber::query()->where('user_id', $user->id)->first() ?? throw new AppException(ErrorCode::Forbidden);
    }

    /**
     * @return array<string, mixed>
     */
    private function present(TimeOffRequest $r): array
    {
        return [
            'id' => $r->public_id,
            'starts_at' => $r->starts_at->toIso8601ZuluString(),
            'ends_at' => $r->ends_at->toIso8601ZuluString(),
            'type' => $r->type->value,
            'status' => $r->status->value,
            'reason' => $r->reason,
        ];
    }
}
