# Phase 14 — SaaS billing and Super Admin / الفوترة ولوحة المشرف العام

الهدف: بيع الباقات والوحدات الإضافية، ولوحة تحكم كاملة للمنصة.

```
Implement PHASE 14 only.

Billing:
- subscription_plans (Starter, Professional, Enterprise — editable), plan_features with
  limits (branches, staff seats, bookings/month, AI generations/month, WhatsApp messages,
  storage GB), addons (AI Studio, WhatsApp, Marketing, Advanced POS, Membership,
  AI Assistant) purchasable separately. Billing periods 1/3/6/12 months.
- salon_subscriptions with trial, active, past_due, grace, suspended, cancelled; upgrade/
  downgrade with proration; coupons; platform invoices; dunning emails.
- salon_features becomes computed from plan + addons + manual overrides. Usage meters
  from AI/WhatsApp/storage ledgers; soft limit warnings at 80%, hard stop at 100%
  except for core booking (never block a salon from taking bookings mid-day).
- Suspended salon: dashboard read-only + banner; customer app shows "temporarily
  unavailable" for new bookings only.

Super Admin console (separate guard, separate subdomain, 2FA mandatory):
- Overview: total/active/new salons, MRR, ARR, churn, trials converting, bookings,
  payments volume, AI and WhatsApp usage, storage, API usage.
- Manage salons (search, detail, impersonate with reason — logged and shown to owner),
  plans, features, addons, subscriptions, coupons, support notes, system settings,
  global audit log, provider health.
Tests: proration maths, feature gating per plan, limits, suspension behaviour,
impersonation audit.
```
