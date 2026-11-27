# ADR-005 — Dashboard stack: Inertia + Vue 3 + TypeScript in the Laravel app

Status: Proposed · Phase 0

## Context
The salon dashboard is a large, permission-heavy admin UI (calendar, POS, tables, settings) used on desktops and tablets, in Arabic and English. The team is small and one Laravel app also serves the mobile API.

## Decision
- Inertia.js 2 + Vue 3 (`<script setup lang="ts">`) + Tailwind CSS, built with Vite, served by the same Laravel app on `{slug}.smartbarber.app`.
- Pages call Laravel controllers that call the **same Actions** as the API. Interactive parts (calendar drag, POS cart, combobox search) call small JSON endpoints on the web guard (session + CSRF), not `/api/v1`. The mobile API stays a clean contract for the apps.
- Shared UI in `resources/js/Components`, layouts in `Layouts`, i18n via `vue-i18n` with `lang/{ar,en}` exported to JSON at build, so there is one translation source.
- Design tokens are CSS variables generated from `design-system.md`; Tailwind `theme.extend` maps to the variables; logical utilities only (an ESLint rule plus a Tailwind safelist test ban `ml-`, `mr-`, `pl-`, `pr-`, `left-`, `right-`).
- Headless primitives: Reka UI (formerly Radix Vue) for accessible dialog, drawer, combobox and menu; TanStack Table for data tables; FullCalendar (resource time-grid) **or** a custom calendar, decided in Phase 4 after a spike (FullCalendar's resource views need a paid licence).
- Permissions and enabled features are shared to the frontend as Inertia props, for **display only**. The server enforces everything.

## Consequences
- + One deploy, one auth system, no separate SPA to version against the API.
- + Server-driven routing keeps permission checks on the server.
- − The dashboard is not reusable by third parties as an API, which is fine. A public API can come later.

## Alternatives rejected
- A separate Nuxt/Next SPA on `/api/v1`: doubles auth, CORS and deploy work for no user benefit.
- Livewire/Filament: fast for CRUD, but the calendar and POS need rich client interaction, and the premium look needs full control.
