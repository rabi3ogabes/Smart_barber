<script setup lang="ts">
import { Inbox } from 'lucide-vue-next';
import type { Component } from 'vue';

withDefaults(defineProps<{ title: string; description?: string; icon?: Component }>(), { description: undefined, icon: () => Inbox });
</script>

<template>
    <div class="flex flex-col items-center justify-center gap-3 px-6 py-12 text-center">
        <div class="flex h-14 w-14 items-center justify-center rounded-pill bg-accent-soft text-accent">
            <component :is="icon" class="h-6 w-6" aria-hidden="true" />
        </div>
        <h3 class="text-h4">{{ title }}</h3>
        <p v-if="description" class="max-w-sm text-body text-text-secondary">{{ description }}</p>
        <div v-if="$slots.default" class="mt-2"><slot /></div>
    </div>
</template>
