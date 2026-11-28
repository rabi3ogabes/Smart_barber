<script setup lang="ts">
import { CalendarClock, Phone, Scissors, UserRound } from 'lucide-vue-next';
import { computed, ref, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import SbBadge from '@/Components/Ui/SbBadge.vue';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbCheckbox from '@/Components/Ui/SbCheckbox.vue';
import SbDrawer from '@/Components/Ui/SbDrawer.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import SbSkeleton from '@/Components/Ui/SbSkeleton.vue';
import { json } from '@/Composables/useJson';
import { useToast } from '@/Composables/useToast';
import { useTr } from '@/Composables/useTr';
import { hhmm, zonedParts, zonedToUtc } from '@/Composables/useZonedTime';
import { type BarberOpt, type BookingDto, statusTone } from './types';

const props = defineProps<{ bookingId: string | null; timezone: string; barbers: BarberOpt[] }>();
const emit = defineEmits<{ changed: [booking: BookingDto] }>();
const open = defineModel<boolean>('open', { default: false });
const { t, locale } = useI18n();
const tr = useTr();
const { push } = useToast();

const booking = ref<BookingDto | null>(null);
const loading = ref(false);
const failed = ref(false);
const busy = ref<string | null>(null);

const load = async (): Promise<void> => {
    if (!props.bookingId) return;
    loading.value = true;
    failed.value = false;
    const res = await json<BookingDto>('GET', `/bookings/${props.bookingId}`);
    loading.value = false;
    if (res.ok) booking.value = res.data;
    else failed.value = true;
};
watch(
    () => [open.value, props.bookingId],
    () => {
        if (open.value) {
            booking.value = null;
            mode.value = null;
            void load();
        }
    },
);

const fmtTime = (iso: string): string => new Intl.DateTimeFormat(locale.value === 'ar' ? 'ar-QA' : 'en-GB', { timeZone: props.timezone, hour: '2-digit', minute: '2-digit' }).format(new Date(iso));
const fmtDate = (iso: string): string => new Intl.DateTimeFormat(locale.value === 'ar' ? 'ar-QA' : 'en-GB', { timeZone: props.timezone, weekday: 'long', day: 'numeric', month: 'long' }).format(new Date(iso));
const can = (action: string): boolean => booking.value?.actions.includes(action) ?? false;

const run = async (action: string, url: string, body: Record<string, unknown> = {}): Promise<void> => {
    busy.value = action;
    const res = await json<BookingDto>('PUT', url, body);
    busy.value = null;
    if (res.ok) {
        booking.value = res.data;
        mode.value = null;
        emit('changed', res.data);
        push(t(`ui.bookings.done.${action}`), 'success');
    } else {
        push(res.message ?? t('ui.states.error_title'), 'error');
    }
};
const transition = (action: 'confirm' | 'arrive' | 'start' | 'complete' | 'no-show'): Promise<void> =>
    run(action === 'no-show' ? 'no_show' : action, `/bookings/${booking.value?.id}/${action}`, action === 'no-show' ? { waive_fee: waiveFee.value } : {});

// Cancel / no-show / reschedule panels
const mode = ref<'cancel' | 'no_show' | 'reschedule' | null>(null);
const reason = ref('');
const override = ref(false);
const waiveFee = ref(false);
const newDate = ref('');
const newTime = ref('');
const newBarber = ref('');
const openReschedule = (): void => {
    if (!booking.value) return;
    const p = zonedParts(booking.value.starts_at, props.timezone);
    newDate.value = p.date;
    newTime.value = hhmm(p.minutes);
    newBarber.value = booking.value.barber?.id ?? '';
    mode.value = 'reschedule';
};
const reschedule = async (): Promise<void> => {
    if (!booking.value || !newDate.value || !newTime.value) return;
    const [h, m] = newTime.value.split(':').map(Number) as [number, number];
    busy.value = 'reschedule';
    const res = await json<BookingDto & { alternatives?: string[] }>('PUT', `/bookings/${booking.value.id}/reschedule`, {
        starts_at: zonedToUtc(newDate.value, h * 60 + m, props.timezone),
        barber: newBarber.value || null,
    });
    busy.value = null;
    if (res.ok) {
        booking.value = res.data;
        mode.value = null;
        emit('changed', res.data);
        push(t('ui.bookings.done.reschedule'), 'success');
    } else {
        const alt = (res.data as { alternatives?: string[] } | undefined)?.alternatives ?? [];
        push(res.message ?? t('ui.states.error_title'), 'error', alt.length ? t('ui.bookings.next_free', { times: alt.map(fmtTime).join('، ') }) : undefined);
    }
};
const statusLabel = (s: string): string => t(`ui.bookings.status.${s}`);
const duration = computed(() => booking.value?.items.reduce((n, i) => n + i.duration_minutes, 0) ?? 0);
</script>

<template>
    <SbDrawer v-model:open="open" :title="booking?.customer?.name ?? t('ui.bookings.booking')" size="md">
        <div v-if="loading" class="flex flex-col gap-3" aria-busy="true">
            <SbSkeleton class="h-6 w-1/2" />
            <SbSkeleton class="h-24" />
            <SbSkeleton class="h-40" />
        </div>
        <div v-else-if="failed" class="flex flex-col items-start gap-3" role="alert">
            <p class="text-body">{{ t('ui.states.error_description') }}</p>
            <SbButton size="sm" variant="secondary" @click="load">{{ t('ui.common.retry') }}</SbButton>
        </div>
        <div v-else-if="booking" class="flex flex-col gap-5">
            <div class="flex flex-wrap items-center gap-2">
                <SbBadge :tone="statusTone[booking.status]" dot>{{ statusLabel(booking.status) }}</SbBadge>
                <SbBadge tone="neutral">{{ t(`ui.bookings.source.${booking.source}`) }}</SbBadge>
                <SbBadge v-if="booking.reschedule_count" tone="info">{{ t('ui.bookings.moved', { n: booking.reschedule_count }) }}</SbBadge>
            </div>

            <dl class="grid gap-3 rounded-card bg-surface-muted p-4 text-label">
                <div class="flex items-center gap-3">
                    <CalendarClock class="h-4 w-4 text-text-secondary" aria-hidden="true" />
                    <span>{{ fmtDate(booking.starts_at) }} · <span dir="ltr" class="tabular">{{ `${fmtTime(booking.starts_at)}–${fmtTime(booking.ends_at)}` }}</span> · {{ t('ui.catalog.minutes_short', { m: duration }) }}</span>
                </div>
                <div class="flex items-center gap-3">
                    <Scissors class="h-4 w-4 text-text-secondary" aria-hidden="true" />
                    <span>{{ tr(booking.barber?.name) }}</span>
                </div>
                <div v-if="booking.customer" class="flex items-center gap-3">
                    <UserRound class="h-4 w-4 text-text-secondary" aria-hidden="true" />
                    <span>{{ booking.customer.name }} · {{ t('ui.bookings.visits', { n: booking.customer.visits }) }}<template v-if="booking.customer.no_shows"> · <span class="text-error">{{ t('ui.bookings.no_shows', { n: booking.customer.no_shows }) }}</span></template></span>
                </div>
                <div v-if="booking.customer" class="flex items-center gap-3">
                    <Phone class="h-4 w-4 text-text-secondary" aria-hidden="true" />
                    <a :href="booking.customer.phone.includes('•') ? undefined : `tel:${booking.customer.phone}`" dir="ltr" class="tabular">{{ booking.customer.phone }}</a>
                </div>
            </dl>

            <section>
                <h3 class="mb-2 text-label font-semibold">{{ t('ui.bookings.services') }}</h3>
                <ul class="flex flex-col divide-y divide-border rounded-card border border-border">
                    <li v-for="(item, i) in booking.items" :key="i" class="flex items-center justify-between gap-3 px-4 py-2.5 text-label">
                        <span>{{ tr(item.name) }} <span class="text-caption text-text-secondary">· {{ t('ui.catalog.minutes_short', { m: item.duration_minutes }) }}</span></span>
                        <span class="tabular" dir="ltr">{{ item.total.formatted }}</span>
                    </li>
                    <li class="flex items-center justify-between px-4 py-2.5 font-semibold">
                        <span>{{ t('ui.bookings.total') }}</span><span class="tabular" dir="ltr">{{ booking.total.formatted }}</span>
                    </li>
                </ul>
                <p v-if="booking.customer_notes" class="mt-3 rounded-input bg-info-soft p-3 text-caption">{{ booking.customer_notes }}</p>
                <p v-if="booking.internal_notes" class="mt-2 rounded-input bg-surface-muted p-3 text-caption text-text-secondary">{{ booking.internal_notes }}</p>
                <p v-if="booking.cancel_reason" class="mt-2 text-caption text-text-secondary">{{ t('ui.bookings.cancel_reason') }}: {{ booking.cancel_reason }}</p>
            </section>

            <!-- Actions -->
            <section v-if="booking.actions.length && mode === null" class="flex flex-wrap gap-2">
                <SbButton v-if="can('confirm')" size="sm" :loading="busy === 'confirm'" @click="transition('confirm')">{{ t('ui.bookings.action.confirm') }}</SbButton>
                <SbButton v-if="can('arrive')" size="sm" :loading="busy === 'arrive'" @click="transition('arrive')">{{ t('ui.bookings.action.arrive') }}</SbButton>
                <SbButton v-if="can('start')" size="sm" :loading="busy === 'start'" @click="transition('start')">{{ t('ui.bookings.action.start') }}</SbButton>
                <SbButton v-if="can('complete')" size="sm" :loading="busy === 'complete'" @click="transition('complete')">{{ t('ui.bookings.action.complete') }}</SbButton>
                <SbButton v-if="can('reschedule')" size="sm" variant="secondary" @click="openReschedule">{{ t('ui.bookings.action.reschedule') }}</SbButton>
                <SbButton v-if="can('no_show')" size="sm" variant="secondary" @click="mode = 'no_show'">{{ t('ui.bookings.action.no_show') }}</SbButton>
                <SbButton v-if="can('cancel')" size="sm" variant="ghost" @click="mode = 'cancel'">{{ t('ui.bookings.action.cancel') }}</SbButton>
            </section>

            <section v-if="mode === 'reschedule'" class="flex flex-col gap-3 rounded-card border border-border p-4">
                <h3 class="text-label font-semibold">{{ t('ui.bookings.action.reschedule') }}</h3>
                <div class="grid gap-3 sm:grid-cols-2">
                    <SbInput v-model="newDate" type="date" :label="t('ui.schedules.date')" ltr />
                    <SbInput v-model="newTime" type="time" :label="t('ui.bookings.time')" ltr />
                </div>
                <SbSelect v-model="newBarber" :label="t('ui.schedules.barber')" :options="barbers.map((b) => ({ value: b.id, label: b.name }))" />
                <div class="flex gap-2">
                    <SbButton size="sm" :loading="busy === 'reschedule'" @click="reschedule">{{ t('ui.common.save') }}</SbButton>
                    <SbButton size="sm" variant="ghost" @click="mode = null">{{ t('ui.common.cancel') }}</SbButton>
                </div>
            </section>

            <section v-if="mode === 'cancel'" class="flex flex-col gap-3 rounded-card border border-error p-4">
                <h3 class="text-label font-semibold">{{ t('ui.bookings.cancel_title') }}</h3>
                <SbInput v-model="reason" :label="t('ui.bookings.cancel_reason')" />
                <SbCheckbox v-if="can('override_policy')" v-model="override" :label="t('ui.bookings.override_policy')" :description="t('ui.bookings.override_policy_hint')" />
                <div class="flex gap-2">
                    <SbButton size="sm" variant="danger" :loading="busy === 'cancel'" @click="run('cancel', `/bookings/${booking.id}/cancel`, { reason: reason || null, override_policy: override })">{{ t('ui.bookings.action.cancel') }}</SbButton>
                    <SbButton size="sm" variant="ghost" @click="mode = null">{{ t('ui.common.close') }}</SbButton>
                </div>
            </section>

            <section v-if="mode === 'no_show'" class="flex flex-col gap-3 rounded-card border border-error p-4">
                <h3 class="text-label font-semibold">{{ t('ui.bookings.no_show_title') }}</h3>
                <p class="text-caption text-text-secondary">{{ t('ui.bookings.no_show_hint') }}</p>
                <SbCheckbox v-if="can('override_policy')" v-model="waiveFee" :label="t('ui.bookings.waive_fee')" />
                <div class="flex gap-2">
                    <SbButton size="sm" variant="danger" :loading="busy === 'no_show'" @click="transition('no-show')">{{ t('ui.bookings.action.no_show') }}</SbButton>
                    <SbButton size="sm" variant="ghost" @click="mode = null">{{ t('ui.common.close') }}</SbButton>
                </div>
            </section>

            <section v-if="booking.history?.length">
                <h3 class="mb-2 text-label font-semibold">{{ t('ui.bookings.timeline') }}</h3>
                <ol class="flex flex-col gap-2 border-s border-border ps-4">
                    <li v-for="(h, i) in booking.history" :key="i" class="text-caption">
                        <span class="font-medium">{{ h.rescheduled ? t('ui.bookings.rescheduled') : statusLabel(h.to) }}</span>
                        <span class="text-text-secondary"> · {{ fmtDate(h.at) }} <span dir="ltr">{{ fmtTime(h.at) }}</span></span>
                        <span v-if="h.reason" class="block text-text-secondary">{{ h.reason }}</span>
                    </li>
                </ol>
            </section>
        </div>
    </SbDrawer>
</template>
