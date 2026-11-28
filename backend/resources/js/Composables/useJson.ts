/**
 * Small fetch wrapper for the dashboard's JSON endpoints (calendar, comboboxes). Sends the
 * session's XSRF token and returns the API envelope; never throws for HTTP errors.
 */
export interface Envelope<T> {
    ok: boolean;
    status: number;
    data: T;
    code?: string;
    message?: string;
    errors?: Record<string, string[]>;
}

function xsrf(): string {
    const cookie = document.cookie.split('; ').find((c) => c.startsWith('XSRF-TOKEN='));
    return cookie ? decodeURIComponent(cookie.split('=')[1] ?? '') : '';
}

export async function json<T>(method: 'GET' | 'POST' | 'PUT' | 'DELETE', url: string, body?: unknown): Promise<Envelope<T>> {
    try {
        const res = await fetch(url, {
            method,
            credentials: 'same-origin',
            headers: { Accept: 'application/json', 'Content-Type': 'application/json', 'X-Requested-With': 'XMLHttpRequest', 'X-XSRF-TOKEN': xsrf() },
            body: body === undefined ? undefined : JSON.stringify(body),
        });
        const payload = (await res.json().catch(() => ({}))) as { data?: T; code?: string; message?: string; errors?: Record<string, string[]> };
        return { ok: res.ok, status: res.status, data: payload.data as T, code: payload.code, message: payload.message, errors: payload.errors };
    } catch {
        return { ok: false, status: 0, data: undefined as T, code: 'NETWORK' };
    }
}

export function query(params: Record<string, string | string[] | null | undefined>): string {
    const q = new URLSearchParams();
    for (const [k, v] of Object.entries(params)) {
        if (v === null || v === undefined || v === '') continue;
        if (Array.isArray(v)) v.forEach((x) => q.append(`${k}[]`, x));
        else q.append(k, v);
    }
    return q.toString();
}
