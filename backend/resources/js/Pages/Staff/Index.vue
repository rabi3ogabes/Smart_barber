<script setup lang="ts">
import { router, useForm } from '@inertiajs/vue3';
import { Mail, MoreHorizontal, RefreshCw, Scissors, ShieldCheck, UserPlus, Users, X } from 'lucide-vue-next';
import { computed, ref } from 'vue';
import { useI18n } from 'vue-i18n';
import SbAvatar from '@/Components/Ui/SbAvatar.vue';
import SbBadge from '@/Components/Ui/SbBadge.vue';
import SbButton from '@/Components/Ui/SbButton.vue';
import SbCheckbox from '@/Components/Ui/SbCheckbox.vue';
import SbChip from '@/Components/Ui/SbChip.vue';
import SbConfirmDialog from '@/Components/Ui/SbConfirmDialog.vue';
import SbDrawer from '@/Components/Ui/SbDrawer.vue';
import SbEmptyState from '@/Components/Ui/SbEmptyState.vue';
import SbInput from '@/Components/Ui/SbInput.vue';
import SbModal from '@/Components/Ui/SbModal.vue';
import SbTabs from '@/Components/Ui/SbTabs.vue';
import SbTextarea from '@/Components/Ui/SbTextarea.vue';
import { useDateFormat } from '@/Composables/useWeekdays';
import AppLayout from '@/Layouts/AppLayout.vue';

type L = { ar?: string | null; en?: string | null };
interface BarberProfile {
    id: string;
    display_name: L;
    bio: L;
    specialties: string[];
    years_experience: number | null;
    is_bookable: boolean;
    sort_order: number;
    photo_url: string | null;
    can_update: boolean;
    can_manage: boolean;
}
interface Member {
    id: string;
    name: string;
    email: string | null;
    phone: string | null;
    status: 'active' | 'inactive' | string;
    joined_at: string | null;
    roles: string[];
    branches: string[];
    is_me: boolean;
    barber: BarberProfile | null;
    can: { update: boolean; assignRoles: boolean; changeStatus: boolean };
}
interface Invitation { id: string; contact: string; name: string | null; roles: string[]; branches: string[]; expires_at: string; expired: boolean }

const props = defineProps<{
    members: Member[];
    invitations: Invitation[];
    branches: { id: string; name: string; is_active: boolean }[];
    assignableRoles: string[];
    salonWideRoles: string[];
    specialties: string[];
    can: { invite: boolean };
}>();
const { t, locale } = useI18n();
const { fmt } = useDateFormat();
const tr = (v: L): string => (locale.value === 'ar' ? v.ar || v.en : v.en || v.ar) ?? '';
const branchName = (id: string): string => props.branches.find((b) => b.id === id)?.name ?? '';
const roleLabel = (r: string): string => t(`ui.roles.${r}`);

// Filters
const tab = ref('active');
const search = ref('');
const tabs = computed(() => [
    { value: 'active', label: `${t('ui.staff.tab_active')} · ${props.members.filter((m) => m.status === 'active').length}` },
    { value: 'inactive', label: t('ui.staff.tab_inactive') },
    { value: 'invited', label: `${t('ui.staff.tab_invited')} · ${props.invitations.length}` },
]);
const filtered = computed(() => {
    const q = search.value.trim().toLowerCase();
    return props.members
        .filter((m) => (tab.value === 'inactive' ? m.status !== 'active' : m.status === 'active'))
        .filter((m) => !q || [m.name, m.email, m.phone].some((v) => v?.toLowerCase().includes(q)));
});

// Role + branch picker shared by invite and access forms
const needsBranches = (roles: string[]): boolean => roles.some((r) => !props.salonWideRoles.includes(r));
const toggle = (list: string[], value: string): void => {
    const i = list.indexOf(value);
    if (i === -1) list.push(value);
    else list.splice(i, 1);
};

// Invite
const inviteOpen = ref(false);
const invite = useForm({ name: '', email: '', phone: '', roles: [] as string[], branches: [] as string[] });
const openInvite = (): void => {
    invite.reset();
    invite.clearErrors();
    if (props.branches.length === 1 && props.branches[0]) invite.branches = [props.branches[0].id];
    inviteOpen.value = true;
};
const sendInvite = (): void => {
    invite
        .transform((d) => ({ ...d, name: d.name || null, email: d.email || null, phone: d.phone || null, branches: needsBranches(d.roles) ? d.branches : [] }))
        .post('/staff/invitations', { preserveScroll: true, onSuccess: () => (inviteOpen.value = false) });
};
const resend = (i: Invitation): void => router.post(`/staff/invitations/${i.id}/resend`, {}, { preserveScroll: true });
const revoking = ref<Invitation | null>(null);
const revoke = (): void => {
    if (!revoking.value) return;
    router.delete(`/staff/invitations/${revoking.value.id}`, { preserveScroll: true, onFinish: () => (revoking.value = null) });
};

// Access
const accessFor = ref<Member | null>(null);
const access = useForm({ roles: [] as string[], branches: [] as string[] });
const openAccess = (m: Member): void => {
    accessFor.value = m;
    access.defaults({ roles: [...m.roles], branches: [...m.branches] });
    access.reset();
    access.clearErrors();
};
const saveAccess = (): void => {
    if (!accessFor.value) return;
    access
        .transform((d) => ({ ...d, branches: needsBranches(d.roles) ? d.branches : [] }))
        .put(`/staff/${accessFor.value.id}/access`, { preserveScroll: true, onSuccess: () => (accessFor.value = null) });
};
const editableRoles = computed(() => {
    // Show roles the member already has even if the actor can't assign them (read-only chips).
    const current = accessFor.value?.roles ?? [];
    return Array.from(new Set([...props.assignableRoles, ...current]));
});

// Status
const statusFor = ref<Member | null>(null);
const changeStatus = (): void => {
    const m = statusFor.value;
    if (!m) return;
    router.put(`/staff/${m.id}/status`, { active: m.status !== 'active' }, { preserveScroll: true, onFinish: () => (statusFor.value = null) });
};

// Barber profile
const profileFor = ref<Member | null>(null);
const profile = useForm({
    display_name: { ar: '', en: '' },
    bio: { ar: '', en: '' } as { ar: string | null; en: string | null },
    specialties: [] as string[],
    years_experience: '' as string,
    is_bookable: true,
    sort_order: '0',
    photo: null as File | null,
});
const photoPreview = ref<string | null>(null);
const openProfile = (m: Member): void => {
    const b = m.barber;
    if (!b) return;
    profileFor.value = m;
    profile.defaults({
        display_name: { ar: b.display_name.ar ?? '', en: b.display_name.en ?? '' },
        bio: { ar: b.bio.ar ?? '', en: b.bio.en ?? '' },
        specialties: [...b.specialties],
        years_experience: b.years_experience === null ? '' : String(b.years_experience),
        is_bookable: b.is_bookable,
        sort_order: String(b.sort_order),
        photo: null,
    });
    profile.reset();
    profile.clearErrors();
    photoPreview.value = b.photo_url;
};
const pickPhoto = (e: Event): void => {
    const file = (e.target as HTMLInputElement).files?.[0] ?? null;
    profile.photo = file;
    if (file) photoPreview.value = URL.createObjectURL(file);
};
const saveProfile = (): void => {
    const b = profileFor.value?.barber;
    if (!b) return;
    profile
        .transform((d) => {
            const base: Record<string, unknown> = {
                display_name: d.display_name,
                bio: d.bio,
                specialties: d.specialties,
                years_experience: d.years_experience === '' ? null : Number(d.years_experience),
            };
            if (b.can_manage) Object.assign(base, { is_bookable: d.is_bookable, sort_order: Number(d.sort_order || 0) });
            if (d.photo) base.photo = d.photo;
            return base;
        })
        .post(`/barbers/${b.id}/profile`, { preserveScroll: true, forceFormData: true, onSuccess: () => (profileFor.value = null) });
};
const err = (f: { errors: Record<string, string> }, key: string): string | undefined => f.errors[key];

// Row menu
const menuFor = ref<string | null>(null);
</script>

<template>
    <AppLayout :title="t('nav.staff')">
        <div class="mx-auto flex max-w-6xl flex-col gap-6">
            <header class="flex flex-wrap items-end justify-between gap-4">
                <div>
                    <h2 class="text-h2">{{ t('nav.staff') }}</h2>
                    <p class="mt-1 text-body text-text-secondary">{{ t('ui.staff.subtitle') }}</p>
                </div>
                <SbButton v-if="can.invite" @click="openInvite">
                    <template #icon><UserPlus class="h-4 w-4" aria-hidden="true" /></template>
                    {{ t('ui.staff.invite') }}
                </SbButton>
            </header>

            <div class="flex flex-wrap items-center justify-between gap-3">
                <SbTabs v-model="tab" :tabs="tabs" />
                <div v-if="tab !== 'invited'" class="w-full sm:w-72">
                    <SbInput v-model="search" type="search" :placeholder="t('ui.staff.search')" />
                </div>
            </div>

            <!-- Members -->
            <section v-if="tab !== 'invited'" class="overflow-hidden rounded-card border border-border bg-surface shadow-sm">
                <SbEmptyState v-if="filtered.length === 0" :icon="Users" :title="search ? t('ui.common.no_results') : tab === 'inactive' ? t('ui.staff.empty_inactive') : t('ui.staff.empty')" />
                <table v-else class="w-full text-start text-label">
                    <thead class="hidden border-b border-border bg-surface-muted text-caption text-text-secondary md:table-header-group">
                        <tr>
                            <th scope="col" class="px-4 py-3 text-start font-medium">{{ t('ui.staff.col_member') }}</th>
                            <th scope="col" class="px-4 py-3 text-start font-medium">{{ t('ui.staff.col_roles') }}</th>
                            <th scope="col" class="px-4 py-3 text-start font-medium">{{ t('ui.staff.branches') }}</th>
                            <th scope="col" class="px-4 py-3 text-start font-medium">{{ t('ui.staff.col_status') }}</th>
                            <th scope="col" class="px-4 py-3"><span class="sr-only">{{ t('ui.staff.col_actions') }}</span></th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border">
                        <tr v-for="m in filtered" :key="m.id" class="flex flex-col gap-2 p-4 md:table-row md:p-0">
                            <td class="md:px-4 md:py-3">
                                <div class="flex items-center gap-3">
                                    <SbAvatar :name="m.name" :src="m.barber?.photo_url" />
                                    <div class="min-w-0">
                                        <p class="truncate font-medium text-text-primary">
                                            {{ m.name }} <span v-if="m.is_me" class="text-caption text-text-secondary">({{ t('ui.staff.you') }})</span>
                                        </p>
                                        <p class="truncate text-caption text-text-secondary" dir="ltr">{{ m.email ?? m.phone }}</p>
                                    </div>
                                </div>
                            </td>
                            <td class="md:px-4 md:py-3">
                                <div class="flex flex-wrap gap-1.5">
                                    <SbBadge v-for="r in m.roles" :key="r" :tone="r === 'owner' ? 'accent' : 'neutral'">{{ roleLabel(r) }}</SbBadge>
                                    <SbBadge v-if="m.barber && !m.barber.is_bookable" tone="warning">{{ t('ui.staff.not_bookable') }}</SbBadge>
                                </div>
                            </td>
                            <td class="text-text-secondary md:px-4 md:py-3">
                                {{ m.branches.length ? m.branches.map(branchName).join('، ') : t('ui.staff.all_branches') }}
                            </td>
                            <td class="md:px-4 md:py-3">
                                <SbBadge :tone="m.status === 'active' ? 'success' : 'neutral'" dot>{{ m.status === 'active' ? t('ui.common.active') : t('ui.common.inactive') }}</SbBadge>
                            </td>
                            <td class="relative md:px-4 md:py-3 md:text-end">
                                <div v-if="m.can.update || m.can.changeStatus || m.barber?.can_update" class="inline-flex">
                                    <SbButton size="sm" variant="ghost" icon-only :label="t('ui.staff.col_actions')" @click="menuFor = menuFor === m.id ? null : m.id">
                                        <MoreHorizontal class="h-4 w-4" aria-hidden="true" />
                                    </SbButton>
                                    <div v-if="menuFor === m.id" class="absolute end-4 top-12 z-20 flex min-w-48 flex-col rounded-card border border-border bg-surface p-1 shadow-lg" role="menu" @click="menuFor = null">
                                        <button v-if="m.can.update" type="button" role="menuitem" class="flex items-center gap-2 rounded-input px-3 py-2 text-start hover:bg-surface-muted" @click="openAccess(m)">
                                            <ShieldCheck class="h-4 w-4" aria-hidden="true" />{{ t('ui.staff.edit_access') }}
                                        </button>
                                        <button v-if="m.barber?.can_update" type="button" role="menuitem" class="flex items-center gap-2 rounded-input px-3 py-2 text-start hover:bg-surface-muted" @click="openProfile(m)">
                                            <Scissors class="h-4 w-4" aria-hidden="true" />{{ t('ui.staff.edit_profile') }}
                                        </button>
                                        <button v-if="m.can.changeStatus" type="button" role="menuitem" class="flex items-center gap-2 rounded-input px-3 py-2 text-start hover:bg-surface-muted" :class="m.status === 'active' ? 'text-error' : ''" @click="statusFor = m">
                                            <X class="h-4 w-4" aria-hidden="true" />{{ m.status === 'active' ? t('ui.staff.deactivate') : t('ui.staff.reactivate') }}
                                        </button>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </section>

            <!-- Invitations -->
            <section v-else class="overflow-hidden rounded-card border border-border bg-surface shadow-sm">
                <SbEmptyState v-if="invitations.length === 0" :icon="Mail" :title="t('ui.staff.no_invitations')" :description="can.invite ? t('ui.staff.no_invitations_hint') : undefined" />
                <ul v-else class="divide-y divide-border">
                    <li v-for="i in invitations" :key="i.id" class="flex flex-wrap items-center justify-between gap-3 p-4">
                        <div class="min-w-0">
                            <p class="font-medium">{{ i.name || i.contact }}</p>
                            <p class="text-caption text-text-secondary"><span dir="ltr">{{ i.contact }}</span> · {{ i.roles.map(roleLabel).join('، ') }}<template v-if="i.branches.length"> · {{ i.branches.map(branchName).join('، ') }}</template></p>
                        </div>
                        <div class="flex items-center gap-2">
                            <SbBadge :tone="i.expired ? 'error' : 'info'">{{ i.expired ? t('ui.staff.expired') : t('ui.staff.expires', { date: fmt(i.expires_at) }) }}</SbBadge>
                            <template v-if="can.invite">
                                <SbButton size="sm" variant="secondary" @click="resend(i)"><template #icon><RefreshCw class="h-4 w-4" aria-hidden="true" /></template>{{ t('ui.staff.resend') }}</SbButton>
                                <SbButton size="sm" variant="ghost" @click="revoking = i">{{ t('ui.staff.revoke') }}</SbButton>
                            </template>
                        </div>
                    </li>
                </ul>
            </section>
        </div>

        <!-- Invite modal -->
        <SbModal v-model:open="inviteOpen" :title="t('ui.staff.invite_title')" :description="t('ui.staff.invite_hint')" size="lg">
            <form id="invite-form" class="flex flex-col gap-4" novalidate @submit.prevent="sendInvite">
                <SbInput v-model="invite.name" :label="t('ui.staff.name')" :error="invite.errors.name" />
                <div class="grid gap-4 sm:grid-cols-2">
                    <SbInput v-model="invite.email" type="email" :label="t('ui.auth.email')" :error="invite.errors.email" ltr />
                    <SbInput v-model="invite.phone" type="tel" :label="t('ui.settings.phone')" placeholder="+97455123456" :error="invite.errors.phone" />
                </div>
                <fieldset>
                    <legend class="mb-2 text-label font-medium">{{ t('ui.staff.col_roles') }}</legend>
                    <div class="flex flex-wrap gap-2">
                        <SbChip v-for="r in assignableRoles" :key="r" :selected="invite.roles.includes(r)" @click="toggle(invite.roles, r)">{{ roleLabel(r) }}</SbChip>
                    </div>
                    <p v-if="invite.errors.roles" class="mt-2 text-caption text-error" role="alert">{{ invite.errors.roles }}</p>
                </fieldset>
                <fieldset v-if="needsBranches(invite.roles)">
                    <legend class="mb-2 text-label font-medium">{{ t('ui.staff.branches') }}</legend>
                    <div class="flex flex-wrap gap-2">
                        <SbChip v-for="b in branches.filter((x) => x.is_active)" :key="b.id" :selected="invite.branches.includes(b.id)" @click="toggle(invite.branches, b.id)">{{ b.name }}</SbChip>
                    </div>
                    <p v-if="invite.errors.branches" class="mt-2 text-caption text-error" role="alert">{{ invite.errors.branches }}</p>
                </fieldset>
            </form>
            <template #footer>
                <SbButton variant="secondary" @click="inviteOpen = false">{{ t('ui.common.cancel') }}</SbButton>
                <SbButton type="submit" form="invite-form" :loading="invite.processing">{{ t('ui.staff.send_invite') }}</SbButton>
            </template>
        </SbModal>

        <!-- Access drawer -->
        <SbDrawer :open="accessFor !== null" :title="t('ui.staff.edit_access')" :description="accessFor?.name" @update:open="(v: boolean) => !v && (accessFor = null)">
            <form id="access-form" class="flex flex-col gap-5" novalidate @submit.prevent="saveAccess">
                <fieldset>
                    <legend class="mb-2 text-label font-medium">{{ t('ui.staff.col_roles') }}</legend>
                    <div class="flex flex-wrap gap-2">
                        <SbChip v-for="r in editableRoles" :key="r" :selected="access.roles.includes(r)" :disabled="!accessFor?.can.assignRoles || !assignableRoles.includes(r)" @click="accessFor?.can.assignRoles && assignableRoles.includes(r) && toggle(access.roles, r)">{{ roleLabel(r) }}</SbChip>
                    </div>
                    <p v-if="!accessFor?.can.assignRoles" class="mt-2 text-caption text-text-secondary">{{ t('ui.staff.roles_locked') }}</p>
                    <p v-if="access.errors.roles" class="mt-2 text-caption text-error" role="alert">{{ access.errors.roles }}</p>
                </fieldset>
                <fieldset v-if="needsBranches(access.roles)">
                    <legend class="mb-2 text-label font-medium">{{ t('ui.staff.branches') }}</legend>
                    <div class="flex flex-wrap gap-2">
                        <SbChip v-for="b in branches" :key="b.id" :selected="access.branches.includes(b.id)" @click="toggle(access.branches, b.id)">{{ b.name }}</SbChip>
                    </div>
                    <p v-if="access.errors.branches" class="mt-2 text-caption text-error" role="alert">{{ access.errors.branches }}</p>
                </fieldset>
                <p class="rounded-input bg-surface-muted p-3 text-caption text-text-secondary">{{ t('ui.staff.audit_note') }}</p>
            </form>
            <template #footer>
                <SbButton variant="secondary" @click="accessFor = null">{{ t('ui.common.cancel') }}</SbButton>
                <SbButton type="submit" form="access-form" :loading="access.processing">{{ t('ui.common.save') }}</SbButton>
            </template>
        </SbDrawer>

        <!-- Barber profile drawer -->
        <SbDrawer :open="profileFor !== null" :title="t('ui.staff.edit_profile')" :description="profileFor?.name" size="lg" @update:open="(v: boolean) => !v && (profileFor = null)">
            <form id="profile-form" class="flex flex-col gap-5" novalidate @submit.prevent="saveProfile">
                <div class="flex items-center gap-4">
                    <SbAvatar :name="profileFor?.name ?? ''" :src="photoPreview" size="lg" />
                    <label class="cursor-pointer text-label font-medium text-accent hover:underline">
                        {{ t('ui.staff.change_photo') }}
                        <input type="file" accept="image/jpeg,image/png,image/webp" class="sr-only" @change="pickPhoto" />
                    </label>
                    <p v-if="err(profile, 'photo')" class="text-caption text-error" role="alert">{{ err(profile, 'photo') }}</p>
                </div>
                <div class="grid gap-4 sm:grid-cols-2">
                    <SbInput v-model="profile.display_name.ar" :label="t('ui.staff.display_name_ar')" :error="err(profile, 'display_name.ar')" required />
                    <SbInput v-model="profile.display_name.en" :label="t('ui.staff.display_name_en')" :error="err(profile, 'display_name.en')" required ltr />
                </div>
                <SbTextarea v-model="profile.bio.ar" :label="t('ui.staff.bio_ar')" :maxlength="500" :rows="3" :error="err(profile, 'bio.ar')" />
                <SbTextarea v-model="profile.bio.en" :label="t('ui.staff.bio_en')" :maxlength="500" :rows="3" :error="err(profile, 'bio.en')" />
                <fieldset>
                    <legend class="mb-2 text-label font-medium">{{ t('ui.staff.specialties') }}</legend>
                    <div class="flex flex-wrap gap-2">
                        <SbChip v-for="s in specialties" :key="s" :selected="profile.specialties.includes(s)" @click="toggle(profile.specialties, s)">{{ t(`ui.specialties.${s}`) }}</SbChip>
                    </div>
                    <p v-if="err(profile, 'specialties')" class="mt-2 text-caption text-error" role="alert">{{ err(profile, 'specialties') }}</p>
                </fieldset>
                <div class="grid gap-4 sm:grid-cols-2">
                    <SbInput v-model="profile.years_experience" inputmode="numeric" :label="t('ui.staff.years_experience')" :error="err(profile, 'years_experience')" />
                    <SbInput v-if="profileFor?.barber?.can_manage" v-model="profile.sort_order" inputmode="numeric" :label="t('ui.staff.sort_order')" :hint="t('ui.staff.sort_order_hint')" :error="err(profile, 'sort_order')" />
                </div>
                <SbCheckbox v-if="profileFor?.barber?.can_manage" v-model="profile.is_bookable" :label="t('ui.staff.bookable')" :description="t('ui.staff.bookable_hint')" />
                <p v-if="profileFor && !profileFor.barber?.can_manage" class="rounded-input bg-surface-muted p-3 text-caption text-text-secondary">{{ t('ui.staff.own_profile_note') }}</p>
                <p class="sr-only">{{ tr(profileFor?.barber?.display_name ?? {}) }}</p>
            </form>
            <template #footer>
                <SbButton variant="secondary" @click="profileFor = null">{{ t('ui.common.cancel') }}</SbButton>
                <SbButton type="submit" form="profile-form" :loading="profile.processing">{{ t('ui.common.save') }}</SbButton>
            </template>
        </SbDrawer>

        <SbConfirmDialog
            :open="statusFor !== null"
            :title="statusFor?.status === 'active' ? t('ui.staff.deactivate_title', { name: statusFor?.name }) : t('ui.staff.reactivate')"
            :description="statusFor?.status === 'active' ? t('ui.staff.deactivate_body') : undefined"
            :confirm-label="statusFor?.status === 'active' ? t('ui.staff.deactivate') : t('ui.staff.reactivate')"
            :danger="statusFor?.status === 'active'"
            @update:open="(v: boolean) => !v && (statusFor = null)"
            @confirm="changeStatus"
        />
        <SbConfirmDialog
            :open="revoking !== null"
            :title="t('ui.staff.revoke_title')"
            :description="t('ui.staff.revoke_body')"
            :confirm-label="t('ui.staff.revoke')"
            danger
            @update:open="(v: boolean) => !v && (revoking = null)"
            @confirm="revoke"
        />
    </AppLayout>
</template>
