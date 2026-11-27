<script setup lang="ts">
import { router, useForm } from '@inertiajs/vue3';
import { CalendarClock, CalendarX, Coffee, Pencil, Trash2 } from 'lucide-vue-next';
import { computed, ref } from 'vue';
import { useI18n } from 'vue-i18n';
import WeekRangesEditor from '@/Components/Domain/WeekRangesEditor.vue';
import SbAvatar from '@/Components/Ui/SbAvatar.vue';
import SbBadge from '@/Components/Ui/SbBadge.vue';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbDrawer from '@/Components/Ui/SbDrawer.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import { type Week, WEEK_ORDER, cloneWeek, useDateFormat, useWeekdays } from '@/Composables/useWeekdays';
import AppLayout from '@/Layouts/AppLayout.vue';

interface Override { id: string; date: string; type: 'day_off' | 'custom_hours'; start: string | null; end: string | null; reason: string | null }
interface BarberRow { id: string; name: string; is_bookable: boolean; hours: Week; breaks: Week; overrides: Override[]; week_minutes: number; can_update: boolean }

const props = defineProps<{
    branches: { id: string; name: string }[];
    branch: { id: string; timezone: string; hours: Week } | null;
    weekStart: string;
    barbers: BarberRow[];
}>();
const { t } = useI18n();
const { shortNames, names } = useWeekdays();
const { fmt } = useDateFormat();

const branchId = ref(props.branch?.id ?? '');
const switchBranch = (id: string): void => router.get('/schedules', { branch: id }, { preserveState: false });
const hoursText = (mins: number): string => t('ui.schedules.hours_short', { h: Math.floor(mins / 60), m: String(mins % 60).padStart(2, '0') });
const dayCell = (w: Week, day: number): string => (w[day] ?? []).map((r) => `${r.start}–${r.end}`).join('\n');
const isOverride = (b: BarberRow, day: number): Override | undefined => {
    // Overrides in the displayed week, matched by weekday.
    const start = new Date(`${props.weekStart}T00:00:00Z`);
    return b.overrides.find((o) => {
        const d = new Date(`${o.date}T00:00:00Z`);
        const diff = (d.getTime() - start.getTime()) / 86_400_000;
        return diff >= 0 && diff < 7 && d.getUTCDay() === day;
    });
};

// Edit drawer
const editing = ref<BarberRow | null>(null);
const form = useForm({ branch: '', hours: cloneWeek(undefined) as Week, breaks: cloneWeek(undefined) as Week });
const open = (b: BarberRow): void => {
    editing.value = b;
    form.defaults({ branch: props.branch?.id ?? '', hours: cloneWeek(b.hours), breaks: cloneWeek(b.breaks) });
    form.reset();
    form.clearErrors();
    overrideForm.reset();
    overrideForm.clearErrors();
};
const copyBranchHours = (): void => {
    if (props.branch) form.hours = cloneWeek(props.branch.hours);
};
const save = (): void => {
    if (!editing.value) return;
    form.put(`/schedules/${editing.value.id}`, { preserveScroll: true, onSuccess: () => (editing.value = null) });
};
const errorList = computed(() => Object.entries(form.errors).map(([, v]) => v));

const overrideForm = useForm({ branch: '', date: '', type: 'day_off' as 'day_off' | 'custom_hours', start: '10:00', end: '18:00', reason: '' });
const addOverride = (): void => {
    if (!editing.value) return;
    overrideForm
        .transform((d) => ({ ...d, branch: props.branch?.id ?? '', start: d.type === 'custom_hours' ? d.start : null, end: d.type === 'custom_hours' ? d.end : null, reason: d.reason || null }))
        .post(`/schedules/${editing.value.id}/overrides`, {
            preserveScroll: true,
            onSuccess: () => {
                overrideForm.reset();
                editing.value = props.barbers.find((b) => b.id === editing.value?.id) ?? null;
            },
        });
};
const removeOverride = (o: Override): void =>
    router.delete(`/schedule-overrides/${o.id}`, {
        preserveScroll: true,
        onSuccess: () => (editing.value = props.barbers.find((b) => b.id === editing.value?.id) ?? null),
    });
const overrideLabel = (o: Override): string => (o.type === 'day_off' ? t('ui.schedules.day_off') : `${o.start}–${o.end}`);
</script>

<template>
    <AppLayout :title="t('nav.schedules')">
        <div class="mx-auto flex max-w-7xl flex-col gap-6">
            <header class="flex flex-wrap items-end justify-between gap-4">
                <div>
                    <h2 class="text-h2">{{ t('nav.schedules') }}</h2>
                    <p class="mt-1 text-body text-text-secondary">{{ t('ui.schedules.subtitle', { date: fmt(weekStart) }) }}</p>
                </div>
                <div v-if="branches.length > 1" class="w-64">
                    <SbSelect v-model="branchId" :label="t('ui.shell.branch')" :options="branches.map((b) => ({ value: b.id, label: b.name }))" @update:model-value="(v?: string) => v && switchBranch(v)" />
                </div>
            </header>

            <div v-if="!branch" class="rounded-card border border-border bg-surface">
                <SbEmptyState :icon="CalendarClock" :title="t('ui.schedules.no_branch')" :description="t('ui.schedules.no_branch_hint')" />
            </div>
            <div v-else-if="barbers.length === 0" class="rounded-card border border-border bg-surface">
                <SbEmptyState :icon="CalendarClock" :title="t('ui.schedules.empty')" :description="t('ui.schedules.empty_hint')" />
            </div>

            <div v-else class="overflow-x-auto rounded-card border border-border bg-surface shadow-sm">
                <table class="w-full min-w-[56rem] border-collapse text-label">
                    <thead>
                        <tr class="border-b border-border bg-surface-muted text-caption text-text-secondary">
                            <th scope="col" class="sticky start-0 z-10 w-56 bg-surface-muted px-4 py-3 text-start font-medium">{{ t('ui.schedules.barber') }}</th>
                            <th v-for="d in WEEK_ORDER" :key="d" scope="col" class="px-2 py-3 text-center font-medium">
                                {{ shortNames[d] }}
                                <span class="block text-text-secondary tabular" dir="ltr">{{ dayCell(branch.hours, d) || '—' }}</span>
                            </th>
                            <th scope="col" class="px-4 py-3 text-end font-medium">{{ t('ui.schedules.week_total') }}</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border">
                        <tr v-for="b in barbers" :key="b.id" class="group">
                            <th scope="row" class="sticky start-0 z-10 bg-surface px-4 py-3 text-start font-normal">
                                <div class="flex items-center gap-3">
                                    <SbAvatar :name="b.name" size="sm" />
                                    <div class="min-w-0">
                                        <p class="truncate font-medium">{{ b.name }}</p>
                                        <SbBadge v-if="!b.is_bookable" tone="warning">{{ t('ui.staff.not_bookable') }}</SbBadge>
                                    </div>
                                    <SbButton v-if="b.can_update" size="sm" variant="ghost" icon-only :label="t('ui.schedules.edit', { name: b.name })" class="ms-auto" @click="open(b)">
                                        <Pencil class="h-4 w-4" aria-hidden="true" />
                                    </SbButton>
                                </div>
                            </th>
                            <td v-for="d in WEEK_ORDER" :key="d" class="px-1.5 py-2 align-top">
                                <div
                                    v-if="isOverride(b, d)"
                                    class="rounded-input border border-dashed border-warning bg-warning-soft px-2 py-1.5 text-center text-caption text-warning"
                                    :title="isOverride(b, d)?.reason ?? ''"
                                >
                                    {{ overrideLabel(isOverride(b, d)!) }}
                                </div>
                                <div v-else-if="(b.hours[d] ?? []).length" class="flex flex-col gap-1">
                                    <span v-for="(r, i) in b.hours[d]" :key="i" class="rounded-input bg-accent-soft px-2 py-1.5 text-center text-caption font-medium text-accent tabular" dir="ltr">{{ `${r.start}–${r.end}` }}</span>
                                    <span v-for="(r, i) in b.breaks[d] ?? []" :key="`b${i}`" class="inline-flex items-center justify-center gap-1 text-caption text-text-secondary tabular" dir="ltr"><Coffee class="h-3 w-3" aria-hidden="true" />{{ `${r.start}–${r.end}` }}</span>
                                </div>
                                <div v-else class="rounded-input bg-surface-muted px-2 py-1.5 text-center text-caption text-text-secondary">{{ t('ui.schedules.off') }}</div>
                            </td>
                            <td class="px-4 py-3 text-end font-medium tabular">{{ hoursText(b.week_minutes) }}</td>
                        </tr>
                    </tbody>
                </table>
                <p class="border-t border-border px-4 py-3 text-caption text-text-secondary">{{ t('ui.schedules.legend', { tz: branch.timezone }) }}</p>
            </div>
        </div>

        <SbDrawer :open="editing !== null" :title="t('ui.schedules.edit', { name: editing?.name ?? '' })" :description="t('ui.schedules.edit_hint')" size="lg" @update:open="(v: boolean) => !v && (editing = null)">
            <form id="schedule-form" class="flex flex-col gap-6" novalidate @submit.prevent="save">
                <section>
                    <div class="mb-3 flex items-center justify-between">
                        <h3 class="text-label font-semibold">{{ t('ui.schedules.working_hours') }}</h3>
                        <button type="button" class="text-label font-medium text-accent hover:underline" @click="copyBranchHours">{{ t('ui.schedules.copy_branch_hours') }}</button>
                    </div>
                    <WeekRangesEditor v-model="form.hours" :empty-label="t('ui.schedules.off')" />
                </section>
                <section>
                    <h3 class="text-label font-semibold">{{ t('ui.schedules.breaks') }}</h3>
                    <p class="mb-3 text-caption text-text-secondary">{{ t('ui.schedules.breaks_hint') }}</p>
                    <WeekRangesEditor v-model="form.breaks" :empty-label="t('ui.schedules.no_break')" :default-range="{ start: '14:00', end: '15:00' }" />
                </section>
                <ul v-if="errorList.length" class="rounded-input bg-error-soft p-3 text-caption text-error" role="alert">
                    <li v-for="(e, i) in errorList" :key="i">{{ e }}</li>
                </ul>
            </form>

            <section class="mt-8 border-t border-border pt-6">
                <h3 class="text-label font-semibold">{{ t('ui.schedules.overrides') }}</h3>
                <p class="mb-3 text-caption text-text-secondary">{{ t('ui.schedules.overrides_hint') }}</p>
                <ul v-if="editing?.overrides.length" class="mb-4 flex flex-col gap-2">
                    <li v-for="o in editing.overrides" :key="o.id" class="flex items-center justify-between gap-2 rounded-input bg-surface-muted px-3 py-2 text-label">
                        <span class="flex items-center gap-2">
                            <CalendarX class="h-4 w-4 text-warning" aria-hidden="true" />
                            {{ fmt(o.date) }} · {{ names[new Date(`${o.date}T00:00:00Z`).getUTCDay()] }} · <span dir="ltr">{{ overrideLabel(o) }}</span>
                            <span v-if="o.reason" class="text-text-secondary">{{ o.reason }}</span>
                        </span>
                        <button type="button" class="inline-flex h-8 w-8 items-center justify-center rounded-input text-text-secondary hover:bg-surface" :aria-label="t('ui.common.remove')" @click="removeOverride(o)"><Trash2 class="h-4 w-4" aria-hidden="true" /></button>
                    </li>
                </ul>
                <div class="grid gap-3 sm:grid-cols-2">
                    <SbInput v-model="overrideForm.date" type="date" :label="t('ui.schedules.date')" :error="overrideForm.errors.date" ltr />
                    <SbSelect
                        v-model="overrideForm.type"
                        :label="t('ui.schedules.type')"
                        :options="[
                            { value: 'day_off', label: t('ui.schedules.day_off') },
                            { value: 'custom_hours', label: t('ui.schedules.custom_hours') },
                        ]"
                    />
                    <template v-if="overrideForm.type === 'custom_hours'">
                        <SbInput v-model="overrideForm.start" type="time" :label="t('ui.common.from')" :error="overrideForm.errors.start" ltr />
                        <SbInput v-model="overrideForm.end" type="time" :label="t('ui.common.to')" :error="overrideForm.errors.end" ltr />
                    </template>
                    <div class="sm:col-span-2">
                        <SbInput v-model="overrideForm.reason" :label="t('ui.schedules.reason')" :error="overrideForm.errors.reason" />
                    </div>
                </div>
                <SbButton class="mt-3" size="sm" variant="secondary" :loading="overrideForm.processing" @click="addOverride">{{ t('ui.schedules.add_override') }}</SbButton>
            </section>

            <template #footer>
                <SbButton variant="secondary" @click="editing = null">{{ t('ui.common.cancel') }}</SbButton>
                <SbButton type="submit" form="schedule-form" :loading="form.processing">{{ t('ui.common.save') }}</SbButton>
            </template>
        </SbDrawer>
    </AppLayout>
</template>
