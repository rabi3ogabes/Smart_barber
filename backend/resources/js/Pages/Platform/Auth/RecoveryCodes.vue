<script setup lang="ts">
import Page from '@/Pages/Auth/RecoveryCodes.vue';

/* Super Admin console reuses the dashboard auth screens; form actions are relative to admin.{domain}. */
defineProps<{ codes: string[] }>();
</script>

<template>
    <Page :codes="codes" />
</template>
