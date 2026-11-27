import { router } from '@inertiajs/vue3';
import type { Locale } from '@/types';

/**
 * Switching language reloads the page so direction, fonts and server messages all change together.
 */
export function useLocale() {
    const setLocale = (locale: Locale): void => {
        router.post('/locale', { locale }, { preserveScroll: true, onSuccess: () => window.location.reload() });
    };

    return { setLocale };
}
