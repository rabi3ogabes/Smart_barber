<script setup lang="ts">
import { useForm } from '@inertiajs/vue3';
import { ref } from 'vue';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import AuthLayout from '@/Layouts/AuthLayout.vue';

const { t } = useI18n();
const recovery = ref(false);
const form = useForm({ code: '' });
const submit = (): void => {
    form.post('/two-factor/challenge', { onError: () => form.reset('code') });
};
</script>

<template>
    <AuthLayout :title="t('ui.auth.two_factor_title')" :subtitle="recovery ? t('ui.auth.recovery_hint') : t('ui.auth.two_factor_hint')">
        <form class="flex flex-col gap-5" novalidate @submit.prevent="submit">
            <SbInput
                v-model="form.code"
                :label="recovery ? t('ui.auth.recovery_code') : t('ui.auth.code')"
                :inputmode="recovery ? 'text' : 'numeric'"
                autocomplete="one-time-code"
                ltr
                :error="form.errors.code"
                required
                autofocus
            />
            <SbButton type="submit" block :loading="form.processing">{{ t('ui.auth.verify') }}</SbButton>
            <button type="button" class="min-h-12 text-label font-medium text-accent hover:underline" @click="recovery = !recovery">
                {{ recovery ? t('ui.auth.use_authenticator') : t('ui.auth.use_recovery') }}
            </button>
        </form>
    </AuthLayout>
</template>
