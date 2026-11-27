<script setup lang="ts">
import { Head, Link, usePage } from '@inertiajs/vue3';
import { Ellipsis, Menu, PanelLeftClose, PanelLeftOpen, Search, X } from 'lucide-vue-next';
import { DialogContent, DialogOverlay, DialogPortal, DialogRoot, DialogTitle, VisuallyHidden } from 'reka-ui';
import { computed, onMounted, ref, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import CommandPalette from '@/Components/Layout/CommandPalette.vue';
import HeaderControls from '@/Components/Layout/HeaderControls.vue';
import SidebarNav from '@/Components/Layout/SidebarNav.vue';
import SbToaster from '@/Components/Ui/SbToaster.vue';
import { menuIcons } from '@/Components/Ui/icons';
import { usePageProps } from '@/Composables/usePageProps';
import { useToast } from '@/Composables/useToast';

defineProps<{ title: string }>();

const { props, staff } = usePageProps();
const { t } = useI18n();
const page = usePage();
const { push } = useToast();

const collapsed = ref(false);
const mobileOpen = ref(false);
const paletteOpen = ref(false);
const groups = computed(() => staff.value?.menu ?? []);
const currentPath = computed(() => page.url.split('?')[0] ?? '/');

// Bottom navigation: the first four available items + "More" (opens the drawer).
const bottomItems = computed(() => groups.value.flatMap((g) => g.items).filter((i) => i.available).slice(0, 4));

onMounted(() => {
    try {
        collapsed.value = localStorage.getItem('sb-sidebar') === 'collapsed';
    } catch {
        /* ignore */
    }
});
watch(collapsed, (v) => {
    try {
        localStorage.setItem('sb-sidebar', v ? 'collapsed' : 'expanded');
    } catch {
        /* ignore */
    }
});
watch(
    () => props.value.flash,
    (flash) => {
        if (flash?.success) push(flash.success, 'success');
        if (flash?.error) push(flash.error, 'error');
    },
    { immediate: true, deep: true },
);
</script>

<template>
    <Head :title="title" />
    <div class="flex min-h-screen bg-background">
        <!-- Desktop / tablet sidebar (start edge: right side in Arabic) -->
        <aside
            class="sticky top-0 hidden h-screen shrink-0 flex-col border-e border-border bg-surface transition-[width] duration-base ease-sb md:flex"
            :class="collapsed ? 'w-[var(--sb-sidebar-collapsed)]' : 'w-[var(--sb-sidebar-expanded)]'"
        >
            <div class="flex h-[var(--sb-header-height)] items-center gap-3 border-b border-border px-4" :class="collapsed ? 'justify-center' : ''">
                <span class="flex h-9 w-9 shrink-0 items-center justify-center rounded-input bg-primary font-display text-h4 text-accent" aria-hidden="true">S</span>
                <div v-if="!collapsed" class="min-w-0">
                    <p class="truncate text-label font-semibold">{{ props.salon?.name }}</p>
                    <p class="text-caption text-text-secondary">{{ t('ui.brand') }}</p>
                </div>
            </div>
            <div class="min-h-0 flex-1 overflow-y-auto px-3 py-4">
                <SidebarNav :groups="groups" :collapsed="collapsed" :current-path="currentPath" />
            </div>
            <div class="border-t border-border p-3">
                <button
                    type="button"
                    class="flex h-11 w-full items-center gap-3 rounded-input px-3 text-label text-text-secondary hover:bg-surface-muted"
                    :class="collapsed ? 'justify-center' : ''"
                    :aria-label="collapsed ? t('ui.shell.expand_sidebar') : t('ui.shell.collapse_sidebar')"
                    :aria-expanded="!collapsed"
                    @click="collapsed = !collapsed"
                >
                    <component :is="collapsed ? PanelLeftOpen : PanelLeftClose" class="flip-rtl h-5 w-5" aria-hidden="true" />
                    <span v-if="!collapsed">{{ t('ui.shell.collapse_sidebar') }}</span>
                </button>
            </div>
        </aside>

        <!-- Mobile drawer from the start edge -->
        <DialogRoot v-model:open="mobileOpen">
            <DialogPortal>
                <DialogOverlay class="fixed inset-0 z-40 bg-overlay md:hidden" />
                <DialogContent class="fixed inset-y-0 start-0 z-50 flex w-[min(20rem,85vw)] flex-col bg-surface shadow-md ltr:animate-[sb-slide-in-start_200ms_var(--ease-sb)] rtl:animate-[sb-slide-in-end_200ms_var(--ease-sb)] md:hidden">
                    <VisuallyHidden><DialogTitle>{{ t('ui.shell.main_navigation') }}</DialogTitle></VisuallyHidden>
                    <div class="flex h-[var(--sb-header-height)] items-center justify-between border-b border-border px-4">
                        <p class="truncate text-label font-semibold">{{ props.salon?.name }}</p>
                        <button type="button" class="inline-flex h-11 w-11 items-center justify-center rounded-input hover:bg-surface-muted" :aria-label="t('ui.common.close')" @click="mobileOpen = false">
                            <X class="h-5 w-5" aria-hidden="true" />
                        </button>
                    </div>
                    <div class="flex-1 overflow-y-auto px-3 py-4">
                        <SidebarNav :groups="groups" :collapsed="false" :current-path="currentPath" @navigate="mobileOpen = false" />
                    </div>
                </DialogContent>
            </DialogPortal>
        </DialogRoot>

        <div class="flex min-w-0 flex-1 flex-col">
            <header class="sticky top-0 z-30 flex h-[var(--sb-header-height)] items-center gap-2 border-b border-border bg-surface/90 px-3 backdrop-blur sm:px-6">
                <button type="button" class="inline-flex h-11 w-11 items-center justify-center rounded-input hover:bg-surface-muted md:hidden" :aria-label="t('ui.shell.open_menu')" @click="mobileOpen = true">
                    <Menu class="h-5 w-5" aria-hidden="true" />
                </button>
                <h1 class="min-w-0 flex-1 truncate text-h4 md:hidden">{{ title }}</h1>
                <!-- Global search: opens the command palette for now -->
                <button
                    type="button"
                    class="hidden h-10 max-w-md flex-1 items-center gap-2 rounded-input border border-border bg-surface-muted px-3 text-label text-text-secondary hover:border-accent md:flex"
                    @click="paletteOpen = true"
                >
                    <Search class="h-4 w-4" aria-hidden="true" />
                    <span class="flex-1 text-start">{{ t('ui.shell.search_placeholder') }}</span>
                    <kbd class="rounded-input border border-border bg-surface px-1.5 text-caption" dir="ltr">⌘K</kbd>
                </button>
                <button type="button" class="inline-flex h-11 w-11 items-center justify-center rounded-input text-text-secondary hover:bg-surface-muted md:hidden" :aria-label="t('ui.shell.search')" @click="paletteOpen = true">
                    <Search class="h-5 w-5" aria-hidden="true" />
                </button>
                <div class="hidden flex-1 md:block"></div>
                <HeaderControls />
            </header>

            <main class="flex-1 px-4 pt-6 pb-28 sm:px-6 md:pb-10 lg:px-10">
                <slot />
            </main>
        </div>

        <!-- Mobile bottom navigation (5 items) -->
        <nav class="fixed inset-x-0 bottom-0 z-30 grid h-16 grid-cols-5 border-t border-border bg-surface md:hidden" :aria-label="t('ui.shell.quick_navigation')">
            <Link
                v-for="item in bottomItems"
                :key="item.key"
                :href="item.href"
                class="flex flex-col items-center justify-center gap-1 text-caption"
                :class="currentPath === item.href ? 'text-accent' : 'text-text-secondary'"
                :aria-current="currentPath === item.href ? 'page' : undefined"
            >
                <component :is="menuIcons[item.icon] ?? menuIcons['layout-grid']" class="h-5 w-5" aria-hidden="true" />
                <span class="max-w-full truncate px-1">{{ t(item.label) }}</span>
            </Link>
            <button v-for="n in Math.max(0, 4 - bottomItems.length)" :key="`pad-${n}`" type="button" class="invisible" tabindex="-1" aria-hidden="true"></button>
            <button type="button" class="flex flex-col items-center justify-center gap-1 text-caption text-text-secondary" @click="mobileOpen = true">
                <Ellipsis class="h-5 w-5" aria-hidden="true" />
                <span>{{ t('ui.shell.more') }}</span>
            </button>
        </nav>

        <CommandPalette v-model:open="paletteOpen" :groups="groups" />
        <SbToaster />
    </div>
</template>
