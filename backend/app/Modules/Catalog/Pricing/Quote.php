<?php

namespace App\Modules\Catalog\Pricing;

use App\Core\Money\Money;

/**
 * The result of PricingService::quote(): every amount a booking, POS order or app screen may
 * show. Totals are sums of line values, so they always reconcile (ADR-003).
 */
final readonly class Quote
{
    /**
     * @param  list<QuoteLine>  $lines
     */
    public function __construct(
        public string $currency,
        public bool $pricesIncludeTax,
        public array $lines,
        public int $bufferMinutes,
        public ?int $barberId = null,
        public ?int $branchId = null,
    ) {}

    public function subtotal(): Money
    {
        return $this->sum(fn (QuoteLine $l) => $l->unitPrice);
    }

    public function discount(): Money
    {
        return $this->sum(fn (QuoteLine $l) => $l->discount ?? Money::zero($this->currency));
    }

    public function tax(): Money
    {
        return $this->sum(fn (QuoteLine $l) => $l->tax);
    }

    public function total(): Money
    {
        return $this->sum(fn (QuoteLine $l) => $l->total);
    }

    public function durationMinutes(): int
    {
        return array_sum(array_map(fn (QuoteLine $l) => $l->durationMinutes, $this->lines));
    }

    /**
     * Replace one line (used by price adjusters).
     */
    public function withLine(int $index, QuoteLine $line): self
    {
        $lines = $this->lines;
        if (! array_key_exists($index, $lines)) {
            throw new \OutOfRangeException("No quote line {$index}.");
        }
        $lines[$index] = $line;

        return new self($this->currency, $this->pricesIncludeTax, $lines, $this->bufferMinutes, $this->barberId, $this->branchId);
    }

    /**
     * @return array<string, mixed>
     */
    public function toArray(): array
    {
        return [
            'currency' => $this->currency,
            'prices_include_tax' => $this->pricesIncludeTax,
            'lines' => array_map(fn (QuoteLine $l) => $l->toArray(), $this->lines),
            'subtotal' => $this->subtotal(),
            'discount' => $this->discount(),
            'tax' => $this->tax(),
            'total' => $this->total(),
            'duration_minutes' => $this->durationMinutes(),
            'buffer_minutes' => $this->bufferMinutes,
        ];
    }

    /**
     * @param  callable(QuoteLine): Money  $pick
     */
    private function sum(callable $pick): Money
    {
        return array_reduce($this->lines, fn (Money $carry, QuoteLine $l) => $carry->plus($pick($l)), Money::zero($this->currency));
    }
}
