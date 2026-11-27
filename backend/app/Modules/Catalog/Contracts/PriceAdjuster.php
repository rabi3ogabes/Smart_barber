<?php

namespace App\Modules\Catalog\Contracts;

use App\Modules\Catalog\Pricing\Quote;
use App\Modules\Catalog\Pricing\QuoteContext;
use Illuminate\Database\Eloquent\Model;

/**
 * Lets later modules (Loyalty, Membership, Marketing offer codes) change a quote without
 * Booking or POS importing them (modules.md, "How the two upward needs are solved").
 * Register an implementation with $app->tag([MyAdjuster::class], PriceAdjuster::TAG).
 */
interface PriceAdjuster
{
    public const TAG = 'catalog.price_adjusters';

    /**
     * Return the quote with discounts applied (QuoteLine::withDiscount). Must not change prices
     * any other way and must not write anything.
     */
    public function adjust(Quote $quote, QuoteContext $context): Quote;

    /**
     * Called inside the booking/order transaction that accepts the quote, to record usage
     * (e.g. a punch-card reward or a membership use) against $transaction.
     */
    public function commit(Quote $quote, QuoteContext $context, Model $transaction): void;
}
