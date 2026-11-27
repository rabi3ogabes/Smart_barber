# Phase 1a — Foundation: backend + dashboard — Report

Status: **DONE**, with the limitations listed in section 9. Flutter is Phase 1b. The Phase 1 gate ("login works in both apps and dashboard") is met only after 1b.

## 1. Implemented (what a user can now do)

- **Salon staff** open `{slug}.{domain}` and sign in with email and password. A wrong salon gets the same generic error as a wrong password.
  - Owners and General Managers must set up TOTP two-factor before seeing anything else. Recovery codes are shown once.
  - Signed-in staff see the dashboard shell in Arabic (default, RTL) or English, in light or dark mode.
  - The sidebar is permission-filtered and modules from later phases are marked "Soon". The shell also has the branch selector, Command Palette (Ctrl/⌘+K), notifications bell, and language/theme/profile menus. On mobile it uses a drawer and a bottom nav.
- **Forgotten password:** a reset link by email (logged in dev). The response is the same whether or not the email exists.
- **Super Admin** signs in at `admin.{domain}` with mandatory 2FA and reaches an empty console home.
- **Customer app API:** phone + OTP sign-in creates the customer account on first login. It returns a 60-minute access token and a rotating 60-day refresh token. Reusing an old refresh token signs that login out everywhere. Profile view and update work.
- **Staff app API:** email + password → 2FA challenge (TOTP or a recovery code) → salon selection for multi-salon staff → tokens bound to one salon. Also `me`, the list of my salons, push-device registration and logout.
- **Developers** get a component gallery at `/dev/components` (local and staging only) with a live AR/EN and light/dark toggle.

## 2. Files created

Repository root:
- `design/tokens.json`: the single source of design tokens
- `docker-compose.yml`: MySQL 8, Redis and Mailpit

`backend/` (Laravel 13 app):

| Area | Files |
|---|---|
| Tenancy | `app/Core/Tenancy/{CurrentSalon,Tenancy,SalonScope,BelongsToSalon,TenantNotResolved}.php`, `Models/{Salon,Branch,SalonMembership}.php`, `Actions/{CreateSalon,AddMember}.php` |
| Identity / auth | `app/Core/Identity/Models/{User,CustomerAccount,PlatformAdmin,OtpCode,RefreshToken,PersonalAccessToken,Device}.php`, `Services/{TokenService,IssuedTokens,OtpService,TwoFactor,TwoFactorUser,ChallengeStore}.php`, `Jobs/SendOtpJob.php`, `Http/Controllers/Api/*` (6), `Http/Controllers/Web/*` (6), `Http/Resources/*` (2) |
| Platform | `app/Core/Platform/Http/Controllers/{PlatformSessionController,PlatformHomeController}.php` |
| Core services | `app/Core/Money/{Money,MoneyCast}.php`, `Http/ApiResponse.php`, `Http/WebExceptionRenderer.php`, `Exceptions/{ErrorCode,AppException,ApiExceptionRenderer}.php`, `Audit/{AuditLog,AuditLogger,Auditable}.php`, `Settings/{Setting,Settings}.php`, `Features/{Feature,SalonFeature}.php`, `Media/{Media,DiskStorageService}.php`, `Navigation/Menu.php`, `Authorization/{PermissionCatalog,SyncRolesAndPermissions,Access}.php` |
| Middleware | `app/Core/Http/Middleware/{SetLocale,ResolveSalonFromSubdomain,EnsureSalonMember,ResolveSalonFromToken,EnsureFeature,Idempotency,EnsureTwoFactorEnrolled,HandleInertiaRequests}.php` |
| Providers | `app/Core/Contracts/*` (10 interfaces), `app/Core/Providers/Fakes/*` (9 dev/test drivers), `app/Core/Providers/DatabaseUsageMeter.php`, `app/Core/CoreServiceProvider.php` |
| Config | `config/{smartbarber,auth,permission,sanctum,broadcasting,inertia,scribe,horizon,reverb,filesystems}.php`, `phpstan.neon`, `phpunit.xml`, `eslint.config.js`, `tsconfig.json`, `vite.config.ts`, `.prettierrc` |
| Database | 4 migrations (below), `database/factories/*` (5), `database/seeders/DatabaseSeeder.php` |
| Translations | `lang/{ar,en}.json` (210 UI keys, shared by Laravel and Vue), `lang/{ar,en}/{errors,messages}.php`, `lang/ar/{validation,passwords,auth}.php` |
| Dashboard | `resources/js/app.ts`, `i18n.ts`, `types/`, `Composables/` (4), `Components/Ui/` (17 components + icon map), `Components/Layout/` (3), `Layouts/{AppLayout,AuthLayout}.vue`, `Pages/` (Welcome, Error, Dashboard, Auth ×6, Platform ×5, Dev/Components), `resources/css/app.css`, `resources/views/app.blade.php` |
| Scripts | `scripts/build-tokens.mjs`, `scripts/check-rtl.mjs`, `scripts/check-i18n.mjs` |
| Tests | `tests/TestCase.php`, `tests/Pest.php`, `tests/Unit/*` (2), `tests/Feature/{Auth,Core,Tenancy}/*` (8), `tests/Architecture/ArchitectureTest.php`, `tests/Support/CountBranchesJob.php` |

## 3. Files modified

- `docs/architecture/modules.md`: the `Salon`, `Branch` and `SalonMembership` models and the `CreateSalon`/`AddMember` actions live in Core, because tenancy needs them. The Salon module manages them from Phase 2.
- `docs/architecture/permissions.md`:
  - Roles are platform-wide templates with per-salon assignments, not copies per salon.
  - `timeoff.request` is "own" for Branch Manager and Receptionist.
- `docs/architecture/erd.md`: added `refresh_tokens` and `personal_access_tokens.refresh_family`.
- `docs/architecture/api-map.md`: staff sign-in steps return 409 envelopes with a code. Staff devices register under `/staff/devices`.
- `docs/architecture/adr/001-tenancy.md`: queue tenancy uses payload hooks instead of job middleware, which would run too late for `SerializesModels`.
- `docs/architecture/adr/005-dashboard-stack.md`: TanStack Table is deferred; there is a small in-house `SbDataTable` for now.

## 4. Migrations

| Migration | Tables |
|---|---|
| `000100_create_core_identity_tables` | `salons`, `branches` (Phase 1 columns only), `users`, `password_reset_tokens`, `sessions`, `platform_admins`, `customer_accounts`, `otp_codes`, `salon_user`, `salon_user_branches` |
| `000200_create_permission_tables` | spatie tables with teams on `salon_id` |
| `000300_create_tokens_tables` | `personal_access_tokens` (+ `salon_id`, `refresh_family`), `refresh_tokens` |
| `000400_create_core_platform_tables` | `audit_logs`, `settings`, `salon_features`, `idempotency_keys`, `devices`, `media`, `usage_records` |

The framework's own `cache` and `jobs` migrations are kept.

## 5. API endpoints (`/api/v1`)

| Method | Path | Auth | Notes |
|---|---|---|---|
| GET | `meta/app-config` | public | |
| POST | `customer/auth/otp`, `customer/auth/otp/verify`, `customer/auth/refresh` | public | OTP: 3 sends per 15 min, a 60 s resend gap, 5 attempts |
| POST | `customer/auth/logout`; GET/PATCH `customer/me`; POST/DELETE `devices` | customer | |
| POST | `staff/auth/login`, `staff/auth/2fa`, `staff/auth/select-salon`, `staff/auth/refresh` | public | |
| POST | `staff/auth/logout`; GET `staff/me`, `staff/me/salons`; POST/DELETE `staff/devices` | staff + salon from token | |

Dashboard (web): `login`, `two-factor/challenge`, `two-factor/setup`, `forgot-password`, `reset-password`, `logout`, `locale`, `branch`, `/` (`dashboard.view`) and `dev/components`. The console uses the same auth routes under `admin.{domain}`, plus `/`.

The `idempotent` route middleware is built and tested, but no Phase 1 endpoint needs it yet. Booking and payment endpoints will use it from Phase 4.

## 6. Screens

| Screen | Notes |
|---|---|
| Login | Split layout with a brand panel |
| Two-factor challenge | Accepts a TOTP or a recovery code |
| Two-factor setup | QR code and manual key |
| Recovery codes | Copy button |
| Forgot / reset password | |
| Dashboard | Shell with KPI bento placeholders, today's schedule empty state, setup checklist |
| Component gallery | Every base component, with AR/EN and light/dark toggles |
| Console login and home | |
| Error pages | 403, 404, 429, 500, 503 |
| Root-domain welcome page | |

These screens were checked with Playwright screenshots, with no console errors:
- Desktop: Arabic light, Arabic dark, English light.
- Mobile at 390 px: the shell and the drawer.

That check found and fixed two layout bugs: the auth layout grid row and the mobile carousel gutter. No golden or screenshot files are committed; visual regression tests start in Phase 1b for Flutter.

KPI tiles show "—" with "Available with Analytics". No number is invented (rule 10).

## 7. Tests and quality gates

The full suite takes about 40 s on MySQL 8.0.

| Gate | Result |
|---|---|
| `vendor/bin/pint --test` | passed |
| `vendor/bin/phpstan analyse` (Larastan level 6, `app` `database` `routes`) | 0 errors |
| `php vendor/bin/pest` | **74 tests, 557 assertions, all passing** |
| `npm run lint` (ESLint incl. no bare template strings, RTL logical-direction check, AR/EN key parity) | passed |
| `npm run build` (vue-tsc + Vite) | passed; pages are code-split (main chunk 290 kB / 97 kB gzip) |
| `flutter analyze`, `flutter test`, app builds | not applicable (Phase 1b) |

What the tests cover:
- **Customer OTP:** happy path, hashed storage, attempt lockout, expiry, resend and send limits, Arabic field errors, refresh rotation and reuse detection, expired access tokens, guard separation, logout, profile update.
- **Staff API:**
  - Sign-in: single and multi-salon login, generic errors and throttling, selecting a foreign salon, mandatory 2FA enrolment, TOTP replay protection, single-use recovery codes.
  - Access: deactivated membership (access and refresh), suspended salon, devices.
- **Dashboard and console:** login, the permission-filtered menu, non-member refusal, cross-salon session kick, deactivated member, forced 2FA enrolment, password reset, locale and direction switch, branch switch scope, gallery hidden in production, translated error page, console 2FA, staff kept out of the console and the console session kept out of salons.
- **Tenancy:**
  - Scope behaviour: fail-closed scope, cross-tenant write and move refused, an isolation dataset over every tenant model, per-salon settings, feature gating with expiry.
  - Queued jobs restore the salon and fail closed without one (run on the real database queue).
- **Route × role matrix:** generated from `PermissionCatalog` for every `can:` route.
- **Idempotency:** required header, replay, key reused with a different body, in progress, released after 5xx, per-actor keys, 24 h expiry, prune.
- **Other units:** Money (QAR and KWD scales, rounding, allocation, cast), permission catalog integrity, media storage.
- **Architecture:** every model is tenant-scoped or allow-listed with a reason, `salon_id` is never fillable, Core never depends on Modules, no debug calls.

## 8. Security checks

- **Tenant isolation:**
  - The tenant comes only from the subdomain (web) or the token's `salon_id` (staff API). No endpoint reads a client `salon_id`.
  - Scopes fail closed. Route bindings use `public_id` through the scoped query.
- **Auth:**
  - OTP codes are HMAC-hashed and encrypted on the queue.
  - Refresh tokens are hashed, single-use, and revoke their whole family on reuse. Challenge and selection tokens are single-use, expire after 5 minutes, and allow at most 5 failures.
  - TOTP has replay protection. Recovery codes are single-use. 2FA secrets and codes are encrypted at rest.
  - Login is throttled per email+IP and per IP.
- **Policies:** permissions are checked with spatie teams; the route × role test covers every guarded route. Branch scope is enforced for the branch switch.
- **Validation and rate limits:**
  - Every input is validated with FormRequest-style rules.
  - Named rate limiters: `api` (per user and per salon), `login`, `otp`, `refresh`.
- **Errors:** raw exceptions and SQL never reach clients. The API uses coded envelopes and the dashboard uses translated error pages.
- **Audit:** logins, 2FA enrolment, password reset, membership changes and role changes are written to `audit_logs`, which is append-only.

## 9. Known limitations and tech debt

- **Horizon:** the dashboard gate (`viewHorizon`) is closed in non-local environments; who may see it is decided in Phase 15.
- **Reverb:** configured, but only the `customer.{id}` channel exists. Salon channels come in Phase 4, and nothing broadcasts yet.
- **Branch selector:** the choice is stored in the session, but no data is filtered by it yet (no branch-scoped data exists).
- **Command palette:** navigation only. Global search opens the palette.
- **Notifications bell:** empty until Phase 11.
- **Arabic validation:** covers the rules used so far; other rules fall back to English until they are added.
- **Scribe API docs:** generated locally (`php artisan scribe:generate`) and not committed. They are served at `/docs/api` outside production only.
- **Custom domains:** `salons.custom_domain` exists, but resolution is subdomain-only (spec-review item 20).
- **phpstan download:** in this cloud session it had to be installed from a git clone, because GitHub zip downloads were blocked. `composer.lock` is standard, and a normal `composer install` works anywhere.
- **Dev database:** `.env.example` targets a local MySQL; tests need the `smartbarber_test` database (created by `docker compose` or by hand).

## 10. How to run, seed and demo

See `backend/README.md`. In short:

```bash
docker compose up -d
cd backend && cp .env.example .env && composer install && php artisan key:generate
npm install && php artisan migrate:fresh --seed && npm run build && php artisan serve
```

Then open `http://salon-a.localhost:8000`. The demo users are `owner.a@smartbarber.test`, `manager.a@smartbarber.test` and `barber.a@smartbarber.test` (and the same for salon B), plus `admin@smartbarber.test` at `http://admin.localhost:8000`. Every password is `Password123!`.

## 11. What remains, and what the next phase needs

- **Phase 1b (Flutter)** needs:
  - The Phase 1 API rows (all implemented).
  - The error codes in `App\Core\Exceptions\ErrorCode` and `lang/*/errors.php`.
  - The token lifecycle: 60-minute access token, rotating refresh token, `REFRESH_TOKEN_REUSED` meaning sign in again.
  - `design/tokens.json` for `sb_ui`.
- **Phase 2** builds on:
  - `CreateSalon`/`AddMember` (invitation acceptance calls `AddMember`).
  - The `Settings` service for the booking policy.
  - `Access::branchIds()` for branch scoping.
  - The `TenantIsolation` dataset and the route × role matrix, which must be extended with every new model and route.

## 12. Decisions made

ADR-001 to 006 were applied as accepted, with the documented adjustments in section 3:
- queue tenancy via payload hooks;
- roles as shared templates;
- Salon and Branch models in Core;
- TanStack Table deferred.

No new ADR was needed. None of these changes the approved schema shape, tenancy, auth or money decisions.
