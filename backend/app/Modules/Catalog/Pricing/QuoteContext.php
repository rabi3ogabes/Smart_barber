<?php

namespace App\Modules\Catalog\Pricing;

use App\Core\Tenancy\Models\Branch;
use App\Modules\Staff\Models\Barber;
use Illuminate\Database\Eloquent\Model;

/**
 * What a price adjuster may know about the quote's situation.
 */
final readonly class QuoteContext
{
    public function __construct(
        public Branch $branch,
        public ?Barber $barber = null,
        public ?Model $customer = null,
    ) {}
}
