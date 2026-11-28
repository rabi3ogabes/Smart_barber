<?php

use App\Core\Audit\AuditLog;
use App\Core\Identity\Models\AccountMedia;
use App\Core\Identity\Models\CustomerAccount;
use App\Core\Identity\Models\Device;
use App\Core\Identity\Models\OtpCode;
use App\Core\Identity\Models\PersonalAccessToken;
use App\Core\Identity\Models\PlatformAdmin;
use App\Core\Identity\Models\RefreshToken;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\BelongsToSalon;
use App\Core\Tenancy\Models\Salon;
use Illuminate\Database\Eloquent\Model;
use Symfony\Component\Finder\Finder;

/**
 * Models that are deliberately NOT tenant-scoped (ADR-001). Adding a model here needs a reason.
 */
const NON_TENANT_MODELS = [
    Salon::class => 'the tenant root',
    User::class => 'global staff identity; access via memberships',
    CustomerAccount::class => 'global customer identity',
    PlatformAdmin::class => 'platform identity',
    OtpCode::class => 'pre-authentication',
    RefreshToken::class => 'identity-level; salon_id nullable',
    PersonalAccessToken::class => 'identity-level; salon_id nullable',
    Device::class => 'owned by an identity; salon_id nullable',
    AuditLog::class => 'salon_id nullable for platform events',
    AccountMedia::class => 'owned by a global customer account (avatar), ADR-009',
];

/**
 * @return list<class-string<Model>>
 */
function appModels(): array
{
    $classes = [];
    foreach ((new Finder)->files()->in(app_path())->name('*.php') as $file) {
        $class = 'App\\'.str_replace(['/', '.php'], ['\\', ''], $file->getRelativePathname());
        if (class_exists($class) && is_subclass_of($class, Model::class) && ! (new ReflectionClass($class))->isAbstract()) {
            $classes[] = $class;
        }
    }

    return $classes;
}

it('makes every model tenant-scoped or explicitly allow-listed', function () {
    foreach (appModels() as $class) {
        $scoped = in_array(BelongsToSalon::class, class_uses_recursive($class), true);
        expect($scoped || array_key_exists($class, NON_TENANT_MODELS))
            ->toBeTrue("{$class} must use BelongsToSalon or be added to NON_TENANT_MODELS with a reason");
    }
});

it('never makes salon_id mass-assignable', function () {
    foreach (appModels() as $class) {
        expect((new $class)->getFillable())->not->toContain('salon_id', "{$class} lists salon_id in \$fillable");
    }
});

arch('core does not depend on modules')
    ->expect('App\Core')
    ->not->toUse('App\Modules');

arch('no debugging calls')
    ->expect(['dd', 'dump', 'ray', 'var_dump', 'print_r'])
    ->not->toBeUsed();

arch('no floats for money: Money never accepts floats')
    ->expect('App\Core\Money\Money')
    ->not->toUse(['floatval']);

arch('controllers stay thin and final')
    ->expect('App\Core\Identity\Http\Controllers\Api')
    ->toBeFinal();
