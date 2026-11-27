import { ref } from 'vue';

export type ToastTone = 'success' | 'error' | 'info' | 'warning';

export interface ToastMessage {
    id: number;
    title: string;
    description?: string;
    tone: ToastTone;
}

const toasts = ref<ToastMessage[]>([]);
let next = 1;

export function useToast() {
    const push = (title: string, tone: ToastTone = 'info', description?: string): void => {
        toasts.value.push({ id: next++, title, tone, description });
    };
    const dismiss = (id: number): void => {
        toasts.value = toasts.value.filter((t) => t.id !== id);
    };

    return { toasts, push, dismiss };
}
