# Phase 1b — Foundation: Flutter apps — Report

Status: **DONE**. Both Android apps build; iOS cannot be built on Linux (section 9). With Phase 1a, the Phase 1 gate is met: login works in both apps and the dashboard, Arabic/English switch, tenant isolation tests green.

## 1. Implemented (what a user can now do)

**Customer app (`apps/customer`)**
- **First launch:** splash, then a language choice (Arabic or English), then phone sign-in.
- **Phone entry:** Qatar code prefilled. Arabic-Indic digits are accepted and normalised to E.164.
- **Code entry:**
  - The 6-digit code fills from the SMS on supporting phones and is verified automatically once complete.
  - A wrong or expired code shows a translated error.
  - The resend countdown follows the server's `retry_after`.
- **Shell:** bottom navigation with Home, Book, AI Studio, Visits and Profile. Each feature tab says "Coming soon" honestly, with no fake content. Home greets the user by name.
- **Profile:** name and phone, language switch, theme (light/dark/system), sign out with confirmation.
- **Session:**
  - Restored at start-up. If the server ends it, the user returns to sign-in with a "session ended" notice and back to the intended route afterwards.
  - Offline start shows the cached profile and an offline banner.

**Staff app (`apps/staff`)**
- **Sign-in:** email and password → 2FA step (authenticator or recovery code) → salon picker for people in several salons → shell.
  - Owners and GMs without 2FA see "set up 2FA in the dashboard first".
  - A language toggle is available on every sign-in step.
- **Shell:** Today, Queue, Customers, POS and Me. The salon name sits under each tab title.
- **Me:** name, email, salon, translated role badges, language, theme, sign out.

**Both apps**
- RTL in Arabic, LTR in English, from the locale only.
- Real brand fonts and token-based theming.
- Offline banner.
- `smartbarber://` deep links (customer) and `smartbarber-staff://` (staff) registered on Android and iOS.

## 2. Files created

| Area | Files |
|---|---|
| Workspace | `pubspec.yaml` (pub workspace), `pubspec.lock`, `analysis_options.yaml` (very_good_analysis 11), `.gitignore`, `tool/flutter_codegen.sh`, `tool/flutter_check.sh` |
| `packages/sb_core` | `env/app_env.dart`, `failures/{app_failure,api_error_code,result}.dart`, `auth/{auth_tokens,token_store}.dart`, `network/{api_client,auth_interceptor,idempotency,locale_interceptor,retry_interceptor}.dart`, `storage/app_preferences.dart`, `connectivity/connectivity_service.dart`, `logging/app_logger.dart`; tests: `test/network_test.dart`, `test/support/fake_adapter.dart` |
| `packages/sb_api` | `envelope.dart`, `models/{app_config,customer_account,staff,localized}.dart` (+ generated), `repositories/{customer_auth,staff_auth,devices,meta}_repository.dart`, `build.yaml`; tests: `test/repositories_test.dart`, `test_e2e/contract_test.dart` |
| `packages/sb_ui` | `tool/generate_tokens.dart`, `src/tokens/sb_tokens.g.dart`, `src/theme/sb_theme.dart`, `src/failure_message.dart`, `src/widgets/{sb_button,sb_text_field,sb_card,sb_sheet,sb_chip,sb_badge,sb_skeleton,sb_states,sb_logo,sb_directional_icon}.dart`, `l10n/sb_{en,ar}.arb` (+ generated), `testing.dart`, `assets/fonts/*` (Inter, Fraunces, IBM Plex Sans Arabic + OFL licences); test: `test/sb_ui_test.dart` |
| `apps/customer` | `lib/app/{bootstrap,app,providers,preferences_controllers,session,router,routes}.dart` (+ generated), `lib/features/{splash,onboarding,auth,shell,profile}/*`, `lib/l10n/app_{en,ar}.arb` (+ generated), `env/{dev,staging,prod}.json`, Android `network_security_config.xml`; tests: `logic_test`, `auth_screens_test`, `shell_golden_test` + 4 goldens |
| `apps/staff` | same structure: `lib/app/*`, `lib/features/{splash,auth,shell,me}/*`, l10n, env; tests: `redirect_test`, `login_flow_test`, `shell_golden_test` + 4 goldens |
| Docs | `docs/architecture/adr/007-flutter-material-ui-package.md`, this report |

## 3. Files modified

- `docs/architecture/flutter.md`: added an "As built (Phase 1b)" section.
- Root `README.md`: added how to run the Flutter apps and the quality gate.
- Android manifests:
  - `INTERNET` permission, `supportsRtl`, network security config, deep-link intent filter.
  - App ids `app.smartbarber.customer` / `app.smartbarber.staff`.
- iOS `Info.plist` and `project.pbxproj`:
  - Display names and bundle ids.
  - URL schemes; localisations ar/en with Arabic as the development region.

## 4. Migrations

None (no backend changes).

## 5. API endpoints used

All Phase 1 rows of `api-map.md`:
- **Customer:** `meta/app-config`, `customer/auth/{otp, otp/verify, refresh, logout}`, `customer/me`, `devices` (repository ready).
- **Staff:** `staff/auth/{login, 2fa, select-salon, refresh, logout}`, `staff/me`, `staff/me/salons`, `staff/devices` (repository ready).

## 6. Screens

| App | Screens |
|---|---|
| Customer | Splash, Language, Phone, Code, Shell (Home, Book, AI Studio, Visits, Profile) |
| Staff | Splash, Login, Two-factor, Salon picker, Shell (Today, Queue, Customers, POS, Me) |

Golden files, rendered with the real fonts:
- `apps/customer/test/goldens/customer_shell_{ar,en}_{light,dark}.png`
- `apps/staff/test/goldens/staff_shell_{ar,en}_{light,dark}.png`

## 7. Tests and quality gates

| Gate | Result |
|---|---|
| `flutter analyze --fatal-infos` (very_good_analysis 11) on all 5 members | **0 issues** |
| `flutter test` — `sb_core` 17, `sb_api` 5, `sb_ui` 4, customer 17, staff 11 | **54 tests, all passing** |
| Generated code up to date (`tool/flutter_codegen.sh` + `git diff`) | passing (it caught one stale hash, fixed) |
| Contract test `sb_api/test_e2e` against the running Laravel backend | **3/3 passing** |
| `flutter build apk --debug` (dev flavor), customer and staff | **both build** (`app-debug.apk`, customer and staff); the customer build needed one retry because Maven Central rate-limited Gradle (HTTP 429) |
| iOS builds | not possible on Linux (needs macOS + Xcode) |

What the tests cover:
- **`sb_core`:**
  - Accept-Language on every request.
  - An Idempotency-Key reused across a retry of the same intent, and keys that are valid UUID v4.
  - GET retried on 503 with backoff; never POST, never 4xx.
  - Auth: bearer attached, opt-out for sign-in calls, **one refresh for concurrent 401s** with all requests replayed, proactive refresh of expired tokens, session ended on `REFRESH_TOKEN_REUSED`, session kept when the refresh fails offline.
  - Error envelope mapping (codes, field errors, data), non-envelope 500 → `SERVER_ERROR`, offline → `NetworkFailure`.
  - Prod builds refuse non-https or foreign API hosts; tokens count as expired 30 s early; the logger redacts tokens and codes.
- **`sb_api`:** the 409 envelopes become 2FA / salon-selection steps; real errors stay failures; `/staff/me` and the customer OTP flow parse exactly as the backend sends them; localized-text fallback.
- **`sb_ui`:** failure → translated text in AR and EN; `SbStateView` covers loading, empty, error + retry, no-permission and content; the Arabic font and RTL are applied; buttons keep a 48 px touch target and block taps while loading.
- **Customer:**
  - Phone normalisation (Arabic digits, 00 prefix, garbage); redirect rules (splash, language, sign-in with `from`, safe return, deep-link scheme).
  - The phone screen's local validation, then the normalised number is sent; translated rate-limit and offline errors.
  - The code screen's format error, wrong-code error and resend countdown.
- **Staff:** redirect rules (only the pending sign-in step is reachable); the full password → 2FA → salon picker → shell flow; translated enrolment and wrong-code errors; session expiry.
- **Contract (live backend):**
  - **Customer:** OTP sign-in (wrong code then right code); `me` after a forced expiry, which proves the interceptor refreshes and replays transparently; reuse of the rotated refresh token rejected by the server.
  - **Staff:** barber login, `/staff/me` with roles, permissions and salon name; owner refused until 2FA enrolment; error messages arrive in Arabic.

## 8. Security checks

- **Tokens:**
  - Tokens live only in Keychain/Keystore (`flutter_secure_storage`), one key per app.
  - Refresh is single-flight, so a rotated refresh token is never sent twice; sending it twice would revoke the whole login.
  - Sign-in and refresh calls never carry an access token.
- **Network:**
  - Prod builds must use `https://api.smartbarber.app` (checked at start-up).
  - Android allows plain HTTP only to `10.0.2.2` and `localhost` (the dev API).
- **Errors and logs:**
  - The logger redacts bearer tokens, refresh tokens, OTP and challenge codes.
  - Raw exceptions never reach the UI; every failure becomes translated text.
- **No business rules on the client** (rule 1): permissions from `/staff/me` are display-only, and phone formatting is input normalisation only (the server validates).

## 9. Known limitations and tech debt

- **iOS has not been built.** The iOS projects, bundle ids, URL schemes and localisations are configured, but building needs macOS with Xcode.
- **Push:** Firebase Cloud Messaging is not wired up yet. `DevicesRepository` is ready, but FCM needs `google-services.json` / `GoogleService-Info.plist` from your Firebase project (spec-review Q10/Q14 territory); it is added when push notifications start being used (Phase 4/5).
- **Generated code from the Scribe OpenAPI** is not used; the DTOs are hand-written and verified by the contract test (spec-review item 21).
- **No integration_test yet:** the booking-flow integration test arrives with booking in Phase 5.
- **Placeholder branding:** the app icons are Flutter's defaults and the logo is a placeholder wordmark (Q8).
- **Staff deep links:** the `smartbarber-staff://` scheme is registered but no screens handle it yet.
- **`flutter_test` is a dependency of `sb_ui`:** it is there for the shared `testing.dart` helpers. It is never imported by app code; move it to a separate `sb_testing` package if that ever matters.
- **Local build setup in this cloud session:**
  - Maven Central rate-limited Gradle (HTTP 429), so the APK builds needed several retries. Nothing in the project depends on that.
  - MySQL had to be restarted once during the session.

## 10. How to run

```bash
flutter pub get
cd backend && QUEUE_CONNECTION=sync php artisan serve --host=0.0.0.0   # seeded dev DB
cd apps/customer && flutter run --dart-define-from-file=env/dev.json    # Android emulator
cd apps/staff && flutter run --dart-define-from-file=env/dev.json
```

Demo sign-ins:
- **Customer:** any Qatar mobile number; the code is printed in `backend/storage/logs/laravel.log`.
- **Staff:** `barber.a@smartbarber.test` / `Password123!`. Owners must enable 2FA in the dashboard first.

Quality gate: `tool/flutter_check.sh` (add `--build` to build both APKs).

## 11. What remains, and what the next phase needs

- **Phase 2 (salon setup):** mostly the dashboard. The staff app will show schedules from Phase 2 data.
- **Ready for later phases:**
  - The networking stack, including idempotency keys per intent for the booking and payment phases.
  - The screen-state widgets, failure messages and tokens.
- **Every new screen must:** use `SbStateView` or equivalent states, add AR/EN strings, and add goldens for key flows.

## 12. Decisions made

- **ADR-007:** use `material_ui` / `cupertino_ui` (Flutter 3.50 deprecates `flutter/material.dart`).
- **Generated code is committed**, and CI checks it is fresh.
- **The English customer tab is "Visits"** instead of "Appointments", which did not fit on a 390 px phone.
- **Goldens use an injected clock,** so they do not depend on the time of day.
