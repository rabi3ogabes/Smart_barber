<script setup lang="ts">
import Cropper from 'cropperjs';
import 'cropperjs/dist/cropper.css';
import { nextTick, onBeforeUnmount, ref, watch } from 'vue';
import { useI18n } from 'vue-i18n';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbModal from '@/Components/Ui/SbModal.vue';

/**
 * Pick → crop (fixed aspect) → emits a JPEG Blob. The server validates the result again.
 */
const props = withDefaults(defineProps<{ aspect?: number; width?: number; busy?: boolean }>(), { aspect: 4 / 3, width: 1200, busy: false });
const emit = defineEmits<{ cropped: [blob: Blob] }>();
const { t } = useI18n();

const open = ref(false);
const src = ref<string | null>(null);
const img = ref<HTMLImageElement | null>(null);
const input = ref<HTMLInputElement | null>(null);
let cropper: Cropper | null = null;

const pick = (): void => input.value?.click();
const onFile = (e: Event): void => {
    const file = (e.target as HTMLInputElement).files?.[0];
    (e.target as HTMLInputElement).value = '';
    if (!file) return;
    if (src.value) URL.revokeObjectURL(src.value);
    src.value = URL.createObjectURL(file);
    open.value = true;
};

watch(open, async (v) => {
    cropper?.destroy();
    cropper = null;
    if (!v) return;
    await nextTick();
    if (img.value) cropper = new Cropper(img.value, { aspectRatio: props.aspect, viewMode: 1, autoCropArea: 1, background: false });
});

const confirm = (): void => {
    cropper
        ?.getCroppedCanvas({ width: props.width, height: Math.round(props.width / props.aspect), imageSmoothingQuality: 'high' })
        .toBlob((blob) => {
            if (blob) emit('cropped', blob);
            open.value = false;
        }, 'image/jpeg', 0.9);
};

onBeforeUnmount(() => {
    cropper?.destroy();
    if (src.value) URL.revokeObjectURL(src.value);
});
defineExpose({ pick });
</script>

<template>
    <input ref="input" type="file" accept="image/jpeg,image/png,image/webp" class="sr-only" tabindex="-1" @change="onFile" />
    <SbModal v-model:open="open" :title="t('ui.catalog.crop_title')" :description="t('ui.catalog.crop_hint')" size="lg">
        <div class="max-h-[60vh] overflow-hidden rounded-input bg-surface-muted" dir="ltr">
            <img v-if="src" ref="img" :src="src" :alt="t('ui.catalog.crop_title')" class="block max-w-full" />
        </div>
        <template #footer>
            <SbButton variant="secondary" @click="open = false">{{ t('ui.common.cancel') }}</SbButton>
            <SbButton :loading="busy" @click="confirm">{{ t('ui.catalog.crop_confirm') }}</SbButton>
        </template>
    </SbModal>
</template>
