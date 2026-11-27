# ADR-003 — Money, tax and immutable financial records

Status: Accepted (2026-11-27, owner approved defaults) · Phase 0 · Irreversible (column types, ledger model)

## Context
The product launches in Qatar (QAR, 2 decimals) and plans other GCC countries. Kuwaiti, Bahraini and Omani currencies (KWD, BHD, OMR) have **3** decimals. Salons need trustworthy totals, refunds and commission.

## Decision
- Store amounts as signed BIGINT **minor units of the row's currency**, with the scale taken from ISO 4217 via brick/money (`QAR 60.00` = `6000`; `KWD 1.500` = `1500`). The code never assumes 2 decimals.
- Financial rows carry `currency` CHAR(3). A salon has one operating currency; mixing currencies inside an order is rejected.
- `App\Core\Money\Money` value object wraps `Brick\Money\Money`, with an Eloquent cast `MoneyCast('amount_column', 'currency_column')`. JSON output: `{"amount": 6000, "currency": "QAR", "formatted": "60.00 QAR"}`. Clients format with `intl` for the locale and never do arithmetic on money.
- Rounding: line-level tax with `RoundingMode::HALF_UP`, then summed. Percent discounts are applied per line and the remainder is allocated to the last line, so totals always reconcile.
- Tax is configurable (`salons.tax_rate_bp`, `services.tax_class`), with prices **tax-inclusive or tax-exclusive** set per salon. The default for Qatar is **0 %** (spec-review item 4).
- **Immutability:** completed `pos_orders`, `payments` (once succeeded), `invoices`, and every ledger (`loyalty_transactions`, `membership_usages`, `inventory_movements`, `barber_commissions`, `cash_movements`) are append-only. Model `updating` and `deleting` hooks throw on these states, and a DB user without UPDATE/DELETE on the ledger tables is planned for production hardening (Phase 15). Corrections are reversal rows linked by `reverses_id` / `refund_of_payment_id`.
- Balances (loyalty points, stock on hand, paid totals) are derived by SUM and may be cached in a projection table. A nightly job compares cache against ledger and raises an alert on drift.
- Invoice numbers are gapless per salon, per kind, per year, issued inside the completing transaction with `SELECT … FOR UPDATE` on `invoice_sequences`.

## Consequences
- + No float errors; ready for 3-decimal currencies.
- + A complete audit trail for refunds and adjustments.
- − Developers must use `Money`, enforced by a Larastan rule banning `float` on `*_amount` properties and by code review.

## Alternatives rejected
- DECIMAL(12,2): fixes the scale at 2 and invites float maths in PHP.
- Editable totals with an audit log only: owners would not be able to trust historic reports.
