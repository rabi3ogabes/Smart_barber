<?php

namespace App\Core\Support;

/**
 * Normalises phone input typed at a reception desk to E.164: Arabic-Indic digits, spaces and
 * dashes are accepted; "00" becomes "+"; a bare local number gets the salon's country code.
 * Returns null when the result is not a plausible E.164 number.
 */
final class PhoneNumber
{
    public const PATTERN = '/^\+[1-9]\d{7,14}$/';

    public static function normalize(?string $input, string $defaultCountryCode = '974'): ?string
    {
        if ($input === null) {
            return null;
        }
        $digits = strtr($input, ['٠' => '0', '١' => '1', '٢' => '2', '٣' => '3', '٤' => '4', '٥' => '5', '٦' => '6', '٧' => '7', '٨' => '8', '٩' => '9']);
        $digits = (string) preg_replace('/[^\d+]/', '', $digits);

        if (str_starts_with($digits, '00')) {
            $digits = '+'.substr($digits, 2);
        } elseif (! str_starts_with($digits, '+')) {
            $digits = '+'.$defaultCountryCode.ltrim($digits, '0');
        }

        return preg_match(self::PATTERN, $digits) === 1 ? $digits : null;
    }
}
