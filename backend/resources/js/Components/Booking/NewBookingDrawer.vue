<script setup lang="ts">
import { Search, UserPlus, X } from 'lucide-vue-next';
import { computed, ref, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import type { MoneyDto } from '@/Components/Catalog/types';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbChip from '@/Components/Ui/SbChip.vue';
import SbDrawer from '@/Components/Ui/SbDrawer.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import SbTextarea from '@/Components/Ui/SbTextarea.vue';
import { json, query } from '@/Composables/useJson';
import { useToast } from '@/Composables/useToast';
import { useTr } from '@/Composables/useTr';
import { hhmm, zonedParts, zonedToUtc } from '@/Composables/useZonedTime';
import type { BarberOpt, BookingDto, ServiceOpt } from './types';

interface CustomerHit {
    id: string;
    name: string;
    phone: string;
    visits: number;
    no_shows: number;
}
interface Slot {
    starts_at: string;
    time: string;
    barbers: string[];
}

const props = defineProps<{
    branch: string;
    timezone: string;
    barbers: BarberOpt[];
    services: ServiceOpt[];
    prefill: { barber: string | null; date: string; minutes: number | null };
    canCreateCustomer: boolean;
    canAny: boolean;
}>();
const emit = defineEmits<{ created: [booking: BookingDto] }>();
const open = defineModel<boolean>('open', { default: false });
const { t } = useI18n();
const tr = useTr();
const { push } = useToast();

// Customer
const q = ref('');
const hits = ref<CustomerHit[]>([]);
const searching = ref(false);
const customer = ref<CustomerHit | null>(null);
const creatingCustomer = ref(false);
const newCustomer = ref({ name: '', phone: '' });
let timer: ReturnType<typeof setTimeout> | undefined;
watch(q, (v) => {
    clearTimeout(timer);
    if (v.trim().length < 2) {
        hits.value = [];
        return;
    }
    timer = setTimeout(async () => {
        searching.value = true;
        const res = await json<CustomerHit[]>('GET', `/customers/search?${query({ q: v })}`);
        searching.value = false;
        hits.value = res.ok ? res.data : [];
    }, 250);
});

// Selection
const serviceIds = ref<string[]>([]);
const barber = ref<string>('any');
const date = ref('');
const startsAt = ref<string | null>(null);
const manualTime = ref('');
const source = ref('dashboard');
const customerNotes = ref('');
const internalNotes = ref('');
const errors = ref<Record<string, string>>({});
const saving = ref(false);

watch(open, (v) => {
    if (!v) return;
    q.value = '';
    hits.value = [];
    customer.value = null;
    creatingCustomer.value = false;
    newCustomer.value = { name: '', phone: '' };
    serviceIds.value = [];
    barber.value = props.prefill.barber ?? (props.canAny ? 'any' : (props.barbers[0]?.id ?? ''));
    date.value = props.prefill.date;
    manualTime.value = props.prefill.minutes !== null ? hhmm(props.prefill.minutes) : '';
    startsAt.value = props.prefill.minutes !== null ? zonedToUtc(props.prefill.date, props.prefill.minutes, props.timezone) : null;
    source.value = 'dashboard';
    customerNotes.value = '';
    internalNotes.value = '';
    errors.value = {};
    slots.value = [];
    quote.value = null;
});

const toggleService = (id: string): void => {
    serviceIds.value = serviceIds.value.includes(id) ? serviceIds.value.filter((x) => x !== id) : [...serviceIds.value, id];
};

// Slots and quote (server-side only)
const slots = ref<Slot[]>([]);
const loadingSlots = ref(false);
const quote = ref<{ total: MoneyDto; duration_minutes: number } | null>(null);
watch([serviceIds, barber, date], async () => {
    quote.value = null;
    slots.value = [];
    if (!serviceIds.value.length || !date.value) return;
    loadingSlots.value = true;
    const params = { branch: props.branch, services: serviceIds.value, barber: barber.value, date: date.value };
    const [s, qt] = await Promise.all([
        json<Slot[]>('GET', `/calendar/slots?${query(params)}`),
        json<{ total: MoneyDto; duration_minutes: number }>('POST', '/calendar/quote', { branch: props.branch, services: serviceIds.value, barber: barber.value === 'any' ? null : barber.value }),
    ]);
    loadingSlots.value = false;
    slots.value = s.ok ? s.data : [];
    quote.value = qt.ok ? qt.data : null;
    if (!qt.ok && qt.message) errors.value = { services: qt.message };
    else errors.value = {};
}, { deep: true });

watch(manualTime, (v) => {
    if (!v || !date.value) return;
    const [h, m] = v.split(':').map(Number) as [number, number];
    startsAt.value = zonedToUtc(date.value, h * 60 + m, props.timezone);
});
const pickSlot = (s: Slot): void => {
    startsAt.value = s.starts_at;
    manualTime.value = s.time;
};
const selectedTime = computed(() => (startsAt.value ? hhmm(zonedParts(startsAt.value, props.timezone).minutes) : null));

const canSubmit = computed(() => (customer.value !== null || (creatingCustomer.value && newCustomer.value.name && newCustomer.value.phone)) && serviceIds.value.length > 0 && startsAt.value !== null);
const submit = async (): Promise<void> => {
    if (!canSubmit.value) return;
    saving.value = true;
    errors.value = {};
    const res = await json<BookingDto & { alternatives?: string[] }>('POST', '/bookings', {
        branch: props.branch,
        services: serviceIds.value,
        barber: barber.value,
        starts_at: startsAt.value,
        customer: customer.value?.id ?? null,
        new_customer: customer.value ? null : newCustomer.value,
        source: source.value,
        customer_notes: customerNotes.value || null,
        internal_notes: internalNotes.value || null,
    });
    saving.value = false;
    if (res.ok) {
        push(t('ui.bookings.created'), 'success');
        emit('created', res.data);
        open.value = false;
        return;
    }
    if (res.errors) errors.value = Object.fromEntries(Object.entries(res.errors).map(([k, v]) => [k, v[0] ?? '']));
    const alternatives = (res.data as { alternatives?: string[] } | undefined)?.alternatives;
    if (res.code === 'BOOKING_SLOT_TAKEN' && alternatives?.length) {
        slots.value = alternatives.map((iso) => ({ starts_at: iso, time: hhmm(zonedParts(iso, props.timezone).minutes), barbers: [] }));
    }
    push(res.message ?? t('ui.states.error_title'), 'error');
};
</script>

<template>
    <SbDrawer v-model:open="open" :title="t('ui.bookings.new')" size="lg">
        <form id="new-booking" class="flex flex-col gap-6" novalidate @submit.prevent="submit">
            <!-- Customer -->
            <section>
                <h3 class="mb-2 text-label font-semibold">{{ t('ui.bookings.customer') }}</h3>
                <div v-if="customer" class="flex items-center justify-between rounded-input border border-accent bg-accent-soft px-3 py-2">
                    <span>{{ customer.name }} · <span dir="ltr" class="tabular">{{ customer.phone }}</span> · {{ t('ui.bookings.visits', { n: customer.visits }) }}</span>
                    <button type="button" class="inline-flex h-8 w-8 items-center justify-center rounded-input hover:bg-surface" :aria-label="t('ui.common.remove')" @click="customer = null"><X class="h-4 w-4" aria-hidden="true" /></button>
                </div>
                <template v-else-if="!creatingCustomer">
                    <div class="relative">
                        <Search class="pointer-events-none absolute start-3 top-3.5 h-5 w-5 text-text-secondary" aria-hidden="true" />
                        <input
                            v-model="q"
                            type="search"
                            class="h-12 w-full rounded-input border border-border bg-surface ps-11 pe-3 text-body focus:border-accent focus:outline-none"
                            :placeholder="t('ui.bookings.search_customer')"
                            :aria-label="t('ui.bookings.search_customer')"
                            autocomplete="off"
                        />
                    </div>
                    <ul v-if="hits.length" class="mt-2 flex flex-col divide-y divide-border rounded-card border border-border" role="listbox">
                        <li v-for="h in hits" :key="h.id" role="option" :aria-selected="false">
                            <button type="button" class="flex w-full items-center justify-between px-3 py-2.5 text-start hover:bg-surface-muted" @click="customer = h">
                                <span class="font-medium">{{ h.name }}</span>
                                <span class="text-caption text-text-secondary"><span dir="ltr">{{ h.phone }}</span> · {{ t('ui.bookings.visits', { n: h.visits }) }}</span>
                            </button>
                        </li>
                    </ul>
                    <p v-else-if="q.length >= 2 && !searching" class="mt-2 text-caption text-text-secondary">{{ t('ui.common.no_results') }}</p>
                    <button v-if="canCreateCustomer" type="button" class="mt-3 inline-flex items-center gap-2 text-label font-medium text-accent hover:underline" @click="creatingCustomer = true; newCustomer.name = q">
                        <UserPlus class="h-4 w-4" aria-hidden="true" />{{ t('ui.bookings.new_customer') }}
                    </button>
                </template>
                <div v-else class="grid gap-3 sm:grid-cols-2">
                    <SbInput v-model="newCustomer.name" :label="t('ui.staff.name')" :error="errors['new_customer.name']" required />
                    <SbInput v-model="newCustomer.phone" type="tel" :label="t('ui.bookings.phone')" placeholder="5512 3456" :error="errors['new_customer.phone']" required />
                    <button type="button" class="text-start text-label text-text-secondary hover:underline sm:col-span-2" @click="creatingCustomer = false">{{ t('ui.bookings.search_instead') }}</button>
                </div>
                <p v-if="errors.customer" class="mt-2 text-caption text-error" role="alert">{{ errors.customer }}</p>
            </section>

            <!-- Services -->
            <section>
                <h3 class="mb-2 text-label font-semibold">{{ t('ui.bookings.services') }}</h3>
                <div class="flex flex-wrap gap-2">
                    <SbChip v-for="s in services" :key="s.id" :selected="serviceIds.includes(s.id)" @click="toggleService(s.id)">
                        {{ tr(s.name) }} · <span dir="ltr">{{ s.price.formatted }}</span>
                    </SbChip>
                </div>
                <p v-if="errors.services" class="mt-2 text-caption text-error" role="alert">{{ errors.services }}</p>
            </section>

            <!-- When and who -->
            <section class="grid gap-4 sm:grid-cols-2">
                <SbSelect v-model="barber" :label="t('ui.schedules.barber')" :options="[...(canAny ? [{ value: 'any', label: t('ui.bookings.any_barber') }] : []), ...barbers.map((b) => ({ value: b.id, label: b.name }))]" />
                <SbInput v-model="date" type="date" :label="t('ui.schedules.date')" ltr />
            </section>

            <section v-if="serviceIds.length">
                <div class="mb-2 flex items-center justify-between">
                    <h3 class="text-label font-semibold">{{ t('ui.bookings.free_times') }}</h3>
                    <span v-if="quote" class="text-label">{{ t('ui.catalog.minutes_short', { m: quote.duration_minutes }) }} · <strong dir="ltr" class="tabular">{{ quote.total.formatted }}</strong></span>
                </div>
                <p v-if="loadingSlots" class="text-caption text-text-secondary">{{ t('ui.bookings.loading_times') }}</p>
                <p v-else-if="!slots.length" class="text-caption text-text-secondary">{{ t('ui.bookings.no_times') }}</p>
                <div v-else class="flex max-h-44 flex-wrap gap-2 overflow-y-auto">
                    <SbChip v-for="s in slots" :key="s.starts_at" :selected="selectedTime === s.time" @click="pickSlot(s)"><span dir="ltr" class="tabular">{{ s.time }}</span></SbChip>
                </div>
                <div class="mt-3 w-40"><SbInput v-model="manualTime" type="time" :label="t('ui.bookings.other_time')" ltr /></div>
                <p v-if="errors.starts_at" class="mt-2 text-caption text-error" role="alert">{{ errors.starts_at }}</p>
            </section>

            <section class="grid gap-4 sm:grid-cols-2">
                <SbSelect v-model="source" :label="t('ui.bookings.source_label')" :options="['dashboard', 'phone', 'walk_in'].map((s) => ({ value: s, label: t(`ui.bookings.source.${s}`) }))" />
                <div></div>
                <SbTextarea v-model="customerNotes" :label="t('ui.bookings.customer_notes')" :rows="2" :maxlength="500" />
                <SbTextarea v-model="internalNotes" :label="t('ui.bookings.internal_notes')" :rows="2" :maxlength="1000" />
            </section>
        </form>
        <template #footer>
            <SbButton variant="secondary" @click="open = false">{{ t('ui.common.cancel') }}</SbButton>
            <SbButton type="submit" form="new-booking" :loading="saving" :disabled="!canSubmit">{{ t('ui.bookings.book') }}</SbButton>
        </template>
    </SbDrawer>
</template>
