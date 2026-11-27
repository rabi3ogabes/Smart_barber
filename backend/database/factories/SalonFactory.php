<?php

namespace Database\Factories;

use App\Core\Tenancy\Models\Salon;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Salon>
 */
class SalonFactory extends Factory
{
    protected $model = Salon::class;

    public function definition(): array
    {
        $word = fake()->unique()->lexify('salon-????');

        return [
            'slug' => $word,
            'name' => ['ar' => 'صالون '.$word, 'en' => 'Salon '.$word],
            'currency' => 'QAR',
            'timezone' => 'Asia/Qatar',
            'default_locale' => 'ar',
            'country' => 'QA',
            'status' => Salon::STATUS_ACTIVE,
        ];
    }
}
