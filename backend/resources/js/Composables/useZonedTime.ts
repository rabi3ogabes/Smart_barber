/**
 * Branch-timezone helpers. The server stores UTC; the calendar lays out by the branch's wall clock.
 */
export function zonedParts(iso: string | Date, timeZone: string): { date: string; minutes: number } {
    const d = typeof iso === 'string' ? new Date(iso) : iso;
    const parts = new Intl.DateTimeFormat('en-CA', { timeZone, year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hourCycle: 'h23' }).formatToParts(d);
    const get = (t: string): string => parts.find((p) => p.type === t)?.value ?? '00';
    return { date: `${get('year')}-${get('month')}-${get('day')}`, minutes: Number(get('hour')) * 60 + Number(get('minute')) };
}

/** UTC ISO for a branch-local date and minutes after midnight. */
export function zonedToUtc(date: string, minutes: number, timeZone: string): string {
    const [y, m, d] = date.split('-').map(Number) as [number, number, number];
    const guess = Date.UTC(y, m - 1, d, Math.floor(minutes / 60), minutes % 60);
    const local = zonedParts(new Date(guess), timeZone);
    const [ly, lm, ld] = local.date.split('-').map(Number) as [number, number, number];
    const offset = Date.UTC(ly, lm - 1, ld, Math.floor(local.minutes / 60), local.minutes % 60) - guess;
    return new Date(guess - offset).toISOString().replace('.000Z', 'Z');
}

export function addDays(date: string, days: number): string {
    const d = new Date(`${date}T12:00:00Z`);
    d.setUTCDate(d.getUTCDate() + days);
    return d.toISOString().slice(0, 10);
}

export function hhmm(minutes: number): string {
    return `${String(Math.floor(minutes / 60)).padStart(2, '0')}:${String(minutes % 60).padStart(2, '0')}`;
}
