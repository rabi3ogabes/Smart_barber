# Phase 4 — Booking engine / محرك الحجز

الهدف: حجز موثوق 100% — لا حجز مزدوج حتى مع طلبين في نفس اللحظة.

```
Implement PHASE 4 only. Follow the locking design in docs/architecture/laravel.md exactly.

- Tables: bookings (public_id, salon, branch, customer, barber, starts_at, ends_at UTC,
  status, source: app/dashboard/walk_in/phone, notes, cancel reason, price snapshot),
  booking_services (snapshot of name, price, duration), booking_status_history.
- Status machine with an enum and allowed transitions: pending → confirmed → arrived →
  in_service → completed; plus cancelled, no_show. Reschedule keeps the same booking and
  logs old/new times in booking_status_history (no `rescheduled` status — ADR-004).
  Salon setting booking.auto_confirm (default on). Overlap uses blocked_until (ends_at +
  buffer). No-show fee: record as an amount owed on the customer (collected at POS in
  Phase 6) unless Q9 in spec-review.md was answered otherwise. Start with a one-day
  calendar-library spike (FullCalendar Premium vs custom) and record it as an ADR.
  Invalid transitions throw.
- AvailabilityService: GET /api/v1/branches/{id}/slots?services[]=&barber=any|id&date=
  returns slots honouring schedules, breaks, time off, existing bookings, buffers, lead time.
- Actions: CreateBooking (transaction + SELECT FOR UPDATE on barber + overlap re-check),
  RescheduleBooking, CancelBooking (policy window), MarkArrived, StartService,
  CompleteBooking, MarkNoShow. "Any barber" tries eligible barbers in order.
- Idempotency-Key required on create/reschedule from mobile.
- Events: BookingCreated/Confirmed/Cancelled/Rescheduled/Completed (listeners come later;
  add a reminder job scheduled 24h and 2h before, using a NotificationChannel stub).
- Reverb broadcast on private-salon.{id}.branch.{id} for calendar updates.
- Dashboard calendar: day/week views, columns per barber, drag to move (calls Reschedule,
  reverts on 409), click empty slot → quick booking drawer with customer combobox,
  colour by status, now-line, filters by barber/service. Bookings list table with filters.
- Customers module minimal: customers table (salon-scoped, phone unique per salon),
  quick create from booking drawer.
Tests: REQUIRED — a parallel test that fires 10 simultaneous CreateBooking calls for the
same barber/slot and asserts exactly 1 succeeds; overlap edge cases (touching ends allowed);
cancellation window; transitions; idempotent retry returns the same booking.
```
