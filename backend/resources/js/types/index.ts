export type Locale = 'ar' | 'en';

export interface MenuItem {
    key: string;
    label: string;
    icon: string;
    href: string;
    badge: string | null;
    available: boolean;
}

export interface MenuGroup {
    key: string;
    label: string;
    icon: string;
    items: MenuItem[];
}

export interface BranchOption {
    id: string;
    name: string;
}

export interface StaffAuth {
    type: 'staff';
    user: { id?: string; name: string; email: string | null; two_factor_enabled?: boolean };
    roles?: string[];
    permissions: string[];
    features?: string[];
    menu: MenuGroup[];
    branches?: BranchOption[];
    currentBranch?: string | null;
}

export interface PlatformAuth {
    type: 'platform';
    user: { name: string; email: string };
}

export interface SharedProps {
    locale: Locale;
    dir: 'rtl' | 'ltr';
    appName: string;
    flash: { success: string | null; error: string | null };
    salon: { id: string; slug: string; name: string; currency: string } | null;
    auth: StaffAuth | PlatformAuth | null;
    errors: Record<string, string>;
    [key: string]: unknown;
}
