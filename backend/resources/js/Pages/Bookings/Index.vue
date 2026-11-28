<script setup lang="ts">
import { router } from '@inertiajs/vue3';
import { CalendarCheck } from 'lucide-vue-next';
import { reactive, ref } from 'vue';
import { useI18n } from 'vue-i18n';
import BookingDrawer from '@/Components/Booking/BookingDrawer.vue';
import { type BookingDto, type Status, statusTone } from '@/Components/Booking/types';
import SbBadge from '@/Components/Ui/SbBadge.vue';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import { useTr } from '@/Composables/useTr';
import AppLayout from '@/Layouts/AppLayout.vue';

const props = defineProps<{
    bookings: BookingDto[];
    pagination: { current: number; last: number; total: number; prev: string | null; next: string | null };
    filters: { from: string; to: string; status: Status | null; barber: string | null; q: string | null };
    barbers: { id: string; name: string }[];
    statuses: Status[];
    timezone: string;
}>();
const { t, locale } = useI18n();
const tr = useTr();

const f = reactive({ from: props.filters.from, to: props.filters.to, status: props.filters.status ?? '', barber: props.filters.barber ?? '', q: props.filters.q ?? '' });
const apply = (): void => {
    router.get('/bookings', Object.fromEntries(Object.entries(f).filter(([, v]) => v)), { preserveState: true, preserveScroll: true });
};
const fmt = (iso: string): string =>
    new Intl.DateTimeFormat(locale.value === 'ar' ? 'ar-QA' : 'en-GB', { timeZone: props.timezone, weekday: 'short', day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' }).format(new Date(iso));

const detailOpen = ref(false);
const detailId = ref<string | null>(null);
const open = (b: BookingDto): void => {
    detailId.value = b.id;
    detailOpen.value = true;
};
const refresh = (): void => router.reload({ only: ['bookings', 'pagination'] });
</script>

<template>
    <AppLayout :title="t('nav.bookings')">
        <div class="mx-auto flex max-w-7xl flex-col gap-5">
            <header>
                <h2 class="text-h2">{{ t('nav.bookings') }}</h2>
                <p class="mt-1 text-body text-text-secondary">{{ t('ui.bookings.list_subtitle', { n: pagination.total }) }}</p>
            </header>

            <form class="grid gap-3 rounded-card border border-border bg-surface p-4 shadow-sm sm:grid-cols-2 lg:grid-cols-6" @submit.prevent="apply">
                <SbInput v-model="f.from" type="date" :label="t('ui.common.from')" ltr />
                <SbInput v-model="f.to" type="date" :label="t('ui.common.to')" ltr />
                <SbSelect v-model="f.status" :label="t('ui.staff.col_status')" :options="[{ value: '', label: t('ui.bookings.all_statuses') }, ...statuses.map((s) => ({ value: s, label: t(`ui.bookings.status.${s}`) }))]" />
                <SbSelect v-model="f.barber" :label="t('ui.schedules.barber')" :options="[{ value: '', label: t('ui.bookings.all_barbers') }, ...barbers.map((b) => ({ value: b.id, label: b.name }))]" />
                <SbInput v-model="f.q" type="search" :label="t('ui.bookings.customer')" :placeholder="t('ui.bookings.search_customer')" />
                <div class="flex items-end"><SbButton type="submit" block>{{ t('ui.bookings.apply') }}</SbButton></div>
            </form>

            <section class="overflow-hidden rounded-card border border-border bg-surface shadow-sm">
                <SbEmptyState v-if="bookings.length === 0" :icon="CalendarCheck" :title="t('ui.bookings.empty')" :description="t('ui.bookings.empty_hint')" />
                <table v-else class="w-full text-start text-label">
                    <thead class="hidden border-b border-border bg-surface-muted text-caption text-text-secondary md:table-header-group">
                        <tr>
                            <th scope="col" class="px-4 py-3 text-start font-medium">{{ t('ui.bookings.when') }}</th>
                            <th scope="col" class="px-4 py-3 text-start font-medium">{{ t('ui.bookings.customer') }}</th>
                            <th scope="col" class="px-4 py-3 text-start font-medium">{{ t('ui.bookings.services') }}</th>
                            <th scope="col" class="px-4 py-3 text-start font-medium">{{ t('ui.schedules.barber') }}</th>
                            <th scope="col" class="px-4 py-3 text-end font-medium">{{ t('ui.bookings.total') }}</th>
                            <th scope="col" class="px-4 py-3 text-start font-medium">{{ t('ui.staff.col_status') }}</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border">
                        <tr v-for="b in bookings" :key="b.id" class="flex cursor-pointer flex-col gap-1 p-4 hover:bg-surface-muted md:table-row md:p-0" tabindex="0" @click="open(b)" @keydown.enter="open(b)">
                            <td class="font-medium md:px-4 md:py-3">{{ fmt(b.starts_at) }}</td>
                            <td class="md:px-4 md:py-3">{{ b.customer?.name }} <span class="block text-caption text-text-secondary" dir="ltr">{{ b.customer?.phone }}</span></td>
                            <td class="text-text-secondary md:px-4 md:py-3">{{ b.items.map((i) => tr(i.name)).join(' + ') }}</td>
                            <td class="md:px-4 md:py-3">{{ tr(b.barber?.name) }}</td>
                            <td class="tabular md:px-4 md:py-3 md:text-end" dir="ltr">{{ b.total.formatted }}</td>
                            <td class="md:px-4 md:py-3"><SbBadge :tone="statusTone[b.status]" dot>{{ t(`ui.bookings.status.${b.status}`) }}</SbBadge></td>
                        </tr>
                    </tbody>
                </table>
            </section>

            <nav v-if="pagination.last > 1" class="flex items-center justify-between" :aria-label="t('ui.audit.pagination')">
                <SbButton v-if="pagination.prev" size="sm" variant="secondary" :href="pagination.prev">{{ t('ui.bookings.prev_page') }}</SbButton>
                <span v-else></span>
                <span class="text-caption text-text-secondary">{{ t('ui.bookings.page', { current: pagination.current, last: pagination.last }) }}</span>
                <SbButton v-if="pagination.next" size="sm" variant="secondary" :href="pagination.next">{{ t('ui.bookings.next_page') }}</SbButton>
                <span v-else></span>
            </nav>
        </div>
        <BookingDrawer v-model:open="detailOpen" :booking-id="detailId" :timezone="timezone" :barbers="barbers.map((b) => ({ ...b, is_bookable: true }))" @changed="refresh" />
    </AppLayout>
</template>
