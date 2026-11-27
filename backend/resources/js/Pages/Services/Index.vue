<script setup lang="ts">
import { router } from '@inertiajs/vue3';
import { ChevronDown, ChevronUp, GripVertical, Package, Pencil, Plus, Scissors, Sparkles, Trash2 } from 'lucide-vue-next';
import { computed, ref, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import AddonDrawer from '@/Components/Catalog/AddonDrawer.vue';
import BundleDrawer from '@/Components/Catalog/BundleDrawer.vue';
import CategoryIcon from '@/Components/Catalog/CategoryIcon.vue';
import CategoryModal from '@/Components/Catalog/CategoryModal.vue';
import ServiceDrawer from '@/Components/Catalog/ServiceDrawer.vue';
import type { Addon, BarberOpt, BranchOpt, Bundle, CatalogCan, Category, ServiceRow } from '@/Components/Catalog/types';
import SbBadge from '@/Components/Ui/SbBadge.vue';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbConfirmDialog from '@/Components/Ui/SbConfirmDialog.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbTabs from '@/Components/Ui/SbTabs.vue';
import { useTr } from '@/Composables/useTr';
import AppLayout from '@/Layouts/AppLayout.vue';

const props = defineProps<{
    currency: string;
    categories: Category[];
    services: ServiceRow[];
    addons: Addon[];
    bundles: Bundle[];
    branches: BranchOpt[];
    barbers: BarberOpt[];
    taxClasses: string[];
    icons: string[];
    can: CatalogCan;
}>();
const { t } = useI18n();
const tr = useTr();

const tab = ref('services');
const tabs = computed(() => [
    { value: 'services', label: `${t('ui.catalog.tab_services')} · ${props.services.length}` },
    { value: 'addons', label: `${t('ui.catalog.tab_addons')} · ${props.addons.length}` },
    { value: 'bundles', label: `${t('ui.catalog.tab_bundles')} · ${props.bundles.length}` },
]);

// Categories: local order for optimistic drag/keyboard reordering, saved on drop.
const order = ref<Category[]>([...props.categories]);
watch(() => props.categories, (v) => (order.value = [...v]));
const selected = ref<string | null>(null);
const dragging = ref<number | null>(null);
const saveOrder = (): void => router.put('/service-categories/order', { order: order.value.map((c) => c.id) }, { preserveScroll: true, preserveState: true });
const move = (from: number, to: number): void => {
    if (to < 0 || to >= order.value.length || from === to) return;
    const list = [...order.value];
    const [item] = list.splice(from, 1);
    if (item) list.splice(to, 0, item);
    order.value = list;
};
const onDrop = (to: number): void => {
    if (dragging.value === null) return;
    move(dragging.value, to);
    dragging.value = null;
    saveOrder();
};
const moveBy = (i: number, delta: number): void => {
    move(i, i + delta);
    saveOrder();
};

const categoryOpen = ref(false);
const editingCategory = ref<Category | null>(null);
const openCategory = (c: Category | null): void => {
    editingCategory.value = c;
    categoryOpen.value = true;
};
const deleting = ref<Category | null>(null);
const confirmDelete = (): void => {
    if (deleting.value) router.delete(`/service-categories/${deleting.value.id}`, { preserveScroll: true, onFinish: () => (deleting.value = null) });
};

// Services
const search = ref('');
const visibleServices = computed(() => {
    const q = search.value.trim().toLowerCase();
    return props.services
        .filter((s) => selected.value === null || s.category === selected.value)
        .filter((s) => !q || [s.name.ar, s.name.en].some((n) => n?.toLowerCase().includes(q)));
});
const categoryName = (id: string | null): string => tr(props.categories.find((c) => c.id === id)?.name);
const serviceOpen = ref(false);
const editingServiceId = ref<string | null>(null);
const editingService = computed(() => props.services.find((s) => s.id === editingServiceId.value) ?? null);
const openService = (s: ServiceRow | null): void => {
    editingServiceId.value = s?.id ?? null;
    serviceOpen.value = true;
};
const branchOverrides = (s: ServiceRow): number => s.branches.filter((b) => b.price_override !== null || !b.is_available).length;

// Add-ons and bundles
const addonOpen = ref(false);
const editingAddon = ref<Addon | null>(null);
const openAddon = (a: Addon | null): void => {
    editingAddon.value = a;
    addonOpen.value = true;
};
const bundleOpen = ref(false);
const editingBundle = ref<Bundle | null>(null);
const openBundle = (b: Bundle | null): void => {
    editingBundle.value = b;
    bundleOpen.value = true;
};
const serviceNames = (ids: string[]): string => ids.map((id) => tr(props.services.find((s) => s.id === id)?.name)).filter(Boolean).join(' + ');
const minutes = (m: number): string => t('ui.catalog.minutes_short', { m });
</script>

<template>
    <AppLayout :title="t('nav.services')">
        <div class="mx-auto flex max-w-7xl flex-col gap-6">
            <header class="flex flex-wrap items-end justify-between gap-4">
                <div>
                    <h2 class="text-h2">{{ t('nav.services') }}</h2>
                    <p class="mt-1 text-body text-text-secondary">{{ t('ui.catalog.subtitle') }}</p>
                </div>
                <div v-if="can.manage" class="flex gap-2">
                    <SbButton v-if="tab === 'services'" :disabled="categories.length === 0" @click="openService(null)">
                        <template #icon><Plus class="h-4 w-4" aria-hidden="true" /></template>{{ t('ui.catalog.add_service') }}
                    </SbButton>
                    <SbButton v-else-if="tab === 'addons'" @click="openAddon(null)">
                        <template #icon><Plus class="h-4 w-4" aria-hidden="true" /></template>{{ t('ui.catalog.add_addon') }}
                    </SbButton>
                    <SbButton v-else :disabled="services.length < 2" @click="openBundle(null)">
                        <template #icon><Plus class="h-4 w-4" aria-hidden="true" /></template>{{ t('ui.catalog.add_bundle') }}
                    </SbButton>
                </div>
            </header>

            <SbTabs v-model="tab" :tabs="tabs">
                <template #services>
                    <div class="grid gap-6 lg:grid-cols-[20rem_1fr]">
                        <!-- Categories -->
                        <aside class="flex flex-col gap-2 self-start rounded-card border border-border bg-surface p-3 shadow-sm">
                            <div class="flex items-center justify-between px-2 py-1">
                                <h3 class="text-label font-semibold">{{ t('ui.catalog.categories') }}</h3>
                                <button v-if="can.manage" type="button" class="text-label font-medium text-accent hover:underline" @click="openCategory(null)">{{ t('ui.catalog.add_category') }}</button>
                            </div>
                            <button type="button" class="flex items-center justify-between rounded-input px-3 py-2 text-start text-label" :class="selected === null ? 'bg-accent-soft font-semibold text-accent' : 'hover:bg-surface-muted'" @click="selected = null">
                                {{ t('ui.catalog.all_services') }} <span class="tabular">{{ services.length }}</span>
                            </button>
                            <p v-if="order.length === 0" class="px-3 py-2 text-caption text-text-secondary">{{ t('ui.catalog.no_categories') }}</p>
                            <ul class="flex flex-col gap-1" :aria-label="t('ui.catalog.categories')">
                                <li
                                    v-for="(c, i) in order"
                                    :key="c.id"
                                    class="group flex items-center gap-1 rounded-input"
                                    :class="[selected === c.id ? 'bg-accent-soft' : 'hover:bg-surface-muted', dragging === i ? 'opacity-50' : '']"
                                    :draggable="can.manage"
                                    @dragstart="dragging = i"
                                    @dragend="dragging = null"
                                    @dragover.prevent
                                    @drop.prevent="onDrop(i)"
                                >
                                    <GripVertical v-if="can.manage" class="h-4 w-4 shrink-0 cursor-grab text-text-secondary" aria-hidden="true" />
                                    <button type="button" class="flex min-w-0 flex-1 items-center gap-2 py-2 ps-2 text-start text-label" :class="selected === c.id ? 'font-semibold text-accent' : ''" @click="selected = c.id">
                                        <CategoryIcon :name="c.icon" class="h-4 w-4 shrink-0" />
                                        <span class="truncate">{{ tr(c.name) }}</span>
                                        <SbBadge v-if="!c.is_active" tone="neutral">{{ t('ui.common.inactive') }}</SbBadge>
                                        <span class="ms-auto text-caption text-text-secondary tabular">{{ c.services_count }}</span>
                                    </button>
                                    <div v-if="can.manage" class="flex shrink-0 items-center opacity-100 lg:opacity-0 lg:group-focus-within:opacity-100 lg:group-hover:opacity-100">
                                        <button type="button" class="inline-flex h-7 w-7 items-center justify-center rounded-input hover:bg-surface" :aria-label="t('ui.catalog.move_up')" :disabled="i === 0" @click="moveBy(i, -1)"><ChevronUp class="h-4 w-4" aria-hidden="true" /></button>
                                        <button type="button" class="inline-flex h-7 w-7 items-center justify-center rounded-input hover:bg-surface" :aria-label="t('ui.catalog.move_down')" :disabled="i === order.length - 1" @click="moveBy(i, 1)"><ChevronDown class="h-4 w-4" aria-hidden="true" /></button>
                                        <button type="button" class="inline-flex h-7 w-7 items-center justify-center rounded-input hover:bg-surface" :aria-label="t('ui.common.edit')" @click="openCategory(c)"><Pencil class="h-3.5 w-3.5" aria-hidden="true" /></button>
                                        <button type="button" class="inline-flex h-7 w-7 items-center justify-center rounded-input text-error hover:bg-surface" :aria-label="t('ui.common.remove')" @click="deleting = c"><Trash2 class="h-3.5 w-3.5" aria-hidden="true" /></button>
                                    </div>
                                </li>
                            </ul>
                        </aside>

                        <!-- Services table -->
                        <section class="flex flex-col gap-3">
                            <div class="w-full sm:w-72"><SbInput v-model="search" type="search" :placeholder="t('ui.catalog.search')" /></div>
                            <div class="overflow-hidden rounded-card border border-border bg-surface shadow-sm">
                                <SbEmptyState
                                    v-if="visibleServices.length === 0"
                                    :icon="Scissors"
                                    :title="search ? t('ui.common.no_results') : categories.length === 0 ? t('ui.catalog.empty_no_categories') : t('ui.catalog.empty')"
                                    :description="can.manage && !search ? (categories.length === 0 ? t('ui.catalog.empty_no_categories_hint') : t('ui.catalog.empty_hint')) : undefined"
                                />
                                <table v-else class="w-full text-start text-label">
                                    <thead class="hidden border-b border-border bg-surface-muted text-caption text-text-secondary md:table-header-group">
                                        <tr>
                                            <th scope="col" class="px-4 py-3 text-start font-medium">{{ t('ui.catalog.col_service') }}</th>
                                            <th scope="col" class="px-4 py-3 text-start font-medium">{{ t('ui.catalog.category') }}</th>
                                            <th scope="col" class="px-4 py-3 text-end font-medium">{{ t('ui.catalog.duration') }}</th>
                                            <th scope="col" class="px-4 py-3 text-end font-medium">{{ t('ui.catalog.col_price') }}</th>
                                            <th scope="col" class="px-4 py-3 text-start font-medium">{{ t('ui.staff.col_status') }}</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-border">
                                        <tr v-for="s in visibleServices" :key="s.id" class="flex cursor-pointer flex-col gap-1 p-4 hover:bg-surface-muted md:table-row md:p-0" tabindex="0" @click="openService(s)" @keydown.enter="openService(s)">
                                            <td class="md:px-4 md:py-3">
                                                <div class="flex items-center gap-3">
                                                    <div class="flex aspect-[4/3] w-14 shrink-0 items-center justify-center overflow-hidden rounded-input bg-surface-muted">
                                                        <img v-if="s.image_url" :src="s.image_url" :alt="tr(s.name)" class="h-full w-full object-cover" />
                                                        <Scissors v-else class="h-4 w-4 text-text-secondary" aria-hidden="true" />
                                                    </div>
                                                    <div class="min-w-0">
                                                        <p class="truncate font-medium">{{ tr(s.name) }}</p>
                                                        <p v-if="s.addons.length || branchOverrides(s)" class="text-caption text-text-secondary">
                                                            <template v-if="s.addons.length">{{ t('ui.catalog.addons_count', { n: s.addons.length }, s.addons.length) }}</template>
                                                            <template v-if="s.addons.length && branchOverrides(s)"> · </template>
                                                            <template v-if="branchOverrides(s)">{{ t('ui.catalog.branch_overrides', { n: branchOverrides(s) }, branchOverrides(s)) }}</template>
                                                        </p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-text-secondary md:px-4 md:py-3">{{ categoryName(s.category) }}</td>
                                            <td class="tabular md:px-4 md:py-3 md:text-end">{{ minutes(s.duration_minutes) }}</td>
                                            <td class="font-medium tabular md:px-4 md:py-3 md:text-end" dir="ltr">{{ s.price.formatted }}</td>
                                            <td class="md:px-4 md:py-3">
                                                <div class="flex flex-wrap gap-1.5">
                                                    <SbBadge :tone="s.is_active ? 'success' : 'neutral'" dot>{{ s.is_active ? t('ui.common.active') : t('ui.common.inactive') }}</SbBadge>
                                                    <SbBadge v-if="s.is_active && !s.is_bookable_online" tone="info">{{ t('ui.catalog.in_salon_only') }}</SbBadge>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </section>
                    </div>
                </template>

                <template #addons>
                    <div class="overflow-hidden rounded-card border border-border bg-surface shadow-sm">
                        <SbEmptyState v-if="addons.length === 0" :icon="Sparkles" :title="t('ui.catalog.no_addons')" :description="can.manage ? t('ui.catalog.no_addons_hint') : undefined" />
                        <ul v-else class="divide-y divide-border">
                            <li v-for="a in addons" :key="a.id">
                                <button type="button" class="flex w-full flex-wrap items-center justify-between gap-3 p-4 text-start hover:bg-surface-muted" @click="openAddon(a)">
                                    <span>
                                        <span class="font-medium">{{ tr(a.name) }}</span>
                                        <span class="block text-caption text-text-secondary">{{ serviceNames(a.services) || t('ui.catalog.addon_unlinked') }}</span>
                                    </span>
                                    <span class="flex items-center gap-3">
                                        <span v-if="a.extra_minutes" class="text-caption text-text-secondary">+{{ minutes(a.extra_minutes) }}</span>
                                        <span class="font-medium tabular" dir="ltr">{{ a.price.formatted }}</span>
                                        <SbBadge v-if="!a.is_active" tone="neutral">{{ t('ui.common.inactive') }}</SbBadge>
                                    </span>
                                </button>
                            </li>
                        </ul>
                    </div>
                </template>

                <template #bundles>
                    <SbEmptyState v-if="bundles.length === 0" :icon="Package" :title="t('ui.catalog.no_bundles')" :description="can.manage ? t('ui.catalog.no_bundles_hint') : undefined" class="rounded-card border border-border bg-surface" />
                    <div v-else class="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
                        <button v-for="b in bundles" :key="b.id" type="button" class="flex flex-col gap-3 rounded-card border border-border bg-surface p-5 text-start shadow-sm hover:border-accent" @click="openBundle(b)">
                            <div class="flex items-start justify-between gap-2">
                                <h3 class="text-h4">{{ tr(b.name) }}</h3>
                                <SbBadge v-if="!b.is_active" tone="neutral">{{ t('ui.common.inactive') }}</SbBadge>
                            </div>
                            <p class="text-label text-text-secondary">{{ serviceNames(b.services) }}</p>
                            <div class="mt-auto flex items-baseline gap-2" dir="ltr">
                                <span class="text-h3 tabular">{{ b.price.formatted }}</span>
                                <span v-if="b.saving" class="text-label text-text-secondary line-through tabular">{{ b.regular_price.formatted }}</span>
                            </div>
                            <div class="flex flex-wrap gap-2">
                                <SbBadge v-if="b.saving" tone="success">{{ t('ui.catalog.save_amount', { amount: b.saving.formatted }) }}</SbBadge>
                                <SbBadge tone="neutral">{{ minutes(b.duration_minutes) }}</SbBadge>
                            </div>
                        </button>
                    </div>
                </template>
            </SbTabs>
        </div>

        <ServiceDrawer v-model:open="serviceOpen" :service="editingService" :default-category="selected" :categories="categories" :addons="addons" :branches="branches" :barbers="barbers" :tax-classes="taxClasses" :currency="currency" :can="can" />
        <AddonDrawer v-model:open="addonOpen" :addon="editingAddon" :services="services" :tax-classes="taxClasses" :currency="currency" :can="can" />
        <BundleDrawer v-model:open="bundleOpen" :bundle="editingBundle" :services="services" :tax-classes="taxClasses" :currency="currency" :can="can" />
        <CategoryModal v-model:open="categoryOpen" :category="editingCategory" :icons="icons" />
        <SbConfirmDialog
            :open="deleting !== null"
            :title="t('ui.catalog.delete_category_title')"
            :description="deleting && deleting.services_count > 0 ? t('ui.catalog.delete_category_blocked') : t('ui.catalog.delete_category_body')"
            :confirm-label="t('ui.common.remove')"
            danger
            @update:open="(v: boolean) => !v && (deleting = null)"
            @confirm="confirmDelete"
        />
    </AppLayout>
</template>
