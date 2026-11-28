<?php

namespace App\Modules\Customer\Actions;

use App\Core\Contracts\StorageService;
use App\Core\Media\Media;
use App\Modules\Customer\Events\CustomerAnonymising;
use App\Modules\Customer\Models\Customer;
use Illuminate\Support\Facades\DB;

/**
 * Anonymises one salon profile (spec-review item 12): name → "Deleted customer", phone → a one-way
 * hash, contact details, notes and tags cleared, the link to the app account removed, personal
 * photos deleted and personal values in its audit trail redacted. Must run inside the profile's
 * tenant. Idempotent.
 */
final class AnonymiseCustomer
{
    public const DELETED_NAME = 'Deleted customer';

    /** Customer attributes that may appear in audit rows and must not survive the erasure. */
    private const PII = ['name', 'phone', 'email', 'birthday', 'internal_notes', 'tags'];

    public function __construct(private readonly StorageService $storage) {}

    public function __invoke(Customer $profile): void
    {
        event(new CustomerAnonymising($profile));

        DB::transaction(function () use ($profile): void {
            // Query-level update: the model's audit hook would otherwise copy the old values into a new audit row.
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

            // Personal photos (AI Studio, hair history — later phases) are flagged contains_pii.
            Media::query()->where('owner_type', $profile->getMorphClass())->where('owner_id', $profile->id)->where('contains_pii', true)
                ->get()->each(fn (Media $m) => $this->storage->delete($m));

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

    /** "del-" + 16 hex: fits the 20-char column, stays unique, cannot be reversed without the app key. */
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
