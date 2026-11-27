<?php

namespace Database\Seeders;

use App\Core\Authorization\PermissionCatalog;
use App\Core\Authorization\SyncRolesAndPermissions;
use App\Core\Identity\Models\PlatformAdmin;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Actions\AddMember;
use App\Core\Tenancy\Actions\CreateSalon;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Salon\Actions\SetOpeningHours;
use App\Modules\Staff\Actions\SetWeeklySchedule;
use App\Modules\Staff\Models\Barber;
use Illuminate\Database\Seeder;

/**
 * Demo data: Super Admin, salons A and B, each with an owner, a branch manager, one branch
 * with opening hours (Phase 2) and two barbers with weekly schedules and a prayer break.
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

            $barber2 = User::query()->firstOrCreate(
                ['email' => "barber2.{$key}@smartbarber.test"],
                ['name' => "Second Barber {$s['en']}", 'password' => 'Password123!', 'locale' => 'ar'],
            );
            app(AddMember::class)($salon, $barber2, [PermissionCatalog::BARBER], [$branch]);

            $this->seedSchedules($salon, $branch, [$barber, $barber2]);
        }
    }

    /**
     * Branch open 10:00–23:00 (Friday 14:00–23:00). Barber 1 works 10–18, barber 2 works
     * 15–23 with Sunday off; both take a 30-minute break.
     *
     * @param  list<User>  $users
     */
    private function seedSchedules(Salon $salon, Branch $branch, array $users): void
    {
        Tenancy::runAs($salon, function () use ($branch, $users): void {
            $week = fn (string $start, string $end, array $skip = []) => collect(range(0, 6))
                ->mapWithKeys(fn (int $d) => [$d => in_array($d, $skip, true) ? [] : [['start' => $d === 5 && $start < '14:00' ? '14:00' : $start, 'end' => $end]]])
                ->all();

            app(SetOpeningHours::class)($branch, $week('10:00', '23:00'));

            foreach ($users as $i => $user) {
                $barber = Barber::query()->where('user_id', $user->id)->firstOrFail();
                $hours = $i === 0 ? $week('10:00', '18:00') : $week('15:00', '23:00', [0]);
                $breaks = $i === 0 ? $week('13:00', '13:30', [5]) : $week('19:00', '19:30', [0]);
                app(SetWeeklySchedule::class)($barber, $branch, $hours, $breaks);
            }
        });
    }
}
