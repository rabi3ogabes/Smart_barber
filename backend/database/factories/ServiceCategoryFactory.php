<?php

namespace Database\Factories;

use App\Modules\Catalog\Models\ServiceCategory;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * Call inside Tenancy::runAs().
 *
 * @extends Factory<ServiceCategory>
 */
class ServiceCategoryFactory extends Factory
{
    protected $model = ServiceCategory::class;

    public function definition(): array
    {
        $en = fake()->randomElement(['Haircuts', 'Beard', 'Shaving', 'Grooming', 'Kids']);

        return ['name' => ['ar' => 'فئة '.$en, 'en' => $en], 'icon' => 'scissors', 'sort_order' => 0, 'is_active' => true];
    }
}
