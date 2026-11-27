# Phase 13 — Inventory and commissions / المخزون والعمولات

الهدف: كل حركة مخزون متتبعة، وكشف عمولات جاهز للرواتب.

```
Implement PHASE 13 only.

Inventory:
- products (sku, barcode, name ar/en, category, cost, retail price, tax, retail vs
  professional use), suppliers, purchase_orders (draft → ordered → partially_received →
  received), inventory per branch, inventory_movements ledger (purchase, sale, use in
  service, adjustment with reason, transfer out/in, return). Stock = SUM of movements.
- POS product sale writes a movement in the same transaction. Low-stock threshold per
  branch → notification. Stock count (stocktake) workflow with variance report.
- Barcode scan in dashboard POS and staff app.

Commissions:
- commission_rules by barber, service, category, product: percent or fixed, optional
  tiers by monthly revenue, effective dates. Rule precedence documented and tested.
- barber_commissions ledger written on payment completion, reversed on refund.
- Statements per period: services, products, tips, deductions, total; approve → lock;
  export PDF/CSV payroll-ready. Barber sees own statement in staff app.
Tests: movement ledger integrity, transfer atomicity, commission precedence, refund
reversal, locked statements immutable.
```
