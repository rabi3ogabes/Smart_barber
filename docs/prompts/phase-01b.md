# Phase 1b — Foundation: Flutter apps / الأساس: تطبيقات الجوال

الهدف: تطبيقا العميل والحلاق يعملان ويتصلان بالخادم — تسجيل دخول، عربي/إنجليزي، الهوية البصرية.

```
Implement PHASE 1b — FOUNDATION (Flutter) only. Phase 1a (backend + dashboard) is done:
read docs/phases/phase-1a.md, docs/architecture/flutter.md, design-system.md,
adr/006-two-flutter-apps.md and the Phase 1 rows of api-map.md first.

- Dart pub workspace at the repo root over apps/* and packages/*; very_good_analysis.
- packages/sb_core: env + flavors dev/staging/prod via --dart-define-from-file (prod must
  be https + prod host), Dio client with interceptors (access token + refresh rotation,
  Accept-Language, Idempotency-Key created per user intent and reused on retry, GET-only
  retry with backoff, error → AppFailure mapper using server error codes),
  flutter_secure_storage, connectivity, logger, Result<T>/AppFailure sealed types.
- packages/sb_ui: tokens (colours, type, spacing, radius, motion) from design-system.md,
  light/dark ThemeData, Inter + Fraunces + IBM Plex Sans Arabic, base widgets (SbButton,
  SbCard, SbSheet, SbChip, SbBadge, SbSkeleton, SbEmptyState, SbErrorState) and a
  standard screen-state scaffold (loading, empty, error+retry, no-permission, offline).
- packages/sb_api: Freezed DTOs + repositories for the Phase 1 endpoints (customer OTP,
  staff login/2FA/select-salon, me, devices, app-config).
- Riverpod (codegen), go_router with typed routes, auth redirect guard and deep link
  scheme smartbarber://; flutter gen-l10n with app_ar.arb (default) and app_en.arb.
- Customer app: splash, language pick, phone + OTP login, bottom nav shell (Home, Book,
  AI Studio, Appointments, Profile) with placeholder screens, logout.
- Staff app: email login, 2FA step, salon picker when the user has several salons,
  shell (Today, Queue, Customers, POS, Me) with placeholder screens, logout.
- Tests: unit tests for interceptors (refresh, idempotency reuse, error mapping), widget
  tests for login screens' states, golden tests of both shells in AR-RTL and EN-LTR,
  light and dark.

Do not build booking, catalog or any Phase 2+ screens.
Before declaring done run: flutter analyze, flutter test, and build both apps (dev flavor)
— fix every failure. Finish with docs/phases/phase-1b.md and the exact run commands.
```
