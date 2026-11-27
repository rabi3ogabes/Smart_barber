<script setup lang="ts">
import { router, useForm } from '@inertiajs/vue3';
import { ImagePlus } from 'lucide-vue-next';
import { computed, ref, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import ImageCropper from '@/Components/Domain/ImageCropper.vue';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbCheckbox from '@/Components/Ui/SbCheckbox.vue';
import SbChip from '@/Components/Ui/SbChip.vue';
import SbDrawer from '@/Components/Ui/SbDrawer.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import SbTabs from '@/Components/Ui/SbTabs.vue';
import SbTextarea from '@/Components/Ui/SbTextarea.vue';
import { useTr } from '@/Composables/useTr';
import type { Addon, BarberOpt, BranchOpt, CatalogCan, Category, ServiceRow } from './types';

const props = defineProps<{
    service: ServiceRow | null;
    defaultCategory: string | null;
    categories: Category[];
    addons: Addon[];
    branches: BranchOpt[];
    barbers: BarberOpt[];
    taxClasses: string[];
    currency: string;
    can: CatalogCan;
}>();
const open = defineModel<boolean>('open', { default: false });
const { t } = useI18n();
const tr = useTr();

const tab = ref('details');
const isNew = computed(() => props.service === null);
const tabs = computed(() =>
    isNew.value
        ? [{ value: 'details', label: t('ui.catalog.tab_details') }]
        : [
              { value: 'details', label: t('ui.catalog.tab_details') },
              { value: 'pricing', label: t('ui.catalog.tab_pricing') },
              { value: 'barbers', label: t('ui.catalog.tab_barbers') },
              { value: 'addons', label: t('ui.catalog.tab_addons') },
          ],
);

// Details
const form = useForm({
    category: '',
    name: { ar: '', en: '' },
    description: { ar: '', en: '' } as { ar: string | null; en: string | null },
    base_price: '',
    duration_minutes: '30',
    buffer_minutes: '0',
    tax_class: 'standard',
    is_active: true,
    is_bookable_online: true,
});
const reset = (): void => {
    const s = props.service;
    form.defaults({
        category: s?.category ?? props.defaultCategory ?? props.categories[0]?.id ?? '',
        name: { ar: s?.name.ar ?? '', en: s?.name.en ?? '' },
        description: { ar: s?.description.ar ?? '', en: s?.description.en ?? '' },
        base_price: s?.base_price ?? '',
        duration_minutes: String(s?.duration_minutes ?? 30),
        buffer_minutes: String(s?.buffer_minutes ?? 0),
        tax_class: s?.tax_class ?? 'standard',
        is_active: s?.is_active ?? true,
        is_bookable_online: s?.is_bookable_online ?? true,
    });
    form.reset();
    form.clearErrors();
    tab.value = 'details';
    branchRows.value = props.branches.map((b) => {
        const row = s?.branches.find((r) => r.branch === b.id);
        return { branch: b.id, name: b.name, can: b.can_price, is_available: row?.is_available ?? true, price_override: row?.price_override ?? '', saving: false, error: '' };
    });
    barberRows.value = props.barbers.map((b) => {
        const row = s?.barbers.find((r) => r.barber === b.id);
        return { barber: b.id, name: b.name, performs: Boolean(row), price_override: row?.price_override ?? '', duration_override: row?.duration_override ? String(row.duration_override) : '' };
    });
    addonIds.value = [...(s?.addons ?? [])];
};
watch(open, (v) => v && reset());

const priceLocked = computed(() => !isNew.value && !props.can.updatePrices);
const saveDetails = (): void => {
    const opts = { preserveScroll: true, onSuccess: () => isNew.value && (open.value = false) };
    form.transform((d) => ({ ...d, buffer_minutes: d.buffer_minutes || 0 }));
    if (props.service) form.put(`/services/${props.service.id}`, opts);
    else form.post('/services', opts);
};
const err = (k: string): string | undefined => (form.errors as Record<string, string>)[k];

// Image
const cropper = ref<InstanceType<typeof ImageCropper> | null>(null);
const uploading = ref(false);
const imageError = ref('');
const upload = (blob: Blob): void => {
    if (!props.service) return;
    uploading.value = true;
    imageError.value = '';
    router.post(`/services/${props.service.id}/image`, { image: new File([blob], 'service.jpg', { type: 'image/jpeg' }) }, {
        forceFormData: true,
        preserveScroll: true,
        onError: (e) => (imageError.value = e.image ?? ''),
        onFinish: () => (uploading.value = false),
    });
};

// Pricing per branch
const branchRows = ref<{ branch: string; name: string; can: boolean; is_available: boolean; price_override: string; saving: boolean; error: string }[]>([]);
const saveBranch = (row: (typeof branchRows.value)[number]): void => {
    if (!props.service) return;
    row.saving = true;
    row.error = '';
    router.put(`/services/${props.service.id}/branches/${row.branch}`, { is_available: row.is_available, price_override: row.price_override || null }, {
        preserveScroll: true,
        onError: (e) => (row.error = e.price_override ?? e.general ?? ''),
        onFinish: () => (row.saving = false),
    });
};

// Barbers
const barberRows = ref<{ barber: string; name: string; performs: boolean; price_override: string; duration_override: string }[]>([]);
const barberForm = useForm({ barbers: [] as { barber: string; price_override: string | null; duration_override: string | null }[] });
const saveBarbers = (): void => {
    if (!props.service) return;
    barberForm.barbers = barberRows.value
        .filter((r) => r.performs)
        .map((r) => ({ barber: r.barber, price_override: r.price_override || null, duration_override: r.duration_override || null }));
    barberForm.put(`/services/${props.service.id}/barbers`, { preserveScroll: true });
};

// Add-ons
const addonIds = ref<string[]>([]);
const addonsSaving = ref(false);
const toggleAddon = (id: string): void => {
    addonIds.value = addonIds.value.includes(id) ? addonIds.value.filter((x) => x !== id) : [...addonIds.value, id];
};
const saveAddons = (): void => {
    if (!props.service) return;
    addonsSaving.value = true;
    router.put(`/services/${props.service.id}/addons`, { addons: addonIds.value }, { preserveScroll: true, onFinish: () => (addonsSaving.value = false) });
};
</script>

<template>
    <SbDrawer v-model:open="open" :title="service ? tr(service.name) : t('ui.catalog.add_service')" size="lg">
        <SbTabs v-model="tab" :tabs="tabs">
            <template #details>
                <form id="service-form" class="flex flex-col gap-5" novalidate @submit.prevent="saveDetails">
                    <div v-if="service" class="flex items-center gap-4">
                        <div class="flex aspect-[4/3] w-40 items-center justify-center overflow-hidden rounded-card border border-border bg-surface-muted">
                            <img v-if="service.image_url" :src="service.image_url" :alt="tr(service.name)" class="h-full w-full object-cover" />
                            <ImagePlus v-else class="h-6 w-6 text-text-secondary" aria-hidden="true" />
                        </div>
                        <div class="flex flex-col gap-1">
                            <SbButton v-if="can.manage" size="sm" variant="secondary" :loading="uploading" @click="cropper?.pick()">{{ t('ui.catalog.change_image') }}</SbButton>
                            <p class="text-caption text-text-secondary">{{ t('ui.catalog.image_hint') }}</p>
                            <p v-if="imageError" class="text-caption text-error" role="alert">{{ imageError }}</p>
                        </div>
                        <ImageCropper ref="cropper" :busy="uploading" @cropped="upload" />
                    </div>
                    <p v-else class="rounded-input bg-surface-muted p-3 text-caption text-text-secondary">{{ t('ui.catalog.image_after_save') }}</p>

                    <fieldset :disabled="!can.manage" class="contents">
                        <div class="grid gap-4 sm:grid-cols-2">
                            <SbInput v-model="form.name.ar" :label="t('ui.settings.name_ar')" :error="err('name.ar')" required />
                            <SbInput v-model="form.name.en" :label="t('ui.settings.name_en')" :error="err('name.en')" required ltr />
                            <SbSelect v-model="form.category" :label="t('ui.catalog.category')" :options="categories.map((c) => ({ value: c.id, label: tr(c.name) }))" :error="err('category')" />
                            <SbSelect v-model="form.tax_class" :label="t('ui.catalog.tax_class')" :options="taxClasses.map((x) => ({ value: x, label: t(`ui.catalog.tax.${x}`) }))" />
                            <SbInput
                                v-model="form.base_price"
                                inputmode="decimal"
                                :label="t('ui.catalog.base_price', { currency })"
                                :hint="priceLocked ? t('ui.catalog.price_locked') : undefined"
                                :disabled="priceLocked"
                                :error="err('base_price')"
                                required
                                ltr
                            />
                            <SbInput v-model="form.duration_minutes" inputmode="numeric" :label="t('ui.catalog.duration')" :hint="t('ui.settings.minutes')" :error="err('duration_minutes')" required ltr />
                            <SbInput v-model="form.buffer_minutes" inputmode="numeric" :label="t('ui.catalog.buffer')" :hint="t('ui.catalog.buffer_hint')" :error="err('buffer_minutes')" ltr />
                        </div>
                        <SbTextarea v-model="form.description.ar" :label="t('ui.catalog.description_ar')" :rows="2" :maxlength="1000" :error="err('description.ar')" />
                        <SbTextarea v-model="form.description.en" :label="t('ui.catalog.description_en')" :rows="2" :maxlength="1000" :error="err('description.en')" />
                        <SbCheckbox v-model="form.is_active" :label="t('ui.catalog.active')" :description="t('ui.catalog.active_hint')" />
                        <SbCheckbox v-model="form.is_bookable_online" :label="t('ui.catalog.bookable_online')" :description="t('ui.catalog.bookable_online_hint')" />
                    </fieldset>
                    <p v-if="err('general')" class="text-caption text-error" role="alert">{{ err('general') }}</p>
                </form>
            </template>

            <template #pricing>
                <p class="mb-4 text-label text-text-secondary">{{ t('ui.catalog.pricing_hint', { price: service?.price.formatted ?? '' }) }}</p>
                <p v-if="branchRows.length === 0" class="text-label text-text-secondary">{{ t('ui.catalog.no_branches') }}</p>
                <ul class="flex flex-col divide-y divide-border rounded-card border border-border">
                    <li v-for="row in branchRows" :key="row.branch" class="flex flex-wrap items-end gap-3 p-4">
                        <div class="min-w-40 flex-1">
                            <p class="font-medium">{{ row.name }}</p>
                            <SbCheckbox v-model="row.is_available" :label="t('ui.catalog.available_here')" :disabled="!row.can" />
                        </div>
                        <div class="w-40">
                            <SbInput v-model="row.price_override" inputmode="decimal" :label="t('ui.catalog.branch_price', { currency })" :placeholder="service?.base_price ?? ''" :disabled="!row.can || !row.is_available" :error="row.error || undefined" ltr />
                        </div>
                        <SbButton v-if="row.can" size="sm" variant="secondary" :loading="row.saving" @click="saveBranch(row)">{{ t('ui.common.save') }}</SbButton>
                    </li>
                </ul>
            </template>

            <template #barbers>
                <p class="mb-4 text-label text-text-secondary">{{ t('ui.catalog.barbers_hint') }}</p>
                <p v-if="barberRows.length === 0" class="text-label text-text-secondary">{{ t('ui.catalog.no_barbers') }}</p>
                <ul class="flex flex-col divide-y divide-border rounded-card border border-border">
                    <li v-for="row in barberRows" :key="row.barber" class="flex flex-wrap items-end gap-3 p-4">
                        <div class="min-w-40 flex-1"><SbCheckbox v-model="row.performs" :label="row.name" :disabled="!can.manage" /></div>
                        <div class="w-36">
                            <SbInput v-model="row.price_override" inputmode="decimal" :label="t('ui.catalog.own_price', { currency })" :placeholder="t('ui.catalog.same_price')" :disabled="!row.performs || !can.updatePrices" ltr />
                        </div>
                        <div class="w-32">
                            <SbInput v-model="row.duration_override" inputmode="numeric" :label="t('ui.catalog.own_duration')" :placeholder="String(service?.duration_minutes ?? '')" :disabled="!row.performs || !can.manage" ltr />
                        </div>
                    </li>
                </ul>
                <p v-for="(e, k) in barberForm.errors" :key="k" class="mt-2 text-caption text-error" role="alert">{{ e }}</p>
                <SbButton v-if="can.manage && barberRows.length" class="mt-4" :loading="barberForm.processing" @click="saveBarbers">{{ t('ui.common.save') }}</SbButton>
            </template>

            <template #addons>
                <p class="mb-4 text-label text-text-secondary">{{ t('ui.catalog.addons_hint') }}</p>
                <p v-if="addons.length === 0" class="text-label text-text-secondary">{{ t('ui.catalog.no_addons') }}</p>
                <div class="flex flex-wrap gap-2">
                    <SbChip v-for="a in addons" :key="a.id" :selected="addonIds.includes(a.id)" :disabled="!can.manage" @click="toggleAddon(a.id)">
                        {{ tr(a.name) }} · <span dir="ltr">{{ a.price.formatted }}</span>
                    </SbChip>
                </div>
                <SbButton v-if="can.manage && addons.length" class="mt-4" :loading="addonsSaving" @click="saveAddons">{{ t('ui.common.save') }}</SbButton>
            </template>
        </SbTabs>

        <template v-if="tab === 'details' && can.manage" #footer>
            <SbButton variant="secondary" @click="open = false">{{ t('ui.common.cancel') }}</SbButton>
            <SbButton type="submit" form="service-form" :loading="form.processing">{{ t('ui.common.save') }}</SbButton>
        </template>
    </SbDrawer>
</template>
