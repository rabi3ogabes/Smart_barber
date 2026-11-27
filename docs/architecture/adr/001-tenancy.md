# ADR-001 — Single-database tenancy with salon_id

Status: Accepted (2026-11-27, owner approved defaults) · Phase 0 · Irreversible (schema shape)

## Context
Smart Barber targets thousands of small salons with low data volume each, sold on cheap plans. It needs one migration path, cross-salon platform reporting (MRR, usage), and customers who may visit more than one salon. A leak between salons would end the business.

## Decision
- One MySQL database. Every tenant-owned table has `salon_id` NOT NULL (FK, first in every composite index).
- `BelongsToSalon` trait: a global scope adds `where salon_id = CurrentSalon::id()` and `creating` fills `salon_id`. `salon_id` is never in `$fillable`.
- `CurrentSalon` is a request-scoped singleton set **only** by middleware:
  - web: subdomain `{slug}.smartbarber.app` (custom domains later), then a check that the user has an active membership;
  - staff API: `personal_access_tokens.salon_id` (the token is bound to one membership);
  - customer API: no CurrentSalon by default. Endpoints resolve the salon from the resource (`{salon}`, branch or booking) and then set CurrentSalon for the rest of the request;
  - queued jobs: the job carries `salon_id` and a `SetsCurrentSalon` job middleware restores it. A job without a salon fails closed;
  - console commands iterate salons explicitly (`Salon::each(fn …)`).
- When CurrentSalon is unset and a tenant model is queried outside an explicit `withoutSalonScope()` block (allowed only in Admin, Analytics aggregation and migrations), the scope **throws** instead of returning every salon's rows.
- Route model binding uses `public_id` through the scoped query, so a foreign id returns 404.
- Branch scope is a second layer, enforced in Policies plus a `BranchScoped` query macro. It is not a global scope, because owners see all branches.

## Consequences
- + Cheapest to run; trivial backups; platform analytics are plain SQL.
- + Phase 1 ships a TenantIsolation test dataset and every later phase adds its models to it.
- − A single forgotten scope leaks data, mitigated by fail-closed scopes, an arch test that every model in `Modules/*/Models` either uses `BelongsToSalon` or is on an explicit allow-list, and the per-endpoint isolation dataset.
- − Very large tenants share resources; they can be moved to dedicated shards later by `salon_id` if ever needed.

## Alternatives rejected
- Database per tenant (stancl/tenancy multi-DB): migration fan-out across thousands of DBs, costly cross-salon reporting, and customers spanning salons get harder.
- Schema per tenant: MySQL has no schemas distinct from databases; same issues.
