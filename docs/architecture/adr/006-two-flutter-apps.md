# ADR-006 — Two Flutter apps sharing three packages

Status: Accepted (2026-11-27, owner approved defaults) · Phase 0

## Context
Customers need a light, polished, store-friendly app. Barbers and reception need a tool app (today's chair, queue, POS, camera for history, commission). App Store review treats staff-only features in a consumer app with suspicion, and the two audiences need different release cadences.

## Decision
- Two apps: `apps/customer` (bundle e.g. `app.smartbarber.customer`) and `apps/staff` (`app.smartbarber.staff`).
- Shared packages in a Dart pub workspace (Dart ≥ 3.6 `workspace:`; Melos only for scripts):
  - `sb_core`: env and flavors, the Dio client and interceptors (auth + refresh, Accept-Language, Idempotency-Key generation per user intent, GET-only retry with backoff, error → `AppFailure` mapper), secure storage, connectivity, logger.
  - `sb_ui`: tokens, light and dark `ThemeData`, fonts (Inter, Fraunces, IBM Plex Sans Arabic), widgets and state views.
  - `sb_api`: Freezed DTOs and repositories per backend module. Generated from the Scribe OpenAPI where that is practical; hand-written otherwise.
- Riverpod (codegen), go_router (typed routes, auth redirect, deep links `smartbarber://`), flutter gen-l10n per app with shared keys in `sb_ui` for common strings.
- An **Idempotency-Key is created when the user taps Confirm** and reused for every retry of that intent, so a retry never books twice.
- Offline: cached reads with a banner; writes are blocked while offline.
- Flavors dev, staging and prod via `--dart-define-from-file=env/{flavor}.json`. Prod builds fail if the API URL is not https or is not the prod host.
- One white-label path later: a salon-branded customer app is a build of `apps/customer` with a different flavor file and assets. Nothing in code assumes a single salon.

## Consequences
- + The customer app stays small; staff tools can request camera and other permissions without affecting consumer reviews.
- + Shared networking and design are written once.
- − Two store listings, two release pipelines (CI handles both).
- − Discipline is needed to keep business rules out of both apps (rule 1). Code review checks this, and `sb_api` exposes server-computed values only (quotes, slots, balances).

## Alternatives rejected
- One app with role-based navigation: heavier binary, review risk, and staff features leaking into the consumer UX.
- Separate repos per app: shared packages drift; one monorepo keeps versions aligned.
