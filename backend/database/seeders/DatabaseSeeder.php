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
use App\Modules\Catalog\Models\BarberService;
use App\Modules\Catalog\Models\BranchService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Models\ServiceCategory;
use App\Modules\Salon\Actions\SetOpeningHours;
use App\Modules\Staff\Actions\SetWeeklySchedule;
use App\Modules\Staff\Models\Barber;
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
            $this->seedCatalog($salon, $branch, $barber);
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

    /**
     * A realistic men's menu in QAR (minor units). Barber 1 is "senior" and charges more for a haircut.
     */
    private function seedCatalog(Salon $salon, Branch $branch, User $seniorUser): void
    {
        Tenancy::runAs($salon, function () use ($branch, $seniorUser): void {
            if (Service::query()->exists()) {
                return;
            }
            $cat = fn (string $ar, string $en, string $icon, int $order) => ServiceCategory::query()->create(['name' => ['ar' => $ar, 'en' => $en], 'icon' => $icon, 'sort_order' => $order]);
            $hair = $cat('الشعر', 'Hair', 'scissors', 0);
            $beard = $cat('اللحية والحلاقة', 'Beard & shave', 'sparkles', 1);
            $care = $cat('العناية', 'Grooming', 'droplet', 2);

            $svc = fn ($c, string $ar, string $en, int $price, int $minutes, int $buffer = 5, ?string $desc = null) => Service::query()->create([
                'category_id' => $c->id, 'name' => ['ar' => $ar, 'en' => $en], 'description' => $desc ? ['en' => $desc] : [],
                'base_price' => $price, 'duration_minutes' => $minutes, 'buffer_minutes' => $buffer,
            ]);
            $haircut = $svc($hair, 'قص شعر', 'Haircut', 6000, 30, 5, 'Consultation, cut, wash and style.');
            $fade = $svc($hair, 'تدريج (فيد)', 'Skin fade', 7000, 40);
            $kids = $svc($hair, 'قص شعر أطفال', 'Kids cut', 4000, 25);
            $trim = $svc($beard, 'تحديد اللحية', 'Beard trim', 4000, 20);
            $shave = $svc($beard, 'حلاقة بالموس والمنشفة الساخنة', 'Hot towel shave', 5000, 30, 10);
            $facial = $svc($care, 'تنظيف البشرة', 'Facial', 9000, 45, 10);

            $towel = ServiceAddon::query()->create(['name' => ['ar' => 'منشفة ساخنة', 'en' => 'Hot towel'], 'price' => 1500, 'extra_minutes' => 5]);
            $towel->syncServices([$trim->id, $haircut->id, $fade->id]);
            $mask = ServiceAddon::query()->create(['name' => ['ar' => 'قناع أسود', 'en' => 'Black mask'], 'price' => 2500, 'extra_minutes' => 10]);
            $mask->syncServices([$facial->id, $haircut->id]);

            $bundle = ServiceBundle::query()->create(['name' => ['ar' => 'قص ولحية', 'en' => 'Haircut + Beard'], 'price' => 8500]);
            $bundle->syncServices([$haircut->id, $trim->id]);

            BranchService::query()->create(['branch_id' => $branch->id, 'service_id' => $facial->id, 'price_override' => 9500]);

            foreach (Barber::query()->get() as $barber) {
                foreach ([$haircut, $fade, $kids, $trim, $shave] as $service) {
                    $senior = $barber->user_id === $seniorUser->id && $service->is($haircut);
                    BarberService::query()->create(['barber_id' => $barber->id, 'service_id' => $service->id, 'price_override' => $senior ? 8000 : null]);
                }
            }
        });
    }
}
