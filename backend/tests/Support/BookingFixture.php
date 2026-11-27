<?php

namespace Tests\Support;

use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Booking\Support\Selection;
use App\Modules\Catalog\Models\BarberService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Customer\Models\Customer;
use App\Modules\Salon\Actions\SetOpeningHours;
use App\Modules\Staff\Actions\SetWeeklySchedule;
use App\Modules\Staff\Models\Barber;
use Carbon\CarbonImmutable;
use Tests\TestCase;

/**
 * A salon with one branch open 10:00–22:00 every day (Asia/Qatar), two barbers working
 * 10:00–18:00 with a 13:00–13:30 break, a 30-min haircut (+5 min buffer, QAR 60) and a 20-min
 * beard trim (QAR 40) that both barbers perform, and one customer.
 */
final class BookingFixture
{
    public Salon $salon;

    public Branch $branch;

    public User $owner;

    public Barber $barberA;

    public Barber $barberB;

    public Service $haircut;

    public Service $beard;

    public Customer $customer;

    public static function make(TestCase $test, string $slug = 'salon-a'): self
    {
        $f = new self;
        ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $test->makeSalon($slug);
        $test->enableTwoFactor($owner);
        $a = $test->memberOf($salon, P::BARBER, [$branch]);
        $b = $test->memberOf($salon, P::BARBER, [$branch]);
        $f->owner = $owner;

        Tenancy::runAs($salon, function () use ($f, $salon, $branch, $a, $b) {
            $week = fn (string $s, string $e) => collect(range(0, 6))->mapWithKeys(fn ($d) => [$d => [['start' => $s, 'end' => $e]]])->all();
            app(SetOpeningHours::class)($branch, $week('10:00', '22:00'));
            $f->salon = $salon->fresh();
            $f->branch = $branch->fresh();
            $f->barberA = Barber::query()->where('user_id', $a->id)->firstOrFail();
            $f->barberB = Barber::query()->where('user_id', $b->id)->firstOrFail();
            $f->barberB->forceFill(['sort_order' => 1])->save();
            foreach ([$f->barberA, $f->barberB] as $barber) {
                app(SetWeeklySchedule::class)($barber, $branch, $week('10:00', '18:00'), $week('13:00', '13:30'));
            }
            $f->haircut = Service::factory()->create(['name' => ['ar' => 'قص', 'en' => 'Haircut'], 'base_price' => 6000, 'duration_minutes' => 30, 'buffer_minutes' => 5]);
            $f->beard = Service::factory()->create(['category_id' => $f->haircut->category_id, 'name' => ['ar' => 'لحية', 'en' => 'Beard'], 'base_price' => 4000, 'duration_minutes' => 20, 'buffer_minutes' => 0]);
            foreach ([$f->barberA, $f->barberB] as $barber) {
                foreach ([$f->haircut, $f->beard] as $service) {
                    BarberService::query()->create(['barber_id' => $barber->id, 'service_id' => $service->id]);
                }
            }
            $f->customer = Customer::query()->create(['name' => 'Ali', 'phone' => '+97455000001']);
        });

        return $f;
    }

    /** A branch-local date a few days ahead, so lead time and "now" never interfere. */
    public static function day(int $daysAhead = 3): string
    {
        return CarbonImmutable::now('Asia/Qatar')->addDays($daysAhead)->toDateString();
    }

    /** UTC instant for a Qatar wall-clock time on day(). */
    public static function at(string $time, int $daysAhead = 3): CarbonImmutable
    {
        return CarbonImmutable::parse(self::day($daysAhead).' '.$time, 'Asia/Qatar')->utc();
    }

    public function haircut(): Selection
    {
        return new Selection([$this->haircut]);
    }

    /**
     * @template T
     *
     * @param  callable(): T  $fn
     * @return T
     */
    public function run(callable $fn): mixed
    {
        return Tenancy::runAs($this->salon, $fn);
    }
}
