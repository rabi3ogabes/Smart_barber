<script setup lang="ts">
import {
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogOverlay,
    AlertDialogPortal,
    AlertDialogRoot,
    AlertDialogTitle,
} from 'reka-ui';
import { useI18n } from 'vue-i18n';

withDefaults(defineProps<{ title: string; description?: string; confirmLabel?: string; danger?: boolean; loading?: boolean }>(), {
    description: undefined,
    confirmLabel: undefined,
    danger: false,
    loading: false,
});
const emit = defineEmits<{ confirm: [] }>();
const open = defineModel<boolean>('open', { default: false });
const { t } = useI18n();
</script>

<template>
    <AlertDialogRoot v-model:open="open">
        <slot name="trigger" />
        <AlertDialogPortal>
            <AlertDialogOverlay class="fixed inset-0 z-40 bg-overlay" />
            <AlertDialogContent
                class="fixed start-1/2 top-1/2 z-50 w-[calc(100%-2rem)] max-w-md -translate-y-1/2 rounded-card bg-surface-elevated p-6 shadow-md ltr:-translate-x-1/2 rtl:translate-x-1/2 animate-[sb-pop_150ms_var(--ease-sb)]"
            >
                <AlertDialogTitle class="text-h4">{{ title }}</AlertDialogTitle>
                <AlertDialogDescription v-if="description" class="mt-2 text-body text-text-secondary">{{ description }}</AlertDialogDescription>
                <div v-if="$slots.default" class="mt-4"><slot /></div>
                <div class="mt-6 flex flex-wrap justify-end gap-3">
                    <AlertDialogCancel class="inline-flex h-12 items-center rounded-input border border-border px-5 text-button hover:bg-surface-muted">
                        {{ t('ui.common.cancel') }}
                    </AlertDialogCancel>
                    <AlertDialogAction
                        class="inline-flex h-12 items-center rounded-input px-5 text-button shadow-sm hover:opacity-90"
                        :class="danger ? 'bg-error text-white' : 'bg-primary text-on-primary'"
                        :disabled="loading"
                        @click="emit('confirm')"
                    >
                        {{ confirmLabel ?? t('ui.common.confirm') }}
                    </AlertDialogAction>
                </div>
            </AlertDialogContent>
        </AlertDialogPortal>
    </AlertDialogRoot>
</template>
