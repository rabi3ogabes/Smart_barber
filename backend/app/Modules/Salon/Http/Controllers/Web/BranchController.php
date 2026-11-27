<?php

namespace App\Modules\Salon\Http\Controllers\Web;

use App\Core\Audit\AuditLogger;
use App\Core\Authorization\Access;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\SalonMembership;
use App\Core\Tenancy\Tenancy;
use App\Modules\Salon\Actions\DeactivateBranch;
use App\Modules\Salon\Actions\SaveBranch;
use App\Modules\Salon\Actions\SetOpeningHours;
use App\Modules\Salon\Models\BranchClosure;
use App\Modules\Salon\Models\BranchOpeningHour;
use App\Modules\Salon\Support\WeekRanges;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Inertia\Inertia;
use Inertia\Response;

final class BranchController
{
    public function index(Request $request): Response
    {
        Gate::authorize('viewAny', Branch::class);
        /** @var User $user */
        $user = $request->user();
        $visible = Access::branchIds($user, Tenancy::membership(), 'branch.view');

        $branches = Branch::query()
            ->when($visible !== null, fn ($q) => $q->whereIn('id', $visible))
            ->orderByDesc('is_active')->orderBy('sort_order')->orderBy('id')
            ->get();
        $hours = BranchOpeningHour::query()->whereIn('branch_id', $branches->pluck('id'))->get()->groupBy('branch_id');
        $closures = BranchClosure::query()->where('ends_on', '>=', today()->toDateString())->orderBy('starts_on')->get();
        $staff = SalonMembership::query()
            ->with('user:id,name')
            ->where('status', SalonMembership::STATUS_ACTIVE)
            ->get()
            ->flatMap(fn (SalonMembership $m) => $m->branches()->pluck('branches.id')->map(fn ($id) => ['branch_id' => $id, 'name' => $m->user?->name]))
            ->groupBy('branch_id');

        return Inertia::render('Branches/Index', [
            'branches' => $branches->map(fn (Branch $b) => [
                'id' => $b->public_id,
                'name' => $b->getTranslations('name'),
                'address' => $b->getTranslations('address'),
                'lat' => $b->lat,
                'lng' => $b->lng,
                'phone' => $b->phone,
                'timezone' => $b->timezone,
                'is_active' => $b->is_active,
                'hours' => WeekRanges::fromRows($hours->get($b->id, collect()), 'opens_at', 'closes_at'),
                'closures' => $closures->where('branch_id', $b->id)->values()->map(fn (BranchClosure $c) => $this->closure($c)),
                'staff' => $staff->get($b->id, collect())->pluck('name')->filter()->values(),
                'can_update' => Gate::allows('update', $b),
            ]),
            'salonClosures' => $closures->whereNull('branch_id')->values()->map(fn (BranchClosure $c) => $this->closure($c)),
            'can' => [
                'create' => Gate::allows('create', Branch::class),
                'changeStatus' => Access::scope($user, 'branch.manage') === 'all',
                'salonClosures' => Gate::allows('manageSalonClosures', Branch::class),
            ],
            'defaultTimezone' => Tenancy::current()?->timezone,
        ]);
    }

    public function store(Request $request, SaveBranch $save, SetOpeningHours $setHours): RedirectResponse
    {
        Gate::authorize('create', Branch::class);
        $data = $this->validated($request);
        $week = WeekRanges::normalize($request->validate(WeekRanges::rules('hours'))['hours']);

        $branch = $save(null, $data);
        $setHours($branch, $week);

        return back()->with('success', __('ui.branches.created'));
    }

    public function update(Request $request, Branch $branch, SaveBranch $save, SetOpeningHours $setHours): RedirectResponse
    {
        Gate::authorize('update', $branch);
        $data = $this->validated($request);
        $week = WeekRanges::normalize($request->validate(WeekRanges::rules('hours'))['hours']);

        $save($branch, $data);
        $setHours($branch, $week);

        return back()->with('success', __('ui.branches.saved'));
    }

    public function status(Request $request, Branch $branch, DeactivateBranch $deactivate): RedirectResponse
    {
        Gate::authorize('changeStatus', $branch);
        $active = $request->validate(['active' => ['required', 'boolean']])['active'];
        $deactivate($branch, (bool) $active);

        return back()->with('success', $active ? __('ui.branches.activated') : __('ui.branches.deactivated'));
    }

    public function storeClosure(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'branch' => ['nullable', 'string', 'size:26'],
            'starts_on' => ['required', 'date_format:Y-m-d', 'after_or_equal:today'],
            'ends_on' => ['required', 'date_format:Y-m-d', 'after_or_equal:starts_on'],
            'reason.ar' => ['nullable', 'string', 'max:120'],
            'reason.en' => ['nullable', 'string', 'max:120'],
        ]);

        $branch = $data['branch'] ? Branch::query()->where('public_id', $data['branch'])->firstOrFail() : null;
        $branch ? Gate::authorize('update', $branch) : Gate::authorize('manageSalonClosures', Branch::class);

        $closure = BranchClosure::query()->create([
            'branch_id' => $branch?->id,
            'starts_on' => $data['starts_on'],
            'ends_on' => $data['ends_on'],
            'reason' => array_filter($data['reason'] ?? []),
        ]);
        AuditLogger::record('branch_closures.created', $closure, new: ['branch' => $branch?->public_id, 'from' => $data['starts_on'], 'to' => $data['ends_on']]);

        return back()->with('success', __('ui.branches.closure_added'));
    }

    public function destroyClosure(BranchClosure $closure): RedirectResponse
    {
        $closure->branch ? Gate::authorize('update', $closure->branch) : Gate::authorize('manageSalonClosures', Branch::class);
        AuditLogger::record('branch_closures.deleted', $closure, ['from' => $closure->starts_on->toDateString(), 'to' => $closure->ends_on->toDateString()]);
        $closure->delete();

        return back()->with('success', __('ui.branches.closure_removed'));
    }

    /**
     * @return array<string, mixed>
     */
    private function validated(Request $request): array
    {
        $data = $request->validate([
            'name.ar' => ['required', 'string', 'max:120'],
            'name.en' => ['required', 'string', 'max:120'],
            'address.ar' => ['nullable', 'string', 'max:255'],
            'address.en' => ['nullable', 'string', 'max:255'],
            'lat' => ['nullable', 'numeric', 'between:-90,90', 'required_with:lng'],
            'lng' => ['nullable', 'numeric', 'between:-180,180', 'required_with:lat'],
            'phone' => ['nullable', 'string', 'regex:/^\+[1-9]\d{7,14}$/'],
            'timezone' => ['required', 'timezone:all'],
        ]);
        $data['address'] = array_filter($data['address'] ?? []);

        return $data;
    }

    /**
     * @return array<string, mixed>
     */
    private function closure(BranchClosure $c): array
    {
        return [
            'id' => $c->public_id,
            'starts_on' => $c->starts_on->toDateString(),
            'ends_on' => $c->ends_on->toDateString(),
            'reason' => $c->getTranslations('reason'),
        ];
    }
}
