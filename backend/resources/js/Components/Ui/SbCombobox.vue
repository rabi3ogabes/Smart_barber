<script setup lang="ts">
import { Check, ChevronsUpDown } from 'lucide-vue-next';
import {
    ComboboxAnchor,
    ComboboxContent,
    ComboboxEmpty,
    ComboboxInput,
    ComboboxItem,
    ComboboxItemIndicator,
    ComboboxPortal,
    ComboboxRoot,
    ComboboxTrigger,
    ComboboxViewport,
} from 'reka-ui';
import { computed, ref, useId } from 'vue';
import { useI18n } from 'vue-i18n';
import type { SelectOption } from './SbSelect.vue';

const props = withDefaults(defineProps<{ options: SelectOption[]; label?: string; placeholder?: string; error?: string }>(), {
    label: undefined,
    placeholder: undefined,
    error: undefined,
});

const model = defineModel<string>();
const search = ref('');
const id = useId();
const { t } = useI18n();

const filtered = computed(() => {
    const q = search.value.trim().toLocaleLowerCase();
    return q === '' ? props.options : props.options.filter((o) => o.label.toLocaleLowerCase().includes(q));
});

const display = (value: unknown): string => props.options.find((o) => o.value === value)?.label ?? '';
</script>

<template>
    <div class="flex flex-col gap-1.5">
        <label v-if="label" :for="id" class="text-label text-text-primary">{{ label }}</label>
        <ComboboxRoot v-model="model" :ignore-filter="true" open-on-click>
            <ComboboxAnchor
                class="flex h-12 w-full items-center gap-2 rounded-input border bg-surface px-3.5 focus-within:border-accent"
                :class="error ? 'border-error' : 'border-border'"
            >
                <ComboboxInput
                    :id="id"
                    v-model="search"
                    :display-value="display"
                    :placeholder="placeholder"
                    class="h-full min-w-0 flex-1 bg-transparent text-body text-text-primary placeholder:text-text-secondary focus:outline-none"
                />
                <ComboboxTrigger :aria-label="t('ui.common.open')"><ChevronsUpDown class="h-4 w-4 text-text-secondary" aria-hidden="true" /></ComboboxTrigger>
            </ComboboxAnchor>
            <ComboboxPortal>
                <ComboboxContent
                    position="popper"
                    :side-offset="6"
                    class="z-50 max-h-72 w-[var(--reka-combobox-trigger-width)] overflow-hidden rounded-card border border-border bg-surface-elevated shadow-md"
                >
                    <ComboboxViewport class="p-1">
                        <ComboboxEmpty class="px-3 py-6 text-center text-label text-text-secondary">{{ t('ui.common.no_results') }}</ComboboxEmpty>
                        <ComboboxItem
                            v-for="option in filtered"
                            :key="option.value"
                            :value="option.value"
                            class="relative flex h-10 cursor-pointer select-none items-center rounded-input ps-8 pe-3 text-body outline-none data-[highlighted]:bg-surface-muted"
                        >
                            <ComboboxItemIndicator class="absolute start-2 inline-flex"><Check class="h-4 w-4 text-accent" aria-hidden="true" /></ComboboxItemIndicator>
                            {{ option.label }}
                        </ComboboxItem>
                    </ComboboxViewport>
                </ComboboxContent>
            </ComboboxPortal>
        </ComboboxRoot>
        <p v-if="error" class="text-caption text-error" role="alert">{{ error }}</p>
    </div>
</template>
