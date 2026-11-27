<script setup lang="ts">
import { Head } from '@inertiajs/vue3';
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';

const props = defineProps<{ status: 403 | 404 | 429 | 500 | 503 }>();
const { t } = useI18n();
const key = computed(() => `ui.errors.${props.status}`);
</script>

<template>
    <Head :title="t(`${key}_title`)" />
    <main class="flex min-h-screen flex-col items-center justify-center gap-4 px-6 text-center">
        <p class="font-display text-display text-accent tabular">{{ status }}</p>
        <h1 class="text-h2">{{ t(`${key}_title`) }}</h1>
        <p class="max-w-md text-body text-text-secondary">{{ t(`${key}_body`) }}</p>
        <SbButton href="/" variant="secondary" class="mt-2">{{ t('ui.errors.home') }}</SbButton>
    </main>
</template>
