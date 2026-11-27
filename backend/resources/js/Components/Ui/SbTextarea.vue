<script setup lang="ts">
import { useId } from 'vue';

withDefaults(defineProps<{ label?: string; error?: string; hint?: string; rows?: number; maxlength?: number; placeholder?: string }>(), {
    label: undefined,
    error: undefined,
    hint: undefined,
    rows: 3,
    maxlength: undefined,
    placeholder: undefined,
});
const model = defineModel<string | null>({ default: '' });
const id = useId();
</script>

<template>
    <div class="flex flex-col gap-1.5">
        <label v-if="label" :for="id" class="text-label">{{ label }}</label>
        <textarea
            :id="id"
            v-model="model"
            :rows="rows"
            :maxlength="maxlength"
            :placeholder="placeholder"
            class="w-full rounded-input border bg-surface px-3.5 py-2.5 text-body focus:border-accent focus:outline-none"
            :class="error ? 'border-error' : 'border-border'"
            :aria-invalid="!!error"
        ></textarea>
        <p v-if="error" class="text-caption text-error" role="alert">{{ error }}</p>
        <p v-else-if="hint" class="text-caption text-text-secondary">{{ hint }}</p>
    </div>
</template>
