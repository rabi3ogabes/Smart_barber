<script setup lang="ts">
import { router, useForm } from '@inertiajs/vue3';
import { ImageUp } from 'lucide-vue-next';
import { ref } from 'vue';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbCheckbox from '@/Components/Ui/SbCheckbox.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import AppLayout from '@/Layouts/AppLayout.vue';

interface Profile {
    name: { ar?: string; en?: string };
    legal_name: string | null;
    currency: string;
    timezone: string;
    default_locale: string;
    tax_number: string | null;
    tax_rate: string;
    prices_include_tax: boolean;
    contact_phone: string | null;
    contact_email: string | null;
    social_links: Record<string, string>;
    lead_time_minutes: number;
    max_days_ahead: number;
    cancellation_window_minutes: number;
    no_show_fee: string;
    logo_url: string | null;
    cover_url: string | null;
    listing_enabled: boolean;
    app_code: string;
    app_link: string;
}

const props = defineProps<{ profile: Profile; timezones: string[]; canUpdate: boolean }>();
const { t } = useI18n();

const form = useForm({
    name: { ar: props.profile.name.ar ?? '', en: props.profile.name.en ?? '' },
    legal_name: props.profile.legal_name ?? '',
    timezone: props.profile.timezone,
    default_locale: props.profile.default_locale,
    tax_number: props.profile.tax_number ?? '',
    tax_rate: props.profile.tax_rate,
    prices_include_tax: props.profile.prices_include_tax,
    contact_phone: props.profile.contact_phone ?? '',
    contact_email: props.profile.contact_email ?? '',
    social_links: {
        instagram: props.profile.social_links.instagram ?? '',
        tiktok: props.profile.social_links.tiktok ?? '',
        snapchat: props.profile.social_links.snapchat ?? '',
        website: props.profile.social_links.website ?? '',
    },
    lead_time_minutes: String(props.profile.lead_time_minutes),
    max_days_ahead: String(props.profile.max_days_ahead),
    cancellation_window_minutes: String(props.profile.cancellation_window_minutes),
    no_show_fee: props.profile.no_show_fee,
    listing_enabled: props.profile.listing_enabled,
});

const save = (): void => {
    form.transform((d) => ({
        ...d,
        legal_name: d.legal_name || null,
        tax_number: d.tax_number || null,
        contact_phone: d.contact_phone || null,
        contact_email: d.contact_email || null,
        social_links: Object.fromEntries(Object.entries(d.social_links).filter(([, v]) => v)),
    })).put('/settings/salon', { preserveScroll: true });
};

const uploading = ref<'logo' | 'cover' | null>(null);
const uploadError = ref<string | null>(null);
const upload = (kind: 'logo' | 'cover', e: Event): void => {
    const file = (e.target as HTMLInputElement).files?.[0];
    if (!file) return;
    uploading.value = kind;
    uploadError.value = null;
    router.post(`/settings/salon/images/${kind}`, { image: file }, {
        forceFormData: true,
        preserveScroll: true,
        onError: (errors) => (uploadError.value = errors.image ?? null),
        onFinish: () => (uploading.value = null),
    });
};

const err = (key: string): string | undefined => (form.errors as Record<string, string>)[key];
const section = 'rounded-card border border-border bg-surface p-6 shadow-sm';
</script>

<template>
    <AppLayout :title="t('ui.settings.title')">
        <form class="mx-auto flex max-w-4xl flex-col gap-6" novalidate @submit.prevent="save">
            <header class="flex flex-wrap items-end justify-between gap-4">
                <div>
                    <h2 class="text-h2">{{ t('ui.settings.title') }}</h2>
                    <p class="mt-1 text-body text-text-secondary">{{ t('ui.settings.subtitle') }}</p>
                </div>
                <SbButton v-if="canUpdate" type="submit" :loading="form.processing" :disabled="!form.isDirty">{{ t('ui.common.save_changes') }}</SbButton>
            </header>

            <fieldset :disabled="!canUpdate" class="contents">
                <section :class="section">
                    <h3 class="text-h4">{{ t('ui.settings.brand') }}</h3>
                    <div class="mt-5 grid gap-5 sm:grid-cols-[auto_1fr]">
                        <div class="flex items-center gap-4">
                            <div class="flex h-24 w-24 items-center justify-center overflow-hidden rounded-card border border-border bg-surface-muted">
                                <img v-if="profile.logo_url" :src="profile.logo_url" :alt="t('ui.settings.logo')" class="h-full w-full object-cover" />
                                <span v-else class="font-display text-h2 text-accent" aria-hidden="true">S</span>
                            </div>
                            <label v-if="canUpdate" class="inline-flex h-10 cursor-pointer items-center gap-2 rounded-input border border-border px-3 text-label hover:bg-surface-muted">
                                <ImageUp class="h-4 w-4" aria-hidden="true" />{{ uploading === 'logo' ? t('ui.common.uploading') : t('ui.settings.change_logo') }}
                                <input type="file" accept="image/png,image/jpeg,image/webp" class="sr-only" @change="upload('logo', $event)" />
                            </label>
                        </div>
                        <div class="flex min-h-24 items-center justify-between gap-4 overflow-hidden rounded-card border border-border bg-surface-muted bg-cover bg-center px-4" :style="profile.cover_url ? { backgroundImage: `url(${profile.cover_url})` } : {}">
                            <span class="text-label text-text-secondary" :class="profile.cover_url ? 'sr-only' : ''">{{ t('ui.settings.cover') }}</span>
                            <label v-if="canUpdate" class="inline-flex h-10 cursor-pointer items-center gap-2 rounded-input border border-border bg-surface px-3 text-label hover:bg-surface-muted">
                                <ImageUp class="h-4 w-4" aria-hidden="true" />{{ uploading === 'cover' ? t('ui.common.uploading') : t('ui.settings.change_cover') }}
                                <input type="file" accept="image/png,image/jpeg,image/webp" class="sr-only" @change="upload('cover', $event)" />
                            </label>
                        </div>
                    </div>
                    <p v-if="uploadError" class="mt-2 text-caption text-error" role="alert">{{ uploadError }}</p>
                    <div class="mt-6 grid gap-5 sm:grid-cols-2">
                        <SbInput v-model="form.name.ar" :label="t('ui.settings.name_ar')" :error="err('name.ar')" required />
                        <SbInput v-model="form.name.en" :label="t('ui.settings.name_en')" :error="err('name.en')" required ltr />
                        <SbInput v-model="form.legal_name" :label="t('ui.settings.legal_name')" :error="err('legal_name')" />
                        <SbSelect
                            v-model="form.default_locale"
                            :label="t('ui.settings.default_language')"
                            :options="[{ value: 'ar', label: 'العربية' }, { value: 'en', label: 'English' }]"
                        />
                    </div>
                </section>

                <section :class="section">
                    <h3 class="text-h4">{{ t('ui.settings.contact') }}</h3>
                    <div class="mt-5 grid gap-5 sm:grid-cols-2">
                        <SbInput v-model="form.contact_phone" type="tel" :label="t('ui.settings.phone')" placeholder="+97455123456" :error="err('contact_phone')" />
                        <SbInput v-model="form.contact_email" type="email" :label="t('ui.auth.email')" :error="err('contact_email')" />
                        <SbInput v-model="form.social_links.instagram" type="url" :label="t('ui.settings.social_instagram')" :error="err('social_links.instagram')" ltr />
                        <SbInput v-model="form.social_links.tiktok" type="url" :label="t('ui.settings.social_tiktok')" :error="err('social_links.tiktok')" ltr />
                        <SbInput v-model="form.social_links.snapchat" type="url" :label="t('ui.settings.social_snapchat')" :error="err('social_links.snapchat')" ltr />
                        <SbInput v-model="form.social_links.website" type="url" :label="t('ui.settings.social_website')" :error="err('social_links.website')" ltr />
                    </div>
                </section>

                <section :class="section">
                    <h3 class="text-h4">{{ t('ui.settings.booking_policy') }}</h3>
                    <p class="mt-1 text-label text-text-secondary">{{ t('ui.settings.booking_policy_hint') }}</p>
                    <div class="mt-5 grid gap-5 sm:grid-cols-2">
                        <SbInput v-model="form.lead_time_minutes" type="number" inputmode="numeric" :label="t('ui.settings.lead_time')" :hint="t('ui.settings.minutes')" :error="err('lead_time_minutes')" ltr />
                        <SbInput v-model="form.max_days_ahead" type="number" inputmode="numeric" :label="t('ui.settings.max_days_ahead')" :hint="t('ui.settings.days')" :error="err('max_days_ahead')" ltr />
                        <SbInput v-model="form.cancellation_window_minutes" type="number" inputmode="numeric" :label="t('ui.settings.cancellation_window')" :hint="t('ui.settings.minutes')" :error="err('cancellation_window_minutes')" ltr />
                        <SbInput v-model="form.no_show_fee" inputmode="decimal" :label="t('ui.settings.no_show_fee', { currency: profile.currency })" :hint="t('ui.settings.no_show_fee_hint')" :error="err('no_show_fee')" ltr />
                    </div>
                </section>

                <section :class="section">
                    <h3 class="text-h4">{{ t('ui.settings.app_title') }}</h3>
                    <p class="mt-1 text-label text-text-secondary">{{ t('ui.settings.app_hint') }}</p>
                    <div class="mt-5 grid gap-5 sm:grid-cols-2">
                        <SbInput :model-value="profile.app_code" :label="t('ui.settings.app_code')" readonly ltr />
                        <SbInput :model-value="profile.app_link" :label="t('ui.settings.app_link')" :hint="t('ui.settings.app_link_hint')" readonly ltr />
                    </div>
                    <div class="mt-3"><SbCheckbox v-model="form.listing_enabled" :label="t('ui.settings.listing_enabled')" :description="t('ui.settings.listing_enabled_hint')" /></div>
                </section>

                <section :class="section">
                    <h3 class="text-h4">{{ t('ui.settings.tax_region') }}</h3>
                    <div class="mt-5 grid gap-5 sm:grid-cols-2">
                        <SbSelect v-model="form.timezone" :label="t('ui.settings.timezone')" :options="timezones.map((z) => ({ value: z, label: z }))" />
                        <SbInput :model-value="profile.currency" :label="t('ui.settings.currency')" :hint="t('ui.settings.currency_hint')" disabled ltr />
                        <SbInput v-model="form.tax_number" :label="t('ui.settings.tax_number')" :error="err('tax_number')" ltr />
                        <SbInput v-model="form.tax_rate" inputmode="decimal" :label="t('ui.settings.tax_rate')" :hint="t('ui.settings.tax_rate_hint')" :error="err('tax_rate')" ltr />
                    </div>
                    <div class="mt-3"><SbCheckbox v-model="form.prices_include_tax" :label="t('ui.settings.prices_include_tax')" :description="t('ui.settings.prices_include_tax_hint')" /></div>
                </section>
            </fieldset>
        </form>
    </AppLayout>
</template>
