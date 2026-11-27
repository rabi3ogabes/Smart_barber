# Permissions

Status: **Proposed (Phase 0)**. Permissions use spatie/laravel-permission with teams (team = salon). Roles are per salon and are copied from platform templates when a salon is created. Owners may later create custom roles from these keys (see [spec-review](spec-review.md) item 15).

## Scope legend

| Mark | Meaning |
|---|---|
| ✓ | Allowed for the whole salon (all branches) |
| B | Allowed only in branches assigned to the membership (`salon_user_branches`) |
| O | Own records only (e.g. a barber's own bookings, own schedule, own commission) |
| – | Not allowed |

A permission key says **whether** a role may act. Its scope (✓, B, O) is applied in the Policy and in the query scope. A Branch Manager with `booking.view` therefore sees only bookings in the Branch Manager's branches.

Roles: **OW** Owner · **GM** General Manager · **BM** Branch Manager · **RC** Receptionist · **BR** Barber · **AC** Accountant · **MM** Marketing Manager · **IM** Inventory Manager.

Super Admin and Customer are not salon roles; they are covered at the end.

## Default matrix

### Dashboard and salon setup

| Key | OW | GM | BM | RC | BR | AC | MM | IM |
|---|---|---|---|---|---|---|---|---|
| `dashboard.view` | ✓ | ✓ | B | B | O | ✓ | ✓ | B |
| `salon.settings.view` | ✓ | ✓ | – | – | – | ✓ | – | – |
| `salon.settings.update` | ✓ | ✓ | – | – | – | – | – | – |
| `branch.view` | ✓ | ✓ | B | B | B | ✓ | ✓ | B |
| `branch.manage` (create, update, deactivate, hours, closures) | ✓ | ✓ | B¹ | – | – | – | – | – |
| `audit_log.view` | ✓ | ✓ | B | – | – | ✓ | – | – |
| `billing.view` (the salon's own subscription) | ✓ | – | – | – | – | ✓ | – | – |
| `billing.manage` | ✓ | – | – | – | – | – | – | – |

¹ A Branch Manager may edit hours and closures of the Branch Manager's own branches but may not create or deactivate branches.

### Staff and schedules

| Key | OW | GM | BM | RC | BR | AC | MM | IM |
|---|---|---|---|---|---|---|---|---|
| `staff.view` | ✓ | ✓ | B | B | – | ✓ | – | – |
| `staff.invite` | ✓ | ✓ | B² | – | – | – | – | – |
| `staff.update` (profile, branches) | ✓ | ✓ | B | – | O³ | – | – | – |
| `staff.deactivate` | ✓ | ✓ | – | – | – | – | – | – |
| `staff.roles.assign` | ✓ | ✓⁴ | – | – | – | – | – | – |
| `schedule.view` | ✓ | ✓ | B | B | O | – | – | – |
| `schedule.update` | ✓ | ✓ | B | – | – | – | – | – |
| `timeoff.request` | – | – | ✓ | ✓ | O | – | – | – |
| `timeoff.approve` | ✓ | ✓ | B | – | – | – | – | – |

² A Branch Manager may invite only Receptionist and Barber roles, only into the Branch Manager's branches.
³ A barber may edit only their own bio and photo.
⁴ A GM may not assign or remove the Owner or GM roles.

### Catalog

| Key | OW | GM | BM | RC | BR | AC | MM | IM |
|---|---|---|---|---|---|---|---|---|
| `service.view` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `service.manage` (create, update, reorder, deactivate) | ✓ | ✓ | – | – | – | – | – | – |
| `service.price.update` (base, branch and barber prices) | ✓ | ✓ | B⁵ | – | – | – | – | – |

⁵ Branch price overrides only.

### Bookings and customers

| Key | OW | GM | BM | RC | BR | AC | MM | IM |
|---|---|---|---|---|---|---|---|---|
| `booking.view` | ✓ | ✓ | B | B | O | ✓ | – | – |
| `booking.create` | ✓ | ✓ | B | B | O⁶ | – | – | – |
| `booking.reschedule` | ✓ | ✓ | B | B | O | – | – | – |
| `booking.cancel` | ✓ | ✓ | B | B | – | – | – | – |
| `booking.cancel.override_policy` (inside the cancellation window, waive the fee) | ✓ | ✓ | B | – | – | – | – | – |
| `booking.status.update` (arrived, start, complete) | ✓ | ✓ | B | B | O | – | – | – |
| `booking.no_show` | ✓ | ✓ | B | B | – | – | – | – |
| `customer.view` | ✓ | ✓ | B⁷ | B⁷ | O⁷ | ✓ | ✓ | – |
| `customer.create` | ✓ | ✓ | B | B | O | – | – | – |
| `customer.update` | ✓ | ✓ | B | B | – | – | – | – |
| `customer.notes.private` (read and write internal notes) | ✓ | ✓ | B | B | O | – | – | – |
| `customer.contact.view` (full phone and email) | ✓ | ✓ | B | B | – | – | ✓ | – |
| `customer.export` | ✓ | – | – | – | – | – | – | – |
| `customer.merge` | ✓ | ✓ | – | – | – | – | – | – |
| `review.moderate` | ✓ | ✓ | – | – | – | – | – | – |

⁶ A barber may book only into their own calendar (e.g. a returning client).
⁷ Customers who have visited, or are booked into, a branch in scope. Barbers see only their own clients, and see phone numbers masked.

### POS, payments, invoices

| Key | OW | GM | BM | RC | BR | AC | MM | IM |
|---|---|---|---|---|---|---|---|---|
| `pos.access` | ✓ | ✓ | B | B | O⁸ | – | – | – |
| `pos.discount.apply` (up to the threshold) | ✓ | ✓ | B | B | – | – | – | – |
| `pos.discount.above_threshold` | ✓ | ✓ | B | – | – | – | – | – |
| `pos.order.void` (draft orders only) | ✓ | ✓ | B | B | – | – | – | – |
| `payment.take` | ✓ | ✓ | B | B | O⁸ | – | – | – |
| `payment.refund` | ✓ | ✓ | B | – | – | ✓ | – | – |
| `payment_method.manage` | ✓ | ✓ | – | – | – | ✓ | – | – |
| `invoice.view` | ✓ | ✓ | B | B | O | ✓ | – | – |
| `invoice.resend` | ✓ | ✓ | B | B | – | ✓ | – | – |
| `cash_shift.operate` (open, close, paid in/out) | ✓ | ✓ | B | B | – | – | – | – |
| `cash_shift.report` | ✓ | ✓ | B | – | – | ✓ | – | – |
| `report.sales.view` | ✓ | ✓ | B | – | O | ✓ | – | – |

⁸ Only when the salon setting `pos.barber_checkout` is on.

### Premium modules

| Key | OW | GM | BM | RC | BR | AC | MM | IM |
|---|---|---|---|---|---|---|---|---|
| `loyalty.view` | ✓ | ✓ | B | B | O | ✓ | ✓ | – |
| `loyalty.manage` (programs) | ✓ | ✓ | – | – | – | – | ✓ | – |
| `loyalty.adjust` (manual ledger adjustment) | ✓ | ✓ | – | – | – | – | – | – |
| `membership.view` | ✓ | ✓ | B | B | O | ✓ | ✓ | – |
| `membership.manage` (plans) | ✓ | ✓ | – | – | – | – | – | – |
| `membership.sell` | ✓ | ✓ | B | B | – | – | – | – |
| `membership.pause_cancel` | ✓ | ✓ | B | – | – | – | – | – |
| `hair_history.view` | ✓ | ✓ | B | B | O | – | – | – |
| `hair_history.record` | ✓ | ✓ | B | – | O | – | – | – |
| `hair_history.photos.view` | ✓ | ✓ | B | – | O | – | – | – |
| `ai_studio.manage` (settings, limits, usage) | ✓ | ✓ | – | – | – | – | ✓ | – |
| `queue.view` | ✓ | ✓ | B | B | B | – | – | – |
| `queue.manage` (call, assign, reorder) | ✓ | ✓ | B | B | O⁹ | – | – | – |
| `notification.templates.manage` | ✓ | ✓ | – | – | – | – | ✓ | – |
| `whatsapp.settings.manage` | ✓ | – | – | – | – | – | – | – |
| `segment.manage` | ✓ | ✓ | – | – | – | – | ✓ | – |
| `campaign.view` | ✓ | ✓ | – | – | – | – | ✓ | – |
| `campaign.create` | ✓ | ✓ | – | – | – | – | ✓ | – |
| `campaign.approve` | ✓ | ✓ | – | – | – | – | – | – |
| `offer_code.manage` | ✓ | ✓ | – | – | – | – | ✓ | – |
| `analytics.view` (operational KPIs) | ✓ | ✓ | B | – | O | ✓ | ✓ | B |
| `analytics.financial` (revenue, MRR, commission totals) | ✓ | ✓ | B | – | – | ✓ | – | – |
| `analytics.export` | ✓ | ✓ | – | – | – | ✓ | – | – |
| `assistant.use` | ✓ | ✓ | B | – | – | ✓ | ✓ | – |
| `inventory.view` | ✓ | ✓ | B | B | – | ✓ | – | ✓ |
| `inventory.manage` (products, suppliers) | ✓ | ✓ | – | – | – | – | – | ✓ |
| `inventory.adjust` | ✓ | ✓ | B | – | – | – | – | ✓ |
| `inventory.transfer` | ✓ | ✓ | – | – | – | – | – | ✓ |
| `purchase_order.manage` | ✓ | ✓ | – | – | – | – | – | ✓ |
| `stocktake.perform` | ✓ | ✓ | B | – | – | – | – | ✓ |
| `commission.view` | ✓ | ✓ | B | – | O | ✓ | – | – |
| `commission.rules.manage` | ✓ | – | – | – | – | ✓ | – | – |
| `commission.statement.approve` | ✓ | – | – | – | – | ✓ | – | – |

⁹ A barber may call the next customer assigned to them, or take an unassigned one.

The assistant inherits the caller's permissions. A tool such as `revenue_by_period` refuses (and says so) when the user lacks `analytics.financial`.

## Customer (customer app, `customer` guard)

A customer is not a spatie role. Customer endpoints are authorised by ownership: the resource's `customers.customer_account_id` must equal the token's account. Abilities:

- read the public catalog, branches, barbers and slots of any **active** salon;
- create, reschedule and cancel **own** bookings (within policy);
- read own appointments, invoices, loyalty, memberships, hair history and AI Studio sessions;
- join and leave the queue; review own completed bookings;
- manage profile, consents, notification preferences; request account deletion.

## Super Admin (`platform` guard, separate subdomain, 2FA mandatory)

| Key | Super Admin | Support (optional later) |
|---|---|---|
| `platform.dashboard.view` | ✓ | ✓ |
| `platform.salons.manage` (create, suspend, reactivate) | ✓ | – |
| `platform.salons.view` | ✓ | ✓ |
| `platform.impersonate` (requires a reason; logged and shown to the owner) | ✓ | ✓ |
| `platform.plans.manage` / `platform.addons.manage` / `platform.coupons.manage` | ✓ | – |
| `platform.subscriptions.manage` | ✓ | – |
| `platform.audit.view` | ✓ | ✓ |
| `platform.settings.manage` / `platform.providers.view` | ✓ | – |

Super Admin has **no implicit access inside a salon**. Seeing salon data means impersonating, and every action during impersonation writes `audit_logs.impersonator_id`.

## Tests

The Phase 1 test helper builds a **route × role** dataset from this file: one row per protected route, expecting 200/201 for allowed roles and 403 for the rest. Branch scope (B) gets its own dataset, which expects 404 for a record in a branch outside the scope.
