<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { LogOut } from 'lucide-vue-next';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import { usePageProps } from '@/Composables/usePageProps';

const { props } = usePageProps();
const { t } = useI18n();
</script>

<template>
    <Head :title="t('ui.platform.title')" />
    <div class="mx-auto flex min-h-screen max-w-3xl flex-col px-6 py-10">
        <header class="flex items-center justify-between gap-4">
            <div>
                <p class="text-label font-semibold text-accent">{{ t('ui.auth.console') }}</p>
                <h1 class="text-h2">{{ t('ui.platform.welcome', { name: props.auth?.user.name ?? '' }) }}</h1>
            </div>
            <SbButton variant="secondary" @click="router.post('/logout')">
                <template #icon><LogOut class="flip-rtl h-4 w-4" aria-hidden="true" /></template>
                {{ t('ui.auth.logout') }}
            </SbButton>
        </header>
        <div class="mt-10 rounded-card border border-border bg-surface">
            <SbEmptyState :title="t('ui.platform.empty_title')" :description="t('ui.platform.empty_body')" />
        </div>
    </div>
</template>
