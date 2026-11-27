# Phase 8 — Staff app and haircut history / تطبيق الحلاق وسجل القصات

الهدف: الحلاق يدير يومه من الجوال، والعميل يعيد نفس القصة بضغطة.

```
Implement PHASE 8 only.

Backend:
- haircut_styles catalog (salon-level + platform defaults; name ar/en, category: fade,
  crop, classic…, image), customer_hair_history (booking, barber, hair style, beard style,
  length/guard numbers, products used, notes private/visible, photos with consent flag),
  customer favourite styles.
- Consent: customer opt-in for photos stored per salon; photos private, signed URLs.
- "Same as last time": endpoint that builds a booking draft from the last completed
  visit (same services, same barber if available) and returns suggested slots.

Staff app (apps/staff):
- Today: current customer card, next up, timeline of the day, today's revenue (own),
  pull-to-refresh + Reverb live updates.
- Booking actions: arrived, start, add service/add-on, complete → history capture sheet
  (style chips, guard numbers, notes, camera with consent check) → POS handoff.
- Customer card: visits, last style with photo, preferences, notes, loyalty status.
- My schedule and time-off request.

Customer app: History tab — visit timeline (date, style, barber, price), detail with
photos, "Same as last time" button, favourite style.
Tests: consent enforcement, barber sees only own bookings unless permitted, history API.
```
