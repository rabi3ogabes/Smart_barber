<?php

namespace Database\Seeders;

use App\Core\Authorization\PermissionCatalog;
use App\Core\Authorization\SyncRolesAndPermissions;
use App\Core\Identity\Models\PlatformAdmin;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Actions\AddMember;
use App\Core\Tenancy\Actions\CreateSalon;
use App\Core\Tenancy\Tenancy;
use Illuminate\Database\Seeder;

/**
 * Demo data (Phase 1): Super Admin, salons A and B, each with an owner, a branch manager,
 * one branch and a barber.
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

        foreach ([
            'a' => ['slug' => 'salon-a', 'ar' => 'صالون النخبة', 'en' => 'Elite Barbers', 'branch_ar' => 'فرع الخليج الغربي', 'branch_en' => 'West Bay'],
            'b' => ['slug' => 'salon-b', 'ar' => 'صالون اللؤلؤة', 'en' => 'Pearl Grooming', 'branch_ar' => 'فرع اللؤلؤة', 'branch_en' => 'The Pearl'],
        ] as $key => $s) {
            $owner = User::query()->firstOrCreate(
                ['email' => "owner.{$key}@smartbarber.test"],
                ['name' => "Owner {$s['en']}", 'password' => 'Password123!', 'locale' => 'ar'],
            );

            $salon = app(CreateSalon::class)(
                ['ar' => $s['ar'], 'en' => $s['en']],
                $s['slug'],
                $owner,
                ['ar' => $s['branch_ar'], 'en' => $s['branch_en']],
            );

            $barber = User::query()->firstOrCreate(
                ['email' => "barber.{$key}@smartbarber.test"],
                ['name' => "Barber {$s['en']}", 'password' => 'Password123!', 'locale' => 'ar'],
            );

            $branch = Tenancy::runAs($salon, fn () => $salon->branches()->firstOrFail());
            app(AddMember::class)($salon, $barber, [PermissionCatalog::BARBER], [$branch]);

            $manager = User::query()->firstOrCreate(
                ['email' => "manager.{$key}@smartbarber.test"],
                ['name' => "Manager {$s['en']}", 'password' => 'Password123!', 'locale' => 'ar'],
            );
            app(AddMember::class)($salon, $manager, [PermissionCatalog::BRANCH_MANAGER], [$branch]);
        }
    }
}
