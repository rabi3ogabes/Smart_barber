# Phase 3 — Services catalog / الخدمات

الهدف: كتالوج خدمات مرن بأسعار لكل فرع ولكل حلاق.

```
Implement PHASE 3 only.

- service_categories (ar/en, icon, order), services (name/description ar/en, image,
  base price, duration minutes, buffer minutes, tax class, active, bookable online),
  service_addons (price, extra minutes), service_bundles (e.g. Hair + Beard at a bundle price).
- branch_service: availability and price override per branch.
- barber_service: which barbers perform which services, optional price/duration override
  (senior barber charges more), commission placeholder field for Phase 13.
- PricingService::quote(services, addons, barber, branch, customer) returns line items,
  tax, total in Money — the ONLY place prices are computed. Unit-test it heavily.
- Public catalog API for the customer app: categories → services with branch price.
- Dashboard: categories with drag-to-reorder, services data table, service drawer with
  tabs (Details, Pricing per branch, Barbers, Add-ons), image upload with crop.
- Audit log on price changes.
Tests: pricing combinations, overrides precedence (barber > branch > base), isolation.
```
