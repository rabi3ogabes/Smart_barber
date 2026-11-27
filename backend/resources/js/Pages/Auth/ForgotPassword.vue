<script setup lang="ts">
import { Link, useForm } from '@inertiajs/vue3';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import AuthLayout from '@/Layouts/AuthLayout.vue';

const { t } = useI18n();
const form = useForm({ email: '' });
const submit = (): void => {
    form.post('/forgot-password');
};
</script>

<template>
    <AuthLayout :title="t('ui.auth.forgot_title')" :subtitle="t('ui.auth.forgot_hint')">
        <form class="flex flex-col gap-5" novalidate @submit.prevent="submit">
            <SbInput v-model="form.email" type="email" :label="t('ui.auth.email')" autocomplete="username" :error="form.errors.email" required autofocus />
            <SbButton type="submit" block :loading="form.processing">{{ t('ui.auth.send_link') }}</SbButton>
            <Link href="/login" class="min-h-12 text-center text-label font-medium text-accent hover:underline">{{ t('ui.auth.back_to_login') }}</Link>
        </form>
    </AuthLayout>
</template>
