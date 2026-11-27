<?php

namespace App\Modules\Staff\Http\Controllers\Web;

use App\Core\Authorization\Access;
use App\Core\Exceptions\AppException;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\SalonMembership;
use App\Core\Tenancy\Tenancy;
use App\Modules\Salon\Support\MediaUrl;
use App\Modules\Staff\Actions\ChangeMemberStatus;
use App\Modules\Staff\Actions\InviteStaff;
use App\Modules\Staff\Actions\UpdateMemberAccess;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\StaffInvitation;
use App\Modules\Staff\Support\RoleRules;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

final class StaffController
{
    public function index(Request $request): Response
    {
        Gate::authorize('viewAny', SalonMembership::class);
        /** @var User $actor */
        $actor = $request->user();
        $visibleBranchIds = Access::branchIds($actor, Tenancy::membership(), 'staff.view');
        $branches = Branch::query()->orderBy('sort_order')->orderBy('id')->get();
        $branchKey = $branches->pluck('public_id', 'id');

        $members = SalonMembership::query()
            ->with(['user', 'branches'])
            ->whereIn('status', [SalonMembership::STATUS_ACTIVE, SalonMembership::STATUS_DEACTIVATED])
            ->get()
            ->filter(fn (SalonMembership $m) => $visibleBranchIds === null || $m->branches->pluck('id')->intersect($visibleBranchIds)->isNotEmpty());
        $barbers = Barber::query()->whereIn('user_id', $members->pluck('user_id'))->get()->keyBy('user_id');

        $roleTable = config('permission.table_names.model_has_roles');
        $roles = DB::table($roleTable)
            ->join('roles', 'roles.id', '=', "{$roleTable}.role_id")
            ->where("{$roleTable}.salon_id", Tenancy::id())->where("{$roleTable}.model_type", 'user')
            ->get(['model_id', 'roles.name'])->groupBy('model_id');

        $invitations = StaffInvitation::query()->whereNull('accepted_at')->whereNull('revoked_at')->latest()->get()
            ->filter(fn (StaffInvitation $i) => $visibleBranchIds === null || array_intersect($i->branch_ids, $visibleBranchIds) !== []);

        return Inertia::render('Staff/Index', [
            'members' => $members->sortBy(fn (SalonMembership $m) => [$m->status !== 'active', $m->user?->name])->values()->map(function (SalonMembership $m) use ($actor, $barbers, $roles) {
                $barber = $barbers->get($m->user_id);

                return [
                    'id' => $m->public_id,
                    'name' => $m->user?->name,
                    'email' => $m->user?->email,
                    'phone' => $m->user?->phone,
                    'status' => $m->status,
                    'joined_at' => $m->joined_at?->toDateString(),
                    'roles' => $roles->get($m->user_id, collect())->pluck('name')->values(),
                    'branches' => $m->branches->pluck('public_id')->values(),
                    'is_me' => $m->user_id === $actor->id,
                    'barber' => $barber === null ? null : [
                        'id' => $barber->public_id,
                        'display_name' => $barber->getTranslations('display_name'),
                        'bio' => $barber->getTranslations('bio'),
                        'specialties' => $barber->specialties ?? [],
                        'years_experience' => $barber->years_experience,
                        'is_bookable' => $barber->is_bookable,
                        'sort_order' => $barber->sort_order,
                        'photo_url' => MediaUrl::for($barber->photo_media_id),
                        'can_update' => Gate::allows('updateProfile', $barber),
                        'can_manage' => Gate::allows('manage', $barber),
                    ],
                    'can' => [
                        'update' => Gate::allows('update', $m),
                        'assignRoles' => Gate::allows('assignRoles', $m),
                        'changeStatus' => Gate::allows('changeStatus', $m),
                    ],
                ];
            }),
            'invitations' => $invitations->values()->map(fn (StaffInvitation $i) => [
                'id' => $i->public_id,
                'contact' => $i->email ?? $i->phone,
                'name' => $i->name,
                'roles' => $i->role_names,
                'branches' => collect($i->branch_ids)->map(fn ($id) => $branchKey->get($id))->filter()->values(),
                'expires_at' => $i->expires_at->toIso8601String(),
                'expired' => $i->expires_at->isPast(),
            ]),
            'branches' => $branches->map(fn (Branch $b) => ['id' => $b->public_id, 'name' => $b->getTranslation('name', app()->getLocale()), 'is_active' => $b->is_active])->values(),
            'assignableRoles' => RoleRules::assignableBy($actor),
            'salonWideRoles' => RoleRules::SALON_WIDE,
            'specialties' => Barber::SPECIALTIES,
            'can' => ['invite' => Gate::allows('invite', SalonMembership::class)],
        ]);
    }

    public function invite(Request $request, InviteStaff $invite): RedirectResponse
    {
        Gate::authorize('invite', SalonMembership::class);
        $data = $request->validate([
            'name' => ['nullable', 'string', 'max:120'],
            'email' => ['nullable', 'required_without:phone', 'email', 'max:190'],
            'phone' => ['nullable', 'required_without:email', 'regex:/^\+[1-9]\d{7,14}$/'],
            'roles' => ['required', 'array', 'min:1'],
            'roles.*' => ['string'],
            'branches' => ['present', 'array'],
            'branches.*' => ['string', 'size:26'],
        ]);

        $this->rethrowAsValidation(fn () => $invite($request->user(), $data), 'roles');

        return back()->with('success', __('ui.staff.invited'));
    }

    public function resendInvitation(StaffInvitation $invitation, InviteStaff $invite): RedirectResponse
    {
        Gate::authorize('invite', SalonMembership::class);
        $this->authorizeInvitation($invitation);
        $invite->resend($invitation);

        return back()->with('success', __('ui.staff.invitation_resent'));
    }

    public function revokeInvitation(StaffInvitation $invitation): RedirectResponse
    {
        Gate::authorize('invite', SalonMembership::class);
        $this->authorizeInvitation($invitation);
        $invitation->forceFill(['revoked_at' => now()])->save();

        return back()->with('success', __('ui.staff.invitation_revoked'));
    }

    public function updateAccess(Request $request, SalonMembership $member, UpdateMemberAccess $update): RedirectResponse
    {
        // Branch moves need staff.update; changing roles additionally needs staff.roles.assign
        // (checked in UpdateMemberAccess, which knows the old roles).
        Gate::authorize('update', $member);
        $data = $request->validate([
            'roles' => ['required', 'array', 'min:1'],
            'roles.*' => ['string'],
            'branches' => ['present', 'array'],
            'branches.*' => ['string', 'size:26'],
        ]);

        $this->rethrowAsValidation(fn () => $update($request->user(), $member, $data['roles'], $data['branches']), 'roles');

        return back()->with('success', __('ui.staff.access_saved'));
    }

    public function status(Request $request, SalonMembership $member, ChangeMemberStatus $change): RedirectResponse
    {
        Gate::authorize('changeStatus', $member);
        $active = (bool) $request->validate(['active' => ['required', 'boolean']])['active'];
        $this->rethrowAsValidation(fn () => $change($request->user(), $member, $active), 'status');

        return back()->with('success', $active ? __('ui.staff.reactivated') : __('ui.staff.deactivated'));
    }

    private function authorizeInvitation(StaffInvitation $invitation): void
    {
        /** @var User $actor */
        $actor = request()->user();
        abort_unless($invitation->branch_ids === [] ? Access::scope($actor, 'staff.invite') === 'all' : Access::allowsInBranches($actor, 'staff.invite', $invitation->branch_ids), 403);
    }

    /**
     * Business errors become form errors on the dashboard.
     */
    private function rethrowAsValidation(callable $action, string $field): void
    {
        try {
            $action();
        } catch (AppException $e) {
            throw ValidationException::withMessages($e->errors !== [] ? $e->errors : [$field => $e->getMessage()]);
        }
    }
}
