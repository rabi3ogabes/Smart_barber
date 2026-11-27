<script setup lang="ts">
import { CircleAlert, CircleCheck, Info, TriangleAlert, X } from 'lucide-vue-next';
import { ToastClose, ToastDescription, ToastProvider, ToastRoot, ToastTitle, ToastViewport } from 'reka-ui';
import { useI18n } from 'vue-i18n';
import { useToast } from '@/Composables/useToast';

const { toasts, dismiss } = useToast();
const { t } = useI18n();
const icons = { success: CircleCheck, error: CircleAlert, warning: TriangleAlert, info: Info };
const tones = { success: 'text-success', error: 'text-error', warning: 'text-warning', info: 'text-info' };
</script>

<template>
    <ToastProvider :duration="5000" swipe-direction="up">
        <ToastRoot
            v-for="toast in toasts"
            :key="toast.id"
            class="flex items-start gap-3 rounded-card border border-border bg-surface-elevated p-4 shadow-md animate-[sb-pop_150ms_var(--ease-sb)]"
            @update:open="(open: boolean) => !open && dismiss(toast.id)"
        >
            <component :is="icons[toast.tone]" class="mt-0.5 h-5 w-5 shrink-0" :class="tones[toast.tone]" aria-hidden="true" />
            <div class="min-w-0 flex-1">
                <ToastTitle class="text-label font-semibold">{{ toast.title }}</ToastTitle>
                <ToastDescription v-if="toast.description" class="mt-1 text-caption text-text-secondary">{{ toast.description }}</ToastDescription>
            </div>
            <ToastClose class="inline-flex h-8 w-8 items-center justify-center rounded-input text-text-secondary hover:bg-surface-muted" :aria-label="t('ui.common.close')">
                <X class="h-4 w-4" aria-hidden="true" />
            </ToastClose>
        </ToastRoot>
        <ToastViewport class="fixed bottom-20 end-4 z-[60] flex w-[min(24rem,calc(100vw-2rem))] flex-col gap-2 outline-none md:bottom-6" />
    </ToastProvider>
</template>
