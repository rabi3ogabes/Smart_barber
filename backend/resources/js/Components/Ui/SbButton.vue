<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
import { LoaderCircle } from 'lucide-vue-next';
import { computed } from 'vue';

type Variant = 'primary' | 'secondary' | 'ghost' | 'danger' | 'accent';
type Size = 'sm' | 'md' | 'lg';

const props = withDefaults(
    defineProps<{
        variant?: Variant;
        size?: Size;
        type?: 'button' | 'submit' | 'reset';
        href?: string;
        loading?: boolean;
        disabled?: boolean;
        block?: boolean;
        iconOnly?: boolean;
        label?: string;
    }>(),
    { variant: 'primary', size: 'md', type: 'button', href: undefined, loading: false, disabled: false, block: false, iconOnly: false, label: undefined },
);

const variants: Record<Variant, string> = {
    primary: 'bg-primary text-on-primary hover:opacity-90 shadow-sm',
    accent: 'bg-accent text-on-primary hover:opacity-90 shadow-sm dark:text-primary',
    secondary: 'bg-surface text-text-primary border border-border hover:bg-surface-muted',
    ghost: 'bg-transparent text-text-primary hover:bg-surface-muted',
    danger: 'bg-error text-white hover:opacity-90 shadow-sm',
};

const sizes: Record<Size, string> = {
    sm: 'h-9 px-3 text-label gap-1.5',
    md: 'h-12 px-5 text-button gap-2',
    lg: 'h-14 px-6 text-button gap-2',
};

const iconSizes: Record<Size, string> = { sm: 'h-9 w-9', md: 'h-12 w-12', lg: 'h-14 w-14' };

const classes = computed(() => [
    'inline-flex items-center justify-center rounded-input font-semibold select-none whitespace-nowrap',
    'transition-[background-color,opacity,box-shadow] duration-fast ease-sb',
    'disabled:cursor-not-allowed disabled:opacity-50',
    variants[props.variant],
    props.iconOnly ? iconSizes[props.size] : sizes[props.size],
    props.block ? 'w-full' : '',
]);
</script>

<template>
    <Link v-if="href && !disabled" :href="href" :class="classes" :aria-label="label">
        <slot name="icon" />
        <slot />
    </Link>
    <button v-else :type="type" :class="classes" :disabled="disabled || loading" :aria-busy="loading" :aria-label="label">
        <LoaderCircle v-if="loading" class="h-4 w-4 animate-spin" aria-hidden="true" />
        <slot v-else name="icon" />
        <slot />
    </button>
</template>
