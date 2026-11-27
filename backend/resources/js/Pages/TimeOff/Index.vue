<script setup lang="ts">
import { router, useForm } from '@inertiajs/vue3';
import { CalendarPlus, Check, Plane, X } from 'lucide-vue-next';
import { computed, ref } from 'vue';
import { useI18n } from 'vue-i18n';
import SbAvatar from '@/Components/Ui/SbAvatar.vue';
import SbBadge from '@/Components/Ui/SbBadge.vue';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbConfirmDialog from '@/Components/Ui/SbConfirmDialog.vue';
import SbDrawer from '@/Components/Ui/SbDrawer.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import SbTextarea from '@/Components/Ui/SbTextarea.vue';
import AppLayout from '@/Layouts/AppLayout.vue';

type Status = 'pending' | 'approved' | 'rejected' | 'cancelled';
interface Req { id: string; barber: string; starts_at: string; ends_at: string; type: string; status: Status; reason: string | null; can_decide: boolean; can_cancel: boolean }
interface BarberRow { id: string; name: string; is_me: boolean; can_enter: boolean }

const props = defineProps<{ timezone: string; from: string; to: string; barbers: BarberRow[]; requests: Req[]; types: string[]; canRequest: boolean }>();
const { t, locale } = useI18n();
const intlLocale = computed(() => (locale.value === 'ar' ? 'ar-QA' : 'en-GB'));

// Dates in the salon timezone, as YYYY-MM-DD.
const localDate = (iso: string, offsetMs = 0): string =>
    new Intl.DateTimeFormat('en-CA', { timeZone: props.timezone, year: 'numeric', month: '2-digit', day: '2-digit' }).format(new Date(new Date(iso).getTime() + offsetMs));
const startDay = (r: Req): string => localDate(r.starts_at);
const endDay = (r: Req): string => localDate(r.ends_at, -1000); // ends_at is exclusive
const fmtDay = (d: string, opts: Intl.DateTimeFormatOptions = { day: 'numeric', month: 'short' }): string => new Intl.DateTimeFormat(intlLocale.value, { ...opts, timeZone: 'UTC' }).format(new Date(`${d}T00:00:00Z`));
const rangeLabel = (r: Req): string => (startDay(r) === endDay(r) ? fmtDay(startDay(r)) : `${fmtDay(startDay(r))} – ${fmtDay(endDay(r))}`);

const days = computed(() => {
    const out: string[] = [];
    const start = new Date(`${props.from}T00:00:00Z`);
    for (let i = 0; i < 56; i++) out.push(new Date(start.getTime() + i * 86_400_000).toISOString().slice(0, 10));
    return out;
});
const dayIndex = (d: string): number => Math.round((new Date(`${d}T00:00:00Z`).getTime() - new Date(`${props.from}T00:00:00Z`).getTime()) / 86_400_000);
const bars = (barberId: string) =>
    props.requests
        .filter((r) => r.barber === barberId && r.status !== 'rejected')
        .map((r) => {
            const s = Math.max(0, dayIndex(startDay(r)));
            const e = Math.min(55, dayIndex(endDay(r)));
            return { r, s, e };
        })
        .filter((b) => b.e >= 0 && b.s <= 55 && b.e >= b.s);
const barberName = (id: string): string => props.barbers.find((b) => b.id === id)?.name ?? '';
const pending = computed(() => props.requests.filter((r) => r.status === 'pending'));
const statusTone = (s: Status) => ({ pending: 'warning', approved: 'success', rejected: 'error', cancelled: 'neutral' })[s] as 'warning' | 'success' | 'error' | 'neutral';
const typeLabel = (type: string): string => t(`ui.time_off.types.${type}`);

// Request / enter form
const me = computed(() => props.barbers.find((b) => b.is_me));
const enterable = computed(() => props.barbers.filter((b) => (b.is_me && props.canRequest) || b.can_enter));
const open = ref(false);
const form = useForm({ barber: '', starts_on: '', ends_on: '', type: 'annual', reason: '' });
const openForm = (): void => {
    form.reset();
    form.clearErrors();
    form.barber = (props.canRequest ? me.value?.id : enterable.value[0]?.id) ?? '';
    open.value = true;
};
const isForSelf = computed(() => form.barber !== '' && form.barber === me.value?.id);
const submit = (): void => {
    form.transform((d) => ({ ...d, ends_on: d.ends_on || d.starts_on, reason: d.reason || null })).post('/time-off', { preserveScroll: true, onSuccess: () => (open.value = false) });
};

// Decisions
const deciding = ref<{ req: Req; approve: boolean } | null>(null);
const note = ref('');
const confirmDecision = (): void => {
    if (!deciding.value) return;
    router.put(`/time-off/${deciding.value.req.id}/decision`, { approve: deciding.value.approve, note: note.value || null }, { preserveScroll: true, onFinish: () => ((deciding.value = null), (note.value = '')) });
};
const cancelling = ref<Req | null>(null);
const confirmCancel = (): void => {
    if (!cancelling.value) return;
    router.put(`/time-off/${cancelling.value.id}/cancel`, {}, { preserveScroll: true, onFinish: () => (cancelling.value = null) });
};
const weekStarts = computed(() => days.value.filter((_, i) => i % 7 === 0));
</script>

<template>
    <AppLayout :title="t('nav.time_off')">
        <div class="mx-auto flex max-w-7xl flex-col gap-6">
            <header class="flex flex-wrap items-end justify-between gap-4">
                <div>
                    <h2 class="text-h2">{{ t('nav.time_off') }}</h2>
                    <p class="mt-1 text-body text-text-secondary">{{ t('ui.time_off.subtitle') }}</p>
                </div>
                <SbButton v-if="enterable.length" @click="openForm">
                    <template #icon><CalendarPlus class="h-4 w-4" aria-hidden="true" /></template>
                    {{ canRequest && enterable.length === 1 ? t('ui.time_off.request') : t('ui.time_off.add') }}
                </SbButton>
            </header>

            <!-- Pending approvals -->
            <section v-if="pending.length" class="rounded-card border border-border bg-surface p-5 shadow-sm">
                <h3 class="text-h4">{{ t('ui.time_off.pending_title', { count: pending.length }) }}</h3>
                <ul class="mt-3 divide-y divide-border">
                    <li v-for="r in pending" :key="r.id" class="flex flex-wrap items-center justify-between gap-3 py-3">
                        <div class="flex items-center gap-3">
                            <SbAvatar :name="barberName(r.barber)" size="sm" />
                            <div>
                                <p class="font-medium">{{ barberName(r.barber) }} · {{ typeLabel(r.type) }}</p>
                                <p class="text-caption text-text-secondary">{{ rangeLabel(r) }}<template v-if="r.reason"> · {{ r.reason }}</template></p>
                            </div>
                        </div>
                        <div class="flex items-center gap-2">
                            <template v-if="r.can_decide">
                                <SbButton size="sm" variant="secondary" @click="deciding = { req: r, approve: false }"><template #icon><X class="h-4 w-4" aria-hidden="true" /></template>{{ t('ui.time_off.reject') }}</SbButton>
                                <SbButton size="sm" @click="deciding = { req: r, approve: true }"><template #icon><Check class="h-4 w-4" aria-hidden="true" /></template>{{ t('ui.time_off.approve') }}</SbButton>
                            </template>
                            <SbButton v-else-if="r.can_cancel" size="sm" variant="ghost" @click="cancelling = r">{{ t('ui.time_off.cancel_request') }}</SbButton>
                            <SbBadge v-else tone="warning">{{ t('ui.time_off.status.pending') }}</SbBadge>
                        </div>
                    </li>
                </ul>
            </section>

            <!-- Timeline -->
            <section class="overflow-hidden rounded-card border border-border bg-surface shadow-sm">
                <SbEmptyState v-if="barbers.length === 0" :icon="Plane" :title="t('ui.time_off.empty')" :description="t('ui.time_off.empty_hint')" />
                <div v-else class="overflow-x-auto">
                    <div class="min-w-[64rem]">
                        <div class="grid border-b border-border bg-surface-muted text-caption text-text-secondary" style="grid-template-columns: 12rem repeat(56, minmax(0, 1fr))">
                            <div class="px-4 py-2 font-medium">{{ t('ui.schedules.barber') }}</div>
                            <div v-for="w in weekStarts" :key="w" class="col-span-7 border-s border-border px-2 py-2">{{ fmtDay(w) }}</div>
                        </div>
                        <div v-for="b in barbers" :key="b.id" class="grid items-center border-b border-border last:border-b-0" style="grid-template-columns: 12rem repeat(56, minmax(0, 1fr))">
                            <div class="flex items-center gap-2 px-4 py-3">
                                <SbAvatar :name="b.name" size="sm" />
                                <span class="truncate text-label font-medium">{{ b.name }}</span>
                            </div>
                            <div class="relative h-10" style="grid-column: 2 / span 56">
                                <div class="absolute inset-0 grid" style="grid-template-columns: repeat(56, minmax(0, 1fr))">
                                    <div v-for="(d, i) in days" :key="d" :class="[i % 7 === 0 ? 'border-s border-border' : '', [5, 6].includes(new Date(`${d}T00:00:00Z`).getUTCDay()) ? 'bg-surface-muted' : '']"></div>
                                </div>
                                <div
                                    v-for="bar in bars(b.id)"
                                    :key="bar.r.id"
                                    class="absolute top-1.5 flex h-7 items-center overflow-hidden rounded-pill px-2 text-caption font-medium"
                                    :class="bar.r.status === 'approved' ? 'bg-accent text-on-primary dark:text-primary' : 'border border-dashed border-warning bg-warning-soft text-warning'"
                                    :style="{ insetInlineStart: `${(bar.s / 56) * 100}%`, width: `${((bar.e - bar.s + 1) / 56) * 100}%` }"
                                    :title="`${typeLabel(bar.r.type)} · ${rangeLabel(bar.r)}`"
                                >
                                    <span class="truncate">{{ typeLabel(bar.r.type) }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="flex flex-wrap gap-4 border-t border-border px-4 py-3 text-caption text-text-secondary">
                    <span class="flex items-center gap-2"><span class="h-3 w-6 rounded-pill bg-accent"></span>{{ t('ui.time_off.status.approved') }}</span>
                    <span class="flex items-center gap-2"><span class="h-3 w-6 rounded-pill border border-dashed border-warning bg-warning-soft"></span>{{ t('ui.time_off.status.pending') }}</span>
                    <span>{{ t('ui.time_off.timezone', { tz: timezone }) }}</span>
                </div>
            </section>

            <!-- All requests -->
            <section v-if="requests.length" class="rounded-card border border-border bg-surface p-5 shadow-sm">
                <h3 class="text-h4">{{ t('ui.time_off.all_title') }}</h3>
                <ul class="mt-3 divide-y divide-border">
                    <li v-for="r in requests" :key="r.id" class="flex flex-wrap items-center justify-between gap-3 py-3 text-label">
                        <span>{{ barberName(r.barber) }} · {{ typeLabel(r.type) }} · {{ rangeLabel(r) }}</span>
                        <span class="flex items-center gap-2">
                            <SbBadge :tone="statusTone(r.status)" dot>{{ t(`ui.time_off.status.${r.status}`) }}</SbBadge>
                            <SbButton v-if="r.can_cancel && r.status === 'approved'" size="sm" variant="ghost" @click="cancelling = r">{{ t('ui.time_off.cancel_request') }}</SbButton>
                        </span>
                    </li>
                </ul>
            </section>
        </div>

        <SbDrawer v-model:open="open" :title="isForSelf ? t('ui.time_off.request') : t('ui.time_off.add')" :description="isForSelf ? t('ui.time_off.request_hint') : t('ui.time_off.add_hint')">
            <form id="timeoff-form" class="flex flex-col gap-4" novalidate @submit.prevent="submit">
                <SbSelect v-if="enterable.length > 1" v-model="form.barber" :label="t('ui.schedules.barber')" :options="enterable.map((b) => ({ value: b.id, label: b.is_me ? `${b.name} (${t('ui.staff.you')})` : b.name }))" :error="form.errors.barber" />
                <SbSelect v-model="form.type" :label="t('ui.schedules.type')" :options="types.map((x) => ({ value: x, label: typeLabel(x) }))" />
                <div class="grid gap-4 sm:grid-cols-2">
                    <SbInput v-model="form.starts_on" type="date" :label="t('ui.common.from')" :error="form.errors.starts_on" ltr />
                    <SbInput v-model="form.ends_on" type="date" :label="t('ui.common.to')" :error="form.errors.ends_on" ltr />
                </div>
                <SbTextarea v-model="form.reason" :label="t('ui.schedules.reason')" :rows="3" :maxlength="500" :error="form.errors.reason" />
            </form>
            <template #footer>
                <SbButton variant="secondary" @click="open = false">{{ t('ui.common.cancel') }}</SbButton>
                <SbButton type="submit" form="timeoff-form" :loading="form.processing">{{ isForSelf ? t('ui.time_off.send_request') : t('ui.common.save') }}</SbButton>
            </template>
        </SbDrawer>

        <SbConfirmDialog
            :open="deciding !== null"
            :title="deciding?.approve ? t('ui.time_off.approve_title') : t('ui.time_off.reject_title')"
            :description="deciding ? `${barberName(deciding.req.barber)} · ${rangeLabel(deciding.req)}` : undefined"
            :confirm-label="deciding?.approve ? t('ui.time_off.approve') : t('ui.time_off.reject')"
            :danger="deciding?.approve === false"
            @update:open="(v: boolean) => !v && (deciding = null)"
            @confirm="confirmDecision"
        >
            <SbInput v-model="note" :label="t('ui.time_off.note')" />
        </SbConfirmDialog>
        <SbConfirmDialog
            :open="cancelling !== null"
            :title="t('ui.time_off.cancel_title')"
            :confirm-label="t('ui.time_off.cancel_request')"
            danger
            @update:open="(v: boolean) => !v && (cancelling = null)"
            @confirm="confirmCancel"
        />
    </AppLayout>
</template>
