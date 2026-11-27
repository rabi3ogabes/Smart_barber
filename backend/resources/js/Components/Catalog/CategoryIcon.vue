<script setup lang="ts">
import { Baby, Brush, Crown, Droplet, Flame, Scissors, Smile, Sparkles, SprayCan, Star } from 'lucide-vue-next';
import { computed } from 'vue';

const props = defineProps<{ name: string | null }>();
const map = { scissors: Scissors, sparkles: Sparkles, droplet: Droplet, 'spray-can': SprayCan, baby: Baby, crown: Crown, brush: Brush, smile: Smile, flame: Flame, star: Star } as const;
const icon = computed(() => map[(props.name ?? 'scissors') as keyof typeof map] ?? Scissors);
</script>

<template>
    <component :is="icon" aria-hidden="true" />
</template>
