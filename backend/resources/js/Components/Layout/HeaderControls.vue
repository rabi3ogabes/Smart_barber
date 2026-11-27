<script setup lang="ts">
import { router } from '@inertiajs/vue3';
import { Bell, Check, ChevronDown, Languages, LogOut, Monitor, Moon, Store, Sun, User } from 'lucide-vue-next';
import {
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuPortal,
    DropdownMenuRoot,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
    PopoverContent,
    PopoverPortal,
    PopoverRoot,
    PopoverTrigger,
} from 'reka-ui';
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import { useLocale } from '@/Composables/useLocale';
import { usePageProps } from '@/Composables/usePageProps';
import { type ThemeChoice, useTheme } from '@/Composables/useTheme';

const { props, staff } = usePageProps();
const { t, locale } = useI18n();
const { setLocale } = useLocale();
const { theme, setTheme } = useTheme();

const branches = computed(() => staff.value?.branches ?? []);
const currentBranch = computed(() => branches.value.find((b) => b.id === staff.value?.currentBranch) ?? branches.value[0]);
const themes: { value: ThemeChoice; icon: typeof Sun; label: string }[] = [
    { value: 'light', icon: Sun, label: 'ui.theme.light' },
    { value: 'dark', icon: Moon, label: 'ui.theme.dark' },
    { value: 'system', icon: Monitor, label: 'ui.theme.system' },
];

const switchBranch = (id: string): void => router.post('/branch', { branch: id }, { preserveScroll: true });
const logout = (): void => router.post('/logout');
const menuItem = 'flex h-10 cursor-pointer select-none items-center gap-2.5 rounded-input px-3 text-body outline-none data-[highlighted]:bg-surface-muted';
const panel = 'z-50 min-w-56 rounded-card border border-border bg-surface-elevated p-1 shadow-md animate-[sb-pop_150ms_var(--ease-sb)]';
</script>

<template>
    <div class="flex items-center gap-1">
        <!-- Branch selector -->
        <DropdownMenuRoot v-if="branches.length > 0">
            <DropdownMenuTrigger
                class="hidden h-10 items-center gap-2 rounded-input border border-border bg-surface px-3 text-label hover:bg-surface-muted sm:inline-flex"
                :aria-label="t('ui.shell.branch')"
            >
                <Store class="h-4 w-4 text-text-secondary" aria-hidden="true" />
                <span class="max-w-40 truncate">{{ currentBranch?.name }}</span>
                <ChevronDown class="h-4 w-4 text-text-secondary" aria-hidden="true" />
            </DropdownMenuTrigger>
            <DropdownMenuPortal>
                <DropdownMenuContent :side-offset="6" align="end" :class="panel">
                    <DropdownMenuLabel class="px-3 py-2 text-caption text-text-secondary">{{ t('ui.shell.branch') }}</DropdownMenuLabel>
                    <DropdownMenuItem v-for="b in branches" :key="b.id" :class="menuItem" @select="switchBranch(b.id)">
                        <Check class="h-4 w-4" :class="b.id === currentBranch?.id ? 'text-accent' : 'invisible'" aria-hidden="true" />
                        {{ b.name }}
                    </DropdownMenuItem>
                </DropdownMenuContent>
            </DropdownMenuPortal>
        </DropdownMenuRoot>

        <!-- Notifications (empty until Phase 11) -->
        <PopoverRoot>
            <PopoverTrigger class="relative inline-flex h-11 w-11 items-center justify-center rounded-input text-text-secondary hover:bg-surface-muted" :aria-label="t('ui.shell.notifications')">
                <Bell class="h-5 w-5" aria-hidden="true" />
            </PopoverTrigger>
            <PopoverPortal>
                <PopoverContent :side-offset="6" align="end" class="z-50 w-80 rounded-card border border-border bg-surface-elevated shadow-md">
                    <p class="border-b border-border px-4 py-3 text-label font-semibold">{{ t('ui.shell.notifications') }}</p>
                    <SbEmptyState :icon="Bell" :title="t('ui.shell.notifications_empty')" :description="t('ui.shell.notifications_empty_hint')" />
                </PopoverContent>
            </PopoverPortal>
        </PopoverRoot>

        <!-- Language -->
        <button
            type="button"
            class="inline-flex h-11 items-center gap-1.5 rounded-input px-2.5 text-label text-text-secondary hover:bg-surface-muted"
            :aria-label="t('ui.shell.language')"
            @click="setLocale(locale === 'ar' ? 'en' : 'ar')"
        >
            <Languages class="h-5 w-5" aria-hidden="true" />
            <span class="hidden sm:inline">{{ locale === 'ar' ? 'English' : 'العربية' }}</span>
        </button>

        <!-- Profile + theme -->
        <DropdownMenuRoot>
            <DropdownMenuTrigger class="inline-flex h-11 items-center gap-2 rounded-input ps-1 pe-2 hover:bg-surface-muted" :aria-label="t('ui.shell.profile_menu')">
                <span class="flex h-8 w-8 items-center justify-center rounded-pill bg-primary text-caption font-semibold text-on-primary">
                    {{ (props.auth?.user.name ?? '?').slice(0, 1).toUpperCase() }}
                </span>
                <ChevronDown class="hidden h-4 w-4 text-text-secondary sm:block" aria-hidden="true" />
            </DropdownMenuTrigger>
            <DropdownMenuPortal>
                <DropdownMenuContent :side-offset="6" align="end" :class="panel">
                    <DropdownMenuLabel class="px-3 py-2">
                        <span class="block text-label font-semibold">{{ props.auth?.user.name }}</span>
                        <span class="block text-caption text-text-secondary" dir="ltr">{{ props.auth?.user.email }}</span>
                    </DropdownMenuLabel>
                    <DropdownMenuSeparator class="my-1 h-px bg-border" />
                    <DropdownMenuItem :class="menuItem" disabled><User class="h-4 w-4" aria-hidden="true" />{{ t('ui.shell.my_profile') }}</DropdownMenuItem>
                    <DropdownMenuSeparator class="my-1 h-px bg-border" />
                    <DropdownMenuLabel class="px-3 pt-2 pb-1 text-caption text-text-secondary">{{ t('ui.theme.title') }}</DropdownMenuLabel>
                    <DropdownMenuItem v-for="th in themes" :key="th.value" :class="menuItem" @select.prevent="setTheme(th.value)">
                        <component :is="th.icon" class="h-4 w-4" aria-hidden="true" />
                        <span class="flex-1">{{ t(th.label) }}</span>
                        <Check v-if="theme === th.value" class="h-4 w-4 text-accent" aria-hidden="true" />
                    </DropdownMenuItem>
                    <DropdownMenuSeparator class="my-1 h-px bg-border" />
                    <DropdownMenuItem :class="menuItem" class="text-error" @select="logout"><LogOut class="flip-rtl h-4 w-4" aria-hidden="true" />{{ t('ui.auth.logout') }}</DropdownMenuItem>
                </DropdownMenuContent>
            </DropdownMenuPortal>
        </DropdownMenuRoot>
    </div>
</template>
