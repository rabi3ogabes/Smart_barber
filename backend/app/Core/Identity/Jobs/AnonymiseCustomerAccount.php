<?php

namespace App\Core\Identity\Jobs;

use App\Core\Identity\Actions\UploadAvatar;
use App\Core\Identity\Events\CustomerAccountErasing;
use App\Core\Identity\Models\AccountMedia;
use App\Core\Identity\Models\CustomerAccount;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;

/**
 * Spec-review item 12, run after a deletion request. First CustomerAccountErasing lets each module
 * erase what it owns while the salon profiles are still linked (Customer anonymises them; Booking
 * frees upcoming chairs and clears notes and review comments). Then the account itself is anonymised
 * and soft-deleted and its avatar removed. Invoices and payments keep their own snapshots.
 * Idempotent: running it twice finds nothing left to change.
 */
final class AnonymiseCustomerAccount implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable;

    public function __construct(public readonly int $accountId) {}

    public function handle(): void
    {
        $account = CustomerAccount::withTrashed()->find($this->accountId);
        if ($account === null || $account->deletion_requested_at === null) {
            return;
        }

        event(new CustomerAccountErasing($account));

        foreach (AccountMedia::query()->where('customer_account_id', $account->id)->get() as $media) {
            UploadAvatar::remove($media);
        }

        $account->forceFill([
            'phone' => str_starts_with($account->phone, 'del-') ? $account->phone : 'del-'.substr(hash_hmac('sha256', $account->phone.'|acct', (string) config('app.key')), 0, 16),
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
}
