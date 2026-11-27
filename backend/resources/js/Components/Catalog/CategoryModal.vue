<script setup lang="ts">
import { useForm } from '@inertiajs/vue3';
import { watch } from 'vue';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbCheckbox from '@/Components/Ui/SbCheckbox.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbModal from '@/Components/Ui/SbModal.vue';
import CategoryIcon from './CategoryIcon.vue';
import type { Category } from './types';

const props = defineProps<{ category: Category | null; icons: string[] }>();
const open = defineModel<boolean>('open', { default: false });
const { t } = useI18n();

const form = useForm({ name: { ar: '', en: '' }, icon: 'scissors' as string | null, is_active: true });
watch(open, (v) => {
    if (!v) return;
    form.defaults({ name: { ar: props.category?.name.ar ?? '', en: props.category?.name.en ?? '' }, icon: props.category?.icon ?? 'scissors', is_active: props.category?.is_active ?? true });
    form.reset();
    form.clearErrors();
});
const save = (): void => {
    const opts = { preserveScroll: true, onSuccess: () => (open.value = false) };
    if (props.category) form.put(`/service-categories/${props.category.id}`, opts);
    else form.post('/service-categories', opts);
};
</script>

<template>
    <SbModal v-model:open="open" :title="category ? t('ui.catalog.edit_category') : t('ui.catalog.add_category')" size="sm">
        <form id="category-form" class="flex flex-col gap-4" novalidate @submit.prevent="save">
            <SbInput v-model="form.name.ar" :label="t('ui.settings.name_ar')" :error="form.errors['name.ar' as keyof typeof form.errors]" required />
            <SbInput v-model="form.name.en" :label="t('ui.settings.name_en')" :error="form.errors['name.en' as keyof typeof form.errors]" required ltr />
            <fieldset>
                <legend class="mb-2 text-label font-medium">{{ t('ui.catalog.icon') }}</legend>
                <div class="flex flex-wrap gap-2" role="radiogroup">
                    <button
                        v-for="i in icons"
                        :key="i"
                        type="button"
                        role="radio"
                        :aria-checked="form.icon === i"
                        :aria-label="i"
                        class="inline-flex h-10 w-10 items-center justify-center rounded-input border"
                        :class="form.icon === i ? 'border-primary bg-primary text-on-primary' : 'border-border hover:bg-surface-muted'"
                        @click="form.icon = i"
                    >
                        <CategoryIcon :name="i" class="h-5 w-5" />
                    </button>
                </div>
            </fieldset>
            <SbCheckbox v-model="form.is_active" :label="t('ui.catalog.active')" :description="t('ui.catalog.category_active_hint')" />
        </form>
        <template #footer>
            <SbButton variant="secondary" @click="open = false">{{ t('ui.common.cancel') }}</SbButton>
            <SbButton type="submit" form="category-form" :loading="form.processing">{{ t('ui.common.save') }}</SbButton>
        </template>
    </SbModal>
</template>
