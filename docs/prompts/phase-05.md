# Phase 5 — Customer app core / تطبيق العميل

الهدف: العميل يحجز ويعدّل ويلغي من الجوال بتجربة فاخرة.

```
Implement PHASE 5 only (apps/customer + any API gaps in backend).

- Salon entry: the app opens a salon by deep link / QR / search (multi-salon marketplace
  is optional later); remember last salon; branch picker with map and hours.
- Home: greeting by time of day and name, next appointment card with Reschedule/Cancel,
  "Book again" chip, popular services carousel, placeholders for AI Studio and loyalty
  (hidden if the salon lacks the feature).
- Booking flow as a stepper: service(s) + add-ons → barber or "Any available" (avatar
  list with specialties) → date strip + time slots from the API → summary with server
  quote → confirm. Slot taken (409) → friendly message and refreshed slots.
- Appointments: tabs Upcoming / Past, detail screen with timeline of status, add to
  calendar, directions, cancel with policy text.
- Profile: name, photo, phone, language, theme, notification settings, delete account
  request (store compliance), logout.
- Reviews: "Rate your visit" (1–5 + comment) after a completed booking → booking_reviews;
  moderation list in the dashboard (review.moderate). Feeds barber rating.
- Salon search returns only salons with listing.enabled (default off); QR/deep link first.
- Account deletion follows spec-review item 12 (anonymise salon profiles, keep invoices).
- Push: register FCM token, open booking detail from notification deep link.
- Network: offline banner, timeout/retry UI, session expiry → re-login keeps intended route.
Tests: widget tests per screen state, integration test of full booking in AR and EN,
golden tests for booking stepper RTL/LTR.
```
