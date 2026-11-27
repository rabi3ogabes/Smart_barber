<?php

namespace App\Core\Money;

use Illuminate\Contracts\Database\Eloquent\CastsAttributes;
use Illuminate\Database\Eloquent\Model;
use InvalidArgumentException;

/**
 * Usage: 'price' => MoneyCast::class.':currency' — the argument names the currency column.
 *
 * Setting accepts any value and rejects everything but Money at runtime.
 *
 * @implements CastsAttributes<Money|null, mixed>
 */
final class MoneyCast implements CastsAttributes
{
    public function __construct(private readonly string $currencyColumn = 'currency') {}

    public function get(Model $model, string $key, mixed $value, array $attributes): ?Money
    {
        if ($value === null) {
            return null;
        }

        $currency = $attributes[$this->currencyColumn] ?? null;
        if (! is_string($currency) || $currency === '') {
            throw new InvalidArgumentException("Missing currency column [{$this->currencyColumn}] for [{$key}].");
        }

        return Money::ofMinor((int) $value, $currency);
    }

    /**
     * @return array<string, int|string|null>
     */
    public function set(Model $model, string $key, mixed $value, array $attributes): array
    {
        if ($value === null) {
            return [$key => null];
        }

        if (! $value instanceof Money) {
            throw new InvalidArgumentException("[{$key}] must be set with a ".Money::class.' instance.');
        }

        $existing = $attributes[$this->currencyColumn] ?? null;
        if (is_string($existing) && $existing !== '' && $existing !== $value->currency()) {
            throw new InvalidArgumentException("Currency mismatch for [{$key}]: {$existing} vs {$value->currency()}.");
        }

        return [$key => $value->minor(), $this->currencyColumn => $value->currency()];
    }
}
