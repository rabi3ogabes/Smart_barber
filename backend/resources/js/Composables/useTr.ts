import { useI18n } from 'vue-i18n';

/** Picks the current-locale value of a {ar, en} field, falling back to the other language. */
export function useTr() {
    const { locale } = useI18n();
    return (v: { ar?: string | null; en?: string | null } | null | undefined): string => {
        if (!v) return '';
        return (locale.value === 'ar' ? v.ar || v.en : v.en || v.ar) ?? '';
    };
}
