# Phase 1a — Foundation: backend + dashboard / الأساس: الخادم ولوحة التحكم

الهدف: الخادم يعمل — تسجيل دخول، عزل الصالونات، الصلاحيات، العربية/الإنجليزية، وهيكل لوحة التحكم.

```
Implement PHASE 1a — FOUNDATION (backend + dashboard) only, following the ACCEPTED
Phase 0 docs: docs/architecture/erd.md (Core section), modules.md (Core), permissions.md,
api-map.md (Phase 1 rows), adr/001–006 and spec-review.md (decisions + answered defaults).
Do not build Flutter in this session — that is Phase 1b.

Backend (backend/):
- New Laravel app (latest stable), MySQL 8, Redis, Horizon, Reverb, Sanctum, Pest,
  Larastan (level 6+), Pint, Scribe, spatie/laravel-permission (teams = salon_id),
  spatie/laravel-translatable, brick/money. Docker Compose for local MySQL + Redis.
- Core/ per ADR-001: CurrentSalon singleton, ResolveSalon middleware (subdomain for web,
  token salon_id for staff API), BelongsToSalon trait with FAIL-CLOSED global scope and
  salon_id auto-fill (never fillable), SetsCurrentSalon job middleware, ULID public_id
  trait + route binding through the scoped query (foreign id → 404).
- Money value object + cast per ADR-003 (currency-aware scale, no floats).
- ApiResponse envelope + exception handler mapping to the error codes in api-map.md.
- Idempotency middleware per ADR-004 (processing/completed states, request hash,
  IDEMPOTENCY_KEY_REUSED, IDEMPOTENCY_IN_PROGRESS, 24h TTL + prune command).
- audit_logs + Auditable trait; settings (morph salon/branch); salon_features +
  Feature::enabled($salon, 'ai_studio') + `feature:{key}` middleware; media table +
  StorageService contract with a local fake; provider contracts with fakes
  (OtpProvider log driver, SmsProvider, PushProvider, NotificationChannel, UsageMeter).
- Tables (Phase 1 subset of erd.md): salons, branches (minimal columns), users,
  customer_accounts, otp_codes, platform_admins, salon_user, salon_user_branches,
  spatie tables, personal_access_tokens + salon_id, audit_logs, settings, salon_features,
  idempotency_keys, devices, media.
- Auth per ADR-002 and the Phase 1 rows of api-map.md: staff email+password, TOTP 2FA
  mandatory for Owner/GM, salon selection for multi-salon users, salon-bound tokens;
  customer phone OTP (hashed codes, attempt + send limits); short access + rotating
  refresh tokens with reuse detection; platform guard with mandatory 2FA (login + empty
  home only — console is Phase 14). Login throttling everywhere.
- Roles: the 8 template roles and all permission keys from permissions.md, seeded and
  copied into each new salon.
- Seeders: Super Admin (platform_admins), salons A and B each with an owner, 1 branch and
  a staff member holding the Barber role (barber profile row comes in Phase 2).
- Tests: auth flows (OTP, 2FA, refresh rotation + reuse, salon selection), Money,
  idempotency, an Architecture test (every model tenant-aware or allow-listed; module
  layering), and a TenantIsolation dataset proving a Salon A user gets 404 on every
  Salon B record and endpoint. A route × role permission dataset generated from
  permissions.md for every route that exists so far.

Dashboard (Inertia + Vue 3 + TS + Tailwind) per ADR-005 and design-system.md:
- Tokens as CSS variables, light/dark, AR (default) / EN with global dir switch; fonts
  Inter, Fraunces (hero only), IBM Plex Sans Arabic; ESLint rule banning ml-/mr-/pl-/pr-/
  left-/right- utilities.
- App shell: collapsible sidebar (all menu items from the spec, permission-filtered,
  badge slots, tooltips when collapsed, right side in Arabic), header with branch
  selector, search, Command Palette (Ctrl/Cmd+K, navigation commands only), empty
  notifications bell, language + theme switch, profile menu. Mobile: drawer + bottom nav.
- Base components: Button, Input, Select, Combobox, Modal, Drawer, Sheet, Toast, Tabs,
  Badge, Chip, DataTable (responsive → cards), Skeleton, EmptyState, ErrorState,
  ConfirmDialog.
- Pages: login, 2FA, forgot password, empty Dashboard with KPI bento placeholders,
  /dev/components (local/staging only) showing every component in AR and EN.

Do not build salons/branches CRUD, services, bookings or anything in Flutter.
Before declaring done run: pint, larastan, pest, npm run build — fix every failure.
Finish with docs/phases/phase-1a.md (Phase Report) and the exact local run commands.
```
