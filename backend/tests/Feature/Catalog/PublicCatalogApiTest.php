<?php

use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use App\Modules\Catalog\Models\BarberService;
use App\Modules\Catalog\Models\BranchService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Models\ServiceCategory;
use App\Modules\Staff\Models\Barber;

function publicCatalog(object $test): array
{
    ['salon' => $salon, 'branch' => $branch] = $test->makeSalon();
    $senior = $test->memberOf($salon, P::BARBER, [$branch]);
    $junior = $test->memberOf($salon, P::BARBER, [$branch]);

    return Tenancy::runAs($salon, function () use ($salon, $branch, $senior, $junior) {
        $cuts = ServiceCategory::factory()->create(['name' => ['ar' => 'قص', 'en' => 'Haircuts'], 'sort_order' => 1]);
        $beard = ServiceCategory::factory()->create(['name' => ['ar' => 'لحية', 'en' => 'Beard'], 'sort_order' => 0]);
        $hidden = ServiceCategory::factory()->create(['name' => ['ar' => 'مخفي', 'en' => 'Hidden'], 'is_active' => false]);
        $haircut = Service::factory()->create(['category_id' => $cuts->id, 'name' => ['ar' => 'قص', 'en' => 'Haircut'], 'base_price' => 6000]);
        $trim = Service::factory()->create(['category_id' => $beard->id, 'name' => ['ar' => 'لحية', 'en' => 'Beard trim'], 'base_price' => 4000]);
        Service::factory()->create(['category_id' => $cuts->id, 'name' => ['ar' => 'داخلي', 'en' => 'In-salon only'], 'is_bookable_online' => false]);
        Service::factory()->create(['category_id' => $cuts->id, 'name' => ['ar' => 'قديم', 'en' => 'Retired'], 'is_active' => false]);
        Service::factory()->create(['category_id' => $hidden->id, 'name' => ['ar' => 'x', 'en' => 'In hidden category']]);
        BranchService::query()->create(['branch_id' => $branch->id, 'service_id' => $haircut->id, 'price_override' => 7000]);
        $towel = ServiceAddon::query()->create(['name' => ['ar' => 'منشفة', 'en' => 'Hot towel'], 'price' => 1500, 'extra_minutes' => 5]);
        $towel->syncServices([$trim->id]);
        $bundle = ServiceBundle::query()->create(['name' => ['ar' => 'باقة', 'en' => 'Hair + Beard'], 'price' => 9000]);
        $bundle->syncServices([$haircut->id, $trim->id]);
        $seniorBarber = Barber::query()->where('user_id', $senior->id)->firstOrFail();
        $juniorBarber = Barber::query()->where('user_id', $junior->id)->firstOrFail();
        BarberService::query()->create(['barber_id' => $seniorBarber->id, 'service_id' => $haircut->id, 'price_override' => 9000]);
        BarberService::query()->create(['barber_id' => $juniorBarber->id, 'service_id' => $haircut->id]);

        return compact('salon', 'branch', 'cuts', 'beard', 'haircut', 'trim', 'seniorBarber', 'juniorBarber', 'bundle');
    });
}

it('lists categories that have bookable services at the branch, in order', function () {
    $f = publicCatalog($this);

    $this->getJson("/api/v1/branches/{$f['branch']->public_id}/service-categories")
        ->assertOk()
        ->assertJsonCount(2, 'data')
        ->assertJsonPath('data.0.id', $f['beard']->public_id)
        ->assertJsonPath('data.1.id', $f['cuts']->public_id)
        ->assertJsonPath('data.1.services_count', 1);
});

it('lists bookable services with the branch price, add-ons and bundles', function () {
    $f = publicCatalog($this);
    $data = $this->getJson("/api/v1/branches/{$f['branch']->public_id}/services")->assertOk()->json('data');

    expect(collect($data['services'])->pluck('name.en')->all())->toBe(['Haircut', 'Beard trim'])
        ->and($data['services'][0]['price'])->toMatchArray(['amount' => 7000, 'currency' => 'QAR'])
        ->and($data['services'][1]['addons'][0]['price']['amount'])->toBe(1500)
        ->and($data['bundles'][0]['price']['amount'])->toBe(9000)
        ->and($data['bundles'][0]['services'])->toBe([$f['haircut']->public_id, $f['trim']->public_id]);

    $beardOnly = $this->getJson("/api/v1/branches/{$f['branch']->public_id}/services?category={$f['beard']->public_id}")->json('data');
    expect(collect($beardOnly['services'])->pluck('id')->all())->toBe([$f['trim']->public_id])
        ->and($beardOnly['bundles'])->toHaveCount(1);
});

it('hides services switched off at the branch, and bundles that contain them', function () {
    $f = publicCatalog($this);
    Tenancy::runAs($f['salon'], fn () => BranchService::query()->create(['branch_id' => $f['branch']->id, 'service_id' => $f['trim']->id, 'is_available' => false]));

    $data = $this->getJson("/api/v1/branches/{$f['branch']->public_id}/services")->json('data');
    expect(collect($data['services'])->pluck('id')->all())->toBe([$f['haircut']->public_id])
        ->and($data['bundles'])->toBe([]);
    $this->getJson("/api/v1/branches/{$f['branch']->public_id}/services/{$f['trim']->public_id}")->assertNotFound();
});

it('shows a service with its barbers and their price only when it differs', function () {
    $f = publicCatalog($this);

    $data = $this->getJson("/api/v1/branches/{$f['branch']->public_id}/services/{$f['haircut']->public_id}")->assertOk()->json('data');
    $barbers = collect($data['barbers'])->keyBy('id');

    expect($data['price']['amount'])->toBe(7000)
        ->and($barbers)->toHaveCount(2)
        ->and($barbers[$f['seniorBarber']->public_id]['price']['amount'])->toBe(9000)
        ->and($barbers[$f['juniorBarber']->public_id]['price'])->toBeNull();
});

it('hides the catalog of suspended salons and of other salons\' branches', function () {
    $f = publicCatalog($this);
    ['branch' => $otherBranch] = $this->makeSalon('salon-b');

    $this->getJson("/api/v1/branches/{$otherBranch->public_id}/services")->assertOk()->assertJsonPath('data.services', []);
    $this->getJson("/api/v1/branches/{$otherBranch->public_id}/services/{$f['haircut']->public_id}")->assertNotFound();

    Salon::query()->whereKey($f['salon']->id)->update(['status' => Salon::STATUS_SUSPENDED]);
    $this->getJson("/api/v1/branches/{$f['branch']->public_id}/services")->assertNotFound();
});
