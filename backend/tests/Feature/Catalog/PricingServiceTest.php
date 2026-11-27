<?php

use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Money\Money;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Catalog\Contracts\PriceAdjuster;
use App\Modules\Catalog\Enums\TaxClass;
use App\Modules\Catalog\Models\BarberService;
use App\Modules\Catalog\Models\BranchService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Pricing\PricingService;
use App\Modules\Catalog\Pricing\Quote;
use App\Modules\Catalog\Pricing\QuoteContext;
use App\Modules\Staff\Models\Barber;
use Illuminate\Database\Eloquent\Model;

/*
| PricingService is the only place prices are computed. Base QAR (2 decimals) unless stated.
*/

function pricingFixture(object $test, array $salon = [], string $slug = 'salon-a'): array
{
    ['salon' => $s, 'branch' => $branch] = $test->makeSalon($slug);
    if ($salon !== []) {
        Salon::query()->whereKey($s->id)->update($salon);
    }
    $user = $test->memberOf($s, P::BARBER, [$branch]);

    return Tenancy::runAs($s->fresh(), function () use ($s, $branch, $user) {
        $haircut = Service::factory()->create(['name' => ['ar' => 'قص', 'en' => 'Haircut'], 'base_price' => 6000, 'duration_minutes' => 30, 'buffer_minutes' => 5]);
        $beard = Service::factory()->create(['category_id' => $haircut->category_id, 'name' => ['ar' => 'لحية', 'en' => 'Beard'], 'base_price' => 4000, 'duration_minutes' => 20, 'buffer_minutes' => 10]);
        $barber = Barber::query()->where('user_id', $user->id)->firstOrFail();

        return ['salon' => $s->fresh(), 'branch' => $branch, 'barber' => $barber, 'haircut' => $haircut, 'beard' => $beard];
    });
}

function q(array $f, array $services, array $addons = [], ?Barber $barber = null, array $bundles = []): Quote
{
    return Tenancy::runAs($f['salon'], fn () => app(PricingService::class)->quote($f['branch'], $services, $addons, $barber, null, $bundles));
}

function minor(Money $m): int
{
    return $m->minor();
}

it('prices services at their base price without a barber', function () {
    $f = pricingFixture($this);
    $quote = q($f, [$f['haircut'], $f['beard']]);

    expect(minor($quote->subtotal()))->toBe(10000)
        ->and(minor($quote->tax()))->toBe(0)
        ->and(minor($quote->total()))->toBe(10000)
        ->and($quote->currency)->toBe('QAR')
        ->and($quote->durationMinutes())->toBe(50)
        ->and($quote->bufferMinutes)->toBe(10)
        ->and(array_map(fn ($l) => $l->priceSource, $quote->lines))->toBe(['base', 'base']);
});

it('applies the precedence barber > branch > base', function () {
    $f = pricingFixture($this);
    Tenancy::runAs($f['salon'], function () use ($f) {
        BranchService::query()->create(['branch_id' => $f['branch']->id, 'service_id' => $f['haircut']->id, 'price_override' => 7000]);
        BranchService::query()->create(['branch_id' => $f['branch']->id, 'service_id' => $f['beard']->id, 'price_override' => 4500]);
        BarberService::query()->create(['barber_id' => $f['barber']->id, 'service_id' => $f['haircut']->id, 'price_override' => 9000, 'duration_override' => 45]);
        BarberService::query()->create(['barber_id' => $f['barber']->id, 'service_id' => $f['beard']->id]);
    });

    $branchOnly = q($f, [$f['haircut'], $f['beard']]);
    expect(array_map(fn ($l) => [$l->priceSource, minor($l->unitPrice)], $branchOnly->lines))->toBe([['branch', 7000], ['branch', 4500]]);

    $withBarber = q($f, [$f['haircut'], $f['beard']], barber: $f['barber']);
    expect(array_map(fn ($l) => [$l->priceSource, minor($l->unitPrice), $l->durationMinutes], $withBarber->lines))
        ->toBe([['barber', 9000, 45], ['branch', 4500, 20]])
        ->and(minor($withBarber->total()))->toBe(13500)
        ->and($withBarber->durationMinutes())->toBe(65);
});

it('uses the base price when the branch row has no override', function () {
    $f = pricingFixture($this);
    Tenancy::runAs($f['salon'], fn () => BranchService::query()->create(['branch_id' => $f['branch']->id, 'service_id' => $f['haircut']->id, 'is_available' => true]));

    expect(q($f, [$f['haircut']])->lines[0]->priceSource)->toBe('base');
});

it('adds VAT on top for tax-exclusive salons and extracts it for tax-inclusive ones', function () {
    $exclusive = pricingFixture($this, ['tax_rate_bp' => 500, 'prices_include_tax' => false]);
    $e = q($exclusive, [$exclusive['haircut'], $exclusive['beard']]);
    expect([minor($e->subtotal()), minor($e->tax()), minor($e->total())])->toBe([10000, 500, 10500]);

    Tenancy::clear();
    $inclusive = pricingFixture($this, ['tax_rate_bp' => 500, 'prices_include_tax' => true], 'salon-b');
    $i = q($inclusive, [$inclusive['haircut'], $inclusive['beard']]);
    // 6000 × 5/105 = 285.71 → 286; 4000 × 5/105 = 190.48 → 190 (per line, half up).
    expect([minor($i->subtotal()), minor($i->tax()), minor($i->total())])->toBe([10000, 476, 10000])
        ->and(minor($i->lines[0]->net))->toBe(5714);
});

it('does not tax zero-rated or exempt items', function () {
    $f = pricingFixture($this, ['tax_rate_bp' => 500, 'prices_include_tax' => false]);
    Tenancy::runAs($f['salon'], fn () => $f['beard']->forceFill(['tax_class' => TaxClass::Exempt])->save());

    $quote = q($f, [$f['haircut'], $f['beard']->fresh()]);
    expect(array_map(fn ($l) => [$l->taxRateBp, minor($l->tax)], $quote->lines))->toBe([[500, 300], [0, 0]]);
});

it('rounds half up per line, and the totals always reconcile', function () {
    $f = pricingFixture($this, ['tax_rate_bp' => 1500, 'prices_include_tax' => false]);
    Tenancy::runAs($f['salon'], function () use ($f) {
        $f['haircut']->forceFill(['base_price' => 3333])->save();
        $f['beard']->forceFill(['base_price' => 3337])->save();
    });

    $quote = q($f, [$f['haircut']->fresh(), $f['beard']->fresh()]);
    // 3333 × 15% = 499.95 → 500; 3337 × 15% = 500.55 → 501.
    expect(array_map(fn ($l) => minor($l->tax), $quote->lines))->toBe([500, 501])
        ->and(minor($quote->tax()))->toBe(1001)
        ->and(minor($quote->total()))->toBe(minor($quote->subtotal()) + minor($quote->tax()));
});

it('works in three-decimal currencies', function () {
    $f = pricingFixture($this, ['currency' => 'KWD', 'tax_rate_bp' => 500, 'prices_include_tax' => false]);
    Tenancy::runAs($f['salon'], fn () => $f['haircut']->forceFill(['base_price' => 3500])->save()); // KWD 3.500

    $quote = q($f, [$f['haircut']->fresh()]);
    expect($quote->currency)->toBe('KWD')
        ->and(minor($quote->tax()))->toBe(175)
        ->and($quote->total()->toDecimal())->toBe('3.675');
});

it('prices bundles at the bundle price with the summed duration', function () {
    $f = pricingFixture($this);
    $bundle = Tenancy::runAs($f['salon'], function () use ($f) {
        $b = ServiceBundle::query()->create(['name' => ['ar' => 'قص ولحية', 'en' => 'Hair + Beard'], 'price' => 8500]);
        $b->syncServices([$f['haircut']->id, $f['beard']->id]);
        BarberService::query()->create(['barber_id' => $f['barber']->id, 'service_id' => $f['haircut']->id, 'duration_override' => 40]);
        BarberService::query()->create(['barber_id' => $f['barber']->id, 'service_id' => $f['beard']->id, 'price_override' => 9999]);

        return $b->fresh('services');
    });

    $quote = q($f, [], barber: $f['barber'], bundles: [$bundle]);
    expect($quote->lines)->toHaveCount(1)
        ->and($quote->lines[0]->type)->toBe('bundle')
        ->and(minor($quote->total()))->toBe(8500) // barber overrides do not change a bundle price
        ->and($quote->durationMinutes())->toBe(60)
        ->and($quote->bufferMinutes)->toBe(10)
        ->and($quote->lines[0]->includes)->toBe([$f['haircut']->public_id, $f['beard']->public_id]);
});

it('adds add-ons linked to a chosen service and refuses unrelated ones', function () {
    $f = pricingFixture($this);
    [$towel, $mask] = Tenancy::runAs($f['salon'], function () use ($f) {
        $towel = ServiceAddon::query()->create(['name' => ['ar' => 'منشفة ساخنة', 'en' => 'Hot towel'], 'price' => 1500, 'extra_minutes' => 5]);
        $towel->syncServices([$f['beard']->id]);
        $mask = ServiceAddon::query()->create(['name' => ['ar' => 'قناع', 'en' => 'Mask'], 'price' => 2000, 'extra_minutes' => 10]);
        $mask->syncServices([$f['haircut']->id]);

        return [$towel, $mask];
    });

    $quote = q($f, [$f['beard']], [$towel]);
    expect(minor($quote->total()))->toBe(5500)->and($quote->durationMinutes())->toBe(25);

    expect(fn () => q($f, [$f['beard']], [$mask]))->toThrow(AppException::class);
});

it('refuses services unavailable at the branch, inactive services and duplicates', function (string $case) {
    $f = pricingFixture($this);
    $services = Tenancy::runAs($f['salon'], function () use ($f, $case) {
        return match ($case) {
            'unavailable' => [BranchService::query()->create(['branch_id' => $f['branch']->id, 'service_id' => $f['haircut']->id, 'is_available' => false]) ? $f['haircut'] : null],
            'inactive' => [tap($f['haircut'])->forceFill(['is_active' => false])->save() ? $f['haircut']->fresh() : null],
            'duplicate' => [$f['haircut'], $f['haircut']],
            'empty' => [],
        };
    });

    try {
        q($f, $services);
        $this->fail('Expected an AppException');
    } catch (AppException $e) {
        expect($e->errorCode)->toBe(match ($case) {
            'unavailable', 'inactive' => ErrorCode::ServiceUnavailableAtBranch,
            default => ErrorCode::CatalogSelectionInvalid,
        });
    }
})->with(['unavailable', 'inactive', 'duplicate', 'empty']);

it('refuses a barber who does not perform the service or work at the branch', function () {
    $f = pricingFixture($this);
    Tenancy::runAs($f['salon'], fn () => BarberService::query()->create(['barber_id' => $f['barber']->id, 'service_id' => $f['haircut']->id]));

    expect(fn () => q($f, [$f['haircut'], $f['beard']], barber: $f['barber']))
        ->toThrow(fn (AppException $e) => expect($e->errorCode)->toBe(ErrorCode::BarberNotEligible));

    $other = $this->addBranch($f['salon']);
    expect(fn () => Tenancy::runAs($f['salon'], fn () => app(PricingService::class)->quote($other, [$f['haircut']], barber: $f['barber'])))
        ->toThrow(fn (AppException $e) => expect($e->errorCode)->toBe(ErrorCode::BarberNotEligible));
});

it('lets registered price adjusters discount lines, recomputing tax', function () {
    $f = pricingFixture($this, ['tax_rate_bp' => 500, 'prices_include_tax' => false]);
    app()->bind('test.adjuster', fn () => new class implements PriceAdjuster
    {
        public function adjust(Quote $quote, QuoteContext $context): Quote
        {
            return $quote->withLine(0, $quote->lines[0]->withDiscount($quote->lines[0]->unitPrice->percentBp(5000), 'Half price'));
        }

        public function commit(Quote $quote, QuoteContext $context, Model $transaction): void {}
    });
    app()->tag(['test.adjuster'], PriceAdjuster::TAG);

    $quote = q($f, [$f['haircut'], $f['beard']]);
    expect(minor($quote->subtotal()))->toBe(10000)
        ->and(minor($quote->discount()))->toBe(3000)
        ->and(minor($quote->lines[0]->tax))->toBe(150) // 5% of 3000
        ->and(minor($quote->total()))->toBe(3000 + 150 + 4000 + 200)
        ->and($quote->lines[0]->discountReason)->toBe('Half price');
});

it('refuses discounts larger than the line', function () {
    $f = pricingFixture($this);
    $line = q($f, [$f['beard']])->lines[0];
    $line->withDiscount(Money::ofMinor(4001, 'QAR'), 'too much');
})->throws(InvalidArgumentException::class);

it('serialises money as minor units with the currency', function () {
    $f = pricingFixture($this);
    $json = json_decode(json_encode(q($f, [$f['haircut']])->toArray()), true);

    expect($json['total'])->toMatchArray(['amount' => 6000, 'currency' => 'QAR'])
        ->and($json['lines'][0]['unit_price']['amount'])->toBe(6000)
        ->and($json['lines'][0]['id'])->toBe($f['haircut']->public_id);
});
