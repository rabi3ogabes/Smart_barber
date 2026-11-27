<?php

namespace App\Core\Identity\Http\Controllers\Web;

use App\Core\Authorization\Access;
use App\Core\Identity\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

final class PreferencesController
{
    public function locale(Request $request): RedirectResponse
    {
        $data = $request->validate(['locale' => ['required', Rule::in(config('smartbarber.locales'))]]);

        $request->session()->put('locale', $data['locale']);
        $user = $request->user();
        if ($user instanceof User) {
            $user->forceFill(['locale' => $data['locale']])->save();
        }

        return back();
    }

    public function branch(Request $request): RedirectResponse
    {
        $data = $request->validate(['branch' => ['required', 'string', 'size:26']]);

        /** @var User $user */
        $user = $request->user();
        $branch = Access::visibleBranches($user)->firstWhere('public_id', $data['branch']);
        abort_if($branch === null, 404);

        $request->session()->put('branch_id', $branch->public_id);

        return back();
    }
}
