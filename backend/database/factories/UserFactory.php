<?php

namespace Database\Factories;

use App\Core\Identity\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends Factory<User>
 */
class UserFactory extends Factory
{
    protected $model = User::class;

    protected static ?string $password = null;

    public function definition(): array
    {
        return [
            'name' => fake()->name(),
            'email' => strtolower(fake()->unique()->safeEmail()),
            'password' => static::$password ??= 'Password123!',
            'locale' => 'ar',
            'remember_token' => Str::random(10),
        ];
    }
}
