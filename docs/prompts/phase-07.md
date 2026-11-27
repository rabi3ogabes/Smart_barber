# Phase 7 — Loyalty and memberships / الولاء والاشتراكات

الهدف: "ادفع 5 واحصل على 1 مجاناً" والنقاط والاشتراكات الشهرية — كلها قابلة للإعداد.

```
Implement PHASE 7 only. Gate both modules with salon_features.

Loyalty:
- loyalty_programs with rule types: punch_card (required count, eligible services,
  reward = free service|discount|free addon, expiry days, branches, min spend) and
  points (earn rate per currency unit, redemption rate, min redeem, expiry).
- loyalty_transactions append-only ledger (earn, redeem, expire, adjust with reason +
  permission, reverse when the source payment is refunded). Balance = SUM, cached.
- Earning happens on a PaymentCompleted listener, never on the client.
- Redemption at POS and in booking quote via PricingService, with idempotency.
- Scheduled job for expiry. Customer app: loyalty card with progress ring (4 / 5),
  history list, reward ready badge.

Memberships:
- membership_plans (price, period monthly/quarterly/yearly, included services with
  quantities or unlimited with fair-use cap, branch scope, discount on extras).
- customer_memberships (active, paused, cancelled, expired; start, end, renew_at),
  membership_usages ledger. Renewal via PaymentGateway recurring or manual POS charge.
- Abuse prevention: one active membership per plan per customer, usage checked inside
  booking/POS transaction, max uses per day, pause limits.
- Dashboard: plan builder, members table, membership detail with usage timeline.
Tests: punch card counting incl. refunds, points expiry, concurrent redemption,
membership usage limits, renewal and pause edge cases.
```
