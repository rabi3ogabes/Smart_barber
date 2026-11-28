<?php

namespace App\Modules\Salon\Http\Controllers\Web;

use App\Core\Authorization\Access;
use App\Core\Identity\Models\User;
use App\Core\Settings\Settings;
use App\Core\Tenancy\Tenancy;
use App\Modules\Salon\Actions\UpdateSalonProfile;
use App\Modules\Salon\Actions\UploadSalonImage;
use App\Modules\Salon\Http\Controllers\Api\SalonDirectoryController;
use App\Modules\Salon\Support\MediaUrl;
use App\Modules\Salon\Support\SalonQr;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Inertia\Response;

final class SalonSettingsController
{
    public function show(Request $request): Response
    {
        $salon = Tenancy::current();
        abort_if($salon === null, 404);
        /** @var User $user */
        $user = $request->user();

        return Inertia::render('Settings/Salon', [
            'profile' => [
                'name' => $salon->getTranslations('name'),
                'legal_name' => $salon->legal_name,
                'currency' => $salon->currency,
                'timezone' => $salon->timezone,
                'default_locale' => $salon->default_locale,
                'tax_number' => $salon->tax_number,
                'tax_rate' => number_format($salon->tax_rate_bp / 100, 2, '.', ''),
                'prices_include_tax' => $salon->prices_include_tax,
                'contact_phone' => $salon->contact_phone,
                'contact_email' => $salon->contact_email,
                'social_links' => $salon->social_links ?? (object) [],
                'lead_time_minutes' => $salon->lead_time_minutes,
                'max_days_ahead' => $salon->max_days_ahead,
                'cancellation_window_minutes' => $salon->cancellation_window_minutes,
                'no_show_fee' => $salon->no_show_fee_amount->toDecimal(),
                'logo_url' => MediaUrl::for($salon->logo_media_id),
                'cover_url' => MediaUrl::for($salon->cover_media_id),
                'listing_enabled' => (bool) Settings::get($salon, SalonDirectoryController::LISTING_KEY, false),
                'app_code' => $salon->slug,
                'app_link' => SalonQr::link($salon->slug),
                'app_qr' => SalonQr::svg($salon->slug),
            ],
            'timezones' => ['Asia/Qatar', 'Asia/Riyadh', 'Asia/Dubai', 'Asia/Kuwait', 'Asia/Bahrain', 'Asia/Muscat'],
            'canUpdate' => Access::scope($user, 'salon.settings.update') !== null,
        ]);
    }

    public function update(Request $request, UpdateSalonProfile $update): RedirectResponse
    {
        $this->authorizeUpdate($request);
        $data = $request->validate([
            'name.ar' => ['required', 'string', 'max:120'],
            'name.en' => ['required', 'string', 'max:120'],
            'legal_name' => ['nullable', 'string', 'max:190'],
            'timezone' => ['required', 'timezone:all'],
            'default_locale' => ['required', Rule::in(config('smartbarber.locales'))],
            'tax_number' => ['nullable', 'string', 'max:50'],
            'tax_rate' => ['required', 'numeric', 'min:0', 'max:30', 'decimal:0,2'],
            'prices_include_tax' => ['required', 'boolean'],
            'contact_phone' => ['nullable', 'string', 'regex:/^\+[1-9]\d{7,14}$/'],
            'contact_email' => ['nullable', 'email', 'max:190'],
            'social_links' => ['nullable', 'array'],
            'social_links.instagram' => ['nullable', 'url', 'max:255'],
            'social_links.tiktok' => ['nullable', 'url', 'max:255'],
            'social_links.snapchat' => ['nullable', 'url', 'max:255'],
            'social_links.website' => ['nullable', 'url', 'max:255'],
            'lead_time_minutes' => ['required', 'integer', 'min:0', 'max:10080'],
            'max_days_ahead' => ['required', 'integer', 'min:1', 'max:365'],
            'cancellation_window_minutes' => ['required', 'integer', 'min:0', 'max:10080'],
            'no_show_fee' => ['required', 'numeric', 'min:0', 'max:100000', 'decimal:0,3'],
            'listing_enabled' => ['sometimes', 'boolean'],
        ]);
        $salon = Tenancy::current() ?? abort(404);
        if (array_key_exists('listing_enabled', $data)) {
            Settings::set($salon, SalonDirectoryController::LISTING_KEY, (bool) $data['listing_enabled']);
            unset($data['listing_enabled']);
        }

        $update($salon, $data);

        return back()->with('success', __('ui.settings.saved'));
    }

    public function uploadImage(Request $request, string $kind, UploadSalonImage $upload): RedirectResponse
    {
        $this->authorizeUpdate($request);
        abort_unless(in_array($kind, ['logo', 'cover'], true), 404);
        $request->validate(['image' => ['required', 'image', 'mimes:jpg,jpeg,png,webp', 'max:4096', 'dimensions:min_width=200,min_height=200']]);

        $upload(Tenancy::current() ?? abort(404), $kind, $request->file('image'));

        return back()->with('success', __('ui.settings.image_saved'));
    }

    private function authorizeUpdate(Request $request): void
    {
        /** @var User $user */
        $user = $request->user();
        abort_unless(Access::scope($user, 'salon.settings.update') !== null, 403);
    }
}
