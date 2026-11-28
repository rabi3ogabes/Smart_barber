<?php

namespace App\Core\Identity\Jobs;

use App\Core\Contracts\StorageService;
use App\Core\Identity\Actions\UploadAvatar;
use App\Core\Identity\Models\AccountMedia;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Media\Media;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Actions\CancelBooking;
use App\Modules\Booking\Enums\BookingStatus;
use App\Modules\Booking\Models\Booking;
use App\Modules\Customer\Models\Customer;
use App\Modules\Review\Models\BookingReview;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Support\Facades\DB;

/**
 * Spec-review item 12, run after a deletion request:
 *  - upcoming bookings are cancelled (the chair is freed for others);
 *  - every linked salon `customers` row: name → "Deleted customer", phone → a one-way hash,
 *    email, birthday, notes and tags cleared, link to the account removed;
 *  - personal content: booking notes and review comments cleared (ratings stay, anonymous);
 *    photos marked as personal data (AI Studio, hair history — later phases) are deleted;
 *  - personal values in that profile's audit trail are redacted;
 *  - the account itself is anonymised and soft-deleted; its avatar is deleted.
 * Bookings, dues, invoices and payments stay: they keep their own line and price snapshots.
 * Idempotent: running it twice finds nothing left to change.
 */
final class AnonymiseCustomerAccount implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable;

    public const DELETED_NAME = 'Deleted customer';

    /** Customer attributes that may appear in audit rows and must not survive the erasure. */
    private const PII = ['name', 'phone', 'email', 'birthday', 'internal_notes', 'tags'];

    public function __construct(public readonly int $accountId) {}

    public function handle(CancelBooking $cancel, StorageService $storage): void
    {
        $account = CustomerAccount::withTrashed()->find($this->accountId);
        if ($account === null || $account->deletion_requested_at === null) {
            return;
        }

        $profiles = Tenancy::bypass(fn () => Customer::withTrashed()->where('customer_account_id', $account->id)->get());
        foreach ($profiles as $profile) {
            $salon = Salon::query()->find($profile->salon_id);
            if ($salon !== null) {
                Tenancy::runAs($salon, fn () => $this->anonymiseProfile($profile, $cancel, $storage));
            }
        }

        foreach (AccountMedia::query()->where('customer_account_id', $account->id)->get() as $media) {
            UploadAvatar::remove($media);
        }

        $account->forceFill([
            'phone' => self::hashPhone($account->phone, 'acct'),
            'name' => null,
            'email' => null,
            'avatar_media_id' => null,
            'notification_preferences' => null,
            'anonymised_at' => now(),
        ])->save();
        if (! $account->trashed()) {
            $account->delete();
        }
    }

    private function anonymiseProfile(Customer $profile, CancelBooking $cancel, StorageService $storage): void
    {
        $upcoming = Booking::query()->where('customer_id', $profile->id)
            ->whereIn('status', [BookingStatus::Pending->value, BookingStatus::Confirmed->value])
            ->where('starts_at', '>', now())->get();
        foreach ($upcoming as $booking) {
            $cancel($booking, null, 'account_deleted', overridePolicy: true);
        }

        DB::transaction(function () use ($profile, $storage): void {
            // Query-level updates: the model's audit hook would otherwise copy the old values into a new audit row.
            Customer::withTrashed()->whereKey($profile->id)->update([
                'name' => self::DELETED_NAME,
                'phone' => self::hashPhone($profile->phone, (string) $profile->salon_id),
                'email' => null,
                'birthday' => null,
                'internal_notes' => null,
                'tags' => null,
                'customer_account_id' => null,
                'updated_at' => now(),
            ]);
            Booking::query()->where('customer_id', $profile->id)->update(['customer_notes' => null]);
            BookingReview::query()->where('customer_id', $profile->id)->update(['comment' => null]);

            Media::query()->where('owner_type', $profile->getMorphClass())->where('owner_id', $profile->id)->where('contains_pii', true)
                ->get()->each(fn (Media $m) => $storage->delete($m));

            DB::table('audit_logs')->where('auditable_type', $profile->getMorphClass())->where('auditable_id', $profile->id)
                ->orderBy('id')->get(['id', 'old_values', 'new_values'])
                ->each(function (object $row): void {
                    DB::table('audit_logs')->where('id', $row->id)->update([
                        'old_values' => self::redact($row->old_values),
                        'new_values' => self::redact($row->new_values),
                    ]);
                });
        });
    }

    /** "del-" + 16 hex: fits the 20-char column, stays unique per salon, cannot be reversed without the app key. */
    public static function hashPhone(string $phone, string $salt): string
    {
        return str_starts_with($phone, 'del-') ? $phone : 'del-'.substr(hash_hmac('sha256', $phone.'|'.$salt, (string) config('app.key')), 0, 16);
    }

    private static function redact(?string $json): ?string
    {
        if ($json === null) {
            return null;
        }
        $values = json_decode($json, true);
        if (! is_array($values)) {
            return $json;
        }
        foreach (self::PII as $key) {
            if (array_key_exists($key, $values)) {
                $values[$key] = '[erased]';
            }
        }

        return (string) json_encode($values, JSON_UNESCAPED_UNICODE);
    }
}
