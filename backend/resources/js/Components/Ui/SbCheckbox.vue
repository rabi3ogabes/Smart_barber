<script setup lang="ts">
defineProps<{ label: string; description?: string; disabled?: boolean }>();
const model = defineModel<boolean>({ default: false });
</script>

<template>
    <label class="flex min-h-11 cursor-pointer items-start gap-3 py-1" :class="disabled ? 'cursor-not-allowed opacity-60' : ''">
        <input v-model="model" type="checkbox" :disabled="disabled" class="mt-0.5 h-5 w-5 shrink-0 rounded border-border accent-[var(--color-accent)]" />
        <span class="flex flex-col">
            <span class="text-body">{{ label }}</span>
            <span v-if="description" class="text-caption text-text-secondary">{{ description }}</span>
        </span>
    </label>
</template>
