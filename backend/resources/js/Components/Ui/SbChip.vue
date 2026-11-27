<script setup lang="ts">
import { X } from 'lucide-vue-next';
import { useI18n } from 'vue-i18n';

withDefaults(defineProps<{ selected?: boolean; removable?: boolean; disabled?: boolean }>(), { selected: false, removable: false, disabled: false });
const emit = defineEmits<{ click: []; remove: [] }>();
const { t } = useI18n();
</script>

<template>
    <span
        class="inline-flex h-9 items-center gap-1.5 rounded-pill border px-3.5 text-label transition-colors duration-fast"
        :class="[selected ? 'border-primary bg-primary text-on-primary' : 'border-border bg-surface text-text-primary hover:bg-surface-muted', disabled ? 'pointer-events-none opacity-50' : '']"
    >
        <button type="button" class="inline-flex items-center gap-1.5" :aria-pressed="selected" :disabled="disabled" @click="emit('click')"><slot /></button>
        <button v-if="removable" type="button" class="-me-1 inline-flex h-6 w-6 items-center justify-center rounded-pill hover:bg-black/10" :aria-label="t('ui.common.remove')" @click="emit('remove')">
            <X class="h-3.5 w-3.5" aria-hidden="true" />
        </button>
    </span>
</template>
