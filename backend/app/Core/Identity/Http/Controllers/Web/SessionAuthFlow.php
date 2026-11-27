<?php

namespace App\Core\Identity\Http\Controllers\Web;

use App\Core\Audit\AuditLogger;
use App\Core\Identity\Services\TwoFactor;
use App\Core\Identity\Services\TwoFactorUser;
use Illuminate\Contracts\Auth\Authenticatable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

/**
 * Session sign-in shared by the salon dashboard (guard web) and the Super Admin console
 * (guard platform): password → TOTP challenge → mandatory enrolment when required.
 */
abstract class SessionAuthFlow
{
    public function __construct(protected readonly TwoFactor $twoFactor) {}

    abstract protected function guard(): string;

    /** Route name prefix, '' for the dashboard and 'platform.' for the console. */
    abstract protected function routePrefix(): string;

    /** Inertia page prefix, 'Auth' or 'Platform/Auth'. */
    abstract protected function pagePrefix(): string;

    abstract protected function findUser(string $email): (Authenticatable&Model&TwoFactorUser)|null;

    abstract protected function findUserById(int $id): (Authenticatable&Model&TwoFactorUser)|null;

    /**
     * Extra checks after the password is verified (e.g. membership in this salon).
     * Return an error message to refuse sign-in.
     */
    protected function refuse(Authenticatable&Model $user): ?string
    {
        return null;
    }

    public function showLogin(): Response
    {
        return Inertia::render($this->pagePrefix().'/Login');
    }

    public function login(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'email' => ['required', 'email', 'max:190'],
            'password' => ['required', 'string', 'max:200'],
            'remember' => ['boolean'],
        ]);

        $throttleKey = $this->guard().'-login:'.strtolower($data['email']).'|'.$request->ip();
        if (RateLimiter::tooManyAttempts($throttleKey, 5)) {
            throw ValidationException::withMessages(['email' => __('errors.RATE_LIMITED')]);
        }

        $user = $this->findUser(strtolower($data['email']));
        if ($user === null || ! Hash::check($data['password'], $user->getAuthPassword())) {
            RateLimiter::hit($throttleKey, 60);
            throw ValidationException::withMessages(['email' => __('errors.INVALID_CREDENTIALS')]);
        }

        if (($reason = $this->refuse($user)) !== null) {
            RateLimiter::hit($throttleKey, 60);
            throw ValidationException::withMessages(['email' => $reason]);
        }

        RateLimiter::clear($throttleKey);

        if ($user->hasTwoFactorEnabled()) {
            $request->session()->put($this->pendingKey(), ['id' => $user->getKey(), 'remember' => (bool) ($data['remember'] ?? false)]);

            return redirect()->route($this->routePrefix().'two-factor.challenge');
        }

        return $this->completeLogin($request, $user, (bool) ($data['remember'] ?? false));
    }

    public function showChallenge(Request $request): Response|RedirectResponse
    {
        if (! $request->session()->has($this->pendingKey())) {
            return redirect()->route($this->routePrefix().'login');
        }

        return Inertia::render($this->pagePrefix().'/TwoFactorChallenge');
    }

    public function challenge(Request $request): RedirectResponse
    {
        $data = $request->validate(['code' => ['required', 'string', 'max:20']]);
        $pending = $request->session()->get($this->pendingKey());

        if (! is_array($pending)) {
            return redirect()->route($this->routePrefix().'login');
        }

        $throttleKey = $this->guard().'-2fa:'.$pending['id'];
        if (RateLimiter::tooManyAttempts($throttleKey, 5)) {
            $request->session()->forget($this->pendingKey());
            throw ValidationException::withMessages(['code' => __('errors.RATE_LIMITED')]);
        }

        $user = $this->findUserById((int) $pending['id']);
        if ($user === null || ! $this->twoFactor->verify($user, $data['code'])) {
            RateLimiter::hit($throttleKey, 300);
            throw ValidationException::withMessages(['code' => __('errors.TWO_FACTOR_INVALID')]);
        }

        RateLimiter::clear($throttleKey);
        $request->session()->forget($this->pendingKey());

        return $this->completeLogin($request, $user, (bool) $pending['remember']);
    }

    public function showSetup(Request $request): Response|RedirectResponse
    {
        /** @var Authenticatable&Model&TwoFactorUser $user */
        $user = $request->user($this->guard());

        if ($user->hasTwoFactorEnabled()) {
            return redirect('/');
        }

        $secret = $user->two_factor_secret ?? $this->twoFactor->begin($user);

        return Inertia::render($this->pagePrefix().'/TwoFactorSetup', [
            'qr' => $this->twoFactor->qrSvg((string) $user->getAttribute('email'), $secret),
            'secret' => $secret,
            'required' => $user->requiresTwoFactor(),
        ]);
    }

    public function confirmSetup(Request $request): Response|RedirectResponse
    {
        $data = $request->validate(['code' => ['required', 'digits:6']]);

        /** @var Authenticatable&Model&TwoFactorUser $user */
        $user = $request->user($this->guard());
        $codes = $this->twoFactor->confirm($user, $data['code']);

        if ($codes === null) {
            throw ValidationException::withMessages(['code' => __('errors.TWO_FACTOR_INVALID')]);
        }

        AuditLogger::record('auth.two_factor_enabled', $user, actor: $user);

        return Inertia::render($this->pagePrefix().'/RecoveryCodes', ['codes' => $codes]);
    }

    public function logout(Request $request): RedirectResponse
    {
        Auth::guard($this->guard())->logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()->route($this->routePrefix().'login');
    }

    protected function completeLogin(Request $request, Authenticatable&Model $user, bool $remember): RedirectResponse
    {
        Auth::guard($this->guard())->login($user, $remember);
        $request->session()->regenerate();
        $user->forceFill(['last_login_at' => now()])->save();
        AuditLogger::record('auth.'.$this->guard().'_login', $user, actor: $user);

        return redirect()->intended('/');
    }

    private function pendingKey(): string
    {
        return 'login.pending.'.$this->guard();
    }
}
