<?php

namespace Database\Seeders;

use App\Core\Authorization\PermissionCatalog;
use App\Core\Exceptions\AppException;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Actions\AddMember;
use App\Core\Tenancy\Actions\CreateSalon;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Actions\CreateBooking;
use App\Modules\Booking\Enums\BookingSource;
use App\Modules\Booking\Models\Booking;
use App\Modules\Booking\Support\Selection;
use App\Modules\Catalog\Models\BarberService;
use App\Modules\Catalog\Models\BranchService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Models\ServiceCategory;
use App\Modules\Customer\Actions\FindOrCreateCustomer;
use App\Modules\Salon\Actions\SetOpeningHours;
use App\Modules\Staff\Actions\SetWeeklySchedule;
use App\Modules\Staff\Models\Barber;
use Carbon\CarbonImmutable;

/**
 * One demo salon: an owner, a branch manager, one branch with opening hours, two barbers with
 * weekly schedules and a break, and a service menu with a branch price, a senior-barber price,
 * add-ons and a bundle. Used by DatabaseSeeder (local demo) and by `smartbarber:demo-salon`
 * (a hosted demo, with random passwords).
 */
final class DemoSalonBuilder
{
    /**
     * @param  array{slug: string, ar: string, en: string, branch_ar: string, branch_en: string}  $s
     * @param  callable(string): string  $email  role key (owner, manager, barber, barber2) → email
     * @param  callable(): string  $password
     * @return list<array{role: string, name: string, email: string, password: string}>
     */
    public function build(array $s, callable $email, callable $password): array
    {
        $accounts = [];
        $user = function (string $role, string $name) use ($email, $password, &$accounts): User {
            $pw = $password();
            $u = User::query()->firstOrCreate(['email' => $email($role)], ['name' => $name, 'password' => $pw, 'locale' => 'ar']);
            if ($u->wasRecentlyCreated) {
                $accounts[] = ['role' => $role, 'name' => $name, 'email' => $u->email, 'password' => $pw];
            }

            return $u;
        };

        $owner = $user('owner', "Owner {$s['en']}");
        $salon = app(CreateSalon::class)(['ar' => $s['ar'], 'en' => $s['en']], $s['slug'], $owner, ['ar' => $s['branch_ar'], 'en' => $s['branch_en']]);
        $branch = Tenancy::runAs($salon, fn () => $salon->branches()->firstOrFail());

        $barber = $user('barber', "Barber {$s['en']}");
        app(AddMember::class)($salon, $barber, [PermissionCatalog::BARBER], [$branch]);
        $manager = $user('manager', "Manager {$s['en']}");
        app(AddMember::class)($salon, $manager, [PermissionCatalog::BRANCH_MANAGER], [$branch]);
        $barber2 = $user('barber2', "Second Barber {$s['en']}");
        app(AddMember::class)($salon, $barber2, [PermissionCatalog::BARBER], [$branch]);

        $this->seedSchedules($salon, $branch, [$barber, $barber2]);
        $this->seedCatalog($salon, $branch, $barber);
        $this->seedBookings($salon, $branch);

        return $accounts;
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

    /**
     * A few customers and today's / tomorrow's appointments (Phase 4), booked through the real
     * engine so every rule applies. Times that do not fit the schedule are skipped.
     */
    private function seedBookings(Salon $salon, Branch $branch): void
    {
        Tenancy::runAs($salon, function () use ($branch): void {
            if (Booking::query()->exists()) {
                return;
            }
            $customers = collect([['Ahmed Al-Kuwari', '+97455100001'], ['Khalid Al-Mannai', '+97455100002'], ['Yousef Hassan', '+97455100003'], ['Faisal Al-Thani', '+97455100004'], ['Omar Saleh', '+97455100005']])
                ->map(fn ($c) => app(FindOrCreateCustomer::class)($c[1], $c[0]));
            $services = Service::query()->orderBy('id')->get()->keyBy(fn (Service $s): string => (string) $s->getTranslation('name', 'en'));
            $barbers = Barber::query()->orderBy('sort_order')->orderBy('id')->get();
            $plan = [
                [0, '16:00', 0, ['Haircut']], [0, '16:45', 1, ['Skin fade']], [0, '17:30', 2, ['Beard trim']],
                [0, '18:00', 3, ['Haircut', 'Beard trim']], [0, '19:00', 4, ['Hot towel shave']],
                [1, '15:00', 1, ['Skin fade']], [1, '16:00', 0, ['Kids cut']], [1, '20:00', 3, ['Haircut']],
            ];
            foreach ($plan as $i => [$day, $time, $customer, $names]) {
                $startsAt = CarbonImmutable::parse(now($branch->timezone)->addDays($day)->toDateString().' '.$time, $branch->timezone)->utc();
                if ($startsAt->isPast()) {
                    continue;
                }
                $selection = new Selection(array_values(array_filter(array_map(fn ($n) => $services->get($n), $names))));
                try {
                    app(CreateBooking::class)($branch, $customers[$customer], $selection, $startsAt, BookingSource::Dashboard, $barbers[$i % max(1, $barbers->count())] ?? null);
                } catch (AppException) {
                    // outside that barber's hours or taken: skip
                }
            }
        });
    }
}
