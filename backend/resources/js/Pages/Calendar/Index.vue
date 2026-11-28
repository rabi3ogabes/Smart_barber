<script setup lang="ts">
import { router } from '@inertiajs/vue3';
import { CalendarDays, ChevronLeft, ChevronRight, Plus, RefreshCw } from 'lucide-vue-next';
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import BookingDrawer from '@/Components/Booking/BookingDrawer.vue';
import NewBookingDrawer from '@/Components/Booking/NewBookingDrawer.vue';
import { type BarberOpt, type BookingDto, type ServiceOpt, type Status, statusClass } from '@/Components/Booking/types';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbChip from '@/Components/Ui/SbChip.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import SbTabs from '@/Components/Ui/SbTabs.vue';
import { json, query } from '@/Composables/useJson';
import { useToast } from '@/Composables/useToast';
import { useTr } from '@/Composables/useTr';
import { addDays, hhmm, zonedParts, zonedToUtc } from '@/Composables/useZonedTime';
import AppLayout from '@/Layouts/AppLayout.vue';

const props = defineProps<{
    branches: { id: string; name: string; timezone: string }[];
    branch: string | null;
    timezone: string;
    date: string;
    view: 'day' | 'week';
    barbers: BarberOpt[];
    services: ServiceOpt[];
    statuses: Status[];
    can: { create: boolean; createCustomer: boolean; any: boolean };
    channel: string | null;
    broadcasting: boolean;
}>();
const { t, locale } = useI18n();
const tr = useTr();
const { push } = useToast();

/** Layout scale: 1.6 px per minute (a 15-minute row is 24 px). */
const PX = 1.6;
const SNAP = 15;

const date = ref(props.date);
const view = ref(props.view);
const barberFilter = ref<string[]>([]);
const serviceFilter = ref('');
const showCancelled = ref(false);
const weekBarber = ref(props.barbers[0]?.id ?? '');

const bookings = ref<BookingDto[]>([]);
const hours = ref<Record<string, { start: string; end: string }[]>>({});
const loading = ref(false);
const failed = ref(false);
const now = ref(new Date());

// Range shown: a day, or the Saturday-first week containing the date (Gulf convention).
const days = computed(() => {
    if (view.value === 'day') return [date.value];
    const d = new Date(`${date.value}T12:00:00Z`);
    const offset = (d.getUTCDay() + 1) % 7; // days since Saturday
    const start = addDays(date.value, -offset);
    return Array.from({ length: 7 }, (_, i) => addDays(start, i));
});

const load = async (): Promise<void> => {
    if (!props.branch) return;
    loading.value = true;
    failed.value = false;
    const res = await json<{ bookings: BookingDto[]; hours: Record<string, { start: string; end: string }[]> }>(
        'GET',
        `/calendar/events?${query({ branch: props.branch, from: days.value[0] ?? date.value, to: days.value[days.value.length - 1] ?? date.value })}`,
    );
    loading.value = false;
    if (!res.ok) {
        failed.value = true;
        return;
    }
    bookings.value = res.data.bookings;
    hours.value = res.data.hours;
};
watch([date, view], () => {
    void load();
    router.replace({ url: `/calendar?${query({ branch: props.branch, date: date.value, view: view.value })}`, preserveState: true, preserveScroll: true });
});

// Columns: barbers (day view) or days of one barber (week view).
interface Column {
    key: string;
    barber: string;
    date: string;
    title: string;
    subtitle?: string;
}
const fmtDay = (d: string, opts: Intl.DateTimeFormatOptions): string => new Intl.DateTimeFormat(locale.value === 'ar' ? 'ar-QA' : 'en-GB', { ...opts, timeZone: 'UTC' }).format(new Date(`${d}T12:00:00Z`));
const columns = computed<Column[]>(() => {
    if (view.value === 'day') {
        return props.barbers
            .filter((b) => barberFilter.value.length === 0 || barberFilter.value.includes(b.id))
            .map((b) => ({ key: b.id, barber: b.id, date: date.value, title: b.name }));
    }
    return days.value.map((d) => ({ key: d, barber: weekBarber.value, date: d, title: fmtDay(d, { weekday: 'short' }), subtitle: fmtDay(d, { day: 'numeric', month: 'short' }) }));
});

// Vertical range: working hours and bookings, rounded to the hour; 09:00–22:00 when empty.
const placed = computed(() =>
    bookings.value
        .filter((b) => showCancelled.value || b.status !== 'cancelled')
        .filter((b) => !serviceFilter.value || b.items.some((i) => i.service === serviceFilter.value))
        .map((b) => {
            const s = zonedParts(b.starts_at, props.timezone);
            const e = zonedParts(b.ends_at, props.timezone);
            const blocked = zonedParts(b.blocked_until, props.timezone);
            return { b, date: s.date, start: s.minutes, end: e.date === s.date ? e.minutes : 24 * 60, blockedEnd: blocked.date === s.date ? blocked.minutes : 24 * 60 };
        }),
);
const workBlocks = computed(() => {
    const out: Record<string, { start: number; end: number }[]> = {};
    for (const [barber, list] of Object.entries(hours.value)) {
        for (const i of list) {
            const s = zonedParts(i.start, props.timezone);
            const e = zonedParts(i.end, props.timezone);
            (out[`${barber}|${s.date}`] ??= []).push({ start: s.minutes, end: e.date === s.date ? e.minutes : 24 * 60 });
        }
    }
    return out;
});
const range = computed(() => {
    let min = 24 * 60;
    let max = 0;
    Object.values(workBlocks.value).flat().forEach((w) => ((min = Math.min(min, w.start)), (max = Math.max(max, w.end))));
    placed.value.forEach((p) => ((min = Math.min(min, p.start)), (max = Math.max(max, p.blockedEnd))));
    if (min >= max) return { start: 9 * 60, end: 22 * 60 };
    return { start: Math.floor(min / 60) * 60, end: Math.min(24 * 60, Math.ceil(max / 60) * 60) };
});
const hourMarks = computed(() => {
    const out: number[] = [];
    for (let m = range.value.start; m < range.value.end; m += 60) out.push(m);
    return out;
});
const top = (minutes: number): number => (minutes - range.value.start) * PX;
const gridHeight = computed(() => (range.value.end - range.value.start) * PX);
const eventsFor = (c: Column) => placed.value.filter((p) => p.date === c.date && p.b.barber?.id === c.barber);
const fmtTime = (iso: string): string => new Intl.DateTimeFormat(locale.value === 'ar' ? 'ar-QA' : 'en-GB', { timeZone: props.timezone, hour: '2-digit', minute: '2-digit' }).format(new Date(iso));

const today = computed(() => zonedParts(now.value, props.timezone));
const nowTop = computed(() => (today.value.minutes >= range.value.start && today.value.minutes <= range.value.end ? top(today.value.minutes) : null));

// Click an empty spot → new booking there.
const newOpen = ref(false);
const prefill = ref<{ barber: string | null; date: string; minutes: number | null }>({ barber: null, date: props.date, minutes: null });
const minutesAt = (e: MouseEvent | DragEvent, el: HTMLElement): number => {
    const y = e.clientY - el.getBoundingClientRect().top;
    return Math.max(range.value.start, Math.min(range.value.end - SNAP, Math.round((range.value.start + y / PX) / SNAP) * SNAP));
};
const clickColumn = (e: MouseEvent, c: Column): void => {
    if (!props.can.create) return;
    prefill.value = { barber: c.barber, date: c.date, minutes: minutesAt(e, e.currentTarget as HTMLElement) };
    newOpen.value = true;
};
const newBooking = (): void => {
    prefill.value = { barber: null, date: date.value, minutes: null };
    newOpen.value = true;
};

// Drag to move: optimistic, reverted when the server says no (409 slot taken, outside hours…).
const dragging = ref<string | null>(null);
const onDragStart = (e: DragEvent, b: BookingDto): void => {
    dragging.value = b.id;
    e.dataTransfer?.setData('text/plain', b.id);
    if (e.dataTransfer) e.dataTransfer.effectAllowed = 'move';
};
const onDrop = async (e: DragEvent, c: Column): Promise<void> => {
    const id = dragging.value;
    dragging.value = null;
    const booking = bookings.value.find((b) => b.id === id);
    if (!booking) return;
    const minutes = minutesAt(e, e.currentTarget as HTMLElement);
    const startsAt = zonedToUtc(c.date, minutes, props.timezone);
    if (startsAt === booking.starts_at && booking.barber?.id === c.barber) return;

    const before = { ...booking };
    const length = new Date(booking.ends_at).getTime() - new Date(booking.starts_at).getTime();
    const tail = new Date(booking.blocked_until).getTime() - new Date(booking.ends_at).getTime();
    Object.assign(booking, {
        starts_at: startsAt,
        ends_at: new Date(new Date(startsAt).getTime() + length).toISOString(),
        blocked_until: new Date(new Date(startsAt).getTime() + length + tail).toISOString(),
        barber: props.barbers.find((x) => x.id === c.barber) ? { id: c.barber, name: { ar: props.barbers.find((x) => x.id === c.barber)?.name, en: props.barbers.find((x) => x.id === c.barber)?.name } } : booking.barber,
    });

    const res = await json<BookingDto & { alternatives?: string[] }>('PUT', `/bookings/${booking.id}/reschedule`, { starts_at: startsAt, barber: c.barber });
    if (res.ok) {
        Object.assign(booking, res.data);
        push(t('ui.bookings.moved_to', { time: hhmm(minutes) }), 'success');
    } else {
        Object.assign(booking, before);
        const alt = (res.data as { alternatives?: string[] } | undefined)?.alternatives ?? [];
        push(res.message ?? t('ui.states.error_title'), 'error', alt.length ? t('ui.bookings.next_free', { times: alt.map(fmtTime).join('، ') }) : undefined);
    }
};

// Detail drawer
const detailOpen = ref(false);
const detailId = ref<string | null>(null);
const openBooking = (b: BookingDto): void => {
    detailId.value = b.id;
    detailOpen.value = true;
};
const onChanged = (b: BookingDto): void => {
    const i = bookings.value.findIndex((x) => x.id === b.id);
    if (i >= 0) bookings.value[i] = { ...bookings.value[i], ...b, actions: b.actions };
};

// Live updates: Reverb when the server broadcasts, plus a quiet refresh every minute.
let clock: ReturnType<typeof setInterval> | undefined;
let poll: ReturnType<typeof setInterval> | undefined;
let leave: (() => void) | undefined;
onMounted(async () => {
    void load();
    clock = setInterval(() => (now.value = new Date()), 30_000);
    poll = setInterval(() => !document.hidden && void load(), 60_000);
    const key = import.meta.env.VITE_REVERB_APP_KEY as string | undefined;
    if (props.broadcasting && props.channel && key) {
        const [{ default: Echo }, { default: Pusher }] = await Promise.all([import('laravel-echo'), import('pusher-js')]);
        (window as unknown as { Pusher: unknown }).Pusher = Pusher;
        const echo = new Echo({
            broadcaster: 'reverb',
            key,
            wsHost: import.meta.env.VITE_REVERB_HOST as string,
            wsPort: Number(import.meta.env.VITE_REVERB_PORT ?? 80),
            wssPort: Number(import.meta.env.VITE_REVERB_PORT ?? 443),
            forceTLS: (import.meta.env.VITE_REVERB_SCHEME ?? 'https') === 'https',
            enabledTransports: ['ws', 'wss'],
        });
        const channel = props.channel;
        echo.private(channel).listen('.booking.changed', () => void load());
        leave = () => echo.leave(channel);
    }
});
onBeforeUnmount(() => {
    clearInterval(clock);
    clearInterval(poll);
    leave?.();
});

const toggleBarber = (id: string): void => {
    barberFilter.value = barberFilter.value.includes(id) ? barberFilter.value.filter((x) => x !== id) : [...barberFilter.value, id];
};
const step = (n: number): void => {
    date.value = addDays(date.value, view.value === 'week' ? 7 * n : n);
};
const switchBranch = (id?: string): void => {
    if (id) router.get('/calendar', { branch: id, date: date.value, view: view.value });
};
const title = computed(() =>
    view.value === 'day'
        ? fmtDay(date.value, { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })
        : `${fmtDay(days.value[0] ?? date.value, { day: 'numeric', month: 'short' })} – ${fmtDay(days.value[6] ?? date.value, { day: 'numeric', month: 'short', year: 'numeric' })}`,
);
const viewTabs = computed(() => [
    { value: 'day', label: t('ui.calendar.day') },
    { value: 'week', label: t('ui.calendar.week') },
]);
const isToday = (d: string): boolean => d === today.value.date;
</script>

<template>
    <AppLayout :title="t('nav.calendar')">
        <div class="flex flex-col gap-4">
            <!-- Toolbar -->
            <header class="flex flex-wrap items-center justify-between gap-3">
                <div class="flex flex-wrap items-center gap-2">
                    <SbButton size="sm" variant="secondary" @click="date = today.date">{{ t('ui.calendar.today') }}</SbButton>
                    <SbButton size="sm" variant="ghost" icon-only :label="t('ui.calendar.previous')" @click="step(-1)"><ChevronLeft class="h-4 w-4 rtl:rotate-180" aria-hidden="true" /></SbButton>
                    <SbButton size="sm" variant="ghost" icon-only :label="t('ui.calendar.next')" @click="step(1)"><ChevronRight class="h-4 w-4 rtl:rotate-180" aria-hidden="true" /></SbButton>
                    <h2 class="text-h4">{{ title }}</h2>
                    <SbButton size="sm" variant="ghost" icon-only :label="t('ui.calendar.refresh')" :loading="loading" @click="load"><RefreshCw class="h-4 w-4" aria-hidden="true" /></SbButton>
                </div>
                <div class="flex flex-wrap items-center gap-2">
                    <div class="w-36"><SbTabs v-model="view" :tabs="viewTabs" /></div>
                    <div v-if="branches.length > 1" class="w-48"><SbSelect :model-value="branch ?? ''" compact :options="branches.map((b) => ({ value: b.id, label: b.name }))" @update:model-value="switchBranch" /></div>
                    <SbButton v-if="can.create && branch" size="sm" @click="newBooking"><template #icon><Plus class="h-4 w-4" aria-hidden="true" /></template>{{ t('ui.bookings.new') }}</SbButton>
                </div>
            </header>

            <!-- Filters -->
            <div class="flex flex-wrap items-center gap-2">
                <template v-if="view === 'day'">
                    <SbChip v-for="b in barbers" :key="b.id" :selected="barberFilter.includes(b.id)" @click="toggleBarber(b.id)">{{ b.name }}</SbChip>
                </template>
                <div v-else class="w-56"><SbSelect v-model="weekBarber" compact :options="barbers.map((b) => ({ value: b.id, label: b.name }))" /></div>
                <div class="w-56"><SbSelect v-model="serviceFilter" compact :options="[{ value: '', label: t('ui.calendar.all_services') }, ...services.map((s) => ({ value: s.id, label: tr(s.name) }))]" /></div>
                <SbChip :selected="showCancelled" @click="showCancelled = !showCancelled">{{ t('ui.calendar.show_cancelled') }}</SbChip>
            </div>

            <div v-if="!branch || barbers.length === 0" class="rounded-card border border-border bg-surface">
                <SbEmptyState :icon="CalendarDays" :title="t('ui.calendar.no_barbers')" :description="t('ui.calendar.no_barbers_hint')" />
            </div>
            <div v-else-if="failed" class="flex items-center justify-between rounded-card border border-error bg-error-soft p-4" role="alert">
                <span>{{ t('ui.states.error_description') }}</span>
                <SbButton size="sm" variant="secondary" @click="load">{{ t('ui.common.retry') }}</SbButton>
            </div>

            <!-- Grid -->
            <div v-else class="overflow-auto rounded-card border border-border bg-surface shadow-sm" :aria-busy="loading">
                <div class="flex min-w-max">
                    <!-- Time gutter -->
                    <div class="sticky start-0 z-20 w-16 shrink-0 border-e border-border bg-surface">
                        <div class="h-12 border-b border-border"></div>
                        <div class="relative" :style="{ height: `${gridHeight}px` }">
                            <span v-for="m in hourMarks" :key="m" class="absolute end-2 -translate-y-2 text-caption text-text-secondary tabular" dir="ltr" :style="{ top: `${top(m)}px` }">{{ hhmm(m) }}</span>
                        </div>
                    </div>

                    <div v-for="c in columns" :key="c.key" class="shrink-0 border-e border-border last:border-e-0" :class="view === 'week' ? 'w-44' : 'w-56'">
                        <div class="sticky top-0 z-10 flex h-12 flex-col items-center justify-center border-b border-border bg-surface px-2 text-center" :class="isToday(c.date) ? 'text-accent' : ''">
                            <span class="truncate text-label font-semibold">{{ c.title }}</span>
                            <span v-if="c.subtitle" class="text-caption text-text-secondary">{{ c.subtitle }}</span>
                        </div>
                        <div
                            class="relative bg-surface-muted"
                            :class="can.create ? 'cursor-copy' : ''"
                            :style="{ height: `${gridHeight}px` }"
                            role="grid"
                            :aria-label="c.title"
                            @dragover.prevent
                            @drop.prevent="onDrop($event, c)"
                        >
                            <!-- Working hours (white), the rest stays muted -->
                            <div
                                v-for="(w, i) in workBlocks[`${c.barber}|${c.date}`] ?? []"
                                :key="i"
                                class="pointer-events-none absolute inset-x-0 bg-surface"
                                :style="{ top: `${top(w.start)}px`, height: `${(w.end - w.start) * PX}px` }"
                            ></div>
                            <!-- Half-hour lines -->
                            <div v-for="m in hourMarks" :key="`l${m}`" class="pointer-events-none absolute inset-x-0 border-t border-border" :style="{ top: `${top(m)}px` }"></div>
                            <div v-for="m in hourMarks" :key="`h${m}`" class="pointer-events-none absolute inset-x-0 border-t border-dashed border-border opacity-50" :style="{ top: `${top(m + 30)}px` }"></div>
                            <!-- Click layer (above the shading, below bookings) -->
                            <div class="absolute inset-0" @click="clickColumn($event, c)"></div>
                            <!-- Now line -->
                            <div v-if="isToday(c.date) && nowTop !== null" class="pointer-events-none absolute inset-x-0 z-20 border-t-2 border-error" :style="{ top: `${nowTop}px` }">
                                <span class="absolute -start-1 -top-1.5 h-3 w-3 rounded-pill bg-error"></span>
                            </div>
                            <!-- Bookings -->
                            <template v-for="p in eventsFor(c)" :key="p.b.id">
                                <div v-if="p.blockedEnd > p.end" class="pointer-events-none absolute inset-x-1 rounded-b-input bg-border opacity-40" :style="{ top: `${top(p.end)}px`, height: `${(p.blockedEnd - p.end) * PX}px` }"></div>
                                <button
                                    type="button"
                                    class="absolute inset-x-1 z-10 flex flex-col overflow-hidden rounded-input border-s-4 px-2 py-1 text-start text-caption shadow-sm transition-opacity"
                                    :class="[statusClass[p.b.status], dragging === p.b.id ? 'opacity-50' : '', p.b.actions.includes('reschedule') ? 'cursor-grab' : '']"
                                    :style="{ top: `${top(p.start)}px`, height: `${Math.max(20, (p.end - p.start) * PX - 2)}px` }"
                                    :draggable="p.b.actions.includes('reschedule')"
                                    @dragstart="onDragStart($event, p.b)"
                                    @click.stop="openBooking(p.b)"
                                >
                                    <span class="truncate font-semibold">{{ p.b.customer?.name }}</span>
                                    <span class="truncate opacity-80"><span dir="ltr" class="tabular">{{ hhmm(p.start) }}</span> · {{ p.b.items.map((i) => tr(i.name)).join(' + ') }}</span>
                                </button>
                            </template>
                        </div>
                    </div>
                </div>
            </div>

            <p class="text-caption text-text-secondary">{{ t('ui.calendar.legend', { tz: timezone }) }}</p>
        </div>

        <NewBookingDrawer
            v-if="branch"
            v-model:open="newOpen"
            :branch="branch"
            :timezone="timezone"
            :barbers="barbers"
            :services="services"
            :prefill="prefill"
            :can-create-customer="can.createCustomer"
            :can-any="can.any"
            @created="load"
        />
        <BookingDrawer v-model:open="detailOpen" :booking-id="detailId" :timezone="timezone" :barbers="barbers" @changed="onChanged" />
    </AppLayout>
</template>
