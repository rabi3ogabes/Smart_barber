<script setup lang="ts">
type Tone = 'neutral' | 'accent' | 'success' | 'warning' | 'error' | 'info';
withDefaults(defineProps<{ tone?: Tone; dot?: boolean }>(), { tone: 'neutral', dot: false });

const tones: Record<Tone, string> = {
    neutral: 'bg-surface-muted text-text-secondary',
    accent: 'bg-accent-soft text-accent',
    success: 'bg-success-soft text-success',
    warning: 'bg-warning-soft text-warning',
    error: 'bg-error-soft text-error',
    info: 'bg-info-soft text-info',
};
</script>

<template>
    <span class="inline-flex h-6 items-center gap-1.5 rounded-pill px-2.5 text-caption font-medium tabular" :class="tones[tone]">
        <span v-if="dot" class="h-1.5 w-1.5 rounded-pill bg-current" aria-hidden="true"></span>
        <slot />
    </span>
</template>
