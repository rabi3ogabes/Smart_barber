<?php

namespace App\Modules\Customer\Actions;

use App\Core\Identity\Models\CustomerAccount;
use App\Modules\Customer\Models\Customer;
use Illuminate\Database\UniqueConstraintViolationException;

/**
 * One customer per salon and phone. Returns the existing profile when the phone is known
 * (filling a missing account link), otherwise creates one. Safe against concurrent creates.
 */
final class FindOrCreateCustomer
{
    public function __invoke(string $phone, string $name, string $source = 'dashboard', ?CustomerAccount $account = null, ?string $locale = null): Customer
    {
        $existing = $account !== null ? Customer::query()->where('customer_account_id', $account->id)->first() : null;
        $existing ??= Customer::query()->where('phone', $phone)->first();

        if ($existing !== null) {
            if ($account !== null && $existing->customer_account_id === null) {
                $existing->forceFill(['customer_account_id' => $account->id])->save();
            }

            return $existing;
        }

        try {
            return Customer::query()->create([
                'customer_account_id' => $account?->id,
                'name' => $name,
                'phone' => $phone,
                'source' => $source,
                'locale' => $locale ?? $account->locale ?? 'ar',
            ]);
        } catch (UniqueConstraintViolationException) {
            return Customer::query()->where('phone', $phone)->firstOrFail();
        }
    }
}
