<script setup lang="ts">
import { Head } from '@inertiajs/vue3';
import { useI18n } from 'vue-i18n';

const { t } = useI18n();
</script>

<template>
    <Head :title="t('ui.brand')" />
    <main class="flex min-h-screen flex-col items-center justify-center gap-4 bg-primary px-6 text-center text-on-primary">
        <span class="flex h-14 w-14 items-center justify-center rounded-card bg-on-primary/10 font-display text-h2 text-accent" aria-hidden="true">S</span>
        <h1 class="font-display text-display text-accent">{{ t('ui.brand') }}</h1>
        <p class="max-w-md text-body opacity-80">{{ t('ui.welcome.body') }}</p>
    </main>
</template>
