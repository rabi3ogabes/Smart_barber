# Phase 2 — Salon, branches, staff, schedules / الصالون والفروع والدوام

الهدف: المالك يجهز الصالون بالكامل قبل أي حجز.

```
Implement PHASE 2 only.

- Salon profile: name (ar/en), logo, cover, currency, timezone, tax number, VAT %, contact,
  social links, booking policy (lead time, max days ahead, cancellation window, no-show fee).
- Branches: CRUD, address + map pin, phone, timezone, opening hours per weekday (multiple
  ranges), holidays/closures, per-branch settings.
- Staff: invite by email/phone, accept invite, assign roles per salon and branches,
  deactivate (never hard delete). Barber profile: photo, bio ar/en, specialties (tags),
  years of experience, display order, bookable yes/no.
- Schedules: barber weekly working hours per branch, breaks, time off/leave requests with
  approval, one-off overrides. A ScheduleService that returns a barber's working intervals
  for a date range (used by Phase 4) — unit test DST-free Gulf zones and multi-range days.
- Dashboard UI: Settings → Salon, Branches list + drawer edit, Staff table with avatar
  group, role chips, invite modal, weekly schedule grid editor, time-off timeline.
- Permissions enforced in policies; Branch Manager only sees his branches.
- Audit log for role/permission changes.
Tests: CRUD, policies per role, branch scoping, tenant isolation, schedule calculations.
```
