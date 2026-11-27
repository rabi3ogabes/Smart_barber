<?php

namespace Database\Factories;

use App\Core\Identity\Models\CustomerAccount;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<CustomerAccount>
 */
class CustomerAccountFactory extends Factory
{
    protected $model = CustomerAccount::class;

    public function definition(): array
    {
        return [
            'phone' => '+9745'.fake()->unique()->numerify('#######'),
            'name' => fake()->name(),
            'locale' => 'ar',
        ];
    }
}
