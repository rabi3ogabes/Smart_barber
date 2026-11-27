<script setup lang="ts">
import { X } from 'lucide-vue-next';
import { DialogClose, DialogContent, DialogDescription, DialogOverlay, DialogPortal, DialogRoot, DialogTitle } from 'reka-ui';
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';

/**
 * Shared surface for Modal (centre), Drawer (end edge) and Sheet (bottom).
 * Drawers open from the end edge, so in Arabic they slide in from the left.
 */
const props = withDefaults(defineProps<{ title: string; description?: string; placement?: 'center' | 'end' | 'bottom'; size?: 'sm' | 'md' | 'lg' }>(), {
    description: undefined,
    placement: 'center',
    size: 'md',
});

const open = defineModel<boolean>('open', { default: false });
const { t } = useI18n();

const panel = computed(() => {
    const widths = { sm: 'max-w-sm', md: 'max-w-lg', lg: 'max-w-2xl' };
    if (props.placement === 'end') {
        return `fixed inset-y-0 end-0 flex w-full ${widths[props.size]} flex-col bg-surface-elevated shadow-md ltr:animate-[sb-slide-in-end_200ms_var(--ease-sb)] rtl:animate-[sb-slide-in-start_200ms_var(--ease-sb)]`;
    }
    if (props.placement === 'bottom') {
        return 'fixed inset-x-0 bottom-0 flex max-h-[90vh] flex-col rounded-t-sheet bg-surface-elevated shadow-md animate-[sb-slide-up_200ms_var(--ease-sb)]';
    }
    return `fixed start-1/2 top-1/2 flex max-h-[90vh] w-[calc(100%-2rem)] ${widths[props.size]} -translate-y-1/2 ltr:-translate-x-1/2 rtl:translate-x-1/2 flex-col rounded-card bg-surface-elevated shadow-md animate-[sb-pop_150ms_var(--ease-sb)]`;
});
</script>

<template>
    <DialogRoot v-model:open="open">
        <slot name="trigger" />
        <DialogPortal>
            <DialogOverlay class="fixed inset-0 z-40 bg-overlay animate-[sb-fade-in_150ms_var(--ease-sb)]" />
            <DialogContent :class="panel" class="z-50 focus:outline-none">
                <div v-if="placement === 'bottom'" class="mx-auto mt-2 h-1.5 w-10 rounded-pill bg-border" aria-hidden="true"></div>
                <header class="flex items-start justify-between gap-4 border-b border-border px-6 py-4">
                    <div class="min-w-0">
                        <DialogTitle class="text-h4 text-text-primary">{{ title }}</DialogTitle>
                        <DialogDescription v-if="description" class="mt-1 text-label text-text-secondary">{{ description }}</DialogDescription>
                    </div>
                    <DialogClose class="-me-2 inline-flex h-10 w-10 items-center justify-center rounded-input text-text-secondary hover:bg-surface-muted" :aria-label="t('ui.common.close')">
                        <X class="h-5 w-5" aria-hidden="true" />
                    </DialogClose>
                </header>
                <div class="min-h-0 flex-1 overflow-y-auto px-6 py-5">
                    <slot />
                </div>
                <footer v-if="$slots.footer" class="flex flex-wrap items-center justify-end gap-3 border-t border-border px-6 py-4">
                    <slot name="footer" />
                </footer>
            </DialogContent>
        </DialogPortal>
    </DialogRoot>
</template>
