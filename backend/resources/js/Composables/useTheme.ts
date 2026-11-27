import { ref } from 'vue';

export type ThemeChoice = 'light' | 'dark' | 'system';

const STORAGE_KEY = 'sb-theme';
const choice = ref<ThemeChoice>(read());

function read(): ThemeChoice {
    try {
        const v = localStorage.getItem(STORAGE_KEY);
        return v === 'light' || v === 'dark' ? v : 'system';
    } catch {
        return 'system';
    }
}

function apply(value: ThemeChoice): void {
    const dark = value === 'dark' || (value === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches);
    document.documentElement.classList.toggle('dark', dark);
}

if (typeof window !== 'undefined') {
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
        if (choice.value === 'system') apply('system');
    });
}

export function useTheme() {
    const set = (value: ThemeChoice): void => {
        choice.value = value;
        try {
            localStorage.setItem(STORAGE_KEY, value);
        } catch {
            /* storage unavailable: keep the in-memory choice */
        }
        apply(value);
    };

    return { theme: choice, setTheme: set };
}
