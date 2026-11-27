# Phase 0 — Architecture plan — Report

Status: **DONE** (documents delivered). Awaiting review and answers to Q1–Q8 in `docs/architecture/spec-review.md` before Phase 1.

1. **Implemented (what a user can now do)**
   No application code, by design. The team can review the full data model, module boundaries, permission matrix, API plan for phases 1–6, the six foundational decisions and the risk register.

2. **Files created**
   - `docs/architecture/erd.md`: every table for phases 1–15 by module, with columns, types, FKs, indexes, unique constraints, soft-delete and tenant columns, plus a Mermaid ER diagram per module
   - `docs/architecture/modules.md`: 21 modules in 10 dependency layers (acyclic), their public actions, events and dependencies, and how upward needs are inverted (`PriceAdjuster`, `NotificationChannel`, `UsageMeter`)
   - `docs/architecture/permissions.md`: about 90 permission keys, a default matrix for 8 salon roles with branch/own scope, the customer ownership rules, and Super Admin keys
   - `docs/architecture/api-map.md`: every `/api/v1` endpoint for phases 1–6 (method, auth, permission, idempotency), the dashboard Inertia routes, broadcast channels and error codes
   - `docs/architecture/adr/001-tenancy.md` … `006-two-flutter-apps.md`
   - `docs/architecture/risks.md`: top 10 risks with mitigations, plus a watch list
   - `docs/architecture/spec-review.md`: 24 review items (contradictions, gaps, over-engineering) and 14 questions
   - `docs/phases/phase-0.md`: this report

   **Files modified:** none.

3. **Migrations:** none (planned in `erd.md`).
4. **API endpoints:** none implemented (planned in `api-map.md`).
5. **Screens:** none.
6. **Tests:** none. Test strategy decisions are recorded in ADR-001 (isolation dataset, arch test) and ADR-004 (parallel booking test on real MySQL). Pint, Larastan, Pest and the Flutter tools were not run because there is no code yet.
7. **Security checks (designed, not yet implemented):** fail-closed tenant scope, salon-bound staff tokens, customer ownership checks, a route × role test matrix generated from `permissions.md`, append-only ledgers, signed and idempotent webhooks.
8. **Known limitations:** the ERD for phases 7–15 is a first pass and will be refined in each phase's planning step. Some recommendations depend on unanswered questions (Q5, Q7, Q9).
9. **How to run:** nothing to run. Read `docs/architecture/spec-review.md` first.
10. **What Phase 1 needs from this phase:** approval of ADR-001 to 006, answers to Q1–Q8, and a decision on splitting Phase 1 into 1a and 1b.
11. **Decisions made:** ADR-001 tenancy, ADR-002 auth and identities, ADR-003 money, ADR-004 booking locking, ADR-005 dashboard stack, ADR-006 two Flutter apps. All are *Proposed* until you approve them.
