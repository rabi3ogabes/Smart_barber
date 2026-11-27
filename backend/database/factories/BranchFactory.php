<?php

namespace Database\Factories;

use App\Core\Tenancy\Models\Branch;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Branch>
 */
class BranchFactory extends Factory
{
    protected $model = Branch::class;

    public function definition(): array
    {
        $area = fake()->randomElement(['West Bay', 'The Pearl', 'Lusail', 'Al Sadd']);

        return [
            'name' => ['ar' => 'فرع '.$area, 'en' => $area],
            'timezone' => 'Asia/Qatar',
            'is_active' => true,
        ];
    }
}
