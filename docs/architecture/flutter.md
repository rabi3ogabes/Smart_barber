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
