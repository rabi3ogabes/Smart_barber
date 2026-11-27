<script setup lang="ts">
import { Link, useForm } from '@inertiajs/vue3';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import AuthLayout from '@/Layouts/AuthLayout.vue';

const props = withDefaults(defineProps<{ context?: 'salon' | 'platform' }>(), { context: 'salon' });
const { t } = useI18n();
const form = useForm({ email: '', password: '', remember: false });
const submit = (): void => {
    form.post('/login', { onFinish: () => form.reset('password') });
};
</script>

<template>
    <AuthLayout :title="t('ui.auth.sign_in')" :subtitle="props.context === 'platform' ? t('ui.auth.console_subtitle') : t('ui.auth.sign_in_subtitle')">
        <form class="flex flex-col gap-5" novalidate @submit.prevent="submit">
            <SbInput v-model="form.email" type="email" :label="t('ui.auth.email')" autocomplete="username" :error="form.errors.email" required autofocus />
            <SbInput v-model="form.password" type="password" :label="t('ui.auth.password')" autocomplete="current-password" :error="form.errors.password" required />
            <div class="flex items-center justify-between gap-4">
                <label class="inline-flex min-h-12 items-center gap-2 text-label">
                    <input v-model="form.remember" type="checkbox" class="h-5 w-5 rounded border-border accent-[var(--color-accent)]" />
                    {{ t('ui.auth.remember') }}
                </label>
                <Link v-if="props.context === 'salon'" href="/forgot-password" class="text-label font-medium text-accent hover:underline">{{ t('ui.auth.forgot') }}</Link>
            </div>
            <SbButton type="submit" block :loading="form.processing">{{ t('ui.auth.sign_in') }}</SbButton>
        </form>
    </AuthLayout>
</template>
