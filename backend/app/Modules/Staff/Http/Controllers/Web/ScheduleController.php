<?php

namespace App\Modules\Staff\Http\Controllers\Web;

use App\Core\Authorization\Access;
use App\Core\Exceptions\AppException;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Tenancy;
use App\Modules\Salon\Models\BranchOpeningHour;
use App\Modules\Salon\Support\WeekRanges;
use App\Modules\Staff\Actions\SetWeeklySchedule;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\BarberBreak;
use App\Modules\Staff\Models\BarberScheduleOverride;
use App\Modules\Staff\Models\BarberWorkingHour;
use App\Modules\Staff\Schedule\Intervals;
use App\Modules\Staff\Schedule\ScheduleService;
use Carbon\CarbonImmutable;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

/**
 * Weekly schedule grid per branch: one row per barber, seven days, editable ranges and breaks.
 */
final class ScheduleController
{
    public function index(Request $request, ScheduleService $schedules): Response
    {
        /** @var User $user */
        $user = $request->user();
        $visible = Access::branchIds($user, Tenancy::membership(), 'schedule.view');
        $branches = Branch::query()->where('is_active', true)->when($visible !== null, fn ($q) => $q->whereIn('id', $visible))->orderBy('sort_order')->get();

        // Barbers (scope "own") see only themselves, at the branches they work in.
        $own = Access::scope($user, 'schedule.view') === 'own';
        $ownBarber = $own ? Barber::query()->where('user_id', $user->id)->first() : null;
        if ($own) {
            $branches = $ownBarber ? $ownBarber->branches()->where('is_active', true)->orderBy('sort_order')->get() : collect();
        }

        $branch = $branches->firstWhere('public_id', $request->query('branch')) ?? $branches->first();
        $weekStart = CarbonImmutable::now($branch->timezone ?? 'UTC')->startOfWeek(CarbonImmutable::SATURDAY);

        $barbers = $branch === null ? collect() : Barber::query()
            ->whereHas('branches', fn ($q) => $q->whereKey($branch->id))
            ->when($own, fn ($q) => $q->whereKey($ownBarber->id ?? 0))
            ->orderBy('sort_order')->get();

        return Inertia::render('Schedules/Index', [
            'branches' => $branches->map(fn (Branch $b) => ['id' => $b->public_id, 'name' => $b->getTranslation('name', app()->getLocale())])->values(),
            'branch' => $branch === null ? null : [
                'id' => $branch->public_id,
                'timezone' => $branch->timezone,
                'hours' => WeekRanges::fromRows(BranchOpeningHour::query()->where('branch_id', $branch->id)->get(), 'opens_at', 'closes_at'),
            ],
            'weekStart' => $weekStart->toDateString(),
            'barbers' => $barbers->map(function (Barber $barber) use ($branch, $schedules, $weekStart) {
                $intervals = $schedules->workingIntervals($barber, $branch, $weekStart->toDateString(), $weekStart->addDays(6)->toDateString());

                return [
                    'id' => $barber->public_id,
                    'name' => $barber->getTranslation('display_name', app()->getLocale()),
                    'is_bookable' => $barber->is_bookable,
                    'hours' => WeekRanges::fromRows(BarberWorkingHour::query()->where('barber_id', $barber->id)->where('branch_id', $branch->id)->get(), 'starts_at', 'ends_at'),
                    'breaks' => WeekRanges::fromRows(BarberBreak::query()->where('barber_id', $barber->id)->where('branch_id', $branch->id)->get(), 'starts_at', 'ends_at'),
                    'overrides' => BarberScheduleOverride::query()->where('barber_id', $barber->id)->where('branch_id', $branch->id)
                        ->where('date', '>=', today($branch->timezone)->toDateString())->orderBy('date')->get()
                        ->map(fn (BarberScheduleOverride $o) => [
                            'id' => $o->public_id,
                            'date' => $o->date->toDateString(),
                            'type' => $o->type,
                            'start' => $o->starts_at ? substr($o->starts_at, 0, 5) : null,
                            'end' => $o->ends_at ? substr($o->ends_at, 0, 5) : null,
                            'reason' => $o->reason,
                        ]),
                    'week_minutes' => Intervals::totalMinutes($intervals),
                    'can_update' => Gate::allows('updateSchedule', [$barber, $branch]),
                ];
            })->values(),
        ]);
    }

    public function update(Request $request, Barber $barber, SetWeeklySchedule $set): RedirectResponse
    {
        $branch = $this->branch($request);
        Gate::authorize('updateSchedule', [$barber, $branch]);
        $data = $request->validate([...WeekRanges::rules('hours'), ...WeekRanges::rules('breaks')]);

        try {
            $set($barber, $branch, WeekRanges::normalize($data['hours']), WeekRanges::normalize($data['breaks']));
        } catch (AppException $e) {
            throw ValidationException::withMessages(['hours' => $e->getMessage()]);
        }

        return back()->with('success', __('ui.schedules.saved'));
    }

    public function storeOverride(Request $request, Barber $barber): RedirectResponse
    {
        $branch = $this->branch($request);
        Gate::authorize('updateSchedule', [$barber, $branch]);
        $data = $request->validate([
            'date' => ['required', 'date_format:Y-m-d', 'after_or_equal:today'],
            'type' => ['required', Rule::in([BarberScheduleOverride::DAY_OFF, BarberScheduleOverride::CUSTOM_HOURS])],
            'start' => ['nullable', 'required_if:type,custom_hours', 'date_format:H:i'],
            'end' => ['nullable', 'required_if:type,custom_hours', 'date_format:H:i', 'after:start'],
            'reason' => ['nullable', 'string', 'max:190'],
        ]);

        BarberScheduleOverride::query()->updateOrCreate(
            ['barber_id' => $barber->id, 'branch_id' => $branch->id, 'date' => $data['date']],
            [
                'type' => $data['type'],
                'starts_at' => $data['type'] === BarberScheduleOverride::CUSTOM_HOURS ? $data['start'] : null,
                'ends_at' => $data['type'] === BarberScheduleOverride::CUSTOM_HOURS ? $data['end'] : null,
                'reason' => $data['reason'] ?? null,
            ],
        );

        return back()->with('success', __('ui.schedules.override_saved'));
    }

    public function destroyOverride(BarberScheduleOverride $override): RedirectResponse
    {
        $barber = Barber::query()->findOrFail($override->barber_id);
        $branch = Branch::query()->findOrFail($override->branch_id);
        Gate::authorize('updateSchedule', [$barber, $branch]);
        $override->delete();

        return back()->with('success', __('ui.schedules.override_removed'));
    }

    private function branch(Request $request): Branch
    {
        $id = $request->validate(['branch' => ['required', 'string', 'size:26']])['branch'];

        return Branch::query()->where('public_id', $id)->firstOrFail();
    }
}
