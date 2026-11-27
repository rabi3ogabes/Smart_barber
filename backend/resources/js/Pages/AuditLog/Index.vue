<script setup lang="ts">
import { router } from '@inertiajs/vue3';
import { ChevronDown, History } from 'lucide-vue-next';
import { ref } from 'vue';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import AppLayout from '@/Layouts/AppLayout.vue';

interface Entry { id: number; event: string; actor: string | null; subject: string | null; old: Record<string, unknown> | null; new: Record<string, unknown> | null; ip: string | null; at: string }
const props = defineProps<{ logs: Entry[]; next: string | null; prev: string | null; filter: string | null }>();
const { t, te, locale } = useI18n();

const groups = ['membership', 'staff', 'salons', 'branches', 'branch_closures', 'barbers', 'time_off_requests', 'catalog', 'services', 'auth'];
const filter = ref(props.filter ?? 'all');
const applyFilter = (v: string): void => router.get('/audit-log', v && v !== 'all' ? { event: v } : {}, { preserveScroll: true });
const eventLabel = (e: string): string => (te(`ui.audit.events.${e.replace('.', '__')}`) ? t(`ui.audit.events.${e.replace('.', '__')}`) : e);
const when = (iso: string): string => new Intl.DateTimeFormat(locale.value === 'ar' ? 'ar-QA' : 'en-GB', { dateStyle: 'medium', timeStyle: 'short' }).format(new Date(iso));
const expanded = ref<number | null>(null);
const keys = (e: Entry): string[] => Array.from(new Set([...Object.keys(e.old ?? {}), ...Object.keys(e.new ?? {})]));
const show = (v: unknown): string => (v === null || v === undefined ? '—' : typeof v === 'object' ? JSON.stringify(v) : String(v));
</script>

<template>
    <AppLayout :title="t('nav.audit_log')">
        <div class="mx-auto flex max-w-5xl flex-col gap-6">
            <header class="flex flex-wrap items-end justify-between gap-4">
                <div>
                    <h2 class="text-h2">{{ t('nav.audit_log') }}</h2>
                    <p class="mt-1 text-body text-text-secondary">{{ t('ui.audit.subtitle') }}</p>
                </div>
                <div class="w-64">
                    <SbSelect
                        v-model="filter"
                        :label="t('ui.audit.filter')"
                        :options="[{ value: 'all', label: t('ui.audit.all') }, ...groups.map((g) => ({ value: g, label: t(`ui.audit.groups.${g}`) }))]"
                        @update:model-value="(v?: string) => applyFilter(v ?? '')"
                    />
                </div>
            </header>

            <section class="overflow-hidden rounded-card border border-border bg-surface shadow-sm">
                <SbEmptyState v-if="logs.length === 0" :icon="History" :title="t('ui.audit.empty')" />
                <ul v-else class="divide-y divide-border">
                    <li v-for="e in logs" :key="e.id">
                        <button type="button" class="flex w-full items-center gap-4 px-4 py-3 text-start hover:bg-surface-muted" :aria-expanded="expanded === e.id" @click="expanded = expanded === e.id ? null : e.id">
                            <div class="min-w-0 flex-1">
                                <p class="truncate text-label font-medium">{{ eventLabel(e.event) }}</p>
                                <p class="text-caption text-text-secondary">{{ e.actor ?? t('ui.audit.system') }} · {{ when(e.at) }}<template v-if="e.ip"> · <span dir="ltr">{{ e.ip }}</span></template></p>
                            </div>
                            <ChevronDown class="h-4 w-4 shrink-0 text-text-secondary transition-transform" :class="expanded === e.id ? 'rotate-180' : ''" aria-hidden="true" />
                        </button>
                        <div v-if="expanded === e.id" class="bg-surface-muted px-4 py-3">
                            <p v-if="keys(e).length === 0" class="text-caption text-text-secondary">{{ t('ui.audit.no_details') }}</p>
                            <table v-else class="w-full text-caption">
                                <thead>
                                    <tr class="text-text-secondary">
                                        <th scope="col" class="py-1 text-start font-medium">{{ t('ui.audit.field') }}</th>
                                        <th scope="col" class="py-1 text-start font-medium">{{ t('ui.audit.before') }}</th>
                                        <th scope="col" class="py-1 text-start font-medium">{{ t('ui.audit.after') }}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="k in keys(e)" :key="k" class="align-top">
                                        <td class="py-1 pe-3 font-medium" dir="ltr">{{ k }}</td>
                                        <td class="break-all py-1 pe-3 text-text-secondary" dir="ltr">{{ show(e.old?.[k]) }}</td>
                                        <td class="break-all py-1" dir="ltr">{{ show(e.new?.[k]) }}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </li>
                </ul>
            </section>

            <nav v-if="prev || next" class="flex justify-between" :aria-label="t('ui.audit.pagination')">
                <SbButton v-if="prev" variant="secondary" size="sm" :href="prev">{{ t('ui.audit.newer') }}</SbButton>
                <span v-else></span>
                <SbButton v-if="next" variant="secondary" size="sm" :href="next">{{ t('ui.audit.older') }}</SbButton>
            </nav>
        </div>
    </AppLayout>
</template>
