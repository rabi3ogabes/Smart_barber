<script setup lang="ts" generic="Row extends Record<string, unknown>">
import { useI18n } from 'vue-i18n';
import SbEmptyState from './SbEmptyState.vue';
import SbErrorState from './SbErrorState.vue';
import SbSkeleton from './SbSkeleton.vue';

export interface Column {
    key: string;
    label: string;
    align?: 'start' | 'end';
    numeric?: boolean;
    /** Hide the column inside mobile cards (still shown on tablet/desktop). */
    hideOnCard?: boolean;
}

/**
 * Data table with a sticky header. Below md it turns into a list of cards (design-system.md).
 * Owns the loading / empty / error states so every list looks the same.
 */
withDefaults(
    defineProps<{
        columns: Column[];
        rows: Row[];
        rowKey: keyof Row & string;
        loading?: boolean;
        error?: boolean;
        emptyTitle?: string;
        emptyDescription?: string;
    }>(),
    { loading: false, error: false, emptyTitle: undefined, emptyDescription: undefined },
);
const emit = defineEmits<{ retry: [] }>();
const { t } = useI18n();
</script>

<template>
    <div class="overflow-hidden rounded-card border border-border bg-surface">
        <div v-if="loading" class="p-4"><SbSkeleton :lines="5" class="h-10 w-full" /></div>
        <SbErrorState v-else-if="error" @retry="emit('retry')" />
        <SbEmptyState v-else-if="rows.length === 0" :title="emptyTitle ?? t('ui.states.empty_title')" :description="emptyDescription" />
        <template v-else>
            <div class="hidden max-h-[70vh] overflow-auto md:block">
                <table class="w-full border-collapse text-body">
                    <thead class="sticky top-0 z-10 bg-surface-muted">
                        <tr>
                            <th
                                v-for="col in columns"
                                :key="col.key"
                                scope="col"
                                class="h-11 whitespace-nowrap px-4 text-label font-semibold text-text-secondary"
                                :class="col.align === 'end' || col.numeric ? 'text-end' : 'text-start'"
                            >
                                {{ col.label }}
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="row in rows" :key="String(row[rowKey])" class="border-t border-border hover:bg-surface-muted/60">
                            <td v-for="col in columns" :key="col.key" class="h-14 px-4" :class="[col.align === 'end' || col.numeric ? 'text-end' : 'text-start', col.numeric ? 'tabular' : '']">
                                <slot :name="`cell-${col.key}`" :row="row" :value="row[col.key]">{{ row[col.key] }}</slot>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <ul class="divide-y divide-border md:hidden">
                <li v-for="row in rows" :key="String(row[rowKey])" class="flex flex-col gap-2 p-4">
                    <div v-for="col in columns.filter((c) => !c.hideOnCard)" :key="col.key" class="flex items-center justify-between gap-4">
                        <span class="text-caption text-text-secondary">{{ col.label }}</span>
                        <span class="text-end text-body" :class="col.numeric ? 'tabular' : ''">
                            <slot :name="`cell-${col.key}`" :row="row" :value="row[col.key]">{{ row[col.key] }}</slot>
                        </span>
                    </div>
                </li>
            </ul>
        </template>
    </div>
</template>
