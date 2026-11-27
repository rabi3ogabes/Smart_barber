<script setup lang="ts">
withDefaults(defineProps<{ lines?: number; class?: string }>(), { lines: 1, class: 'h-4 w-full' });
</script>

<template>
    <div class="flex flex-col gap-2" role="status" aria-live="polite" aria-busy="true">
        <div
            v-for="n in lines"
            :key="n"
            :class="$props.class"
            class="rounded-input bg-[linear-gradient(90deg,var(--color-surface-muted)_25%,var(--color-border)_50%,var(--color-surface-muted)_75%)] bg-[length:200%_100%] animate-[sb-shimmer_1.4s_ease-in-out_infinite]"
        ></div>
    </div>
</template>
