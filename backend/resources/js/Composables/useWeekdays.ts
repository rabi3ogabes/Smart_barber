import { computed } from 'vue';
import { useI18n } from 'vue-i18n';

/** Weekdays in Gulf order (Saturday first). Values follow the API: 0 = Sunday … 6 = Saturday. */
export const WEEK_ORDER = [6, 0, 1, 2, 3, 4, 5] as const;

export function useWeekdays() {
    const { locale } = useI18n();
    const names = computed(() => {
        const fmt = new Intl.DateTimeFormat(locale.value === 'ar' ? 'ar-QA' : 'en-GB', { weekday: 'long' });
        // 2023-01-01 was a Sunday.
        return Array.from({ length: 7 }, (_, d) => fmt.format(new Date(Date.UTC(2023, 0, 1 + d, 12))));
    });
    const shortNames = computed(() => {
        const fmt = new Intl.DateTimeFormat(locale.value === 'ar' ? 'ar-QA' : 'en-GB', { weekday: 'short' });
        return Array.from({ length: 7 }, (_, d) => fmt.format(new Date(Date.UTC(2023, 0, 1 + d, 12))));
    });
    return { order: WEEK_ORDER, names, shortNames };
}

export type TimeRange = { start: string; end: string };
export type Week = Record<number, TimeRange[]>;

export function emptyWeek(): Week {
    return { 0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: [] };
}

export function cloneWeek(week: Week | TimeRange[][] | undefined): Week {
    const out = emptyWeek();
    if (!week) return out;
    for (let d = 0; d < 7; d++) {
        const ranges = (week as Record<number, TimeRange[]>)[d] ?? [];
        out[d] = ranges.map((r) => ({ start: r.start, end: r.end }));
    }
    return out;
}

/** Formats a date (YYYY-MM-DD or ISO) for the current locale. */
export function useDateFormat() {
    const { locale } = useI18n();
    const fmt = (value: string, opts: Intl.DateTimeFormatOptions = { day: 'numeric', month: 'short', year: 'numeric' }) =>
        new Intl.DateTimeFormat(locale.value === 'ar' ? 'ar-QA' : 'en-GB', opts).format(new Date(value.length === 10 ? `${value}T12:00:00` : value));
    return { fmt };
}
