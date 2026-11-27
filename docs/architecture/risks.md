# Top 10 technical risks

Status: Proposed (Phase 0). Likelihood (L) and impact (I) are rated H/M/L. The list is reviewed at the end of every phase in the Phase Report.

| # | Risk | L | I | Mitigation | Owner phase |
|---|---|---|---|---|---|
| 1 | **Cross-salon data leak** (a missing scope, a job without a salon, a binding by raw id) | M | H | Fail-closed `BelongsToSalon` scope (throws when no salon is set); job middleware restoring the salon; `public_id` bindings through scoped queries; an arch test that every model is tenant-aware or allow-listed; a TenantIsolation dataset over **every** endpoint, extended each phase; a hostile-tester prompt per phase | 1, every phase |
| 2 | **Double booking under concurrency** | M | H | ADR-004: row lock on `barbers` + re-check inside one transaction; `blocked_until` covers buffers; idempotency on create and reschedule; a 10-process parallel test on real MySQL in CI | 4 |
| 3 | **Phases too large for one session**: partial work declared done, regressions | H | M | Split Phase 1 (spec-review item 3); vertical slices with tests after each; the Phase Report states DONE or PARTIAL honestly; the "Continue" prompt; tag `phase-N` only when the gate passes | all |
| 4 | **RTL and Arabic quality debt** (mirroring, mixed bidi text, number formats, fonts) | H | M | Logical properties only, enforced by lint; golden tests AR-RTL/EN-LTR for the shell and key flows; `<bdi>` and isolates for names and phones; Arabic screenshots required on UI PRs; a native-speaker review of copy before each store release | 1, 5, 15 |
| 5 | **Payment integration variance in the Gulf** (webhook reliability, refunds API gaps, settlement reconciliation) | M | H | `PaymentGateway` contract + fake; webhooks stored raw, signature-verified, idempotent by event id, processed in a queue; a reconciliation report (gateway vs ledger); card-terminal payments recorded as "external" so the POS works without any integration | 6 |
| 6 | **Financial correctness** (rounding, partial refunds, gapless invoice numbers, cached balances drifting from ledgers) | M | H | ADR-003 Money and append-only ledgers; PricingService is the only price calculator; invoice numbering under a row lock with a concurrency test; a nightly drift check of ledger SUM vs cache with alerts | 3, 6, 7, 13 |
| 7 | **Schedule and timezone bugs** (multi-range days, breaks, closures, overrides, UTC conversion, week starting Saturday) | M | M | One `ScheduleService` with exhaustive unit tests (DST-free Gulf zones **plus** one DST zone so expansion stays safe); all storage in UTC; local `time` only in schedule tables; property-based tests for AvailabilityService | 2, 4 |
| 8 | **WhatsApp compliance and cost** (template rejection, number quality rating, opt-out handling, per-conversation pricing) | M | M | Official Cloud API or BSP only; template registry synced from Meta; consent ledger + STOP handling; frequency caps; campaign approval workflow; usage metered into the plan limits | 11 |
| 9 | **AI Hair Studio** (provider cost and latency, uneven output quality, face-photo privacy, provider terms) | M | M | `AiImageProvider` interface with a fake; queued generation with timeouts and retries; per-customer and per-salon limits; originals private, EXIF stripped, auto-deleted after N days; explicit consent text; output labelled "preview"; a provider ToS and data-processing review before choosing (Phase 9 ADR) | 9 |
| 10 | **App store rejection** (account deletion, privacy manifests and data-safety forms, AI-generated imagery of real faces, demo access) | M | M | In-app account deletion from Phase 5; privacy manifest kept current per release; a demo salon + reviewer account; AI Studio described accurately in listings; staff app distributed via the stores, or via Apple Business Manager custom apps if review objects | 5, 15 |

## Watch list (below the top 10)

- Availability calculation performance for "any barber" across a week: cache per branch per day and invalidate on booking or schedule events.
- Reverb connection limits on cheap hosting: fall back to polling in the apps; a Reverb horizontal-scaling plan (Redis pub/sub) in Phase 15.
- Queue backlog during campaign sends: dedicated `notifications` workers, throttled batches, Horizon alerts.
- Scope creep from the 21 → 16 phase regrouping: each phase prompt is the contract; changes go through the change-request prompt and an ADR.
