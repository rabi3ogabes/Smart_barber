<?php

namespace Database\Seeders;

use App\Core\Authorization\SyncRolesAndPermissions;
use App\Core\Identity\Models\PlatformAdmin;
use Illuminate\Database\Seeder;

/**
 * Demo data: Super Admin, salons A and B, each with an owner, a branch manager, one branch
 * with opening hours (Phase 2), two barbers with weekly schedules and a prayer break, and a
 * service menu with a branch price, a senior-barber price, add-ons and a bundle (Phase 3).
 * Every demo password is "Password123!". Never run in production.
 */
class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        app(SyncRolesAndPermissions::class)();

        if (app()->isProduction()) {
            return;
        }

        PlatformAdmin::query()->firstOrCreate(
            ['email' => 'admin@smartbarber.test'],
            ['name' => 'Super Admin', 'password' => 'Password123!'],
        );

        $builder = new DemoSalonBuilder;
        foreach ([
            'a' => ['slug' => 'salon-a', 'ar' => 'صالون النخبة', 'en' => 'Elite Barbers', 'branch_ar' => 'فرع الخليج الغربي', 'branch_en' => 'West Bay'],
            'b' => ['slug' => 'salon-b', 'ar' => 'صالون اللؤلؤة', 'en' => 'Pearl Grooming', 'branch_ar' => 'فرع اللؤلؤة', 'branch_en' => 'The Pearl'],
        ] as $key => $s) {
            $builder->build($s, fn (string $role) => "{$role}.{$key}@smartbarber.test", fn () => 'Password123!');
        }
    }
}
