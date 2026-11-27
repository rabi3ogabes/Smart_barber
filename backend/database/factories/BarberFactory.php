<?php

namespace Database\Factories;

use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\SalonMembership;
use App\Modules\Staff\Models\Barber;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * Bare barber profile with a plain membership row (no roles). Tests normally get one through
 * AddMember (SyncBarberProfile); use this only when roles are irrelevant. Call inside Tenancy::runAs().
 *
 * @extends Factory<Barber>
 */
class BarberFactory extends Factory
{
    protected $model = Barber::class;

    public function definition(): array
    {
        $name = fake()->firstName('male');
        $user = User::factory()->create(['name' => $name]);

        return [
            'user_id' => $user->id,
            'salon_user_id' => fn () => SalonMembership::query()->create(['user_id' => $user->id, 'status' => SalonMembership::STATUS_ACTIVE, 'joined_at' => now()])->id,
            'display_name' => ['ar' => $name, 'en' => $name],
            'specialties' => ['fade'],
            'years_experience' => fake()->numberBetween(1, 15),
            'is_bookable' => true,
        ];
    }
}
