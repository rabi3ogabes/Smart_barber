# Phase 6 — POS, payments, invoices / نقطة البيع والدفع والفواتير

الهدف: محاسبة دقيقة — لا تعديل على عملية مكتملة، الاسترداد عملية عكسية.

```
Implement PHASE 6 only.

- pos_orders (draft → completed → refunded/partially_refunded/void), pos_order_items
  (type: service|product|addon|tip, snapshot name/price/tax, barber_id), discounts
  (fixed/percent, reason, permission-gated above a threshold).
- payments: method (configurable per salon: cash, card terminal, online, wallet, other),
  amount, status, provider ref; split payments across methods; change due for cash.
- refunds as new negative payment rows linked to the original; never update a completed row.
- invoices: sequential number per salon per year (gapless, generated in a locked
  transaction), bilingual PDF + thermal receipt (80mm) layout, VAT lines, QR placeholder
  for e-invoicing, send by email/WhatsApp link (signed URL).
- PaymentGateway interface + FakeGateway + one real adapter chosen in Phase 0 ADR;
  webhook endpoint verifies signature, is idempotent, and is processed in a queued job.
- CompleteBooking can open a POS order pre-filled from booking_services.
- Cash drawer: open/close shift with counted cash, expected vs counted report.
- Dashboard POS screen (tablet-first): customer search, service/product grid with
  category tabs, cart sheet, discount, tip, tax, payment modal, success + receipt.
- Reports: daily sales by method, by barber, refunds.
Tests: totals and VAT rounding, split payments, partial refund, webhook replay,
invoice numbering under concurrency, idempotent payment retry, permission on discounts.
```
