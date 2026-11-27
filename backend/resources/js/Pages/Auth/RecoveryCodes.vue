<script setup lang="ts">
import { Copy } from 'lucide-vue-next';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';
import { useToast } from '@/Composables/useToast';
import AuthLayout from '@/Layouts/AuthLayout.vue';

const props = defineProps<{ codes: string[] }>();
const { t } = useI18n();
const { push } = useToast();
const copy = async (): Promise<void> => {
    try {
        await navigator.clipboard.writeText(props.codes.join('\n'));
        push(t('ui.auth.codes_copied'), 'success');
    } catch {
        push(t('ui.auth.copy_failed'), 'error');
    }
};
</script>

<template>
    <AuthLayout :title="t('ui.auth.codes_title')" :subtitle="t('ui.auth.codes_hint')">
        <ul class="grid grid-cols-2 gap-2 rounded-card border border-border bg-surface p-4" dir="ltr">
            <li v-for="code in codes" :key="code" class="rounded-input bg-surface-muted px-3 py-2 text-center text-label tabular">{{ code }}</li>
        </ul>
        <div class="mt-6 flex flex-col gap-3">
            <SbButton variant="secondary" block @click="copy">
                <template #icon><Copy class="h-4 w-4" aria-hidden="true" /></template>
                {{ t('ui.auth.copy_codes') }}
            </SbButton>
            <SbButton href="/" block>{{ t('ui.auth.codes_saved') }}</SbButton>
        </div>
    </AuthLayout>
</template>
