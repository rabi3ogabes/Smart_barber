<script setup lang="ts">
import { useForm } from '@inertiajs/vue3';
import { watch } from 'vue';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbCheckbox from '@/Components/Ui/SbCheckbox.vue';
import SbChip from '@/Components/Ui/SbChip.vue';
import SbDrawer from '@/Components/Ui/SbDrawer.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import { useTr } from '@/Composables/useTr';
import type { Bundle, CatalogCan, ServiceRow } from './types';

const props = defineProps<{ bundle: Bundle | null; services: ServiceRow[]; taxClasses: string[]; currency: string; can: CatalogCan }>();
const open = defineModel<boolean>('open', { default: false });
const { t } = useI18n();
const tr = useTr();

const form = useForm({ name: { ar: '', en: '' }, description: { ar: '', en: '' }, price: '', tax_class: 'standard', is_active: true, services: [] as string[] });
watch(open, (v) => {
    if (!v) return;
    const b = props.bundle;
    form.defaults({ name: { ar: b?.name.ar ?? '', en: b?.name.en ?? '' }, description: { ar: b?.description.ar ?? '', en: b?.description.en ?? '' }, price: b?.price_decimal ?? '', tax_class: b?.tax_class ?? 'standard', is_active: b?.is_active ?? true, services: [...(b?.services ?? [])] });
    form.reset();
    form.clearErrors();
});
const toggle = (id: string): void => {
    form.services = form.services.includes(id) ? form.services.filter((x) => x !== id) : [...form.services, id];
};
const save = (): void => {
    const opts = { preserveScroll: true, onSuccess: () => (open.value = false) };
    if (props.bundle) form.put(`/service-bundles/${props.bundle.id}`, opts);
    else form.post('/service-bundles', opts);
};
const err = (k: string): string | undefined => (form.errors as Record<string, string>)[k];
</script>

<template>
    <SbDrawer v-model:open="open" :title="bundle ? tr(bundle.name) : t('ui.catalog.add_bundle')" :description="t('ui.catalog.bundle_hint')">
        <form id="bundle-form" class="flex flex-col gap-4" novalidate @submit.prevent="save">
            <SbInput v-model="form.name.ar" :label="t('ui.settings.name_ar')" :error="err('name.ar')" required />
            <SbInput v-model="form.name.en" :label="t('ui.settings.name_en')" :error="err('name.en')" required ltr />
            <SbInput v-model="form.description.ar" :label="t('ui.catalog.description_ar')" :error="err('description.ar')" />
            <SbInput v-model="form.description.en" :label="t('ui.catalog.description_en')" :error="err('description.en')" ltr />
            <div class="grid gap-4 sm:grid-cols-2">
                <SbInput v-model="form.price" inputmode="decimal" :label="t('ui.catalog.bundle_price', { currency })" :disabled="bundle !== null && !can.updatePrices" :error="err('price')" required ltr />
                <SbSelect v-model="form.tax_class" :label="t('ui.catalog.tax_class')" :options="taxClasses.map((x) => ({ value: x, label: t(`ui.catalog.tax.${x}`) }))" />
            </div>
            <p v-if="bundle?.saving" class="rounded-input bg-success-soft p-3 text-caption text-success">{{ t('ui.catalog.bundle_saving', { regular: bundle.regular_price.formatted, saving: bundle.saving.formatted }) }}</p>
            <SbCheckbox v-model="form.is_active" :label="t('ui.catalog.active')" />
            <fieldset>
                <legend class="mb-2 text-label font-medium">{{ t('ui.catalog.bundle_services') }}</legend>
                <div class="flex flex-wrap gap-2">
                    <SbChip v-for="s in services" :key="s.id" :selected="form.services.includes(s.id)" @click="toggle(s.id)">{{ tr(s.name) }}</SbChip>
                </div>
                <p v-if="err('services')" class="mt-2 text-caption text-error" role="alert">{{ err('services') }}</p>
            </fieldset>
        </form>
        <template #footer>
            <SbButton variant="secondary" @click="open = false">{{ t('ui.common.cancel') }}</SbButton>
            <SbButton type="submit" form="bundle-form" :loading="form.processing">{{ t('ui.common.save') }}</SbButton>
        </template>
    </SbDrawer>
</template>
