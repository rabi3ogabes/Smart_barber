<?php

use App\Core\Audit\AuditLog;
use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Tenancy;
use App\Modules\Salon\Models\BranchClosure;
use App\Modules\Salon\Models\BranchOpeningHour;
use Inertia\Testing\AssertableInertia as Assert;

function branchPayload(array $overrides = []): array
{
    return array_replace([
        'name' => ['ar' => 'فرع لوسيل', 'en' => 'Lusail'],
        'address' => ['ar' => 'لوسيل، مارينا', 'en' => 'Lusail Marina'],
        'phone' => '+97444556677',
        'lat' => '25.4210',
        'lng' => '51.4900',
        'timezone' => 'Asia/Qatar',
        'hours' => [
            0 => [['start' => '10:00', 'end' => '13:00'], ['start' => '16:00', 'end' => '23:00']],
            5 => [['start' => '14:00', 'end' => '23:00']],
        ],
    ], $overrides);
}

function owner2fa(object $test): array
{
    $s = $test->makeSalon();
    $test->enableTwoFactor($s['owner']);

    return $s;
}

it('creates a branch with multi-range opening hours', function () {
    ['salon' => $salon, 'owner' => $owner] = owner2fa($this);

    $this->actingAs($owner)->post($this->salonUrl($salon, '/branches'), branchPayload())->assertRedirect()->assertSessionHasNoErrors();

    Tenancy::runAs($salon, function () {
        $branch = Branch::query()->where('name->en', 'Lusail')->firstOrFail();
        expect($branch->phone)->toBe('+97444556677')
            ->and(BranchOpeningHour::query()->where('branch_id', $branch->id)->orderBy('weekday')->orderBy('opens_at')->get()
                ->map(fn ($h) => [$h->weekday, substr($h->opens_at, 0, 5), substr($h->closes_at, 0, 5)])->all())
            ->toBe([[0, '10:00', '13:00'], [0, '16:00', '23:00'], [5, '14:00', '23:00']]);
    });
});

it('rejects overlapping or inverted ranges and bad times', function (array $hours) {
    ['salon' => $salon, 'owner' => $owner] = owner2fa($this);

    $this->actingAs($owner)->post($this->salonUrl($salon, '/branches'), branchPayload(['hours' => $hours]))->assertSessionHasErrors();
    expect(Tenancy::runAs($salon, fn () => Branch::query()->count()))->toBe(1);
})->with([
    'overlap' => [[1 => [['start' => '10:00', 'end' => '14:00'], ['start' => '13:00', 'end' => '18:00']]]],
    'inverted' => [[1 => [['start' => '18:00', 'end' => '10:00']]]],
    'bad format' => [[1 => [['start' => '9am', 'end' => '18:00']]]],
    'bad weekday' => [[9 => [['start' => '10:00', 'end' => '18:00']]]],
    'too many ranges' => [[1 => array_map(fn ($h) => ['start' => sprintf('%02d:00', $h), 'end' => sprintf('%02d:30', $h)], range(8, 12))]],
]);

it('lists branches with hours, team and permissions', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = owner2fa($this);
    $this->memberOf($salon, P::BARBER, [$branch]);

    $this->actingAs($owner)->get($this->salonUrl($salon, '/branches'))
        ->assertInertia(fn (Assert $page) => $page->component('Branches/Index')
            ->has('branches', 1)
            ->where('branches.0.id', $branch->public_id)
            ->where('branches.0.can_update', true)
            ->where('can.create', true)
            ->where('branches.0.staff', fn ($names) => count($names) >= 1));
});

it('lets a branch manager edit their own branch hours but not create, deactivate or touch other branches', function () {
    ['salon' => $salon, 'branch' => $mine] = $this->makeSalon();
    $other = $this->addBranch($salon, 'Al Sadd');
    $manager = $this->memberOf($salon, P::BRANCH_MANAGER, [$mine]);

    $this->actingAs($manager)->put($this->salonUrl($salon, "/branches/{$mine->public_id}"), branchPayload(['name' => ['ar' => 'الخليج الغربي', 'en' => 'West Bay']]))
        ->assertRedirect()->assertSessionHasNoErrors();
    $this->actingAs($manager)->post($this->salonUrl($salon, '/branches'), branchPayload())->assertForbidden();
    $this->actingAs($manager)->put($this->salonUrl($salon, "/branches/{$mine->public_id}/status"), ['active' => false])->assertForbidden();
    $this->actingAs($manager)->put($this->salonUrl($salon, "/branches/{$other->public_id}"), branchPayload())->assertNotFound();
    $this->actingAs($manager)->post($this->salonUrl($salon, '/closures'), ['branch' => $other->public_id, 'starts_on' => now()->addDay()->toDateString(), 'ends_on' => now()->addDay()->toDateString()])->assertNotFound();
    $this->actingAs($manager)->post($this->salonUrl($salon, '/closures'), ['branch' => null, 'starts_on' => now()->addDay()->toDateString(), 'ends_on' => now()->addDay()->toDateString()])->assertForbidden();

    $this->actingAs($manager)->get($this->salonUrl($salon, '/branches'))
        ->assertInertia(fn (Assert $page) => $page->has('branches', 1)->where('branches.0.id', $mine->public_id)->where('can.create', false));

    expect(Tenancy::runAs($salon, fn () => Branch::query()->count()))->toBe(2);
});

it('audits opening-hour changes', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = owner2fa($this);

    $this->actingAs($owner)->put($this->salonUrl($salon, "/branches/{$branch->public_id}"), branchPayload())->assertSessionHasNoErrors();

    expect(AuditLog::query()->where('salon_id', $salon->id)->where('event', 'branches.hours_changed')->exists())->toBeTrue();
});

it('deactivates and reactivates a branch but never the last active one', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = owner2fa($this);

    $this->actingAs($owner)->put($this->salonUrl($salon, "/branches/{$branch->public_id}/status"), ['active' => false])->assertSessionHasErrors();
    expect(Tenancy::runAs($salon, fn () => $branch->refresh()->is_active))->toBeTrue();

    $second = $this->addBranch($salon);
    $this->actingAs($owner)->put($this->salonUrl($salon, "/branches/{$second->public_id}/status"), ['active' => false])->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => $second->refresh()->is_active))->toBeFalse();
    $this->actingAs($owner)->put($this->salonUrl($salon, "/branches/{$second->public_id}/status"), ['active' => true])->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => $second->refresh()->is_active))->toBeTrue();
});

it('adds and removes branch and salon-wide closures', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = owner2fa($this);
    $day = now('Asia/Qatar')->addDays(3)->toDateString();

    $this->actingAs($owner)->post($this->salonUrl($salon, '/closures'), ['branch' => $branch->public_id, 'starts_on' => $day, 'ends_on' => $day, 'reason' => ['en' => 'Renovation']])->assertSessionHasNoErrors();
    $this->actingAs($owner)->post($this->salonUrl($salon, '/closures'), ['branch' => null, 'starts_on' => $day, 'ends_on' => $day, 'reason' => ['ar' => 'عيد']])->assertSessionHasNoErrors();
    $this->actingAs($owner)->post($this->salonUrl($salon, '/closures'), ['starts_on' => '2020-01-01', 'ends_on' => '2020-01-01'])->assertSessionHasErrors('starts_on');

    $closures = Tenancy::runAs($salon, fn () => BranchClosure::query()->get());
    expect($closures)->toHaveCount(2);

    $this->actingAs($owner)->delete($this->salonUrl($salon, "/closures/{$closures->first()->public_id}"))->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => BranchClosure::query()->count()))->toBe(1);
});

it('isolates branches between salons', function () {
    ['salon' => $a, 'owner' => $ownerA] = owner2fa($this);
    ['branch' => $branchOfB] = $this->makeSalon('salon-b');

    $this->actingAs($ownerA)->put($this->salonUrl($a, "/branches/{$branchOfB->public_id}"), branchPayload())->assertNotFound();
    $this->actingAs($ownerA)->put($this->salonUrl($a, "/branches/{$branchOfB->public_id}/status"), ['active' => false])->assertNotFound();
    $this->actingAs($ownerA)->post($this->salonUrl($a, '/closures'), ['branch' => $branchOfB->public_id, 'starts_on' => now()->addDay()->toDateString(), 'ends_on' => now()->addDay()->toDateString()])->assertNotFound();
});
