<script setup lang="ts">
import { TabsContent, TabsIndicator, TabsList, TabsRoot, TabsTrigger } from 'reka-ui';

defineProps<{ tabs: { value: string; label: string }[] }>();
const model = defineModel<string>();
</script>

<template>
    <TabsRoot v-model="model" class="flex flex-col gap-4">
        <TabsList class="relative flex gap-1 overflow-x-auto border-b border-border">
            <TabsIndicator class="absolute bottom-0 h-0.5 w-[var(--reka-tabs-indicator-size)] translate-x-[var(--reka-tabs-indicator-position)] rounded-pill bg-accent transition-[width,transform] duration-base ease-sb" />
            <TabsTrigger
                v-for="tab in tabs"
                :key="tab.value"
                :value="tab.value"
                class="h-11 shrink-0 px-4 text-label text-text-secondary transition-colors hover:text-text-primary data-[state=active]:font-semibold data-[state=active]:text-text-primary"
            >
                {{ tab.label }}
            </TabsTrigger>
        </TabsList>
        <TabsContent v-for="tab in tabs" :key="tab.value" :value="tab.value" class="focus:outline-none">
            <slot :name="tab.value" />
        </TabsContent>
    </TabsRoot>
</template>
