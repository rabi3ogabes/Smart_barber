<script setup lang="ts">
import { Check, ChevronDown } from 'lucide-vue-next';
import {
    SelectContent,
    SelectIcon,
    SelectItem,
    SelectItemIndicator,
    SelectItemText,
    SelectPortal,
    SelectRoot,
    SelectTrigger,
    SelectValue,
    SelectViewport,
} from 'reka-ui';
import { computed, useId } from 'vue';

export interface SelectOption {
    value: string;
    label: string;
}

withDefaults(defineProps<{ options: SelectOption[]; label?: string; placeholder?: string; error?: string; disabled?: boolean; compact?: boolean }>(), {
    label: undefined,
    placeholder: undefined,
    error: undefined,
    disabled: false,
    compact: false,
});

const model = defineModel<string>();
const id = useId();

// Reka reserves "" for "no selection". An option whose value is "" (e.g. "All statuses") is
// mapped to a private sentinel inside the component, so callers can keep using "".
const EMPTY = '__sb_empty__';
const inner = computed({
    get: () => (model.value === '' ? EMPTY : model.value),
    set: (v?: string) => (model.value = v === EMPTY ? '' : v),
});
</script>

<template>
    <div class="flex flex-col gap-1.5">
        <label v-if="label" :for="id" class="text-label text-text-primary">{{ label }}</label>
        <SelectRoot v-model="inner" :disabled="disabled">
            <SelectTrigger
                :id="id"
                class="inline-flex w-full items-center justify-between gap-2 rounded-input border bg-surface px-3.5 text-body text-text-primary transition-colors duration-fast focus:border-accent focus:outline-none data-[disabled]:opacity-50"
                :class="[error ? 'border-error' : 'border-border', compact ? 'h-10' : 'h-12']"
                :aria-invalid="!!error"
            >
                <SelectValue :placeholder="placeholder" class="truncate text-start" />
                <SelectIcon as-child><ChevronDown class="h-4 w-4 shrink-0 text-text-secondary" aria-hidden="true" /></SelectIcon>
            </SelectTrigger>
            <SelectPortal>
                <SelectContent
                    position="popper"
                    :side-offset="6"
                    class="z-50 max-h-72 min-w-[var(--reka-select-trigger-width)] overflow-hidden rounded-card border border-border bg-surface-elevated shadow-md data-[state=open]:animate-[sb-pop_150ms_var(--ease-sb)]"
                >
                    <SelectViewport class="p-1">
                        <SelectItem
                            v-for="option in options"
                            :key="option.value"
                            :value="option.value === '' ? EMPTY : option.value"
                            class="relative flex h-10 cursor-pointer select-none items-center gap-2 rounded-input ps-8 pe-3 text-body text-text-primary outline-none data-[highlighted]:bg-surface-muted data-[state=checked]:font-semibold"
                        >
                            <SelectItemIndicator class="absolute start-2 inline-flex"><Check class="h-4 w-4 text-accent" aria-hidden="true" /></SelectItemIndicator>
                            <SelectItemText>{{ option.label }}</SelectItemText>
                        </SelectItem>
                    </SelectViewport>
                </SelectContent>
            </SelectPortal>
        </SelectRoot>
        <p v-if="error" class="text-caption text-error" role="alert">{{ error }}</p>
    </div>
</template>
