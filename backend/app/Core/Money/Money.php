<?php

namespace App\Core\Money;

use Brick\Math\BigDecimal;
use Brick\Math\RoundingMode;
use Brick\Money\AllocationMode;
use Brick\Money\Money as BrickMoney;
use InvalidArgumentException;
use JsonSerializable;

/**
 * Immutable money value in integer minor units of its currency (ADR-003).
 * The currency's scale comes from ISO 4217 (QAR 2 decimals, KWD 3 decimals).
 */
final class Money implements JsonSerializable
{
    private function __construct(private readonly BrickMoney $money) {}

    public static function ofMinor(int $minor, string $currency): self
    {
        return new self(BrickMoney::ofMinor($minor, strtoupper($currency)));
    }

    /**
     * Build from a major-unit decimal string such as "60.00". Floats are rejected on purpose.
     */
    public static function ofMajor(string $amount, string $currency): self
    {
        if (! preg_match('/^-?\d+(\.\d+)?$/', $amount)) {
            throw new InvalidArgumentException("Invalid money amount [{$amount}].");
        }

        return new self(BrickMoney::of($amount, strtoupper($currency), roundingMode: RoundingMode::HalfUp));
    }

    public static function zero(string $currency): self
    {
        return self::ofMinor(0, $currency);
    }

    public function minor(): int
    {
        return $this->money->getMinorAmount()->toInt();
    }

    public function currency(): string
    {
        return $this->money->getCurrency()->getCurrencyCode();
    }

    public function scale(): int
    {
        return $this->money->getCurrency()->getDefaultFractionDigits();
    }

    public function plus(self $other): self
    {
        $this->assertSameCurrency($other);

        return new self($this->money->plus($other->money));
    }

    public function minus(self $other): self
    {
        $this->assertSameCurrency($other);

        return new self($this->money->minus($other->money));
    }

    /**
     * Multiply by an integer or a decimal string (never a float), rounding half up.
     */
    public function multipliedBy(int|string $factor): self
    {
        return new self($this->money->multipliedBy($factor, RoundingMode::HalfUp));
    }

    /**
     * Percentage of this amount expressed in basis points (500 = 5.00 %), rounded half up.
     */
    public function percentBp(int $basisPoints): self
    {
        $minor = BigDecimal::of($this->minor())
            ->multipliedBy($basisPoints)
            ->dividedBy(10000, 0, RoundingMode::HalfUp)
            ->toInt();

        return self::ofMinor($minor, $this->currency());
    }

    /**
     * Split into parts by ratio; leftover minor units go to the first parts so the sum always matches.
     *
     * @return list<self>
     */
    public function allocate(int ...$ratios): array
    {
        $parts = $this->money->allocate(array_values($ratios), AllocationMode::FloorToFirst);

        return array_map(fn (BrickMoney $m) => new self($m), $parts);
    }

    public function isZero(): bool
    {
        return $this->money->isZero();
    }

    public function isNegative(): bool
    {
        return $this->money->isNegative();
    }

    public function equals(self $other): bool
    {
        return $this->currency() === $other->currency() && $this->minor() === $other->minor();
    }

    /** Decimal string in major units, e.g. "60.00". */
    public function toDecimal(): string
    {
        return (string) $this->money->getAmount();
    }

    public function format(?string $locale = null): string
    {
        $locale ??= app()->getLocale();

        return $this->money->formatToLocale($locale === 'ar' ? 'ar-QA' : 'en-QA');
    }

    /**
     * @return array{amount: int, currency: string, formatted: string}
     */
    public function toArray(): array
    {
        return [
            'amount' => $this->minor(),
            'currency' => $this->currency(),
            'formatted' => $this->format(),
        ];
    }

    /**
     * @return array{amount: int, currency: string, formatted: string}
     */
    public function jsonSerialize(): array
    {
        return $this->toArray();
    }

    private function assertSameCurrency(self $other): void
    {
        if ($this->currency() !== $other->currency()) {
            throw new InvalidArgumentException("Currency mismatch: {$this->currency()} vs {$other->currency()}.");
        }
    }
}
