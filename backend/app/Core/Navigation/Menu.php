<?php

namespace App\Core\Navigation;

use App\Core\Authorization\Access;
use App\Core\Features\Feature;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Salon;

/**
 * Dashboard sidebar, filtered on the server by permission and salon feature.
 * Items whose phase has not shipped yet are marked `available: false` (shown as "Soon").
 */
final class Menu
{
    /** Phases already delivered; an item is clickable when its phase is in this list. */
    private const SHIPPED_PHASES = [1, 2, 3, 4];

    /**
     * @return list<array{key: string, label: string, icon: string, items: list<array<string, mixed>>}>
     */
    public static function definition(): array
    {
        return [
            ['key' => 'overview', 'label' => 'nav.group.overview', 'icon' => 'layout-grid', 'items' => [
                ['key' => 'dashboard', 'label' => 'nav.dashboard', 'icon' => 'layout-grid', 'href' => '/', 'permission' => 'dashboard.view', 'phase' => 1],
                ['key' => 'calendar', 'label' => 'nav.calendar', 'icon' => 'calendar', 'href' => '/calendar', 'permission' => 'booking.view', 'phase' => 4],
                ['key' => 'bookings', 'label' => 'nav.bookings', 'icon' => 'calendar-check', 'href' => '/bookings', 'permission' => 'booking.view', 'phase' => 4, 'badge' => 'bookings_pending'],
                ['key' => 'queue', 'label' => 'nav.queue', 'icon' => 'users-round', 'href' => '/queue', 'permission' => 'queue.view', 'feature' => Feature::SMART_QUEUE, 'phase' => 10, 'badge' => 'queue_waiting'],
            ]],
            ['key' => 'sales', 'label' => 'nav.group.sales', 'icon' => 'receipt', 'items' => [
                ['key' => 'pos', 'label' => 'nav.pos', 'icon' => 'credit-card', 'href' => '/pos', 'permission' => 'pos.access', 'phase' => 6],
                ['key' => 'invoices', 'label' => 'nav.invoices', 'icon' => 'receipt', 'href' => '/invoices', 'permission' => 'invoice.view', 'phase' => 6],
                ['key' => 'cash_shifts', 'label' => 'nav.cash_shifts', 'icon' => 'wallet', 'href' => '/cash-shifts', 'permission' => 'cash_shift.operate', 'phase' => 6],
            ]],
            ['key' => 'customers', 'label' => 'nav.group.customers', 'icon' => 'contact', 'items' => [
                ['key' => 'customers', 'label' => 'nav.customers', 'icon' => 'contact', 'href' => '/customers', 'permission' => 'customer.view', 'phase' => 4],
                ['key' => 'loyalty', 'label' => 'nav.loyalty', 'icon' => 'gift', 'href' => '/loyalty', 'permission' => 'loyalty.view', 'feature' => Feature::LOYALTY, 'phase' => 7],
                ['key' => 'memberships', 'label' => 'nav.memberships', 'icon' => 'badge-check', 'href' => '/memberships', 'permission' => 'membership.view', 'feature' => Feature::MEMBERSHIP, 'phase' => 7],
                ['key' => 'marketing', 'label' => 'nav.marketing', 'icon' => 'megaphone', 'href' => '/marketing', 'permission' => 'campaign.view', 'feature' => Feature::MARKETING, 'phase' => 11],
                ['key' => 'ai_studio', 'label' => 'nav.ai_studio', 'icon' => 'sparkles', 'href' => '/ai-studio', 'permission' => 'ai_studio.manage', 'feature' => Feature::AI_STUDIO, 'phase' => 9],
            ]],
            ['key' => 'team', 'label' => 'nav.group.team', 'icon' => 'scissors', 'items' => [
                ['key' => 'services', 'label' => 'nav.services', 'icon' => 'scissors', 'href' => '/services', 'permission' => 'service.view', 'phase' => 3],
                ['key' => 'staff', 'label' => 'nav.staff', 'icon' => 'users', 'href' => '/staff', 'permission' => 'staff.view', 'phase' => 2],
                ['key' => 'schedules', 'label' => 'nav.schedules', 'icon' => 'clock', 'href' => '/schedules', 'permission' => 'schedule.view', 'phase' => 2],
                ['key' => 'time_off', 'label' => 'nav.time_off', 'icon' => 'calendar', 'href' => '/time-off', 'permission' => 'schedule.view', 'phase' => 2],
                ['key' => 'commissions', 'label' => 'nav.commissions', 'icon' => 'percent', 'href' => '/commissions', 'permission' => 'commission.view', 'feature' => Feature::COMMISSION, 'phase' => 13],
                ['key' => 'inventory', 'label' => 'nav.inventory', 'icon' => 'package', 'href' => '/inventory', 'permission' => 'inventory.view', 'feature' => Feature::INVENTORY, 'phase' => 13],
            ]],
            ['key' => 'insights', 'label' => 'nav.group.insights', 'icon' => 'chart', 'items' => [
                ['key' => 'reports', 'label' => 'nav.reports', 'icon' => 'chart', 'href' => '/reports', 'permission' => 'analytics.view', 'phase' => 12],
                ['key' => 'assistant', 'label' => 'nav.assistant', 'icon' => 'message', 'href' => '/assistant', 'permission' => 'assistant.use', 'feature' => Feature::ASSISTANT, 'phase' => 12],
            ]],
            ['key' => 'admin', 'label' => 'nav.group.admin', 'icon' => 'settings', 'items' => [
                ['key' => 'branches', 'label' => 'nav.branches', 'icon' => 'store', 'href' => '/branches', 'permission' => 'branch.view', 'phase' => 2],
                ['key' => 'settings', 'label' => 'nav.settings', 'icon' => 'settings', 'href' => '/settings/salon', 'permission' => 'salon.settings.view', 'phase' => 2],
                ['key' => 'audit_log', 'label' => 'nav.audit_log', 'icon' => 'shield', 'href' => '/audit-log', 'permission' => 'audit_log.view', 'phase' => 2],
                ['key' => 'billing', 'label' => 'nav.billing', 'icon' => 'wallet', 'href' => '/billing', 'permission' => 'billing.view', 'phase' => 14],
            ]],
        ];
    }

    /**
     * @return list<array<string, mixed>>
     */
    public static function for(User $user, Salon $salon): array
    {
        $permissions = array_flip(Access::permissions($user));
        $features = array_flip(Feature::enabledFor($salon));
        $groups = [];

        foreach (self::definition() as $group) {
            $items = [];
            foreach ($group['items'] as $item) {
                if (! isset($permissions[$item['permission']])) {
                    continue;
                }
                if (isset($item['feature']) && ! isset($features[$item['feature']])) {
                    continue;
                }
                $items[] = [
                    'key' => $item['key'],
                    'label' => $item['label'],
                    'icon' => $item['icon'],
                    'href' => $item['href'],
                    'badge' => $item['badge'] ?? null,
                    'available' => in_array($item['phase'], self::SHIPPED_PHASES, true),
                ];
            }
            if ($items !== []) {
                $groups[] = ['key' => $group['key'], 'label' => $group['label'], 'icon' => $group['icon'], 'items' => $items];
            }
        }

        return $groups;
    }
}
