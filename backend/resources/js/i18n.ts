import { createI18n } from 'vue-i18n';
import ar from '../../lang/ar.json';
import en from '../../lang/en.json';

/*
 * One translation source for server and client: lang/{ar,en}.json (ADR-005).
 * Keys are flat ("nav.dashboard"); flatJson lets vue-i18n read them.
 */
export const i18n = createI18n({
    legacy: false,
    locale: 'ar',
    fallbackLocale: 'en',
    flatJson: true,
    messages: { ar, en },
    numberFormats: {
        ar: { decimal: { style: 'decimal', maximumFractionDigits: 2 } },
        en: { decimal: { style: 'decimal', maximumFractionDigits: 2 } },
    },
});
