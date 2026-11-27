<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
import { TooltipContent, TooltipPortal, TooltipProvider, TooltipRoot, TooltipTrigger } from 'reka-ui';
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import SbBadge from '@/Components/Ui/SbBadge.vue';
import { menuIcons } from '@/Components/Ui/icons';
import { usePageProps } from '@/Composables/usePageProps';
import type { MenuGroup } from '@/types';

/**
 * Permission- and feature-filtered menu from the server. Items of phases not shipped yet
 * show a "Soon" badge and are not links. Badge counters fill in when their modules ship.
 */
defineProps<{ groups: MenuGroup[]; collapsed: boolean; currentPath: string; badges?: Record<string, number> }>();
const emit = defineEmits<{ navigate: [] }>();
const { t } = useI18n();
const { props: page } = usePageProps();
// Tooltips open towards the content: right of the sidebar in LTR, left of it in RTL.
const tooltipSide = computed(() => (page.value.dir === 'rtl' ? 'left' : 'right'));
</script>

<template>
    <TooltipProvider :delay-duration="200">
        <nav :aria-label="t('ui.shell.main_navigation')" class="flex flex-col gap-5">
            <div v-for="group in groups" :key="group.key" class="flex flex-col gap-1">
                <p v-if="!collapsed" class="px-3 pb-1 text-caption font-medium uppercase tracking-wide text-text-secondary">{{ t(group.label) }}</p>
                <div v-else class="mx-auto mb-1 h-px w-6 bg-border" aria-hidden="true"></div>
                <template v-for="item in group.items" :key="item.key">
                    <TooltipRoot :disabled="!collapsed">
                        <TooltipTrigger as-child>
                            <component
                                :is="item.available ? Link : 'span'"
                                :href="item.available ? item.href : undefined"
                                class="group relative flex h-11 items-center gap-3 rounded-input px-3 text-label transition-colors duration-fast ease-sb"
                                :class="[
                                    currentPath === item.href ? 'bg-accent-soft font-semibold text-text-primary' : 'text-text-secondary',
                                    item.available ? 'hover:bg-surface-muted hover:text-text-primary' : 'cursor-default opacity-60',
                                    collapsed ? 'justify-center' : '',
                                ]"
                                :aria-current="currentPath === item.href ? 'page' : undefined"
                                :aria-disabled="!item.available || undefined"
                                @click="item.available && emit('navigate')"
                            >
                                <span v-if="currentPath === item.href" class="absolute inset-y-2 start-0 w-0.5 rounded-pill bg-accent" aria-hidden="true"></span>
                                <component :is="menuIcons[item.icon] ?? menuIcons['layout-grid']" class="h-5 w-5 shrink-0" aria-hidden="true" />
                                <span v-if="!collapsed" class="min-w-0 flex-1 truncate">{{ t(item.label) }}</span>
                                <SbBadge v-if="!collapsed && !item.available" tone="neutral">{{ t('ui.shell.soon') }}</SbBadge>
                                <SbBadge v-else-if="!collapsed && item.badge && badges?.[item.badge]" tone="accent">{{ badges[item.badge] }}</SbBadge>
                            </component>
                        </TooltipTrigger>
                        <TooltipPortal>
                            <TooltipContent :side="tooltipSide" :side-offset="8" class="z-50 rounded-input bg-primary px-3 py-1.5 text-caption text-on-primary shadow-md">
                                {{ t(item.label) }}<template v-if="!item.available"> · {{ t('ui.shell.soon') }}</template>
                            </TooltipContent>
                        </TooltipPortal>
                    </TooltipRoot>
                </template>
            </div>
        </nav>
    </TooltipProvider>
</template>
