<script setup lang="ts">
import { router } from '@inertiajs/vue3';
import { EyeOff, Eye, Star } from 'lucide-vue-next';
import { reactive, ref } from 'vue';
import { useI18n } from 'vue-i18n';
import SbBadge from '@/Components/Ui/SbBadge.vue';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbConfirmDialog from '@/Components/Ui/SbConfirmDialog.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import SbSelect from '@/Components/Ui/SbSelect.vue';
import SbTextarea from '@/Components/Ui/SbTextarea.vue';
import { useTr } from '@/Composables/useTr';
import AppLayout from '@/Layouts/AppLayout.vue';

type ReviewStatus = 'published' | 'hidden';
interface ReviewRow {
    id: string;
    rating: number;
    comment: string | null;
    status: ReviewStatus;
    created_at: string;
    visit_at: string | null;
    customer: string | null;
    barber: Record<string, string> | null;
    branch: Record<string, string> | null;
    moderation: { note: string | null; by: string | null; at: string } | null;
}

const props = defineProps<{
    reviews: ReviewRow[];
    summary: { average: number | null; published: number; hidden: number };
    pagination: { current: number; last: number; total: number; prev: string | null; next: string | null };
    filters: { status: ReviewStatus | null; rating: number | null };
    timezone: string;
}>();
const { t, locale } = useI18n();
const tr = useTr();

const f = reactive({ status: props.filters.status ?? '', rating: props.filters.rating ? String(props.filters.rating) : '' });
const apply = (): void => {
    router.get('/reviews', Object.fromEntries(Object.entries(f).filter(([, v]) => v)), { preserveState: true, preserveScroll: true });
};
const fmt = (iso: string | null): string =>
    iso === null ? '' : new Intl.DateTimeFormat(locale.value === 'ar' ? 'ar-QA' : 'en-GB', { timeZone: props.timezone, day: 'numeric', month: 'short', year: 'numeric' }).format(new Date(iso));
const avg = (n: number | null): string => (n === null ? '—' : new Intl.NumberFormat(locale.value === 'ar' ? 'ar-QA' : 'en-GB', { maximumFractionDigits: 1, minimumFractionDigits: 1 }).format(n));

const target = ref<ReviewRow | null>(null);
const dialogOpen = ref(false);
const note = ref('');
const busy = ref(false);
const ask = (r: ReviewRow): void => {
    target.value = r;
    note.value = '';
    dialogOpen.value = true;
};
const moderate = (): void => {
    if (target.value === null) return;
    busy.value = true;
    router.put(`/reviews/${target.value.id}`, { status: target.value.status === 'published' ? 'hidden' : 'published', note: note.value || null }, {
        preserveScroll: true,
        onFinish: () => {
            busy.value = false;
            dialogOpen.value = false;
        },
    });
};
</script>

<template>
    <AppLayout :title="t('nav.reviews')">
        <div class="mx-auto flex max-w-5xl flex-col gap-5">
            <header>
                <h2 class="text-h2">{{ t('nav.reviews') }}</h2>
                <p class="mt-1 text-body text-text-secondary">{{ t('ui.reviews.subtitle') }}</p>
            </header>

            <section class="grid gap-3 sm:grid-cols-3">
                <div class="rounded-card border border-border bg-surface p-4 shadow-sm">
                    <p class="text-caption text-text-secondary">{{ t('ui.reviews.average') }}</p>
                    <p class="mt-1 flex items-center gap-2 text-h3 tabular"><Star class="h-5 w-5 fill-accent text-accent" aria-hidden="true" />{{ avg(summary.average) }}</p>
                </div>
                <div class="rounded-card border border-border bg-surface p-4 shadow-sm">
                    <p class="text-caption text-text-secondary">{{ t('ui.reviews.published') }}</p>
                    <p class="mt-1 text-h3 tabular">{{ summary.published }}</p>
                </div>
                <div class="rounded-card border border-border bg-surface p-4 shadow-sm">
                    <p class="text-caption text-text-secondary">{{ t('ui.reviews.hidden') }}</p>
                    <p class="mt-1 text-h3 tabular">{{ summary.hidden }}</p>
                </div>
            </section>

            <form class="grid gap-3 rounded-card border border-border bg-surface p-4 shadow-sm sm:grid-cols-3" @submit.prevent="apply">
                <SbSelect
                    v-model="f.status"
                    :label="t('ui.staff.col_status')"
                    :options="[{ value: '', label: t('ui.reviews.all') }, { value: 'published', label: t('ui.reviews.status.published') }, { value: 'hidden', label: t('ui.reviews.status.hidden') }]"
                />
                <SbSelect v-model="f.rating" :label="t('ui.reviews.rating')" :options="[{ value: '', label: t('ui.reviews.any_rating') }, ...[5, 4, 3, 2, 1].map((n) => ({ value: String(n), label: t('ui.reviews.stars', { n }, n) }))]" />
                <div class="flex items-end"><SbButton type="submit" block>{{ t('ui.bookings.apply') }}</SbButton></div>
            </form>

            <section class="overflow-hidden rounded-card border border-border bg-surface shadow-sm">
                <SbEmptyState v-if="reviews.length === 0" :icon="Star" :title="t('ui.reviews.empty')" :description="t('ui.reviews.empty_hint')" />
                <ul v-else class="divide-y divide-border">
                    <li v-for="r in reviews" :key="r.id" class="flex flex-col gap-3 p-4 sm:flex-row sm:items-start sm:justify-between">
                        <div class="min-w-0 flex-1">
                            <div class="flex flex-wrap items-center gap-2">
                                <span class="flex" :aria-label="t('ui.reviews.stars', { n: r.rating }, r.rating)">
                                    <Star v-for="n in 5" :key="n" class="h-4 w-4" :class="n <= r.rating ? 'fill-accent text-accent' : 'text-border'" aria-hidden="true" />
                                </span>
                                <SbBadge :tone="r.status === 'published' ? 'success' : 'neutral'">{{ t(`ui.reviews.status.${r.status}`) }}</SbBadge>
                                <span class="text-caption text-text-secondary">{{ fmt(r.created_at) }}</span>
                            </div>
                            <p v-if="r.comment" class="mt-2 whitespace-pre-line text-body">{{ r.comment }}</p>
                            <p v-else class="mt-2 text-label text-text-secondary">{{ t('ui.reviews.no_comment') }}</p>
                            <p class="mt-2 text-caption text-text-secondary">
                                {{ t('ui.reviews.meta', { customer: r.customer ?? '—', barber: tr(r.barber) || '—', branch: tr(r.branch) || '—', date: fmt(r.visit_at) }) }}
                            </p>
                            <p v-if="r.moderation" class="mt-1 text-caption text-text-secondary">
                                {{ t('ui.reviews.moderated', { by: r.moderation.by ?? '—', date: fmt(r.moderation.at) }) }}<template v-if="r.moderation.note"> · {{ r.moderation.note }}</template>
                            </p>
                        </div>
                        <SbButton size="sm" variant="secondary" @click="ask(r)">
                            <component :is="r.status === 'published' ? EyeOff : Eye" class="h-4 w-4" aria-hidden="true" />
                            {{ r.status === 'published' ? t('ui.reviews.hide') : t('ui.reviews.publish') }}
                        </SbButton>
                    </li>
                </ul>
            </section>

            <nav v-if="pagination.last > 1" class="flex items-center justify-between" :aria-label="t('ui.audit.pagination')">
                <SbButton v-if="pagination.prev" size="sm" variant="secondary" :href="pagination.prev">{{ t('ui.bookings.prev_page') }}</SbButton>
                <span v-else></span>
                <span class="text-caption text-text-secondary">{{ t('ui.bookings.page', { current: pagination.current, last: pagination.last }) }}</span>
                <SbButton v-if="pagination.next" size="sm" variant="secondary" :href="pagination.next">{{ t('ui.bookings.next_page') }}</SbButton>
                <span v-else></span>
            </nav>
        </div>

        <SbConfirmDialog
            v-model:open="dialogOpen"
            :title="target?.status === 'published' ? t('ui.reviews.hide_title') : t('ui.reviews.publish_title')"
            :description="target?.status === 'published' ? t('ui.reviews.hide_hint') : t('ui.reviews.publish_hint')"
            :confirm-label="target?.status === 'published' ? t('ui.reviews.hide') : t('ui.reviews.publish')"
            :danger="target?.status === 'published'"
            :loading="busy"
            @confirm="moderate"
        >
            <SbTextarea v-model="note" :label="t('ui.reviews.note')" :maxlength="255" />
        </SbConfirmDialog>
    </AppLayout>
</template>
