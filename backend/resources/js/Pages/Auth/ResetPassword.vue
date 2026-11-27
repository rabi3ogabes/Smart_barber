<script setup lang="ts">
import { useForm } from '@inertiajs/vue3';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import AuthLayout from '@/Layouts/AuthLayout.vue';

const props = defineProps<{ token: string; email: string }>();
const { t } = useI18n();
const form = useForm({ token: props.token, email: props.email, password: '', password_confirmation: '' });
const submit = (): void => {
    form.post('/reset-password', { onFinish: () => form.reset('password', 'password_confirmation') });
};
</script>

<template>
    <AuthLayout :title="t('ui.auth.reset_title')" :subtitle="t('ui.auth.reset_hint')">
        <form class="flex flex-col gap-5" novalidate @submit.prevent="submit">
            <SbInput v-model="form.email" type="email" :label="t('ui.auth.email')" autocomplete="username" :error="form.errors.email" required />
            <SbInput v-model="form.password" type="password" :label="t('ui.auth.new_password')" autocomplete="new-password" :hint="t('ui.auth.password_rules')" :error="form.errors.password" required />
            <SbInput v-model="form.password_confirmation" type="password" :label="t('ui.auth.confirm_password')" autocomplete="new-password" required />
            <SbButton type="submit" block :loading="form.processing">{{ t('ui.auth.reset_submit') }}</SbButton>
        </form>
    </AuthLayout>
</template>
