<?php

namespace App\Core\Authorization;

/**
 * The single source of truth for salon roles and permission keys (docs/architecture/permissions.md).
 *
 * Each matrix row lists the scope per role in ROLES order:
 *   A = whole salon, B = assigned branches only, O = own records only, - = not allowed.
 * Spatie stores *whether* a role has a permission; Policies read the *scope* from here.
 */
final class PermissionCatalog
{
    public const SCOPE_ALL = 'all';

    public const SCOPE_BRANCH = 'branch';

    public const SCOPE_OWN = 'own';

    public const OWNER = 'owner';

    public const GENERAL_MANAGER = 'general_manager';

    public const BRANCH_MANAGER = 'branch_manager';

    public const RECEPTIONIST = 'receptionist';

    public const BARBER = 'barber';

    public const ACCOUNTANT = 'accountant';

    public const MARKETING_MANAGER = 'marketing_manager';

    public const INVENTORY_MANAGER = 'inventory_manager';

    /** @var list<string> */
    public const ROLES = [
        self::OWNER, self::GENERAL_MANAGER, self::BRANCH_MANAGER, self::RECEPTIONIST,
        self::BARBER, self::ACCOUNTANT, self::MARKETING_MANAGER, self::INVENTORY_MANAGER,
    ];

    //                                               OW GM BM RC BR AC MM IM
    private const MATRIX = [
        'dashboard.view' => 'A A B B O A A B',
        'salon.settings.view' => 'A A - - - A - -',
        'salon.settings.update' => 'A A - - - - - -',
        'branch.view' => 'A A B B B A A B',
        'branch.manage' => 'A A B - - - - -',
        'audit_log.view' => 'A A B - - A - -',
        'billing.view' => 'A - - - - A - -',
        'billing.manage' => 'A - - - - - - -',
        'staff.view' => 'A A B B - A - -',
        'staff.invite' => 'A A B - - - - -',
        'staff.update' => 'A A B - O - - -',
        'staff.deactivate' => 'A A - - - - - -',
        'staff.roles.assign' => 'A A - - - - - -',
        'schedule.view' => 'A A B B O - - -',
        'schedule.update' => 'A A B - - - - -',
        'timeoff.request' => '- - O O O - - -',
        'timeoff.approve' => 'A A B - - - - -',
        'service.view' => 'A A A A A A A A',
        'service.manage' => 'A A - - - - - -',
        'service.price.update' => 'A A B - - - - -',
        'booking.view' => 'A A B B O A - -',
        'booking.create' => 'A A B B O - - -',
        'booking.reschedule' => 'A A B B O - - -',
        'booking.cancel' => 'A A B B - - - -',
        'booking.cancel.override_policy' => 'A A B - - - - -',
        'booking.status.update' => 'A A B B O - - -',
        'booking.no_show' => 'A A B B - - - -',
        'customer.view' => 'A A B B O A A -',
        'customer.create' => 'A A B B O - - -',
        'customer.update' => 'A A B B - - - -',
        'customer.notes.private' => 'A A B B O - - -',
        'customer.contact.view' => 'A A B B - - A -',
        'customer.export' => 'A - - - - - - -',
        'customer.merge' => 'A A - - - - - -',
        'review.moderate' => 'A A - - - - - -',
        'pos.access' => 'A A B B O - - -',
        'pos.discount.apply' => 'A A B B - - - -',
        'pos.discount.above_threshold' => 'A A B - - - - -',
        'pos.order.void' => 'A A B B - - - -',
        'payment.take' => 'A A B B O - - -',
        'payment.refund' => 'A A B - - A - -',
        'payment_method.manage' => 'A A - - - A - -',
        'invoice.view' => 'A A B B O A - -',
        'invoice.resend' => 'A A B B - A - -',
        'cash_shift.operate' => 'A A B B - - - -',
        'cash_shift.report' => 'A A B - - A - -',
        'report.sales.view' => 'A A B - O A - -',
        'loyalty.view' => 'A A B B O A A -',
        'loyalty.manage' => 'A A - - - - A -',
        'loyalty.adjust' => 'A A - - - - - -',
        'membership.view' => 'A A B B O A A -',
        'membership.manage' => 'A A - - - - - -',
        'membership.sell' => 'A A B B - - - -',
        'membership.pause_cancel' => 'A A B - - - - -',
        'hair_history.view' => 'A A B B O - - -',
        'hair_history.record' => 'A A B - O - - -',
        'hair_history.photos.view' => 'A A B - O - - -',
        'ai_studio.manage' => 'A A - - - - A -',
        'queue.view' => 'A A B B B - - -',
        'queue.manage' => 'A A B B O - - -',
        'notification.templates.manage' => 'A A - - - - A -',
        'whatsapp.settings.manage' => 'A - - - - - - -',
        'segment.manage' => 'A A - - - - A -',
        'campaign.view' => 'A A - - - - A -',
        'campaign.create' => 'A A - - - - A -',
        'campaign.approve' => 'A A - - - - - -',
        'offer_code.manage' => 'A A - - - - A -',
        'analytics.view' => 'A A B - O A A B',
        'analytics.financial' => 'A A B - - A - -',
        'analytics.export' => 'A A - - - A - -',
        'assistant.use' => 'A A B - - A A -',
        'inventory.view' => 'A A B B - A - A',
        'inventory.manage' => 'A A - - - - - A',
        'inventory.adjust' => 'A A B - - - - A',
        'inventory.transfer' => 'A A - - - - - A',
        'purchase_order.manage' => 'A A - - - - - A',
        'stocktake.perform' => 'A A B - - - - A',
        'commission.view' => 'A A B - O A - -',
        'commission.rules.manage' => 'A - - - - A - -',
        'commission.statement.approve' => 'A - - - - A - -',
    ];

    /** @return list<string> */
    public static function permissions(): array
    {
        return array_keys(self::MATRIX);
    }

    /**
     * Permission keys granted to a role.
     *
     * @return list<string>
     */
    public static function permissionsFor(string $role): array
    {
        return array_keys(array_filter(self::MATRIX, fn (string $row) => self::scopeFromRow($row, $role) !== null));
    }

    /**
     * Scope of a permission for a role, or null when not granted.
     */
    public static function scope(string $role, string $permission): ?string
    {
        $row = self::MATRIX[$permission] ?? null;

        return $row === null ? null : self::scopeFromRow($row, $role);
    }

    /**
     * Broadest scope across several roles (all > branch > own).
     *
     * @param  iterable<string>  $roles
     */
    public static function broadestScope(iterable $roles, string $permission): ?string
    {
        $rank = [self::SCOPE_OWN => 1, self::SCOPE_BRANCH => 2, self::SCOPE_ALL => 3];
        $best = null;
        foreach ($roles as $role) {
            $scope = self::scope($role, $permission);
            if ($scope !== null && ($best === null || $rank[$scope] > $rank[$best])) {
                $best = $scope;
            }
        }

        return $best;
    }

    private static function scopeFromRow(string $row, string $role): ?string
    {
        $index = array_search($role, self::ROLES, true);
        if ($index === false) {
            return null;
        }

        return match (explode(' ', $row)[$index] ?? '-') {
            'A' => self::SCOPE_ALL,
            'B' => self::SCOPE_BRANCH,
            'O' => self::SCOPE_OWN,
            default => null,
        };
    }
}
