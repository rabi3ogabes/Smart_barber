import '../css/app.css';

import { createInertiaApp } from '@inertiajs/vue3';
import type { DefineComponent } from 'vue';
import { createApp, h } from 'vue';
import { i18n } from './i18n';
import type { SharedProps } from './types';

createInertiaApp({
    title: (title) => (title ? `${title} · Smart Barber` : 'Smart Barber'),
    // Pages are code-split: each screen loads its own chunk.
    resolve: async (name) => {
        const pages = import.meta.glob<{ default: DefineComponent }>('./Pages/**/*.vue');
        const load = pages[`./Pages/${name}.vue`];
        if (!load) {
            throw new Error(`Unknown page: ${name}`);
        }
        return (await load()).default;
    },
    setup({ el, App, props, plugin }) {
        const shared = props.initialPage.props as unknown as SharedProps;
        i18n.global.locale.value = shared.locale ?? 'ar';

        createApp({ render: () => h(App, props) })
            .use(plugin)
            .use(i18n)
            .mount(el);
    },
    progress: { color: 'var(--color-accent)' },
});
