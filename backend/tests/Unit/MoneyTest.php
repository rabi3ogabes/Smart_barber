<?php

use App\Core\Money\Money;
use App\Core\Money\MoneyCast;
use Illuminate\Database\Eloquent\Model;

it('stores QAR as 2-decimal minor units', function () {
    $m = Money::ofMajor('60.00', 'QAR');
    expect($m->minor())->toBe(6000)->and($m->toDecimal())->toBe('60.00')->and($m->scale())->toBe(2);
});

it('respects 3-decimal currencies', function () {
    $m = Money::ofMinor(1500, 'KWD');
    expect($m->toDecimal())->toBe('1.500')->and($m->scale())->toBe(3);
});

it('rejects float-looking input and garbage', function () {
    Money::ofMajor('abc', 'QAR');
})->throws(InvalidArgumentException::class);

it('adds and subtracts in the same currency only', function () {
    $a = Money::ofMinor(1000, 'QAR');
    expect($a->plus(Money::ofMinor(250, 'QAR'))->minor())->toBe(1250)
        ->and($a->minus(Money::ofMinor(1250, 'QAR'))->isNegative())->toBeTrue();

    $a->plus(Money::ofMinor(1, 'KWD'));
})->throws(InvalidArgumentException::class);

it('computes basis-point percentages with half-up rounding', function () {
    expect(Money::ofMinor(6000, 'QAR')->percentBp(500)->minor())->toBe(300)
        ->and(Money::ofMinor(333, 'QAR')->percentBp(500)->minor())->toBe(17); // 16.65 → 17
});

it('allocates without losing minor units', function () {
    $parts = Money::ofMinor(1000, 'QAR')->allocate(1, 1, 1);
    expect(array_map(fn ($p) => $p->minor(), $parts))->toBe([334, 333, 333]);
});

it('serialises to amount, currency and formatted', function () {
    app()->setLocale('en');
    expect(Money::ofMinor(6000, 'QAR')->toArray())
        ->toMatchArray(['amount' => 6000, 'currency' => 'QAR'])
        ->and(Money::ofMinor(6000, 'QAR')->toArray()['formatted'])->toContain('60.00');
});

it('casts to and from minor units with a currency column', function () {
    $model = new class extends Model
    {
        protected $guarded = [];

        protected function casts(): array
        {
            return ['price' => MoneyCast::class.':currency'];
        }
    };

    $model->price = Money::ofMinor(4500, 'QAR');
    expect($model->getAttributes())->toMatchArray(['price' => 4500, 'currency' => 'QAR'])
        ->and($model->price)->toBeInstanceOf(Money::class)
        ->and($model->price->minor())->toBe(4500);

    $model->price = 12; // not a Money
})->throws(InvalidArgumentException::class);
