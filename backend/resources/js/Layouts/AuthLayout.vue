<script setup lang="ts">
import { Head } from '@inertiajs/vue3';
import { Languages } from 'lucide-vue-next';
import { useI18n } from 'vue-i18n';
import SbToaster from '@/Components/Ui/SbToaster.vue';
import { useLocale } from '@/Composables/useLocale';
import { usePageProps } from '@/Composables/usePageProps';

defineProps<{ title: string; subtitle?: string }>();
const { props } = usePageProps();
const { t, locale } = useI18n();
const { setLocale } = useLocale();
</script>

<template>
    <Head :title="title" />
    <div class="grid min-h-screen lg:grid-cols-2 lg:grid-rows-1">
        <section class="relative hidden overflow-hidden bg-primary p-12 text-on-primary lg:flex lg:flex-col lg:justify-between">
            <div class="flex items-center gap-3">
                <span class="flex h-10 w-10 items-center justify-center rounded-input bg-on-primary/10 font-display text-h3 text-accent" aria-hidden="true">S</span>
                <span class="text-h4">{{ t('ui.brand') }}</span>
            </div>
            <div class="max-w-md">
                <p class="font-display text-display text-accent">{{ t('ui.auth.hero_title') }}</p>
                <p class="mt-4 text-body opacity-80">{{ t('ui.auth.hero_body') }}</p>
            </div>
            <p class="text-caption opacity-60">{{ props.salon?.name ?? t('ui.auth.console') }}</p>
        </section>

        <section class="flex flex-col px-6 py-8 sm:px-12">
            <div class="flex justify-end">
                <button type="button" class="inline-flex h-11 items-center gap-2 rounded-input px-3 text-label text-text-secondary hover:bg-surface-muted" @click="setLocale(locale === 'ar' ? 'en' : 'ar')">
                    <Languages class="h-4 w-4" aria-hidden="true" />
                    {{ locale === 'ar' ? 'English' : 'العربية' }}
                </button>
            </div>
            <div class="mx-auto flex w-full max-w-sm flex-1 flex-col justify-center py-10">
                <p v-if="props.salon" class="mb-2 text-label font-semibold text-accent">{{ props.salon.name }}</p>
                <h1 class="text-h1">{{ title }}</h1>
                <p v-if="subtitle" class="mt-2 text-body text-text-secondary">{{ subtitle }}</p>
                <div class="mt-8"><slot /></div>
            </div>
        </section>
    </div>
    <SbToaster />
</template>
