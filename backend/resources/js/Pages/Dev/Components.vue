<script setup lang="ts">
import { Plus, Scissors } from 'lucide-vue-next';
import { ref } from 'vue';
import { useI18n } from 'vue-i18n';
import SbBadge from '@/Components/Ui/SbBadge.vue';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbChip from '@/Components/Ui/SbChip.vue';
import SbCombobox from '@/Components/Ui/SbCombobox.vue';
import SbConfirmDialog from '@/Components/Ui/SbConfirmDialog.vue';
import SbDataTable from '@/Components/Ui/SbDataTable.vue';
import SbDrawer from '@/Components/Ui/SbDrawer.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import SbErrorState from '@/Components/Ui/SbErrorState.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbModal from '@/Components/Ui/SbModal.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import SbSheet from '@/Components/Ui/SbSheet.vue';
import SbSkeleton from '@/Components/Ui/SbSkeleton.vue';
import SbTabs from '@/Components/Ui/SbTabs.vue';
import { useTheme } from '@/Composables/useTheme';
import { useToast } from '@/Composables/useToast';
import { i18n } from '@/i18n';
import AppLayout from '@/Layouts/AppLayout.vue';

/**
 * Component gallery (local and staging only). The language toggle switches locale and
 * direction in place so both versions can be reviewed and screenshotted quickly.
 */
const { t } = useI18n();
const { push } = useToast();
const { theme, setTheme } = useTheme();

const setPreviewLocale = (locale: 'ar' | 'en'): void => {
    i18n.global.locale.value = locale;
    document.documentElement.lang = locale;
    document.documentElement.dir = locale === 'ar' ? 'rtl' : 'ltr';
};

const name = ref('');
const phone = ref('+974 5512 3456');
const barber = ref<string>();
const service = ref<string>();
const tab = ref('details');
const chips = ref(['fade']);
const modal = ref(false);
const drawer = ref(false);
const sheet = ref(false);
const confirm = ref(false);
const tableState = ref<'data' | 'loading' | 'empty' | 'error'>('data');

const barbers = [
    { value: 'b1', label: 'Yousef' },
    { value: 'b2', label: 'Omar' },
    { value: 'b3', label: 'Karim' },
];
const sample = [
    { id: '1', service: 'Fade', barber: 'Yousef', time: '10:30', price: 'QAR 80.00' },
    { id: '2', service: 'Beard trim', barber: 'Omar', time: '11:15', price: 'QAR 45.00' },
];
const toggleChip = (key: string): void => {
    chips.value = chips.value.includes(key) ? chips.value.filter((c) => c !== key) : [...chips.value, key];
};
</script>

<template>
    <AppLayout :title="t('ui.dev.title')">
        <div class="mx-auto flex max-w-5xl flex-col gap-10">
            <div class="sticky top-[calc(var(--sb-header-height)+0.5rem)] z-20 flex flex-wrap items-center gap-2 rounded-card border border-border bg-surface/95 p-3 shadow-sm backdrop-blur">
                <span class="text-label font-semibold">{{ t('ui.dev.preview') }}</span>
                <SbButton size="sm" variant="secondary" @click="setPreviewLocale('ar')">العربية</SbButton>
                <SbButton size="sm" variant="secondary" @click="setPreviewLocale('en')">English</SbButton>
                <span class="mx-2 h-5 w-px bg-border" aria-hidden="true"></span>
                <SbButton size="sm" :variant="theme === 'light' ? 'primary' : 'secondary'" @click="setTheme('light')">{{ t('ui.theme.light') }}</SbButton>
                <SbButton size="sm" :variant="theme === 'dark' ? 'primary' : 'secondary'" @click="setTheme('dark')">{{ t('ui.theme.dark') }}</SbButton>
            </div>

            <section class="flex flex-col gap-4">
                <h2 class="text-h3">{{ t('ui.dev.buttons') }}</h2>
                <div class="flex flex-wrap items-center gap-3">
                    <SbButton>{{ t('ui.dev.primary') }}</SbButton>
                    <SbButton variant="accent">{{ t('ui.dev.accent') }}</SbButton>
                    <SbButton variant="secondary">{{ t('ui.dev.secondary') }}</SbButton>
                    <SbButton variant="ghost">{{ t('ui.dev.ghost') }}</SbButton>
                    <SbButton variant="danger">{{ t('ui.dev.danger') }}</SbButton>
                    <SbButton loading>{{ t('ui.common.save') }}</SbButton>
                    <SbButton disabled>{{ t('ui.dev.disabled') }}</SbButton>
                    <SbButton size="sm"><template #icon><Plus class="h-4 w-4" aria-hidden="true" /></template>{{ t('ui.dev.small') }}</SbButton>
                    <SbButton icon-only variant="secondary" :label="t('ui.dev.icon_button')"><template #icon><Scissors class="h-5 w-5" aria-hidden="true" /></template></SbButton>
                </div>
            </section>

            <section class="grid gap-5 sm:grid-cols-2">
                <h2 class="text-h3 sm:col-span-2">{{ t('ui.dev.inputs') }}</h2>
                <SbInput v-model="name" :label="t('ui.dev.name')" :placeholder="t('ui.dev.name_placeholder')" :hint="t('ui.dev.hint')" />
                <SbInput v-model="phone" type="tel" :label="t('ui.dev.phone')" />
                <SbInput model-value="" :label="t('ui.dev.with_error')" :error="t('ui.dev.error_text')" />
                <SbInput model-value="" :label="t('ui.dev.disabled')" disabled />
                <SbSelect v-model="barber" :options="barbers" :label="t('ui.dev.select')" :placeholder="t('ui.dev.select_placeholder')" />
                <SbCombobox v-model="service" :options="barbers" :label="t('ui.dev.combobox')" :placeholder="t('ui.dev.search_placeholder')" />
            </section>

            <section class="flex flex-col gap-4">
                <h2 class="text-h3">{{ t('ui.dev.badges_chips') }}</h2>
                <div class="flex flex-wrap gap-2">
                    <SbBadge>{{ t('ui.dev.neutral') }}</SbBadge>
                    <SbBadge tone="accent" dot>{{ t('ui.dev.accent') }}</SbBadge>
                    <SbBadge tone="success" dot>{{ t('ui.dev.confirmed') }}</SbBadge>
                    <SbBadge tone="warning" dot>{{ t('ui.dev.pending') }}</SbBadge>
                    <SbBadge tone="error" dot>{{ t('ui.dev.cancelled') }}</SbBadge>
                    <SbBadge tone="info" dot>{{ t('ui.dev.info') }}</SbBadge>
                </div>
                <div class="flex flex-wrap gap-2">
                    <SbChip v-for="c in ['fade', 'crop', 'classic']" :key="c" :selected="chips.includes(c)" @click="toggleChip(c)">{{ t(`ui.dev.style_${c}`) }}</SbChip>
                    <SbChip removable>{{ t('ui.dev.removable') }}</SbChip>
                </div>
            </section>

            <section class="flex flex-col gap-4">
                <h2 class="text-h3">{{ t('ui.dev.overlays') }}</h2>
                <div class="flex flex-wrap gap-3">
                    <SbButton variant="secondary" @click="modal = true">{{ t('ui.dev.open_modal') }}</SbButton>
                    <SbButton variant="secondary" @click="drawer = true">{{ t('ui.dev.open_drawer') }}</SbButton>
                    <SbButton variant="secondary" @click="sheet = true">{{ t('ui.dev.open_sheet') }}</SbButton>
                    <SbButton variant="danger" @click="confirm = true">{{ t('ui.dev.open_confirm') }}</SbButton>
                    <SbButton variant="secondary" @click="push(t('ui.dev.toast_title'), 'success', t('ui.dev.toast_body'))">{{ t('ui.dev.show_toast') }}</SbButton>
                </div>
                <SbModal v-model:open="modal" :title="t('ui.dev.modal_title')" :description="t('ui.dev.modal_body')">
                    <p class="text-body text-text-secondary">{{ t('ui.dev.modal_content') }}</p>
                    <template #footer><SbButton variant="secondary" @click="modal = false">{{ t('ui.common.cancel') }}</SbButton><SbButton @click="modal = false">{{ t('ui.common.save') }}</SbButton></template>
                </SbModal>
                <SbDrawer v-model:open="drawer" :title="t('ui.dev.drawer_title')" :description="t('ui.dev.drawer_body')">
                    <div class="flex flex-col gap-4"><SbInput v-model="name" :label="t('ui.dev.name')" /><SbSelect v-model="barber" :options="barbers" :label="t('ui.dev.select')" /></div>
                    <template #footer><SbButton @click="drawer = false">{{ t('ui.common.save') }}</SbButton></template>
                </SbDrawer>
                <SbSheet v-model:open="sheet" :title="t('ui.dev.sheet_title')">
                    <p class="text-body text-text-secondary">{{ t('ui.dev.modal_content') }}</p>
                </SbSheet>
                <SbConfirmDialog v-model:open="confirm" :title="t('ui.dev.confirm_title')" :description="t('ui.dev.confirm_body')" :confirm-label="t('ui.dev.confirm_action')" danger />
            </section>

            <section class="flex flex-col gap-4">
                <h2 class="text-h3">{{ t('ui.dev.tabs') }}</h2>
                <SbTabs v-model="tab" :tabs="[{ value: 'details', label: t('ui.dev.tab_details') }, { value: 'pricing', label: t('ui.dev.tab_pricing') }, { value: 'barbers', label: t('ui.dev.tab_barbers') }]">
                    <template #details><p class="text-body text-text-secondary">{{ t('ui.dev.tab_details') }}</p></template>
                    <template #pricing><p class="text-body text-text-secondary">{{ t('ui.dev.tab_pricing') }}</p></template>
                    <template #barbers><p class="text-body text-text-secondary">{{ t('ui.dev.tab_barbers') }}</p></template>
                </SbTabs>
            </section>

            <section class="flex flex-col gap-4">
                <div class="flex flex-wrap items-center justify-between gap-3">
                    <h2 class="text-h3">{{ t('ui.dev.table') }}</h2>
                    <div class="flex flex-wrap gap-2">
                        <SbChip v-for="s in ['data', 'loading', 'empty', 'error'] as const" :key="s" :selected="tableState === s" @click="tableState = s">{{ t(`ui.dev.state_${s}`) }}</SbChip>
                    </div>
                </div>
                <SbDataTable
                    row-key="id"
                    :rows="tableState === 'data' ? sample : []"
                    :loading="tableState === 'loading'"
                    :error="tableState === 'error'"
                    :empty-title="t('ui.dev.empty_title')"
                    :empty-description="t('ui.dev.empty_body')"
                    :columns="[
                        { key: 'service', label: t('ui.dev.col_service') },
                        { key: 'barber', label: t('ui.dev.col_barber') },
                        { key: 'time', label: t('ui.dev.col_time'), numeric: true },
                        { key: 'price', label: t('ui.dev.col_price'), numeric: true },
                    ]"
                    @retry="tableState = 'data'"
                />
            </section>

            <section class="grid gap-4 md:grid-cols-3">
                <h2 class="text-h3 md:col-span-3">{{ t('ui.dev.states') }}</h2>
                <div class="rounded-card border border-border bg-surface p-5"><SbSkeleton :lines="4" /></div>
                <div class="rounded-card border border-border bg-surface"><SbEmptyState :title="t('ui.dev.empty_title')" :description="t('ui.dev.empty_body')" /></div>
                <div class="rounded-card border border-border bg-surface"><SbErrorState /></div>
            </section>
        </div>
    </AppLayout>
</template>
