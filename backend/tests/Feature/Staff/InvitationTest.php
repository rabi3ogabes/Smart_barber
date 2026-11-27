<?php

use App\Core\Audit\AuditLog;
use App\Core\Authorization\PermissionCatalog as P;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\SalonMembership;
use App\Core\Tenancy\Tenancy;
use App\Modules\Staff\Actions\InviteStaff;
use App\Modules\Staff\Jobs\SendStaffInvitationSms;
use App\Modules\Staff\Models\Barber;
use App\Modules\Staff\Models\StaffInvitation;
use App\Modules\Staff\Notifications\StaffInvitationMail;
use Illuminate\Support\Facades\Bus;
use Illuminate\Support\Facades\Notification;
use Inertia\Testing\AssertableInertia as Assert;

beforeEach(function () {
    Notification::fake();
    Bus::fake([SendStaffInvitationSms::class]);
});

function inviteToken(object $test, $salon, User $actor, array $data): string
{
    return Tenancy::runAs($salon, function () use ($salon, $actor, $data) {
        Tenancy::set($salon, $actor->membershipIn((int) $salon->id));

        return app(InviteStaff::class)($actor, $data + ['branches' => []])['token'];
    });
}

it('sends an email invitation through a queued notification and audits it', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $this->enableTwoFactor($owner);

    $this->actingAs($owner)->post($this->salonUrl($salon, '/staff/invitations'), ['name' => 'Omar', 'email' => 'Omar@Example.test', 'roles' => ['barber'], 'branches' => [$branch->public_id]])
        ->assertRedirect()->assertSessionHasNoErrors();

    Notification::assertSentOnDemand(StaffInvitationMail::class, fn ($n, $channels, $notifiable) => $notifiable->routes['mail'] === 'omar@example.test');
    $invitation = Tenancy::runAs($salon, fn () => StaffInvitation::query()->firstOrFail());
    expect($invitation->role_names)->toBe(['barber'])
        ->and($invitation->branch_ids)->toBe([$branch->id])
        ->and($invitation->expires_at->isAfter(now()->addDays(6)))->toBeTrue()
        ->and(strlen($invitation->token_hash))->toBe(64);
    expect(AuditLog::query()->where('event', 'staff.invited')->where('salon_id', $salon->id)->exists())->toBeTrue();
});

it('sends a phone invitation by SMS in a queued job', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $this->enableTwoFactor($owner);

    $this->actingAs($owner)->post($this->salonUrl($salon, '/staff/invitations'), ['phone' => '+97455123456', 'roles' => ['receptionist'], 'branches' => [$branch->public_id]])
        ->assertSessionHasNoErrors();

    Bus::assertDispatched(SendStaffInvitationSms::class);
    Notification::assertNothingSent();
});

it('enforces who may give which roles where', function (string $actorRole, array $roles, bool $otherBranch, bool $allowed) {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $other = $this->addBranch($salon);
    $actor = $this->memberOf($salon, $actorRole, $actorRole === P::BRANCH_MANAGER ? [$branch] : []);
    $this->enableTwoFactor($actor);

    $response = $this->actingAs($actor)->post($this->salonUrl($salon, '/staff/invitations'), [
        'email' => 'new@example.test', 'roles' => $roles, 'branches' => P::OWNER === ($roles[0] ?? '') || $roles === [P::GENERAL_MANAGER] ? [] : [($otherBranch ? $other : $branch)->public_id],
    ]);

    $allowed ? $response->assertSessionHasNoErrors() : $response->assertSessionHasErrors();
    expect(Tenancy::runAs($salon, fn () => StaffInvitation::query()->count()))->toBe($allowed ? 1 : 0);
})->with([
    'owner gives GM' => [P::OWNER, [P::GENERAL_MANAGER], false, true],
    'GM gives branch manager' => [P::GENERAL_MANAGER, [P::BRANCH_MANAGER], false, true],
    'GM cannot give GM' => [P::GENERAL_MANAGER, [P::GENERAL_MANAGER], false, false],
    'GM cannot give owner' => [P::GENERAL_MANAGER, [P::OWNER], false, false],
    'BM gives barber in own branch' => [P::BRANCH_MANAGER, [P::BARBER], false, true],
    'BM cannot give barber in another branch' => [P::BRANCH_MANAGER, [P::BARBER], true, false],
    'BM cannot give branch manager' => [P::BRANCH_MANAGER, [P::BRANCH_MANAGER], false, false],
]);

it('forbids roles without staff.invite from inviting', function () {
    ['salon' => $salon, 'branch' => $branch] = $this->makeSalon();
    $receptionist = $this->memberOf($salon, P::RECEPTIONIST, [$branch]);

    $this->actingAs($receptionist)->post($this->salonUrl($salon, '/staff/invitations'), ['email' => 'x@example.test', 'roles' => ['barber'], 'branches' => [$branch->public_id]])
        ->assertForbidden();
});

it('requires branches for branch roles and refuses existing active members', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $this->enableTwoFactor($owner);
    $barber = $this->memberOf($salon, P::BARBER, [$branch]);

    $this->actingAs($owner)->post($this->salonUrl($salon, '/staff/invitations'), ['email' => 'x@example.test', 'roles' => ['barber'], 'branches' => []])->assertSessionHasErrors('branches');
    $this->actingAs($owner)->post($this->salonUrl($salon, '/staff/invitations'), ['email' => $barber->email, 'roles' => ['barber'], 'branches' => [$branch->public_id]])->assertSessionHasErrors('roles');
});

it('shows a valid invitation and lets a new person create an account and join', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $token = inviteToken($this, $salon, $owner, ['email' => 'omar@example.test', 'name' => 'Omar', 'roles' => ['barber'], 'branches' => [$branch->public_id]]);

    $this->get($this->salonUrl($salon, "/invitations/{$token}"))
        ->assertOk()
        ->assertInertia(fn (Assert $page) => $page->component('Invitations/Accept')->where('valid', true)->where('hasAccount', false)->where('invitation.roles', ['barber']));

    $this->post($this->salonUrl($salon, "/invitations/{$token}"), ['name' => 'Omar Ali', 'password' => 'Secret12345', 'password_confirmation' => 'Secret12345'])
        ->assertRedirect('/');

    $user = User::query()->where('email', 'omar@example.test')->firstOrFail();
    $this->assertAuthenticatedAs($user, 'web');
    expect($user->membershipIn((int) $salon->id)?->isActive())->toBeTrue()
        ->and(Tenancy::runAs($salon, fn () => Barber::query()->where('user_id', $user->id)->exists()))->toBeTrue()
        ->and(Tenancy::runAs($salon, fn () => StaffInvitation::query()->firstOrFail()->accepted_at))->not->toBeNull();

    // The link works once.
    $this->post('/logout');
    $this->get($this->salonUrl($salon, "/invitations/{$token}"))->assertInertia(fn (Assert $page) => $page->where('valid', false));
});

it('lets an existing account accept with its password', function () {
    ['salon' => $a] = $this->makeSalon('salon-a');
    ['salon' => $b, 'owner' => $ownerB, 'branch' => $branchB] = $this->makeSalon('salon-b');
    $existing = $this->memberOf($a, P::BARBER, [Tenancy::runAs($a, fn () => Branch::query()->firstOrFail())]);
    $token = inviteToken($this, $b, $ownerB, ['email' => $existing->email, 'roles' => ['barber'], 'branches' => [$branchB->public_id]]);

    $this->get($this->salonUrl($b, "/invitations/{$token}"))->assertInertia(fn (Assert $page) => $page->where('hasAccount', true));
    $this->post($this->salonUrl($b, "/invitations/{$token}"), ['password' => 'wrong'])->assertSessionHasErrors('password');
    $this->assertGuest('web');

    $this->post($this->salonUrl($b, "/invitations/{$token}"), ['password' => 'Password123!'])->assertRedirect('/');
    expect($existing->membershipIn((int) $b->id)?->isActive())->toBeTrue()
        ->and($existing->membershipIn((int) $a->id)?->isActive())->toBeTrue();
});

it('rejects expired, revoked and unknown tokens', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $expired = inviteToken($this, $salon, $owner, ['email' => 'a@example.test', 'roles' => ['barber'], 'branches' => [$branch->public_id]]);
    Tenancy::runAs($salon, fn () => StaffInvitation::query()->update(['expires_at' => now()->subMinute()]));
    $revoked = inviteToken($this, $salon, $owner, ['email' => 'b@example.test', 'roles' => ['barber'], 'branches' => [$branch->public_id]]);
    Tenancy::runAs($salon, fn () => StaffInvitation::query()->where('email', 'b@example.test')->update(['revoked_at' => now()]));

    foreach ([$expired, $revoked, str_repeat('x', 48)] as $token) {
        $this->get($this->salonUrl($salon, "/invitations/{$token}"))->assertInertia(fn (Assert $page) => $page->where('valid', false)->where('invitation', null));
        $this->post($this->salonUrl($salon, "/invitations/{$token}"), ['name' => 'X', 'password' => 'Secret12345', 'password_confirmation' => 'Secret12345'])->assertRedirect();
    }
    expect(User::query()->whereIn('email', ['a@example.test', 'b@example.test'])->exists())->toBeFalse();
});

it('does not accept salon A invitation tokens on salon B', function () {
    ['salon' => $a, 'owner' => $ownerA, 'branch' => $branchA] = $this->makeSalon('salon-a');
    ['salon' => $b] = $this->makeSalon('salon-b');
    $token = inviteToken($this, $a, $ownerA, ['email' => 'c@example.test', 'roles' => ['barber'], 'branches' => [$branchA->public_id]]);

    $this->get($this->salonUrl($b, "/invitations/{$token}"))->assertInertia(fn (Assert $page) => $page->where('valid', false));
    $this->post($this->salonUrl($b, "/invitations/{$token}"), ['name' => 'C', 'password' => 'Secret12345', 'password_confirmation' => 'Secret12345']);
    expect(User::query()->where('email', 'c@example.test')->exists())->toBeFalse()
        ->and(SalonMembership::query()->withoutGlobalScopes()->where('salon_id', $b->id)->count())->toBe(1);
});

it('resends with a fresh token and revokes', function () {
    ['salon' => $salon, 'owner' => $owner, 'branch' => $branch] = $this->makeSalon();
    $this->enableTwoFactor($owner);
    $old = inviteToken($this, $salon, $owner, ['email' => 'd@example.test', 'roles' => ['barber'], 'branches' => [$branch->public_id]]);
    $invitation = Tenancy::runAs($salon, fn () => StaffInvitation::query()->firstOrFail());

    $this->actingAs($owner)->post($this->salonUrl($salon, "/staff/invitations/{$invitation->public_id}/resend"))->assertSessionHasNoErrors();
    $this->get($this->salonUrl($salon, "/invitations/{$old}"))->assertInertia(fn (Assert $page) => $page->where('valid', false));

    $this->actingAs($owner)->delete($this->salonUrl($salon, "/staff/invitations/{$invitation->public_id}"))->assertSessionHasNoErrors();
    expect(Tenancy::runAs($salon, fn () => $invitation->refresh()->revoked_at))->not->toBeNull();
});
