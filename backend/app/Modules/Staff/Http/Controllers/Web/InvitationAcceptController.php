<?php

namespace App\Modules\Staff\Http\Controllers\Web;

use App\Core\Audit\AuditLogger;
use App\Core\Exceptions\AppException;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Tenancy;
use App\Modules\Staff\Actions\AcceptInvitation;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Password;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

/**
 * Public invitation page on the salon sub-domain. An existing account proves ownership with
 * its password; otherwise a new account is created. Then the membership is added and the
 * person is signed in (owners/GMs are then sent to 2FA setup by the usual middleware).
 */
final class InvitationAcceptController
{
    public function show(string $token): Response
    {
        $invitation = AcceptInvitation::find($token);
        $valid = $invitation !== null && $invitation->isPending();
        $account = $valid ? AcceptInvitation::accountFor($invitation) : null;

        return Inertia::render('Invitations/Accept', [
            'token' => $token,
            'valid' => $valid,
            'invitation' => ! $valid ? null : [
                'name' => $invitation->name,
                'email' => $invitation->email,
                'phone' => $invitation->phone,
                'roles' => $invitation->role_names,
                'branches' => Branch::query()->whereIn('id', $invitation->branch_ids)->get()->map(fn (Branch $b) => $b->getTranslation('name', app()->getLocale()))->values(),
                'expires_at' => $invitation->expires_at->toIso8601String(),
            ],
            'hasAccount' => $account !== null,
        ]);
    }

    public function accept(Request $request, string $token, AcceptInvitation $accept): RedirectResponse
    {
        $key = 'invite-accept:'.$request->ip();
        if (RateLimiter::tooManyAttempts($key, 10)) {
            throw ValidationException::withMessages(['password' => __('errors.RATE_LIMITED')]);
        }
        RateLimiter::hit($key, 600);

        $invitation = AcceptInvitation::find($token);
        if ($invitation === null || ! $invitation->isPending()) {
            return redirect()->to("/invitations/{$token}");
        }

        $account = AcceptInvitation::accountFor($invitation);

        if ($account !== null) {
            $data = $request->validate(['password' => ['required', 'string', 'max:200']]);
            if (! Hash::check($data['password'], $account->getAuthPassword())) {
                throw ValidationException::withMessages(['password' => __('errors.INVALID_CREDENTIALS')]);
            }
            $user = $account;
        } else {
            $data = $request->validate([
                'name' => ['required', 'string', 'max:120'],
                'email' => [$invitation->email ? 'nullable' : 'required', 'email', 'max:190', Rule::unique('users', 'email')],
                'password' => ['required', 'confirmed', Password::min(10)->mixedCase()->numbers()],
            ]);
            $user = DB::transaction(fn () => User::query()->create([
                'name' => $data['name'],
                'email' => $invitation->email ?? strtolower((string) $data['email']),
                'phone' => $invitation->phone,
                'password' => $data['password'],
                'locale' => app()->getLocale(),
            ]));
        }

        try {
            $accept($invitation, $user);
        } catch (AppException $e) {
            throw ValidationException::withMessages(['password' => $e->getMessage()]);
        }

        AuditLogger::record('staff.invitation_accepted', $invitation, new: ['user' => $user->public_id], actor: $user);
        Auth::guard('web')->login($user);
        $request->session()->regenerate();
        RateLimiter::clear($key);

        return redirect('/')->with('success', __('ui.invitations.welcome', ['salon' => Tenancy::current()?->getTranslation('name', app()->getLocale())]));
    }
}
