<script setup lang="ts">
import SbDialog from './SbDialog.vue';

withDefaults(defineProps<{ title: string; description?: string; size?: 'sm' | 'md' | 'lg' }>(), { description: undefined, size: 'md' });
const open = defineModel<boolean>('open', { default: false });
</script>

<template>
    <SbDialog v-model:open="open" :title="title" :description="description" :size="size" placement="bottom">
        <template #trigger><slot name="trigger" /></template>
        <slot />
        <template v-if="$slots.footer" #footer><slot name="footer" /></template>
    </SbDialog>
</template>
