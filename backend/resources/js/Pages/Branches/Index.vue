<script setup lang="ts">
import { router, useForm } from '@inertiajs/vue3';
import { CalendarOff, MapPin, Pencil, Phone, Plus, Store, Trash2 } from 'lucide-vue-next';
import { computed, ref } from 'vue';
import { useI18n } from 'vue-i18n';
import WeekRangesEditor from '@/Components/Domain/WeekRangesEditor.vue';
import SbAvatarGroup from '@/Components/Ui/SbAvatarGroup.vue';
import SbBadge from '@/Components/Ui/SbBadge.vue';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbConfirmDialog from '@/Components/Ui/SbConfirmDialog.vue';
import SbDrawer from '@/Components/Ui/SbDrawer.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import { type Week, cloneWeek, useDateFormat, useWeekdays } from '@/Composables/useWeekdays';
import AppLayout from '@/Layouts/AppLayout.vue';

interface Closure { id: string; starts_on: string; ends_on: string; reason: { ar?: string; en?: string } }
interface Branch {
    id: string;
    name: { ar?: string; en?: string };
    address: { ar?: string; en?: string };
    lat: string | null;
    lng: string | null;
    phone: string | null;
    timezone: string;
    is_active: boolean;
    hours: Week;
    closures: Closure[];
    staff: string[];
    can_update: boolean;
}

const props = defineProps<{
    branches: Branch[];
    salonClosures: Closure[];
    can: { create: boolean; changeStatus: boolean; salonClosures: boolean };
    defaultTimezone: string;
}>();
const { t, locale } = useI18n();
const { names } = useWeekdays();
const { fmt } = useDateFormat();
const tr = (v: { ar?: string; en?: string }): string => (locale.value === 'ar' ? v.ar || v.en : v.en || v.ar) ?? '';

const todayIdx = new Date().getDay();
const todayHours = (b: Branch): string => {
    const ranges = b.hours[todayIdx] ?? [];
    return ranges.length ? ranges.map((r) => `${r.start}–${r.end}`).join(' · ') : t('ui.common.closed');
};

// Drawer form
const open = ref(false);
const editing = ref<Branch | null>(null);
const form = useForm({ name: { ar: '', en: '' }, address: { ar: '', en: '' }, phone: '', lat: '', lng: '', timezone: props.defaultTimezone, hours: cloneWeek(undefined) as Week });
const startCreate = (): void => {
    editing.value = null;
    form.defaults({ name: { ar: '', en: '' }, address: { ar: '', en: '' }, phone: '', lat: '', lng: '', timezone: props.defaultTimezone, hours: cloneWeek({ 0: [{ start: '10:00', end: '22:00' }], 1: [{ start: '10:00', end: '22:00' }], 2: [{ start: '10:00', end: '22:00' }], 3: [{ start: '10:00', end: '22:00' }], 4: [{ start: '10:00', end: '22:00' }], 5: [{ start: '14:00', end: '22:00' }], 6: [{ start: '10:00', end: '22:00' }] }) });
    form.reset();
    form.clearErrors();
    open.value = true;
};
const startEdit = (b: Branch): void => {
    editing.value = b;
    form.defaults({ name: { ar: b.name.ar ?? '', en: b.name.en ?? '' }, address: { ar: b.address.ar ?? '', en: b.address.en ?? '' }, phone: b.phone ?? '', lat: b.lat ?? '', lng: b.lng ?? '', timezone: b.timezone, hours: cloneWeek(b.hours) });
    form.reset();
    form.clearErrors();
    open.value = true;
};
const save = (): void => {
    const opts = { preserveScroll: true, onSuccess: () => (open.value = false) };
    form.transform((d) => ({ ...d, phone: d.phone || null, lat: d.lat || null, lng: d.lng || null }));
    if (editing.value) form.put(`/branches/${editing.value.id}`, opts);
    else form.post('/branches', opts);
};
const err = (key: string): string | undefined => (form.errors as Record<string, string>)[key];

// Status
const toggling = ref<Branch | null>(null);
const confirmToggle = (): void => {
    const b = toggling.value;
    if (!b) return;
    router.put(`/branches/${b.id}/status`, { active: !b.is_active }, { preserveScroll: true, onFinish: () => (toggling.value = null) });
};

// Closures
const closureForm = useForm({ branch: null as string | null, starts_on: '', ends_on: '', reason: { ar: '', en: '' } });
const closureOpen = ref(false);
const addClosure = (branch: string | null): void => {
    closureForm.reset();
    closureForm.clearErrors();
    closureForm.branch = branch;
    closureOpen.value = true;
};
const saveClosure = (): void => {
    closureForm.post('/closures', { preserveScroll: true, onSuccess: () => (closureOpen.value = false) });
};
const removeClosure = (c: Closure): void => router.delete(`/closures/${c.id}`, { preserveScroll: true });
const closureLabel = (c: Closure): string => (c.starts_on === c.ends_on ? fmt(c.starts_on) : `${fmt(c.starts_on)} – ${fmt(c.ends_on)}`);

const activeCount = computed(() => props.branches.filter((b) => b.is_active).length);
</script>

<template>
    <AppLayout :title="t('nav.branches')">
        <div class="mx-auto flex max-w-6xl flex-col gap-6">
            <header class="flex flex-wrap items-end justify-between gap-4">
                <div>
                    <h2 class="text-h2">{{ t('nav.branches') }}</h2>
                    <p class="mt-1 text-body text-text-secondary">{{ t('ui.branches.subtitle', { count: activeCount }) }}</p>
                </div>
                <SbButton v-if="can.create" @click="startCreate">
                    <template #icon><Plus class="h-4 w-4" aria-hidden="true" /></template>
                    {{ t('ui.branches.add') }}
                </SbButton>
            </header>

            <div v-if="branches.length === 0" class="rounded-card border border-border bg-surface">
                <SbEmptyState :icon="Store" :title="t('ui.branches.empty')" />
            </div>

            <div class="grid gap-4 md:grid-cols-2">
                <article v-for="b in branches" :key="b.id" class="flex flex-col gap-4 rounded-card border border-border bg-surface p-5 shadow-sm" :class="b.is_active ? '' : 'opacity-70'">
                    <div class="flex items-start justify-between gap-3">
                        <div class="min-w-0">
                            <div class="flex items-center gap-2">
                                <h3 class="truncate text-h4">{{ tr(b.name) }}</h3>
                                <SbBadge :tone="b.is_active ? 'success' : 'neutral'" dot>{{ b.is_active ? t('ui.common.active') : t('ui.common.inactive') }}</SbBadge>
                            </div>
                            <p v-if="tr(b.address)" class="mt-1 flex items-center gap-1.5 text-label text-text-secondary"><MapPin class="h-4 w-4 shrink-0" aria-hidden="true" />{{ tr(b.address) }}</p>
                            <p v-if="b.phone" class="mt-1 flex items-center gap-1.5 text-label text-text-secondary"><Phone class="h-4 w-4 shrink-0" aria-hidden="true" /><span dir="ltr">{{ b.phone }}</span></p>
                        </div>
                        <SbButton v-if="b.can_update" size="sm" variant="secondary" @click="startEdit(b)">
                            <template #icon><Pencil class="h-4 w-4" aria-hidden="true" /></template>{{ t('ui.common.edit') }}
                        </SbButton>
                    </div>
                    <dl class="grid grid-cols-2 gap-3 rounded-input bg-surface-muted p-3 text-label">
                        <div>
                            <dt class="text-caption text-text-secondary">{{ t('ui.branches.today', { day: names[todayIdx] }) }}</dt>
                            <dd class="tabular" dir="ltr">{{ todayHours(b) }}</dd>
                        </div>
                        <div>
                            <dt class="text-caption text-text-secondary">{{ t('ui.branches.team') }}</dt>
                            <dd class="mt-1">
                                <SbAvatarGroup v-if="b.staff.length" :names="b.staff" />
                                <span v-else class="text-text-secondary">{{ t('ui.branches.no_team') }}</span>
                            </dd>
                        </div>
                    </dl>
                    <div>
                        <div class="flex items-center justify-between">
                            <h4 class="text-label font-semibold">{{ t('ui.branches.closures') }}</h4>
                            <button v-if="b.can_update" type="button" class="text-label font-medium text-accent hover:underline" @click="addClosure(b.id)">{{ t('ui.branches.add_closure') }}</button>
                        </div>
                        <ul v-if="b.closures.length" class="mt-2 flex flex-col gap-1.5">
                            <li v-for="c in b.closures" :key="c.id" class="flex items-center justify-between gap-2 text-label">
                                <span class="flex items-center gap-2"><CalendarOff class="h-4 w-4 text-warning" aria-hidden="true" />{{ closureLabel(c) }} <span class="text-text-secondary">{{ tr(c.reason) }}</span></span>
                                <button v-if="b.can_update" type="button" class="inline-flex h-8 w-8 items-center justify-center rounded-input text-text-secondary hover:bg-surface-muted" :aria-label="t('ui.common.remove')" @click="removeClosure(c)"><Trash2 class="h-4 w-4" aria-hidden="true" /></button>
                            </li>
                        </ul>
                        <p v-else class="mt-2 text-caption text-text-secondary">{{ t('ui.branches.no_closures') }}</p>
                    </div>
                    <div v-if="can.changeStatus" class="border-t border-border pt-3">
                        <button type="button" class="text-label font-medium" :class="b.is_active ? 'text-error' : 'text-accent'" @click="toggling = b">
                            {{ b.is_active ? t('ui.branches.deactivate') : t('ui.branches.activate') }}
                        </button>
                    </div>
                </article>
            </div>

            <section v-if="can.salonClosures || salonClosures.length" class="rounded-card border border-border bg-surface p-5 shadow-sm">
                <div class="flex items-center justify-between">
                    <div>
                        <h3 class="text-h4">{{ t('ui.branches.salon_closures') }}</h3>
                        <p class="text-label text-text-secondary">{{ t('ui.branches.salon_closures_hint') }}</p>
                    </div>
                    <SbButton v-if="can.salonClosures" size="sm" variant="secondary" @click="addClosure(null)">{{ t('ui.branches.add_closure') }}</SbButton>
                </div>
                <ul v-if="salonClosures.length" class="mt-3 flex flex-col gap-1.5">
                    <li v-for="c in salonClosures" :key="c.id" class="flex items-center justify-between gap-2 text-label">
                        <span class="flex items-center gap-2"><CalendarOff class="h-4 w-4 text-warning" aria-hidden="true" />{{ closureLabel(c) }} <span class="text-text-secondary">{{ tr(c.reason) }}</span></span>
                        <button v-if="can.salonClosures" type="button" class="inline-flex h-8 w-8 items-center justify-center rounded-input text-text-secondary hover:bg-surface-muted" :aria-label="t('ui.common.remove')" @click="removeClosure(c)"><Trash2 class="h-4 w-4" aria-hidden="true" /></button>
                    </li>
                </ul>
            </section>
        </div>

        <SbDrawer v-model:open="open" :title="editing ? t('ui.branches.edit_title') : t('ui.branches.add')" size="lg">
            <form id="branch-form" class="flex flex-col gap-5" novalidate @submit.prevent="save">
                <div class="grid gap-4 sm:grid-cols-2">
                    <SbInput v-model="form.name.ar" :label="t('ui.settings.name_ar')" :error="err('name.ar')" required />
                    <SbInput v-model="form.name.en" :label="t('ui.settings.name_en')" :error="err('name.en')" required ltr />
                    <SbInput v-model="form.address.ar" :label="t('ui.branches.address_ar')" :error="err('address.ar')" />
                    <SbInput v-model="form.address.en" :label="t('ui.branches.address_en')" :error="err('address.en')" ltr />
                    <SbInput v-model="form.phone" type="tel" :label="t('ui.settings.phone')" placeholder="+97444123456" :error="err('phone')" />
                    <SbSelect v-model="form.timezone" :label="t('ui.settings.timezone')" :options="['Asia/Qatar', 'Asia/Riyadh', 'Asia/Dubai', 'Asia/Kuwait', 'Asia/Bahrain', 'Asia/Muscat'].map((z) => ({ value: z, label: z }))" />
                    <SbInput v-model="form.lat" inputmode="decimal" :label="t('ui.branches.lat')" placeholder="25.3176" :error="err('lat')" ltr />
                    <SbInput v-model="form.lng" inputmode="decimal" :label="t('ui.branches.lng')" placeholder="51.5300" :error="err('lng')" ltr />
                </div>
                <div>
                    <h4 class="text-label font-semibold">{{ t('ui.branches.opening_hours') }}</h4>
                    <p class="mb-3 text-caption text-text-secondary">{{ t('ui.branches.opening_hours_hint') }}</p>
                    <WeekRangesEditor v-model="form.hours" />
                    <p v-if="err('hours')" class="mt-2 text-caption text-error" role="alert">{{ err('hours') }}</p>
                </div>
            </form>
            <template #footer>
                <SbButton variant="secondary" @click="open = false">{{ t('ui.common.cancel') }}</SbButton>
                <SbButton type="submit" form="branch-form" :loading="form.processing">{{ t('ui.common.save') }}</SbButton>
            </template>
        </SbDrawer>

        <SbDrawer v-model:open="closureOpen" :title="t('ui.branches.add_closure')" size="sm">
            <form id="closure-form" class="flex flex-col gap-4" novalidate @submit.prevent="saveClosure">
                <SbInput v-model="closureForm.starts_on" type="date" :label="t('ui.common.from')" :error="closureForm.errors.starts_on" ltr />
                <SbInput v-model="closureForm.ends_on" type="date" :label="t('ui.common.to')" :error="closureForm.errors.ends_on" ltr />
                <SbInput v-model="closureForm.reason.ar" :label="t('ui.branches.reason_ar')" />
                <SbInput v-model="closureForm.reason.en" :label="t('ui.branches.reason_en')" ltr />
            </form>
            <template #footer>
                <SbButton variant="secondary" @click="closureOpen = false">{{ t('ui.common.cancel') }}</SbButton>
                <SbButton type="submit" form="closure-form" :loading="closureForm.processing">{{ t('ui.common.save') }}</SbButton>
            </template>
        </SbDrawer>

        <SbConfirmDialog
            :open="toggling !== null"
            :title="toggling?.is_active ? t('ui.branches.deactivate_title') : t('ui.branches.activate')"
            :description="toggling?.is_active ? t('ui.branches.deactivate_body') : undefined"
            :confirm-label="toggling?.is_active ? t('ui.branches.deactivate') : t('ui.branches.activate')"
            :danger="toggling?.is_active"
            @update:open="(v: boolean) => !v && (toggling = null)"
            @confirm="confirmToggle"
        />
    </AppLayout>
</template>
