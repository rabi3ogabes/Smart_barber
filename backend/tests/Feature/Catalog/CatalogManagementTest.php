<?php

use App\Core\Audit\AuditLog;
use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Tenancy\Tenancy;
use App\Modules\Catalog\Events\ServicePriceChanged;
use App\Modules\Catalog\Models\BarberService;
use App\Modules\Catalog\Models\BranchService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;
use App\Modules\Catalog\Models\ServiceCategory;
use App\Modules\Staff\Models\Barber;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Storage;
use Inertia\Testing\AssertableInertia as Assert;

function catalogOwner(object $test, string $slug = 'salon-a'): array
{
    $s = $test->makeSalon($slug);
    $test->enableTwoFactor($s['owner']);
    $s['category'] = Tenancy::runAs($s['salon'], fn () => ServiceCategory::factory()->create(['name' => ['ar' => 'قص', 'en' => 'Haircuts']]));

    return $s;
}

function servicePayload(string $category, array $overrides = []): array
{
    return array_replace([
        'category' => $category,
        'name' => ['ar' => 'قص شعر', 'en' => 'Haircut'],
        'description' => ['ar' => null, 'en' => 'Wash, cut and style'],
        'base_price' => '60.00',
        'duration_minutes' => 30,
        'buffer_minutes' => 5,
        'tax_class' => 'standard',
        'is_active' => true,
        'is_bookable_online' => true,
    ], $overrides);
}

it('creates categories at the end of the list and reorders them', function () {
    ['salon' => $salon, 'owner' => $owner, 'category' => $first] = catalogOwner($this);

    $this->actingAs($owner)->post($this->salonUrl($salon, '/service-categories'), ['name' => ['ar' => 'لحية', 'en' => 'Beard'], 'icon' => 'sparkles', 'is_active' => true])
        ->assertSessionHasNoErrors();
    $second = Tenancy::runAs($salon, fn () => ServiceCategory::query()->where('name->en', 'Beard')->firstOrFail());
    expect($second->sort_order)->toBeGreaterThan($first->sort_order);

    $this->actingAs($owner)->put($this->salonUrl($salon, '/service-categories/order'), ['order' => [$second->public_id, $first->public_id]])->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => ServiceCategory::query()->orderBy('sort_order')->pluck('public_id')->all()))->toBe([$second->public_id, $first->public_id]);

    // The order must name every category exactly once.
    $this->actingAs($owner)->put($this->salonUrl($salon, '/service-categories/order'), ['order' => [$second->public_id]])->assertSessionHasErrors('order');
    $this->actingAs($owner)->post($this->salonUrl($salon, '/service-categories'), ['name' => ['ar' => 'x', 'en' => 'x'], 'icon' => 'not-an-icon', 'is_active' => true])->assertSessionHasErrors('icon');
});

it('deletes only empty categories', function () {
    ['salon' => $salon, 'owner' => $owner, 'category' => $category] = catalogOwner($this);
    Tenancy::runAs($salon, fn () => Service::factory()->create(['category_id' => $category->id]));

    $this->actingAs($owner)->delete($this->salonUrl($salon, "/service-categories/{$category->public_id}"))->assertSessionHasErrors('general');
    expect(Tenancy::runAs($salon, fn () => ServiceCategory::query()->count()))->toBe(1);

    $empty = Tenancy::runAs($salon, fn () => ServiceCategory::factory()->create());
    $this->actingAs($owner)->delete($this->salonUrl($salon, "/service-categories/{$empty->public_id}"))->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => ServiceCategory::query()->count()))->toBe(1);
});

it('creates a service with the price in minor units and lists it', function () {
    ['salon' => $salon, 'owner' => $owner, 'category' => $category] = catalogOwner($this);

    $this->actingAs($owner)->post($this->salonUrl($salon, '/services'), servicePayload($category->public_id, ['base_price' => '65.50']))->assertSessionHasNoErrors();

    $service = Tenancy::runAs($salon, fn () => Service::query()->firstOrFail());
    expect($service->base_price)->toBe(6550)->and($service->getTranslation('description', 'en'))->toBe('Wash, cut and style');

    $this->actingAs($owner)->get($this->salonUrl($salon, '/services'))
        ->assertInertia(fn (Assert $page) => $page->component('Services/Index')
            ->where('services.0.id', $service->public_id)
            ->where('services.0.price.amount', 6550)
            ->where('services.0.base_price', '65.50')
            ->where('can.manage', true)
            ->where('can.updatePrices', true));
});

it('validates services', function () {
    ['salon' => $salon, 'owner' => $owner, 'category' => $category] = catalogOwner($this);

    $this->actingAs($owner)->post($this->salonUrl($salon, '/services'), servicePayload($category->public_id, [
        'name' => ['ar' => '', 'en' => 'x'], 'base_price' => '-1', 'duration_minutes' => 0, 'tax_class' => 'luxury', 'base_price_extra' => 1,
    ]))->assertSessionHasErrors(['name.ar', 'base_price', 'duration_minutes', 'tax_class']);
    $this->actingAs($owner)->post($this->salonUrl($salon, '/services'), servicePayload($category->public_id, ['base_price' => '10.12345']))->assertSessionHasErrors('base_price');
});

it('audits every price change with old and new minor units and emits an event', function () {
    Event::fake([ServicePriceChanged::class]);
    ['salon' => $salon, 'owner' => $owner, 'category' => $category, 'branch' => $branch] = catalogOwner($this);
    $barberUser = $this->memberOf($salon, P::BARBER, [$branch]);
    [$service, $barber] = Tenancy::runAs($salon, fn () => [Service::factory()->create(['category_id' => $category->id, 'base_price' => 6000]), Barber::query()->where('user_id', $barberUser->id)->firstOrFail()]);

    $this->actingAs($owner)->put($this->salonUrl($salon, "/services/{$service->public_id}"), servicePayload($category->public_id, ['base_price' => '70']))->assertSessionHasNoErrors();
    $this->actingAs($owner)->put($this->salonUrl($salon, "/services/{$service->public_id}/branches/{$branch->public_id}"), ['is_available' => true, 'price_override' => '75'])->assertSessionHasNoErrors();
    $this->actingAs($owner)->put($this->salonUrl($salon, "/services/{$service->public_id}/barbers"), ['barbers' => [['barber' => $barber->public_id, 'price_override' => '90', 'duration_override' => 45]]])->assertSessionHasNoErrors();
    // Saving without a change records nothing new.
    $this->actingAs($owner)->put($this->salonUrl($salon, "/services/{$service->public_id}"), servicePayload($category->public_id, ['base_price' => '70']))->assertSessionHasNoErrors();

    $logs = AuditLog::query()->where('salon_id', $salon->id)->where('event', 'catalog.price_changed')->orderBy('id')->get();
    expect($logs)->toHaveCount(3)
        ->and($logs[0]->old_values)->toBe(['scope' => 'base', 'base_price' => 6000])
        ->and($logs[0]->new_values)->toBe(['scope' => 'base', 'base_price' => 7000])
        ->and($logs[1]->new_values)->toMatchArray(['scope' => 'branch', 'price_override' => 7500, 'is_available' => true])
        ->and($logs[2]->new_values)->toBe(['scope' => 'barber', 'barber_prices' => [$barber->public_id => 9000]])
        ->and($logs[0]->actor_id)->toBe($owner->id);
    Event::assertDispatchedTimes(ServicePriceChanged::class, 3);

    expect(Tenancy::runAs($salon, fn () => BarberService::query()->sole()->duration_override))->toBe(45);
});

it('removes the branch row when the branch goes back to the base price', function () {
    ['salon' => $salon, 'owner' => $owner, 'category' => $category, 'branch' => $branch] = catalogOwner($this);
    $service = Tenancy::runAs($salon, fn () => Service::factory()->create(['category_id' => $category->id]));
    $url = $this->salonUrl($salon, "/services/{$service->public_id}/branches/{$branch->public_id}");

    $this->actingAs($owner)->put($url, ['is_available' => false, 'price_override' => null])->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => BranchService::query()->sole()->is_available))->toBeFalse();
    $this->actingAs($owner)->put($url, ['is_available' => true, 'price_override' => ''])->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => BranchService::query()->count()))->toBe(0);
});

it('lets a branch manager set branch prices only in their branches and nothing else', function () {
    ['salon' => $salon, 'category' => $category, 'branch' => $mine] = catalogOwner($this);
    $other = $this->addBranch($salon);
    $manager = $this->memberOf($salon, P::BRANCH_MANAGER, [$mine]);
    $service = Tenancy::runAs($salon, fn () => Service::factory()->create(['category_id' => $category->id, 'base_price' => 6000]));

    $this->actingAs($manager)->put($this->salonUrl($salon, "/services/{$service->public_id}/branches/{$mine->public_id}"), ['is_available' => true, 'price_override' => '55'])->assertSessionHasNoErrors();
    $this->actingAs($manager)->put($this->salonUrl($salon, "/services/{$service->public_id}/branches/{$other->public_id}"), ['is_available' => true, 'price_override' => '1'])->assertNotFound();
    $this->actingAs($manager)->put($this->salonUrl($salon, "/services/{$service->public_id}"), servicePayload($category->public_id, ['base_price' => '1']))->assertForbidden();
    $this->actingAs($manager)->post($this->salonUrl($salon, '/service-categories'), ['name' => ['ar' => 'x', 'en' => 'x'], 'is_active' => true])->assertForbidden();
    $this->actingAs($manager)->put($this->salonUrl($salon, "/services/{$service->public_id}/barbers"), ['barbers' => []])->assertForbidden();

    $this->actingAs($manager)->get($this->salonUrl($salon, '/services'))
        ->assertInertia(fn (Assert $page) => $page->where('can.manage', false)->where('can.updatePrices', false)
            ->where('branches', fn ($b) => collect($b)->pluck('id')->all() === [$mine->public_id] && collect($b)->first()['can_price'] === true));

    expect(Tenancy::runAs($salon, fn () => [$service->fresh()->base_price, BranchService::query()->sole()->price_override]))->toBe([6000, 5500]);
});

it('lets every role read the catalog but only owners and GMs change it', function (string $role, bool $canManage) {
    ['salon' => $salon, 'category' => $category, 'branch' => $branch] = catalogOwner($this);
    $user = $this->memberOf($salon, $role, [$branch]);
    $this->enableTwoFactor($user);

    $this->actingAs($user)->get($this->salonUrl($salon, '/services'))->assertOk();
    $response = $this->actingAs($user)->post($this->salonUrl($salon, '/services'), servicePayload($category->public_id));
    $canManage ? $response->assertSessionHasNoErrors() : $response->assertForbidden();
})->with([
    'general manager' => [P::GENERAL_MANAGER, true],
    'receptionist' => [P::RECEPTIONIST, false],
    'barber' => [P::BARBER, false],
    'accountant' => [P::ACCOUNTANT, false],
    'marketing' => [P::MARKETING_MANAGER, false],
]);

it('manages add-ons and their services', function () {
    ['salon' => $salon, 'owner' => $owner, 'category' => $category] = catalogOwner($this);
    $service = Tenancy::runAs($salon, fn () => Service::factory()->create(['category_id' => $category->id]));

    $this->actingAs($owner)->post($this->salonUrl($salon, '/service-addons'), ['name' => ['ar' => 'منشفة', 'en' => 'Hot towel'], 'price' => '15', 'extra_minutes' => 5, 'tax_class' => 'standard', 'is_active' => true, 'services' => [$service->public_id]])
        ->assertSessionHasNoErrors();
    $addon = Tenancy::runAs($salon, fn () => ServiceAddon::query()->with('services')->sole());
    expect($addon->price)->toBe(1500)->and($addon->services->pluck('id')->all())->toBe([$service->id]);

    $this->actingAs($owner)->put($this->salonUrl($salon, "/services/{$service->public_id}/addons"), ['addons' => []])->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => $addon->services()->count()))->toBe(0);

    $this->actingAs($owner)->put($this->salonUrl($salon, "/service-addons/{$addon->public_id}"), ['name' => ['ar' => 'منشفة', 'en' => 'Hot towel'], 'price' => '20', 'extra_minutes' => 5, 'tax_class' => 'standard', 'is_active' => true, 'services' => []])
        ->assertSessionHasNoErrors();
    expect(AuditLog::query()->where('event', 'catalog.price_changed')->latest('id')->first()?->new_values)->toEqual(['scope' => 'addon', 'price' => 2000]);
});

it('manages bundles and shows their saving computed on the server', function () {
    ['salon' => $salon, 'owner' => $owner, 'category' => $category] = catalogOwner($this);
    [$a, $b] = Tenancy::runAs($salon, fn () => [
        Service::factory()->create(['category_id' => $category->id, 'base_price' => 6000, 'duration_minutes' => 30]),
        Service::factory()->create(['category_id' => $category->id, 'base_price' => 4000, 'duration_minutes' => 20]),
    ]);
    $payload = ['name' => ['ar' => 'قص ولحية', 'en' => 'Hair + Beard'], 'price' => '85', 'tax_class' => 'standard', 'is_active' => true, 'services' => [$a->public_id, $b->public_id]];

    $this->actingAs($owner)->post($this->salonUrl($salon, '/service-bundles'), ['services' => [$a->public_id]] + $payload)->assertSessionHasErrors('services');
    $this->actingAs($owner)->post($this->salonUrl($salon, '/service-bundles'), $payload)->assertSessionHasNoErrors();

    $this->actingAs($owner)->get($this->salonUrl($salon, '/services'))
        ->assertInertia(fn (Assert $page) => $page
            ->where('bundles.0.price.amount', 8500)
            ->where('bundles.0.regular_price.amount', 10000)
            ->where('bundles.0.saving.amount', 1500)
            ->where('bundles.0.duration_minutes', 50)
            ->where('bundles.0.services', [$a->public_id, $b->public_id]));
    expect(Tenancy::runAs($salon, fn () => ServiceBundle::query()->sole()->price))->toBe(8500);
});

it('uploads a cropped service image', function () {
    Storage::fake('media');
    ['salon' => $salon, 'owner' => $owner, 'category' => $category] = catalogOwner($this);
    $service = Tenancy::runAs($salon, fn () => Service::factory()->create(['category_id' => $category->id]));

    $this->actingAs($owner)->post($this->salonUrl($salon, "/services/{$service->public_id}/image"), ['image' => UploadedFile::fake()->image('cut.jpg', 1200, 900)])->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => $service->fresh()->image_media_id))->not->toBeNull();
    $this->actingAs($owner)->post($this->salonUrl($salon, "/services/{$service->public_id}/image"), ['image' => UploadedFile::fake()->image('tiny.jpg', 100, 100)])->assertSessionHasErrors('image');
});

it('isolates the catalog between salons', function () {
    ['salon' => $a, 'owner' => $ownerA, 'category' => $categoryA, 'branch' => $branchA] = catalogOwner($this, 'salon-a');
    ['salon' => $b, 'category' => $categoryB] = catalogOwner($this, 'salon-b');
    $serviceB = Tenancy::runAs($b, fn () => Service::factory()->create(['category_id' => $categoryB->id, 'base_price' => 6000]));

    $this->actingAs($ownerA)->put($this->salonUrl($a, "/services/{$serviceB->public_id}"), servicePayload($categoryA->public_id, ['base_price' => '1']))->assertNotFound();
    $this->actingAs($ownerA)->put($this->salonUrl($a, "/services/{$serviceB->public_id}/branches/{$branchA->public_id}"), ['is_available' => false])->assertNotFound();
    $this->actingAs($ownerA)->delete($this->salonUrl($a, "/service-categories/{$categoryB->public_id}"))->assertNotFound();
    // Salon B's category cannot be used for a salon A service.
    $this->actingAs($ownerA)->post($this->salonUrl($a, '/services'), servicePayload($categoryB->public_id))->assertNotFound();
    $this->actingAs($ownerA)->post($this->salonUrl($a, '/service-bundles'), ['name' => ['ar' => 'x', 'en' => 'x'], 'price' => '1', 'tax_class' => 'standard', 'is_active' => true, 'services' => [$serviceB->public_id, $serviceB->public_id]])->assertSessionHasErrors();
    $this->actingAs($ownerA)->get($this->salonUrl($a, '/services'))->assertInertia(fn (Assert $page) => $page->has('services', 0)->has('categories', 1));

    expect(Tenancy::runAs($b, fn () => $serviceB->fresh()->base_price))->toBe(6000);
});
