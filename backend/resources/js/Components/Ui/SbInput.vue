<script setup lang="ts">
import { computed, useId } from 'vue';

const props = withDefaults(
    defineProps<{
        label?: string;
        type?: string;
        error?: string;
        hint?: string;
        placeholder?: string;
        autocomplete?: string;
        inputmode?: 'text' | 'email' | 'tel' | 'numeric' | 'decimal' | 'search' | 'url';
        required?: boolean;
        disabled?: boolean;
        autofocus?: boolean;
        /** Phones, emails and codes stay LTR inside Arabic text. */
        ltr?: boolean;
    }>(),
    {
        label: undefined,
        type: 'text',
        error: undefined,
        hint: undefined,
        placeholder: undefined,
        autocomplete: undefined,
        inputmode: undefined,
        required: false,
        disabled: false,
        autofocus: false,
        ltr: undefined,
    },
);

const model = defineModel<string>({ default: '' });
const id = useId();
const forceLtr = computed(() => props.ltr ?? ['email', 'tel', 'password', 'url'].includes(props.type));
</script>

<template>
    <div class="flex flex-col gap-1.5">
        <label v-if="label" :for="id" class="text-label text-text-primary">
            {{ label }}
            <span v-if="required" class="text-error" aria-hidden="true">*</span>
        </label>
        <input
            :id="id"
            v-model="model"
            :type="type"
            :placeholder="placeholder"
            :autocomplete="autocomplete"
            :inputmode="inputmode"
            :required="required"
            :disabled="disabled"
            :autofocus="autofocus"
            :dir="forceLtr ? 'ltr' : undefined"
            :aria-invalid="!!error"
            :aria-describedby="error ? `${id}-error` : hint ? `${id}-hint` : undefined"
            class="h-12 w-full rounded-input border bg-surface px-3.5 text-body text-text-primary placeholder:text-text-secondary transition-colors duration-fast ease-sb focus:border-accent focus:outline-none disabled:cursor-not-allowed disabled:bg-surface-muted"
            :class="[error ? 'border-error' : 'border-border', forceLtr ? 'text-start [direction:ltr]' : 'text-start']"
        />
        <p v-if="error" :id="`${id}-error`" class="text-caption text-error" role="alert">{{ error }}</p>
        <p v-else-if="hint" :id="`${id}-hint`" class="text-caption text-text-secondary">{{ hint }}</p>
    </div>
</template>
