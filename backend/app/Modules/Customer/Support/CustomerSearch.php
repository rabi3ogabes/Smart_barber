<?php

namespace App\Modules\Customer\Support;

use App\Core\Authorization\Access;
use App\Core\Identity\Models\User;
use App\Modules\Customer\Models\Customer;

/**
 * Name/phone search for the booking drawer and the staff app. Barbers (no contact permission)
 * see masked numbers. At most 10 results.
 */
final class CustomerSearch
{
    /**
     * @return list<array{id: string, name: string, phone: string, visits: int, no_shows: int}>
     */
    public static function run(User $user, string $q): array
    {
        $q = trim($q);
        if (mb_strlen($q) < 2) {
            return [];
        }
        $digits = (string) preg_replace('/\D/', '', strtr($q, ['٠' => '0', '١' => '1', '٢' => '2', '٣' => '3', '٤' => '4', '٥' => '5', '٦' => '6', '٧' => '7', '٨' => '8', '٩' => '9']));
        $contact = Access::scope($user, 'customer.contact.view') !== null;

        return Customer::query()
            ->where(fn ($w) => $w->where('name', 'like', '%'.addcslashes($q, '%_').'%')
                ->when(strlen($digits) >= 3, fn ($w) => $w->orWhere('phone', 'like', '%'.$digits.'%')))
            ->orderByDesc('last_visit_at')->orderBy('name')
            ->limit(10)->get()
            ->map(fn (Customer $c) => ['id' => $c->public_id, 'name' => $c->name, 'phone' => $contact ? $c->phone : $c->maskedPhone(), 'visits' => $c->visits_count, 'no_shows' => $c->no_show_count])
            ->values()->all();
    }
}
