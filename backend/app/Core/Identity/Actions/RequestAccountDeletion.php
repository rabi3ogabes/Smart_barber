<?php

namespace App\Core\Identity\Actions;

use App\Core\Audit\AuditLogger;
use App\Core\Identity\Jobs\AnonymiseCustomerAccount;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Identity\Models\Device;
use App\Core\Identity\Models\PersonalAccessToken;
use App\Core\Identity\Models\RefreshToken;
use Illuminate\Support\Facades\DB;

/**
 * Store-compliant account deletion (spec-review item 12). Immediately: sign out everywhere (all
 * tokens and push devices). Then a queued job anonymises the account and every salon profile
 * linked to it. Financial records keep their own snapshots and are never touched.
 */
final class RequestAccountDeletion
{
    public function __invoke(CustomerAccount $account, ?string $reason = null): void
    {
        if ($account->deletion_requested_at !== null) {
            return; // already requested: repeating it is harmless
        }

        DB::transaction(function () use ($account): void {
            $account->forceFill(['deletion_requested_at' => now()])->save();
            PersonalAccessToken::query()->where('tokenable_type', $account->getMorphClass())->where('tokenable_id', $account->id)->delete();
            RefreshToken::query()->where('tokenable_type', $account->getMorphClass())->where('tokenable_id', $account->id)->whereNull('revoked_at')->update(['revoked_at' => now()]);
            Device::query()->where('owner_type', $account->getMorphClass())->where('owner_id', $account->id)->delete();
        });
        AuditLogger::record('customer_account.deletion_requested', $account, [], ['reason' => $reason], salonId: null, actor: $account);

        AnonymiseCustomerAccount::dispatch($account->id)->afterCommit();
    }
}
