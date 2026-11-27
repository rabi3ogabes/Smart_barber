# Phase 1 — Foundation / الأساس

الهدف: هيكل كامل يعمل — تسجيل دخول، عزل الصالونات، الصلاحيات، العربية/الإنجليزية، التصميم.

```
Implement PHASE 1 — FOUNDATION only, following the approved Phase 0 docs.

Backend (backend/):
- New Laravel app, MySQL, Redis, Horizon, Reverb, Sanctum, Pest, Larastan, Pint, Scribe.
- Core/: CurrentSalon + ResolveSalon middleware (subdomain for web, user membership for API),
  BelongsToSalon trait with global scope and auto-fill of salon_id on create,
  Money value object + cast, ULID public ids, ApiResponse envelope + exception handler
  mapping to error codes, Idempotency middleware (idempotency_keys table, 24h TTL),
  audit_logs + Auditable trait, settings (salon-level key/value), salon_features table +
  Feature::enabled($salon, 'ai_studio') helper.
- Tables: salons, branches, users, salon_user (membership + status), roles/permissions
  (spatie, teams = salon), audit_logs, settings, salon_features, idempotency_keys, devices.
- Auth: owner/staff email+password with 2FA (TOTP) for owner/admin; customer phone OTP
  (OtpProvider interface + log driver for dev); login throttling; token refresh for mobile.
- Seeders: Super Admin, two demo salons (A and B) each with an owner, 1 branch, 1 barber.
- Tests: auth flows, and a TenantIsolation test suite that, for every tenant model and
  endpoint, proves user of Salon A gets 404 on Salon B records.

Dashboard (Inertia + Vue 3 + TS + Tailwind):
- Design tokens from design-system.md as CSS variables, light/dark, AR/EN with dir switch.
- App shell: collapsible sidebar (all menu items from the spec, permission-filtered,
  badge slots, tooltips when collapsed, moves to the right in Arabic), header with branch
  selector, search, Command Palette (Ctrl/Cmd+K) with navigation commands, notifications
  bell (empty), language + theme switch, profile menu. Mobile: drawer + bottom nav.
- Base components: Button, Input, Select, Combobox, Modal, Drawer, Sheet, Toast, Tabs,
  Badge, Chip, DataTable (responsive → cards), Skeleton, EmptyState, ErrorState, ConfirmDialog.
- Pages: login, 2FA, forgot password, empty Dashboard with KPI bento placeholders,
  a /dev/components page showing every component in AR and EN.

Flutter (apps/customer, apps/staff, packages/sb_core, sb_ui, sb_api):
- Workspace, flavors dev/staging/prod, Riverpod, go_router, Dio + interceptors, Freezed.
- sb_ui: tokens, light/dark ThemeData, Arabic + English fonts, base widgets + states.
- Customer app: splash, language pick, phone + OTP login, bottom nav shell
  (Home, Book, AI Studio, Appointments, Profile) with placeholder screens.
- Staff app: email login, shell (Today, Queue, Customers, POS, Me) placeholders.
- Golden tests of the shell in AR-RTL and EN-LTR, light and dark.

Do not build salons/branches CRUD, services or bookings yet.
Finish with the Phase Report and the exact commands to run everything locally.
```
