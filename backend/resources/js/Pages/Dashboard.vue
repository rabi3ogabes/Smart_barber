<script setup lang="ts">
import { CalendarCheck, ChartColumn, Clock, UsersRound, Wallet } from 'lucide-vue-next';
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import SbBadge from '@/Components/Ui/SbBadge.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import { usePageProps } from '@/Composables/usePageProps';
import AppLayout from '@/Layouts/AppLayout.vue';

const { props } = usePageProps();
const { t } = useI18n();

const greeting = computed(() => {
    const h = new Date().getHours();
    return h < 12 ? t('ui.dashboard.good_morning') : h < 17 ? t('ui.dashboard.good_afternoon') : t('ui.dashboard.good_evening');
});

// KPI tiles are placeholders: real numbers arrive with Analytics (Phase 12). Never invent numbers (rule 10).
const tiles = [
    { key: 'revenue', icon: Wallet, label: 'ui.dashboard.kpi_revenue' },
    { key: 'bookings', icon: CalendarCheck, label: 'ui.dashboard.kpi_bookings' },
    { key: 'customers', icon: UsersRound, label: 'ui.dashboard.kpi_customers' },
    { key: 'utilisation', icon: ChartColumn, label: 'ui.dashboard.kpi_utilisation' },
];
</script>

<template>
    <AppLayout :title="t('nav.dashboard')">
        <div class="mx-auto flex max-w-7xl flex-col gap-8">
            <section>
                <p class="text-label text-text-secondary">{{ props.salon?.name }}</p>
                <h2 class="mt-1 text-h2 sm:text-h1">{{ t('ui.dashboard.greeting', { greeting, name: props.auth?.user.name ?? '' }) }}</h2>
            </section>

            <!-- Bento: 4 columns desktop, 2 tablet, swipeable single column on mobile -->
            <section :aria-label="t('ui.dashboard.kpis')" class="-mx-4 flex snap-x snap-mandatory scroll-ps-4 gap-4 overflow-x-auto px-4 pb-2 sm:mx-0 sm:grid sm:grid-cols-2 sm:overflow-visible sm:px-0 lg:grid-cols-4">
                <article v-for="tile in tiles" :key="tile.key" class="flex min-w-[78%] snap-start flex-col gap-4 rounded-card border border-border bg-surface p-5 shadow-sm sm:min-w-0">
                    <div class="flex items-center justify-between">
                        <span class="text-label text-text-secondary">{{ t(tile.label) }}</span>
                        <span class="flex h-9 w-9 items-center justify-center rounded-input bg-accent-soft text-accent"><component :is="tile.icon" class="h-4 w-4" aria-hidden="true" /></span>
                    </div>
                    <p class="text-h1 tabular text-text-secondary" :aria-label="t('ui.dashboard.no_data_yet')">—</p>
                    <SbBadge tone="neutral">{{ t('ui.dashboard.kpi_soon') }}</SbBadge>
                </article>
            </section>

            <section class="grid gap-4 lg:grid-cols-3">
                <article class="rounded-card border border-border bg-surface shadow-sm lg:col-span-2">
                    <header class="flex items-center justify-between border-b border-border px-5 py-4">
                        <h3 class="text-h4">{{ t('ui.dashboard.today') }}</h3>
                        <SbBadge tone="accent" dot>{{ t('ui.dashboard.live_soon') }}</SbBadge>
                    </header>
                    <SbEmptyState :icon="Clock" :title="t('ui.dashboard.today_empty')" :description="t('ui.dashboard.today_empty_hint')" />
                </article>
                <article class="rounded-card border border-border bg-surface p-5 shadow-sm">
                    <h3 class="text-h4">{{ t('ui.dashboard.setup_title') }}</h3>
                    <p class="mt-1 text-label text-text-secondary">{{ t('ui.dashboard.setup_hint') }}</p>
                    <ol class="mt-5 flex flex-col gap-3">
                        <li v-for="(step, i) in ['ui.dashboard.setup_branches', 'ui.dashboard.setup_staff', 'ui.dashboard.setup_services', 'ui.dashboard.setup_booking']" :key="step" class="flex items-center gap-3">
                            <span class="flex h-7 w-7 shrink-0 items-center justify-center rounded-pill border border-border text-caption tabular">{{ i + 1 }}</span>
                            <span class="flex-1 text-body">{{ t(step) }}</span>
                            <SbBadge tone="neutral">{{ t('ui.shell.soon') }}</SbBadge>
                        </li>
                    </ol>
                </article>
            </section>
        </div>
    </AppLayout>
</template>
