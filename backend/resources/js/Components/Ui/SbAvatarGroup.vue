<script setup lang="ts">
import SbAvatar from './SbAvatar.vue';

withDefaults(defineProps<{ names: string[]; max?: number }>(), { max: 4 });
</script>

<template>
    <div class="flex items-center -space-x-2" :aria-label="names.join(', ')">
        <SbAvatar v-for="n in names.slice(0, max)" :key="n" :name="n" />
        <span v-if="names.length > max" class="inline-flex h-9 min-w-9 items-center justify-center rounded-pill bg-surface-muted px-1.5 text-caption font-medium text-text-secondary ring-2 ring-surface">
            +{{ names.length - max }}
        </span>
    </div>
</template>
