<script setup lang="ts">
import { computed } from 'vue';

const props = withDefaults(defineProps<{ name: string; src?: string | null; size?: 'sm' | 'md' | 'lg' }>(), { src: null, size: 'md' });
const initials = computed(() =>
    props.name
        .split(/\s+/)
        .filter(Boolean)
        .slice(0, 2)
        .map((p) => p[0])
        .join('')
        .toUpperCase(),
);
const sizes = { sm: 'h-7 w-7 text-caption', md: 'h-9 w-9 text-label', lg: 'h-14 w-14 text-h4' };
</script>

<template>
    <span class="inline-flex shrink-0 items-center justify-center overflow-hidden rounded-pill bg-accent-soft font-semibold text-accent ring-2 ring-surface" :class="sizes[size]" :title="name">
        <img v-if="src" :src="src" :alt="name" class="h-full w-full object-cover" />
        <span v-else aria-hidden="true">{{ initials }}</span>
    </span>
</template>
