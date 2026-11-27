<?php

use App\Core\Authorization\PermissionCatalog as P;

it('gives every role a row in every permission', function () {
    $reflection = new ReflectionClass(P::class);
    $matrix = $reflection->getConstant('MATRIX');

    foreach ($matrix as $key => $row) {
        expect(explode(' ', $row))->toHaveCount(count(P::ROLES), "Row [{$key}] must list ".count(P::ROLES).' scopes')
            ->and(preg_match('/^[ABO\-]( [ABO\-])*$/', $row))->toBe(1, "Row [{$key}] has an invalid token");
    }
});

it('reads scopes from the matrix', function () {
    expect(P::scope(P::OWNER, 'payment.refund'))->toBe(P::SCOPE_ALL)
        ->and(P::scope(P::BRANCH_MANAGER, 'booking.view'))->toBe(P::SCOPE_BRANCH)
        ->and(P::scope(P::BARBER, 'booking.view'))->toBe(P::SCOPE_OWN)
        ->and(P::scope(P::RECEPTIONIST, 'payment.refund'))->toBeNull()
        ->and(P::scope('nope', 'booking.view'))->toBeNull();
});

it('picks the broadest scope across roles', function () {
    expect(P::broadestScope([P::BARBER, P::BRANCH_MANAGER], 'booking.view'))->toBe(P::SCOPE_BRANCH)
        ->and(P::broadestScope([P::BARBER], 'campaign.approve'))->toBeNull();
});

it('keeps owner-only and accountant-only keys as documented', function () {
    expect(P::permissionsFor(P::GENERAL_MANAGER))->not->toContain('billing.manage')
        ->and(P::permissionsFor(P::ACCOUNTANT))->toContain('commission.statement.approve')
        ->and(P::permissionsFor(P::MARKETING_MANAGER))->not->toContain('campaign.approve');
});
