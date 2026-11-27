<?php

use App\Core\Audit\AuditLog;
use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Tenancy\Models\SalonMembership;
use App\Core\Tenancy\Tenancy;
use App\Modules\Staff\Models\Barber;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Inertia\Testing\AssertableInertia as Assert;

function membership($salon, $user): SalonMembership
{
    // Fresh from the database: User::membershipIn() may hold an already-loaded relation.
    return SalonMembership::query()->withoutGlobalScopes()->where('salon_id', $salon->id)->where('user_id', $user->id)->firstOrFail();
}

it('lists the team with roles, branches and barber profiles', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $this->enableTwoFactor($owner);
    $barber = $this->memberOf($salon, P::BARBER, [$branch]);

    $this->actingAs($owner)->get($this->salonUrl($salon, '/staff'))
        ->assertInertia(fn (Assert $page) => $page->component('Staff/Index')
            ->has('members', 2)
            ->where('members', fn ($members) => collect($members)->firstWhere('email', $barber->email)['roles'] === ['barber']
                && collect($members)->firstWhere('email', $barber->email)['barber'] !== null)
            ->where('can.invite', true)
            ->where('assignableRoles', P::ROLES));
});

it('shows a branch manager only the staff of their branches', function () {
    ['salon' => $salon, 'branch' => $mine] = $this->makeSalon();
    $other = $this->addBranch($salon);
    $manager = $this->memberOf($salon, P::BRANCH_MANAGER, [$mine]);
    $here = $this->memberOf($salon, P::BARBER, [$mine]);
    $there = $this->memberOf($salon, P::BARBER, [$other]);

    $this->actingAs($manager)->get($this->salonUrl($salon, '/staff'))
        ->assertInertia(fn (Assert $page) => $page
            ->where('members', fn ($m) => collect($m)->pluck('email')->contains($here->email) && ! collect($m)->pluck('email')->contains($there->email))
            ->where('assignableRoles', [P::RECEPTIONIST, P::BARBER]));

    $this->actingAs($manager)->put($this->salonUrl($salon, '/staff/'.membership($salon, $there)->public_id.'/access'), ['roles' => ['barber'], 'branches' => [$mine->public_id]])
        ->assertForbidden();
});

it('changes roles and branches, records old and new values, and syncs the barber profile', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $this->enableTwoFactor($owner);
    $second = $this->addBranch($salon);
    $user = $this->memberOf($salon, P::RECEPTIONIST, [$branch]);

    $this->actingAs($owner)->put($this->salonUrl($salon, '/staff/'.membership($salon, $user)->public_id.'/access'), ['roles' => ['barber', 'receptionist'], 'branches' => [$branch->public_id, $second->public_id]])
        ->assertSessionHasNoErrors();

    $log = AuditLog::query()->where('salon_id', $salon->id)->where('event', 'membership.access_changed')->latest('id')->firstOrFail();
    expect($log->old_values['roles'])->toBe(['receptionist'])
        ->and($log->new_values['roles'])->toBe(['barber', 'receptionist'])
        ->and($log->new_values['branches'])->toHaveCount(2)
        ->and($log->actor_id)->toBe($owner->id);

    Tenancy::runAs($salon, function () use ($user, $branch, $second) {
        $barber = Barber::query()->where('user_id', $user->id)->firstOrFail();
        expect($barber->branches()->pluck('branches.id')->sort()->values()->all())->toBe(collect([$branch->id, $second->id])->sort()->values()->all());
    });

    // Removing the barber role keeps the profile (history) but stops bookings.
    $this->actingAs($owner)->put($this->salonUrl($salon, '/staff/'.membership($salon, $user)->public_id.'/access'), ['roles' => ['receptionist'], 'branches' => [$branch->public_id]])
        ->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => Barber::query()->where('user_id', $user->id)->firstOrFail()->is_bookable))->toBeFalse();
});

it('lets a branch manager move a barber between their branches but not change roles', function () {
    ['salon' => $salon, 'branch' => $a] = $this->makeSalon();
    $b = $this->addBranch($salon);
    $manager = $this->memberOf($salon, P::BRANCH_MANAGER, [$a, $b]);
    $barber = $this->memberOf($salon, P::BARBER, [$a]);
    $url = $this->salonUrl($salon, '/staff/'.membership($salon, $barber)->public_id.'/access');

    $this->actingAs($manager)->put($url, ['roles' => ['barber'], 'branches' => [$a->public_id, $b->public_id]])->assertSessionHasNoErrors();
    $this->actingAs($manager)->put($url, ['roles' => ['receptionist'], 'branches' => [$a->public_id]])->assertSessionHasErrors('roles');
});

it('stops a GM from touching owner or GM roles and anyone from changing their own access', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $gm = $this->memberOf($salon, P::GENERAL_MANAGER);
    $this->enableTwoFactor($gm);
    $this->enableTwoFactor($owner);

    $this->actingAs($gm)->put($this->salonUrl($salon, '/staff/'.membership($salon, $owner)->public_id.'/access'), ['roles' => ['receptionist'], 'branches' => [$branch->public_id]])
        ->assertSessionHasErrors('roles');
    $this->actingAs($owner)->put($this->salonUrl($salon, '/staff/'.membership($salon, $owner)->public_id.'/access'), ['roles' => ['general_manager'], 'branches' => []])
        ->assertSessionHasErrors('roles');
    expect(Tenancy::runAs($salon, fn () => $owner->fresh()->hasRole(P::OWNER)))->toBeTrue();
});

it('never removes the last active owner', function () {
    ['salon' => $salon, 'owner' => $owner] = $this->makeSalon();
    $co = $this->memberOf($salon, P::OWNER);
    $this->enableTwoFactor($co);

    // Two owners: one may demote the other.
    $this->actingAs($co)->put($this->salonUrl($salon, '/staff/'.membership($salon, $owner)->public_id.'/access'), ['roles' => ['general_manager'], 'branches' => []])
        ->assertSessionHasNoErrors();
    // Now $co is the only owner; deactivating them is impossible from anyone (and self-change is blocked).
    $this->actingAs($co)->put($this->salonUrl($salon, '/staff/'.membership($salon, $co)->public_id.'/status'), ['active' => false])->assertSessionHasErrors();
    expect(membership($salon, $co)->isActive())->toBeTrue();
});

it('deactivates a member: revokes their app tokens, stops bookings, keeps history; reactivation restores', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $this->enableTwoFactor($owner);
    $barber = $this->memberOf($salon, P::BARBER, [$branch]);
    $headers = $this->staffHeaders($barber, $salon);
    $this->getJson('/api/v1/staff/me', $headers)->assertOk();
    app('auth')->shouldUse('web'); // the API request switched the default guard to "staff"

    $this->actingAs($owner)->put($this->salonUrl($salon, '/staff/'.membership($salon, $barber)->public_id.'/status'), ['active' => false])->assertRedirect()->assertSessionHasNoErrors();

    expect(membership($salon, $barber)->status)->toBe(SalonMembership::STATUS_DEACTIVATED)
        ->and(DB::table('personal_access_tokens')->where('tokenable_id', $barber->id)->count())->toBe(0)
        ->and(Tenancy::runAs($salon, fn () => Barber::query()->where('user_id', $barber->id)->firstOrFail()->is_bookable))->toBeFalse()
        ->and(AuditLog::query()->where('event', 'membership.deactivated')->exists())->toBeTrue();
    app('auth')->shouldUse('web');
    $this->getJson('/api/v1/staff/me', $headers)->assertUnauthorized();
    app('auth')->shouldUse('web');

    $this->actingAs($owner)->put($this->salonUrl($salon, '/staff/'.membership($salon, $barber)->public_id.'/status'), ['active' => true])->assertSessionHasNoErrors();
    expect(membership($salon, $barber)->isActive())->toBeTrue()
        ->and(Tenancy::runAs($salon, fn () => Barber::query()->where('user_id', $barber->id)->firstOrFail()->is_bookable))->toBeTrue();
});

it('only lets owners and GMs deactivate staff', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $manager = $this->memberOf($salon, P::BRANCH_MANAGER, [$branch]);
    $barber = $this->memberOf($salon, P::BARBER, [$branch]);

    $this->actingAs($manager)->put($this->salonUrl($salon, '/staff/'.membership($salon, $barber)->public_id.'/status'), ['active' => false])->assertForbidden();
});

it('lets a barber edit their own profile but not bookability or order; managers can', function () {
    Storage::fake('media');
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $barberUser = $this->memberOf($salon, P::BARBER, [$branch]);
    $colleague = $this->memberOf($salon, P::BARBER, [$branch]);
    $manager = $this->memberOf($salon, P::BRANCH_MANAGER, [$branch]);
    [$mine, $theirs] = Tenancy::runAs($salon, fn () => [Barber::query()->where('user_id', $barberUser->id)->firstOrFail(), Barber::query()->where('user_id', $colleague->id)->firstOrFail()]);
    $payload = ['display_name' => ['ar' => 'عمر', 'en' => 'Omar'], 'bio' => ['en' => 'Fades and beard design.'], 'specialties' => ['fade', 'beard'], 'years_experience' => 8];

    $this->actingAs($barberUser)->post($this->salonUrl($salon, "/barbers/{$mine->public_id}/profile"), $payload + ['is_bookable' => false, 'sort_order' => 1, 'photo' => UploadedFile::fake()->image('me.jpg', 400, 400)])
        ->assertSessionHasNoErrors();
    Tenancy::runAs($salon, function () use ($mine) {
        $mine->refresh();
        expect($mine->getTranslation('display_name', 'en'))->toBe('Omar')
            ->and($mine->specialties)->toBe(['fade', 'beard'])
            ->and($mine->photo_media_id)->not->toBeNull()
            ->and($mine->is_bookable)->toBeTrue(); // ignored for a barber
    });

    $this->actingAs($barberUser)->post($this->salonUrl($salon, "/barbers/{$theirs->public_id}/profile"), $payload)->assertForbidden();
    $this->actingAs($barberUser)->post($this->salonUrl($salon, "/barbers/{$mine->public_id}/profile"), ['specialties' => ['juggling']] + $payload)->assertSessionHasErrors('specialties.0');

    $this->actingAs($manager)->post($this->salonUrl($salon, "/barbers/{$theirs->public_id}/profile"), $payload + ['is_bookable' => false, 'sort_order' => 3])->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => $theirs->refresh()->is_bookable))->toBeFalse();
});

it('isolates staff records between salons', function () {
    ['salon' => $a, 'owner' => $ownerA] = $this->makeSalon('salon-a');
    ['salon' => $b, 'branch' => $branchB] = $this->makeSalon('salon-b');
    $this->enableTwoFactor($ownerA);
    $barberB = $this->memberOf($b, P::BARBER, [$branchB]);
    $profileB = Tenancy::runAs($b, fn () => Barber::query()->where('user_id', $barberB->id)->firstOrFail());

    $this->actingAs($ownerA)->put($this->salonUrl($a, '/staff/'.membership($b, $barberB)->public_id.'/status'), ['active' => false])->assertNotFound();
    $this->actingAs($ownerA)->put($this->salonUrl($a, '/staff/'.membership($b, $barberB)->public_id.'/access'), ['roles' => ['barber'], 'branches' => []])->assertNotFound();
    $this->actingAs($ownerA)->post($this->salonUrl($a, "/barbers/{$profileB->public_id}/profile"), ['display_name' => ['ar' => 'x', 'en' => 'x'], 'specialties' => []])->assertNotFound();
    $this->actingAs($ownerA)->get($this->salonUrl($a, '/staff'))->assertInertia(fn (Assert $page) => $page->where('members', fn ($m) => ! collect($m)->pluck('email')->contains($barberB->email)));
    expect(membership($b, $barberB)->isActive())->toBeTrue();
});
