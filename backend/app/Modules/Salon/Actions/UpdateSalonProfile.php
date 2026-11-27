<?php

namespace App\Modules\Salon\Actions;

use App\Core\Money\Money;
use App\Core\Tenancy\Models\Salon;

/**
 * Salon profile and booking policy. Changes are audited by the model.
 */
final class UpdateSalonProfile
{
    /**
     * @param  array<string, mixed>  $data  validated fields; money as major-unit strings
     */
    public function __invoke(Salon $salon, array $data): Salon
    {
        if (array_key_exists('no_show_fee', $data)) {
            $data['no_show_fee_amount'] = Money::ofMajor((string) $data['no_show_fee'], $salon->currency);
            unset($data['no_show_fee']);
        }
        if (array_key_exists('tax_rate', $data)) {
            // Percent with up to two decimals → basis points (ADR-003).
            $data['tax_rate_bp'] = (int) round(((float) $data['tax_rate']) * 100);
            unset($data['tax_rate']);
        }

        $salon->fill($data)->save();

        return $salon;
    }
}
