# Phase 10 — Smart features / الميزات الذكية

الهدف: تذكير بالموعد المتوقع، ترشيح أفضل حلاق، وطابور انتظار مباشر.

```
Implement PHASE 10 only.

Smart rebooking:
- Nightly job computes each customer's typical interval (median of last 3–6 completed
  visits, min 2 visits required) and predicted next date; store in customer_insights.
- Send one reminder near the predicted date (configurable offset), respecting
  notification preferences, quiet hours and a max-frequency cap. Actions: Book now (deep
  link to "Same as last time"), Remind me later (snooze N days).

Barber matching:
- MatchingService with transparent weighted scoring: service specialty, past visits with
  this barber, customer's preferred barber, rating, availability in requested window,
  load balance. Weights stored in config/settings. Return score 0–100 plus the top reasons
  ("Specialises in fades", "You've visited 4 times", "Free at 7:30 PM"). Unit-test weights.
- Never describe it as scientific; label as "match".

Smart queue (walk-ins):
- queue_entries per branch (waiting, called, in_service, done, left), priority flag (VIP,
  appointment holder), estimated start computed from barbers' remaining bookings and
  average service durations. Reverb updates; push "you're next".
- Customer app: Join queue (with service), live position + estimate, Leave queue.
- Dashboard + staff app: queue board, call next, assign barber, reorder with reason.
Tests: interval prediction, cap on reminders, scoring, queue estimate recalculation.
```
