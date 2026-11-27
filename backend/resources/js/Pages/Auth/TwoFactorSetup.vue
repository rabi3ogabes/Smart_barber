<script setup lang="ts">
import { useForm } from '@inertiajs/vue3';
import { ShieldCheck } from 'lucide-vue-next';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import AuthLayout from '@/Layouts/AuthLayout.vue';

defineProps<{ qr: string; secret: string; required: boolean }>();
const { t } = useI18n();
const form = useForm({ code: '' });
const submit = (): void => {
    form.post('/two-factor/setup', { onError: () => form.reset('code') });
};
</script>

<template>
    <AuthLayout :title="t('ui.auth.setup_title')" :subtitle="required ? t('ui.auth.setup_required') : t('ui.auth.setup_optional')">
        <ol class="flex flex-col gap-6">
            <li class="flex flex-col gap-3">
                <p class="text-label font-semibold">{{ t('ui.auth.setup_step1') }}</p>
                <!-- eslint-disable-next-line vue/no-v-html -- server-generated QR SVG -->
                <div class="w-fit rounded-card border border-border bg-white p-3" v-html="qr"></div>
                <p class="text-caption text-text-secondary">{{ t('ui.auth.setup_manual') }}</p>
                <code class="w-fit select-all break-all rounded-input bg-surface-muted px-3 py-2 text-label tabular" dir="ltr">{{ secret }}</code>
            </li>
            <li>
                <form class="flex flex-col gap-4" novalidate @submit.prevent="submit">
                    <SbInput v-model="form.code" :label="t('ui.auth.setup_step2')" inputmode="numeric" autocomplete="one-time-code" ltr :error="form.errors.code" required />
                    <SbButton type="submit" block :loading="form.processing">
                        <template #icon><ShieldCheck class="h-4 w-4" aria-hidden="true" /></template>
                        {{ t('ui.auth.enable_2fa') }}
                    </SbButton>
                </form>
            </li>
        </ol>
    </AuthLayout>
</template>
