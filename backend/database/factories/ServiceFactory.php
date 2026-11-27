<?php

namespace Database\Factories;

use App\Modules\Catalog\Enums\TaxClass;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceCategory;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * Call inside Tenancy::runAs(). Prices are minor units of the salon currency.
 *
 * @extends Factory<Service>
 */
class ServiceFactory extends Factory
{
    protected $model = Service::class;

    public function definition(): array
    {
        $en = fake()->randomElement(['Haircut', 'Skin fade', 'Beard trim', 'Hot towel shave', 'Kids cut']);

        return [
            'category_id' => ServiceCategory::factory(),
            'name' => ['ar' => 'خدمة '.$en, 'en' => $en],
            'base_price' => 6000,
            'duration_minutes' => 30,
            'buffer_minutes' => 0,
            'tax_class' => TaxClass::Standard,
            'is_active' => true,
            'is_bookable_online' => true,
        ];
    }
}
