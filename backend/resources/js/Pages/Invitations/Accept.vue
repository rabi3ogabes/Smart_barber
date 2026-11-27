<script setup lang="ts">
import { useForm } from '@inertiajs/vue3';
import { MailX } from 'lucide-vue-next';
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import SbBadge from '@/Components/Ui/SbBadge.vue';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import { useDateFormat } from '@/Composables/useWeekdays';
import AuthLayout from '@/Layouts/AuthLayout.vue';

const props = defineProps<{
    token: string;
    valid: boolean;
    invitation: { name: string | null; email: string | null; phone: string | null; roles: string[]; branches: string[]; expires_at: string } | null;
    hasAccount: boolean;
}>();
const { t } = useI18n();
const { fmt } = useDateFormat();
const form = useForm({ name: props.invitation?.name ?? '', email: '', password: '', password_confirmation: '' });
const needsEmail = computed(() => !props.invitation?.email);
const submit = (): void => {
    form.transform((d) => (props.hasAccount ? { password: d.password } : { ...d, email: needsEmail.value ? d.email : null })).post(`/invitations/${props.token}`, {
        onFinish: () => form.reset('password', 'password_confirmation'),
    });
};
</script>

<template>
    <AuthLayout
        :title="valid ? t('ui.invitations.title') : t('ui.invitations.invalid_title')"
        :subtitle="valid ? (hasAccount ? t('ui.invitations.subtitle_existing') : t('ui.invitations.subtitle_new')) : undefined"
    >
        <SbEmptyState v-if="!valid || !invitation" :icon="MailX" :title="t('ui.invitations.invalid_title')" :description="t('ui.invitations.invalid_body')" />
        <template v-else>
            <div class="mb-6 rounded-card border border-border bg-surface-muted p-4">
                <p class="text-caption text-text-secondary">{{ t('ui.invitations.joining_as') }}</p>
                <div class="mt-2 flex flex-wrap gap-1.5">
                    <SbBadge v-for="r in invitation.roles" :key="r" tone="accent">{{ t(`ui.roles.${r}`) }}</SbBadge>
                </div>
                <p v-if="invitation.branches.length" class="mt-2 text-label">{{ invitation.branches.join('، ') }}</p>
                <p class="mt-2 text-caption text-text-secondary">{{ t('ui.invitations.expires', { date: fmt(invitation.expires_at) }) }}</p>
            </div>
            <form class="flex flex-col gap-5" novalidate @submit.prevent="submit">
                <template v-if="hasAccount">
                    <SbInput :model-value="invitation.email ?? invitation.phone ?? ''" :label="t('ui.invitations.account')" disabled ltr />
                    <SbInput v-model="form.password" type="password" :label="t('ui.auth.password')" autocomplete="current-password" :error="form.errors.password" required autofocus />
                </template>
                <template v-else>
                    <SbInput v-model="form.name" :label="t('ui.staff.name')" autocomplete="name" :error="form.errors.name" required />
                    <SbInput v-if="needsEmail" v-model="form.email" type="email" :label="t('ui.auth.email')" autocomplete="username" :hint="t('ui.invitations.email_hint')" :error="form.errors.email" required />
                    <SbInput v-else :model-value="invitation.email ?? ''" :label="t('ui.auth.email')" disabled ltr />
                    <SbInput v-model="form.password" type="password" :label="t('ui.auth.new_password')" autocomplete="new-password" :hint="t('ui.auth.password_rules')" :error="form.errors.password" required />
                    <SbInput v-model="form.password_confirmation" type="password" :label="t('ui.auth.confirm_password')" autocomplete="new-password" required />
                </template>
                <SbButton type="submit" block :loading="form.processing">{{ t('ui.invitations.accept') }}</SbButton>
            </form>
        </template>
    </AuthLayout>
</template>
