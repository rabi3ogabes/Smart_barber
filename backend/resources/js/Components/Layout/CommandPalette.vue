<script setup lang="ts">
import { router } from '@inertiajs/vue3';
import { CornerDownLeft, Search } from 'lucide-vue-next';
import { DialogContent, DialogOverlay, DialogPortal, DialogRoot, DialogTitle, VisuallyHidden } from 'reka-ui';
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import { menuIcons } from '@/Components/Ui/icons';
import type { MenuGroup } from '@/types';

/** Ctrl/⌘+K: jump to any page the user may open. Actions arrive per module later. */
const props = defineProps<{ groups: MenuGroup[] }>();
const open = defineModel<boolean>('open', { default: false });
const { t } = useI18n();
const query = ref('');
const active = ref(0);
const input = ref<HTMLInputElement | null>(null);

const commands = computed(() =>
    props.groups.flatMap((g) => g.items.filter((i) => i.available).map((i) => ({ ...i, group: t(g.label), title: t(i.label) }))),
);
const results = computed(() => {
    const q = query.value.trim().toLocaleLowerCase();
    return q === '' ? commands.value : commands.value.filter((c) => c.title.toLocaleLowerCase().includes(q) || c.group.toLocaleLowerCase().includes(q));
});

watch(open, async (value) => {
    if (value) {
        query.value = '';
        active.value = 0;
        await nextTick();
        input.value?.focus();
    }
});
watch(query, () => (active.value = 0));

const go = (href: string): void => {
    open.value = false;
    router.visit(href);
};

const onKey = (e: KeyboardEvent): void => {
    if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault();
        open.value = !open.value;
    }
};
const onListKey = (e: KeyboardEvent): void => {
    if (e.key === 'ArrowDown') {
        e.preventDefault();
        active.value = Math.min(active.value + 1, results.value.length - 1);
    } else if (e.key === 'ArrowUp') {
        e.preventDefault();
        active.value = Math.max(active.value - 1, 0);
    } else if (e.key === 'Enter' && results.value[active.value]) {
        e.preventDefault();
        go(results.value[active.value]!.href);
    }
};

onMounted(() => window.addEventListener('keydown', onKey));
onBeforeUnmount(() => window.removeEventListener('keydown', onKey));
</script>

<template>
    <DialogRoot v-model:open="open">
        <DialogPortal>
            <DialogOverlay class="fixed inset-0 z-40 bg-overlay" />
            <DialogContent
                class="fixed start-1/2 top-[12vh] z-50 w-[calc(100%-2rem)] max-w-xl overflow-hidden rounded-card border border-border bg-surface-elevated shadow-md ltr:-translate-x-1/2 rtl:translate-x-1/2 animate-[sb-pop_150ms_var(--ease-sb)]"
            >
                <VisuallyHidden><DialogTitle>{{ t('ui.shell.command_palette') }}</DialogTitle></VisuallyHidden>
                <div class="flex items-center gap-3 border-b border-border px-4">
                    <Search class="h-5 w-5 text-text-secondary" aria-hidden="true" />
                    <input
                        ref="input"
                        v-model="query"
                        type="search"
                        class="h-14 min-w-0 flex-1 bg-transparent text-body focus:outline-none"
                        :placeholder="t('ui.shell.command_placeholder')"
                        role="combobox"
                        aria-controls="command-results"
                        :aria-expanded="true"
                        :aria-activedescendant="results[active] ? `cmd-${results[active]!.key}` : undefined"
                        @keydown="onListKey"
                    />
                </div>
                <ul id="command-results" role="listbox" class="max-h-80 overflow-y-auto p-2">
                    <li v-if="results.length === 0" class="px-3 py-8 text-center text-label text-text-secondary">{{ t('ui.common.no_results') }}</li>
                    <li
                        v-for="(cmd, i) in results"
                        :id="`cmd-${cmd.key}`"
                        :key="cmd.key"
                        role="option"
                        :aria-selected="i === active"
                        class="flex h-11 cursor-pointer items-center gap-3 rounded-input px-3 text-body"
                        :class="i === active ? 'bg-surface-muted' : ''"
                        @mouseenter="active = i"
                        @click="go(cmd.href)"
                    >
                        <component :is="menuIcons[cmd.icon] ?? menuIcons['layout-grid']" class="h-4 w-4 text-text-secondary" aria-hidden="true" />
                        <span class="flex-1 truncate">{{ cmd.title }}</span>
                        <span class="text-caption text-text-secondary">{{ cmd.group }}</span>
                        <CornerDownLeft v-if="i === active" class="flip-rtl h-4 w-4 text-text-secondary" aria-hidden="true" />
                    </li>
                </ul>
            </DialogContent>
        </DialogPortal>
    </DialogRoot>
</template>
