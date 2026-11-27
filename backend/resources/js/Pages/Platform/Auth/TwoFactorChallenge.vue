<script setup lang="ts">
import Page from '@/Pages/Auth/TwoFactorChallenge.vue';

/* Super Admin console reuses the dashboard auth screens; form actions are relative to admin.{domain}. */
defineOptions({ inheritAttrs: false });
</script>

<template>
    <Page v-bind="$attrs" />
</template>
