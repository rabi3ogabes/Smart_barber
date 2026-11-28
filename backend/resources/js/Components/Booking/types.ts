import type { MoneyDto } from '@/Components/Catalog/types';

export type L = { ar?: string | null; en?: string | null };
export type Status = 'pending' | 'confirmed' | 'arrived' | 'in_service' | 'completed' | 'cancelled' | 'no_show';
export interface BookingDto {
    id: string;
    status: Status;
    source: string;
    starts_at: string;
    ends_at: string;
    blocked_until: string;
    barber: { id: string; name: L } | null;
    customer: { id: string; name: string; phone: string; visits: number; no_shows: number } | null;
    items: { type: string; service: string | null; name: L; duration_minutes: number; total: MoneyDto }[];
    total: MoneyDto;
    tax: MoneyDto;
    customer_notes: string | null;
    internal_notes: string | null;
    cancel_reason: string | null;
    reschedule_count: number;
    actions: string[];
    history: { from: string | null; to: string; at: string; actor: string | null; reason: string | null; rescheduled: boolean; meta: Record<string, unknown> | null }[] | null;
}
export interface BarberOpt {
    id: string;
    name: string;
    is_bookable: boolean;
}
export interface ServiceOpt {
    id: string;
    name: L;
    category: L | null;
    duration_minutes: number;
    price: MoneyDto;
}

/** Status colours from design tokens only (rule 8). */
export const statusClass: Record<Status, string> = {
    pending: 'bg-warning-soft border-warning text-text-primary',
    confirmed: 'bg-accent-soft border-accent text-text-primary',
    arrived: 'bg-info-soft border-info text-text-primary',
    in_service: 'bg-primary border-primary text-on-primary',
    completed: 'bg-success-soft border-success text-text-primary',
    cancelled: 'bg-surface-muted border-border text-text-secondary line-through',
    no_show: 'bg-error-soft border-error text-text-primary',
};
export const statusTone: Record<Status, 'warning' | 'accent' | 'info' | 'success' | 'neutral' | 'error'> = {
    pending: 'warning',
    confirmed: 'accent',
    arrived: 'info',
    in_service: 'accent',
    completed: 'success',
    cancelled: 'neutral',
    no_show: 'error',
};
