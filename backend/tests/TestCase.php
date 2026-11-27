<?php

namespace Tests;

use App\Core\Authorization\PermissionCatalog;
use App\Core\Authorization\SyncRolesAndPermissions;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Identity\Models\User;
use App\Core\Identity\Services\TokenService;
use App\Core\Tenancy\Actions\AddMember;
use App\Core\Tenancy\Actions\CreateSalon;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
use PragmaRX\Google2FA\Google2FA;

abstract class TestCase extends BaseTestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        Tenancy::clear();
        $this->withoutVite();

        if (in_array(RefreshDatabase::class, class_uses_recursive(static::class), true)) {
            app(SyncRolesAndPermissions::class)();
        }
    }

    protected function tearDown(): void
    {
        Tenancy::clear();
        parent::tearDown();
    }

    /**
     * A salon with its owner and first branch.
     *
     * @return array{salon: Salon, owner: User, branch: Branch}
     */
    protected function makeSalon(string $slug = 'salon-a'): array
    {
        $owner = User::factory()->create();
        $salon = app(CreateSalon::class)(['ar' => 'صالون '.$slug, 'en' => 'Salon '.$slug], $slug, $owner);
        $branch = Tenancy::runAs($salon, fn () => Branch::query()->firstOrFail());

        return ['salon' => $salon, 'owner' => $owner, 'branch' => $branch];
    }

    /**
     * @param  list<Branch>  $branches
     */
    protected function memberOf(Salon $salon, string $role = PermissionCatalog::BARBER, array $branches = [], ?User $user = null): User
    {
        $user ??= User::factory()->create();
        app(AddMember::class)($salon, $user, [$role], $branches);

        return $user;
    }

    protected function addBranch(Salon $salon, string $en = 'Lusail'): Branch
    {
        return Tenancy::runAs($salon, fn () => Branch::factory()->create(['name' => ['ar' => 'فرع '.$en, 'en' => $en]]));
    }

    protected function salonUrl(Salon $salon, string $path = '/'): string
    {
        return 'http://'.$salon->slug.'.'.config('smartbarber.domain').'/'.ltrim($path, '/');
    }

    protected function adminUrl(string $path = '/'): string
    {
        return 'http://'.config('smartbarber.admin_subdomain').'.'.config('smartbarber.domain').'/'.ltrim($path, '/');
    }

    /**
     * @return array<string, string>
     */
    protected function staffHeaders(User $user, Salon $salon): array
    {
        $tokens = app(TokenService::class)->issue($user, (int) $salon->getKey(), 'test', ['staff']);

        return ['Authorization' => 'Bearer '.$tokens->accessToken, 'Accept' => 'application/json'];
    }

    /**
     * @return array<string, string>
     */
    protected function customerHeaders(CustomerAccount $account): array
    {
        $tokens = app(TokenService::class)->issue($account, null, 'test', ['customer']);

        return ['Authorization' => 'Bearer '.$tokens->accessToken, 'Accept' => 'application/json'];
    }

    protected function enableTwoFactor(Model $user): string
    {
        $google = new Google2FA;
        $secret = $google->generateSecretKey(32);
        $user->forceFill([
            'two_factor_secret' => $secret,
            'two_factor_confirmed_at' => now(),
            'two_factor_recovery_codes' => json_encode(['AAAAA-BBBBB', 'CCCCC-DDDDD']),
        ])->save();

        return $secret;
    }

    protected function totp(string $secret): string
    {
        return (new Google2FA)->getCurrentOtp($secret);
    }
}
