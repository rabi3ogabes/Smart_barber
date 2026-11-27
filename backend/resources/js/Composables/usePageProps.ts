import { usePage } from '@inertiajs/vue3';
import { computed } from 'vue';
import type { SharedProps, StaffAuth } from '@/types';

export function usePageProps() {
    const page = usePage();
    const props = computed(() => page.props as unknown as SharedProps);

    const staff = computed<StaffAuth | null>(() => (props.value.auth?.type === 'staff' ? props.value.auth : null));

    /** Display-only check; the server enforces every permission. */
    const can = (permission: string): boolean => staff.value?.permissions.includes(permission) ?? false;

    return { props, staff, can };
}
