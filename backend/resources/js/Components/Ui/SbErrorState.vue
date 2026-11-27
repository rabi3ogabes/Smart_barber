<script setup lang="ts">
import { RefreshCw, TriangleAlert } from 'lucide-vue-next';
import { useI18n } from 'vue-i18n';
import SbButton from './SbButton.vue';

withDefaults(defineProps<{ title?: string; description?: string; retrying?: boolean }>(), { title: undefined, description: undefined, retrying: false });
const emit = defineEmits<{ retry: [] }>();
const { t } = useI18n();
</script>

<template>
    <div class="flex flex-col items-center justify-center gap-3 px-6 py-12 text-center" role="alert">
        <div class="flex h-14 w-14 items-center justify-center rounded-pill bg-error-soft text-error">
            <TriangleAlert class="h-6 w-6" aria-hidden="true" />
        </div>
        <h3 class="text-h4">{{ title ?? t('ui.states.error_title') }}</h3>
        <p class="max-w-sm text-body text-text-secondary">{{ description ?? t('ui.states.error_description') }}</p>
        <SbButton variant="secondary" :loading="retrying" class="mt-2" @click="emit('retry')">
            <template #icon><RefreshCw class="h-4 w-4" aria-hidden="true" /></template>
            {{ t('ui.common.retry') }}
        </SbButton>
    </div>
</template>
