<script setup lang="ts">
import { Plus, X } from 'lucide-vue-next';
import { useI18n } from 'vue-i18n';
import { type Week, useWeekdays } from '@/Composables/useWeekdays';

/**
 * Edit weekly time ranges (several per day). Times are branch-local "HH:MM".
 * Shows a "Closed"/"Off" label for days without ranges.
 */
const props = withDefaults(defineProps<{ emptyLabel?: string; disabled?: boolean; max?: number; defaultRange?: { start: string; end: string } }>(), {
    emptyLabel: undefined,
    disabled: false,
    max: 4,
    defaultRange: () => ({ start: '10:00', end: '22:00' }),
});
const week = defineModel<Week>({ required: true });
const { t } = useI18n();
const { order, names } = useWeekdays();

const add = (day: number): void => {
    const ranges = week.value[day] ?? [];
    const last = ranges[ranges.length - 1];
    week.value[day] = [...ranges, last ? { start: last.end, end: last.end < '23:00' ? `${String(Number(last.end.slice(0, 2)) + 1).padStart(2, '0')}:00` : '23:59' } : { ...props.defaultRange }];
};
const remove = (day: number, index: number): void => {
    week.value[day] = (week.value[day] ?? []).filter((_, i) => i !== index);
};
</script>

<template>
    <div class="divide-y divide-border rounded-card border border-border bg-surface">
        <div v-for="day in order" :key="day" class="flex flex-col gap-2 px-4 py-3 sm:flex-row sm:items-start">
            <div class="w-32 shrink-0 pt-2 text-label font-medium">{{ names[day] }}</div>
            <div class="flex min-w-0 flex-1 flex-wrap items-center gap-2">
                <span v-if="(week[day] ?? []).length === 0" class="py-2 text-label text-text-secondary">{{ emptyLabel ?? t('ui.common.closed') }}</span>
                <div v-for="(range, i) in week[day]" :key="i" class="inline-flex items-center gap-1.5 rounded-input border border-border bg-surface-muted px-2 py-1" dir="ltr">
                    <input v-model="range.start" type="time" step="300" :disabled="disabled" class="h-9 rounded-input bg-transparent px-1 text-label tabular focus:outline-none" :aria-label="`${names[day]} ${t('ui.common.from')}`" />
                    <span class="text-text-secondary" aria-hidden="true">{{ "–" }}</span>
                    <input v-model="range.end" type="time" step="300" :disabled="disabled" class="h-9 rounded-input bg-transparent px-1 text-label tabular focus:outline-none" :aria-label="`${names[day]} ${t('ui.common.to')}`" />
                    <button v-if="!disabled" type="button" class="inline-flex h-8 w-8 items-center justify-center rounded-input text-text-secondary hover:bg-surface" :aria-label="t('ui.common.remove')" @click="remove(day, i)">
                        <X class="h-4 w-4" aria-hidden="true" />
                    </button>
                </div>
                <button
                    v-if="!disabled && (week[day] ?? []).length < max"
                    type="button"
                    class="inline-flex h-10 items-center gap-1 rounded-input px-3 text-label font-medium text-accent hover:bg-accent-soft"
                    @click="add(day)"
                >
                    <Plus class="h-4 w-4" aria-hidden="true" />{{ t('ui.common.add_range') }}
                </button>
            </div>
        </div>
    </div>
</template>
