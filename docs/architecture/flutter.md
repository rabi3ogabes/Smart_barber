# Flutter architecture

Two apps (customer and staff) share three packages, so networking, design and models are written once. — تطبيقان منفصلان يتشاركان نفس الحزم، فلا تكرار للكود.

Two apps, not one role-based app: the customer app stays light and App Store-friendly, while the staff app can hold POS, camera and queue tools without bloating it. — الفصل يبقي تطبيق العميل خفيفاً.

| Decision | Choice | Why |
|---|---|---|
| Workspace | Dart pub workspaces (or Melos) over `apps/*` and `packages/*` | One `flutter pub get`, shared versions |
| Layers per feature | `data/` (DTOs, remote source, repository impl) → `domain/` (entities, repository contract) → `presentation/` (screens, widgets, controllers) | Clean Architecture without ceremony |
| State | Riverpod with code generation (`@riverpod`), `AsyncNotifier` for screens | Testable, no BuildContext in logic |
| Navigation | go_router with typed routes, auth redirect guard, deep links (`smartbarber://booking/{id}`) | Notifications open the right screen |
| Networking | Dio in `sb_core` with interceptors: auth token, `Accept-Language`, Idempotency-Key, refresh/expired-session, retry with backoff for GET only, error mapper | Uniform behaviour, no duplicate bookings |
| Models | Freezed + json_serializable; a `Result<T>` / `AppFailure` sealed type | Exhaustive error handling |
| Storage | flutter_secure_storage for tokens; shared_preferences for locale/theme; small read cache (last appointments, profile, loyalty) | Fast start, graceful offline |
| Offline | Reads show cached data with an "offline" banner; writes are blocked offline with a clear message (no queued bookings) | Avoids ghost bookings and double charges |
| Localization | `flutter gen-l10n` with `app_en.arb` / `app_ar.arb`; server error `code` → local translated string | Proper Arabic everywhere |
| Push | Firebase Cloud Messaging; token registered per device to `/api/v1/devices` | Laravel decides what and when to send |
| Images | image_picker + compression before upload; cached_network_image | AI Studio uploads stay small |
| Flavors | `dev`, `staging`, `prod` with `--dart-define-from-file` | Never ship a test API URL |
| Quality | very_good_analysis lints; unit + widget tests; golden tests in EN-LTR and AR-RTL, light and dark; integration_test for booking flow | RTL bugs caught by CI |

## As built (Phase 1b)

- Flutter 3.50.1 / Dart 3.14, a pub workspace at the repo root (`pubspec.yaml`), `very_good_analysis` 11 via the root `analysis_options.yaml`.
- Material and Cupertino come from `material_ui` / `cupertino_ui` (ADR-007).
- Riverpod 3 with codegen (`@riverpod`), go_router 18 with `go_router_builder` typed routes (including a typed `StatefulShellRoute` for the tab shells), Freezed 4 + json_serializable for DTOs.
- Generated files (`*.g.dart`, `*.freezed.dart`, `l10n/generated/`, `sb_tokens.g.dart`) are committed. `tool/flutter_codegen.sh` regenerates them; `tool/flutter_check.sh` fails when they are stale and runs analyze and tests for every member.
- Design tokens: `design/tokens.json` → `packages/sb_ui/tool/generate_tokens.dart` → `sb_tokens.g.dart` (`SbColors` ThemeExtension, `SbType`, `SbRadius`, `SbSpace`, `SbMotion`, `SbLayout`). The fonts (Inter, Fraunces, IBM Plex Sans Arabic, OFL) are bundled in `sb_ui`; the variable fonts get their weight through `FontVariation`.
- Networking (`sb_core`): Accept-Language → Idempotency-Key (per user intent) → auth (single-flight refresh, replay through a separate client, session ends only on `REFRESH_TOKEN_*`/`UNAUTHENTICATED`/`MEMBERSHIP_INACTIVE`) → GET-only retry with backoff. Every error becomes a sealed `AppFailure`, and the UI shows `failureMessage()` (server code → local translation).
- Goldens: `test/goldens/*` in both apps, rendered with the real fonts (`sb_ui/testing.dart`). Regenerate on Linux: `flutter test --update-goldens`.
- Flavours: `--dart-define-from-file=env/{dev,staging,prod}.json`; `AppEnv.validate()` refuses a prod build that is not `https://api.smartbarber.app`.

## Package layout

```
packages/
  sb_core/   env, dio client, interceptors, failures, secure storage, connectivity, logger
  sb_ui/     tokens (colors, type, spacing, radius, motion), ThemeData light/dark,
             SbButton, SbCard, SbSheet, SbChip, SbBadge, SbSkeleton, SbEmptyState,
             SbErrorState, SbBeforeAfterSlider, SbProgressRing, SbAvatarGroup
  sb_api/    DTOs + repositories per backend module (auth, catalog, booking, loyalty…)
apps/customer/lib/
  app/ (router, bootstrap, providers)
  features/ home/ booking/ ai_studio/ appointments/ profile/ loyalty/ history/
apps/staff/lib/
  features/ today/ queue/ customer_card/ pos/ history_capture/ commission/
```

## Rules for every screen

- Use `EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional`; never `left`/`right`.
- Directional icons (back, forward, chevrons) mirror in RTL; brand icons and clocks do not.
- Numbers, prices and times format with `intl` for the current locale; phone numbers stay LTR inside RTL text.
- Minimum touch target 48×48; `Semantics` labels on icon buttons; respect reduced motion.
- Every screen shows loading (skeleton), empty, error + retry, and no-permission states from `sb_ui`.
