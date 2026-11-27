<script setup lang="ts">
import Page from '@/Pages/Auth/TwoFactorSetup.vue';

/* Super Admin console reuses the dashboard auth screens; form actions are relative to admin.{domain}. */
defineProps<{ qr: string; secret: string; required: boolean }>();
</script>

<template>
    <Page :qr="qr" :secret="secret" :required="required" />
</template>
