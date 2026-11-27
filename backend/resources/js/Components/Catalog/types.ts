export type L = { ar?: string | null; en?: string | null };
export interface MoneyDto {
    amount: number;
    currency: string;
    formatted: string;
}
export interface Category {
    id: string;
    name: L;
    icon: string | null;
    is_active: boolean;
    services_count: number;
}
export interface ServiceRow {
    id: string;
    category: string | null;
    name: L;
    description: L;
    image_url: string | null;
    price: MoneyDto;
    base_price: string;
    duration_minutes: number;
    buffer_minutes: number;
    tax_class: string;
    is_active: boolean;
    is_bookable_online: boolean;
    addons: string[];
    branches: { branch: string | null; is_available: boolean; price_override: string | null; price: MoneyDto | null }[];
    barbers: { barber: string; price_override: string | null; duration_override: number | null }[];
}
export interface Addon {
    id: string;
    name: L;
    price: MoneyDto;
    price_decimal: string;
    extra_minutes: number;
    tax_class: string;
    is_active: boolean;
    services: string[];
}
export interface Bundle {
    id: string;
    name: L;
    description: L;
    price: MoneyDto;
    price_decimal: string;
    regular_price: MoneyDto;
    saving: MoneyDto | null;
    duration_minutes: number;
    tax_class: string;
    is_active: boolean;
    services: string[];
}
export interface BranchOpt {
    id: string;
    name: string;
    can_price: boolean;
}
export interface BarberOpt {
    id: string;
    name: string;
    branches: string[];
    is_bookable: boolean;
}
export interface CatalogCan {
    manage: boolean;
    updatePrices: boolean;
}
