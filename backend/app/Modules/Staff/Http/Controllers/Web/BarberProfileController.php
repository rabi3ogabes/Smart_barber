<?php

namespace App\Modules\Staff\Http\Controllers\Web;

use App\Modules\Staff\Actions\UpdateBarberProfile;
use App\Modules\Staff\Models\Barber;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Validation\Rule;

final class BarberProfileController
{
    public function update(Request $request, Barber $barber, UpdateBarberProfile $update): RedirectResponse
    {
        Gate::authorize('updateProfile', $barber);
        $data = $request->validate([
            'display_name.ar' => ['required', 'string', 'max:80'],
            'display_name.en' => ['required', 'string', 'max:80'],
            'bio.ar' => ['nullable', 'string', 'max:500'],
            'bio.en' => ['nullable', 'string', 'max:500'],
            'specialties' => ['present', 'array', 'max:6'],
            'specialties.*' => [Rule::in(Barber::SPECIALTIES)],
            'years_experience' => ['nullable', 'integer', 'min:0', 'max:60'],
            'is_bookable' => ['sometimes', 'boolean'],
            'sort_order' => ['sometimes', 'integer', 'min:0', 'max:999'],
            'photo' => ['nullable', 'image', 'mimes:jpg,jpeg,png,webp', 'max:4096', 'dimensions:min_width=200,min_height=200'],
        ]);

        // Bookable and order are for managers; a barber editing their own profile cannot change them.
        if (! Gate::allows('manage', $barber)) {
            unset($data['is_bookable'], $data['sort_order']);
        }
        $data['bio'] = array_filter($data['bio'] ?? []);
        unset($data['photo']);

        $update($barber, $data, $request->file('photo'));

        return back()->with('success', __('ui.staff.profile_saved'));
    }
}
