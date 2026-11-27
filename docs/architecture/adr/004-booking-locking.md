# ADR-004 — Booking conflict prevention

Status: Proposed · Phase 0 · Irreversible in practice (the core correctness guarantee)

## Context
Two customers (or a customer and the receptionist) can request the same barber and time at the same instant. MySQL 8 has no exclusion constraints. "No double booking" is the Phase 4 gate.

## Decision
`CreateBooking` and `RescheduleBooking` run in one transaction at READ COMMITTED:

1. `SELECT id FROM barbers WHERE id = ? AND salon_id = ? FOR UPDATE`. The barber row is the lock key for that chair.
2. Re-validate the request against `ScheduleService::workingIntervals()` (branch hours, closures, barber hours, breaks, overrides, approved time off), lead time and max days ahead.
3. Overlap check on the **blocked** range, so buffers are respected:
   `exists bookings where barber_id = ? and status in (pending, confirmed, arrived, in_service) and starts_at < :new_blocked_until and blocked_until > :new_starts_at [and id <> :self]`.
   This uses the index (`barber_id`, `starts_at`, `blocked_until`). Touching ranges (one ends exactly when the next starts) are allowed.
4. Price the booking via `PricingService::quote()` and snapshot the line items into `booking_services` and `bookings.quote_snapshot`.
5. Insert, write `booking_status_history`, commit. Events are dispatched **after commit** (`ShouldDispatchAfterCommit`).
6. On conflict: roll back, return 409 `BOOKING_SLOT_TAKEN` with the next 3 free slots for that barber and the same day's alternatives for "any".

**"Any available barber"**: build the eligible barber list (performs all services, works at the branch, `is_bookable`), order it by matching score (Phase 10; before that, by fewest bookings that day, then `sort_order`), and try each with steps 1–5, **one lock at a time** (each lock is released before the next). Taking one lock at a time rules out deadlocks.

**Reschedule** keeps the same booking row and public id (deep links and notifications keep working). It locks the target barber (and the old barber if different, always in ascending id order) and records the old and new times in `booking_status_history.meta`. `rescheduled` is not a status (spec-review item 5).

**Idempotency:** mobile create and reschedule require an `Idempotency-Key`. The middleware stores `(actor, key, request_hash)` with status `processing` before running the action. A concurrent duplicate gets 409 `IDEMPOTENCY_IN_PROGRESS`, and a completed duplicate replays the stored response.

## Verification (Phase 4 gate)
- A Pest test that runs against a real MySQL (not SQLite) and fires 10 parallel `CreateBooking` calls for one barber and slot from separate processes (`pcntl_fork` or `Process::pool`), asserting exactly one booking row and nine `BOOKING_SLOT_TAKEN` results.
- Edge cases: touching ends, buffer overlap, a multi-range day, a break inside the service, a barber's time off, reschedule onto self, "any" falling through to the second barber.

## Consequences
- + Correct under concurrency with plain MySQL; short lock (single row, milliseconds).
- − Throughput per barber is serialised, which is irrelevant at barbershop scale.
- − The test needs MySQL in CI (a service container).

## Alternatives rejected
- Unique index on (barber_id, starts_at) with fixed slots: breaks with variable durations and buffers.
- A slot table with a row per 5 minutes per barber: heavy writes and schedule-change complexity.
- Redis locks: adds a second source of truth; DB row locks already work inside the transaction.
