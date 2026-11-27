<?php

namespace App\Modules\Catalog\Pricing;

use App\Core\Money\Money;
use Brick\Math\BigDecimal;
use Brick\Math\RoundingMode;

/**
 * One priced line of a quote. Immutable; tax is always derived from the amount after discount.
 *
 * - unitPrice: catalog price after precedence (barber > branch > base), before discount.
 * - discount:  set by price adjusters (loyalty, memberships, offer codes — later phases).
 * - tax/net/total: tax-inclusive prices extract tax from the amount; tax-exclusive prices add it.
 */
final readonly class QuoteLine
{
    public Money $tax;

    public Money $net;

    public Money $total;

    /**
     * @param  'service'|'addon'|'bundle'  $type
     * @param  array<string, string>  $name  translations
     * @param  'base'|'branch'|'barber'|'addon'|'bundle'  $priceSource
     * @param  list<string>  $includes  public ids of a bundle's services
     */
    public function __construct(
        public string $type,
        public int $modelId,
        public string $publicId,
        public array $name,
        public Money $unitPrice,
        public string $priceSource,
        public int $durationMinutes,
        public int $taxRateBp,
        public bool $pricesIncludeTax,
        public ?Money $discount = null,
        public ?string $discountReason = null,
        public array $includes = [],
    ) {
        $amount = $this->amountAfterDiscount();
        if ($pricesIncludeTax) {
            $taxMinor = BigDecimal::of($amount->minor())
                ->multipliedBy($taxRateBp)
                ->dividedBy(10000 + $taxRateBp, 0, RoundingMode::HalfUp)
                ->toInt();
            $this->tax = Money::ofMinor($taxMinor, $amount->currency());
            $this->net = $amount->minus($this->tax);
            $this->total = $amount;
        } else {
            $this->tax = $amount->percentBp($taxRateBp);
            $this->net = $amount;
            $this->total = $amount->plus($this->tax);
        }
    }

    public function amountAfterDiscount(): Money
    {
        return $this->discount === null ? $this->unitPrice : $this->unitPrice->minus($this->discount);
    }

    public function withDiscount(Money $discount, string $reason): self
    {
        if ($discount->isNegative() || $discount->minor() > $this->unitPrice->minor()) {
            throw new \InvalidArgumentException('A discount must be between zero and the line price.');
        }

        return new self($this->type, $this->modelId, $this->publicId, $this->name, $this->unitPrice, $this->priceSource,
            $this->durationMinutes, $this->taxRateBp, $this->pricesIncludeTax, $discount, $reason, $this->includes);
    }

    /**
     * @return array<string, mixed>
     */
    public function toArray(): array
    {
        return [
            'type' => $this->type,
            'id' => $this->publicId,
            'name' => $this->name,
            'unit_price' => $this->unitPrice,
            'price_source' => $this->priceSource,
            'discount' => $this->discount,
            'discount_reason' => $this->discountReason,
            'duration_minutes' => $this->durationMinutes,
            'tax_rate_bp' => $this->taxRateBp,
            'tax' => $this->tax,
            'total' => $this->total,
            'includes' => $this->includes,
        ];
    }
}
