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
import type { Addon, CatalogCan, ServiceRow } from './types';

const props = defineProps<{ addon: Addon | null; services: ServiceRow[]; taxClasses: string[]; currency: string; can: CatalogCan }>();
const open = defineModel<boolean>('open', { default: false });
const { t } = useI18n();
const tr = useTr();

const form = useForm({ name: { ar: '', en: '' }, price: '', extra_minutes: '0', tax_class: 'standard', is_active: true, services: [] as string[] });
watch(open, (v) => {
    if (!v) return;
    const a = props.addon;
    form.defaults({ name: { ar: a?.name.ar ?? '', en: a?.name.en ?? '' }, price: a?.price_decimal ?? '', extra_minutes: String(a?.extra_minutes ?? 0), tax_class: a?.tax_class ?? 'standard', is_active: a?.is_active ?? true, services: [...(a?.services ?? [])] });
    form.reset();
    form.clearErrors();
});
const toggle = (id: string): void => {
    form.services = form.services.includes(id) ? form.services.filter((x) => x !== id) : [...form.services, id];
};
const save = (): void => {
    const opts = { preserveScroll: true, onSuccess: () => (open.value = false) };
    if (props.addon) form.put(`/service-addons/${props.addon.id}`, opts);
    else form.post('/service-addons', opts);
};
const err = (k: string): string | undefined => (form.errors as Record<string, string>)[k];
</script>

<template>
    <SbDrawer v-model:open="open" :title="addon ? tr(addon.name) : t('ui.catalog.add_addon')">
        <form id="addon-form" class="flex flex-col gap-4" novalidate @submit.prevent="save">
            <SbInput v-model="form.name.ar" :label="t('ui.settings.name_ar')" :error="err('name.ar')" required />
            <SbInput v-model="form.name.en" :label="t('ui.settings.name_en')" :error="err('name.en')" required ltr />
            <div class="grid gap-4 sm:grid-cols-2">
                <SbInput v-model="form.price" inputmode="decimal" :label="t('ui.catalog.price', { currency })" :disabled="addon !== null && !can.updatePrices" :error="err('price')" required ltr />
                <SbInput v-model="form.extra_minutes" inputmode="numeric" :label="t('ui.catalog.extra_minutes')" :error="err('extra_minutes')" ltr />
            </div>
            <SbSelect v-model="form.tax_class" :label="t('ui.catalog.tax_class')" :options="taxClasses.map((x) => ({ value: x, label: t(`ui.catalog.tax.${x}`) }))" />
            <SbCheckbox v-model="form.is_active" :label="t('ui.catalog.active')" />
            <fieldset>
                <legend class="mb-2 text-label font-medium">{{ t('ui.catalog.addon_services') }}</legend>
                <div class="flex flex-wrap gap-2">
                    <SbChip v-for="s in services" :key="s.id" :selected="form.services.includes(s.id)" @click="toggle(s.id)">{{ tr(s.name) }}</SbChip>
                </div>
            </fieldset>
        </form>
        <template #footer>
            <SbButton variant="secondary" @click="open = false">{{ t('ui.common.cancel') }}</SbButton>
            <SbButton type="submit" form="addon-form" :loading="form.processing">{{ t('ui.common.save') }}</SbButton>
        </template>
    </SbDrawer>
</template>
