# API map — phases 1–6

Status: **Accepted (Phase 0, 2026-11-27)**. All paths are under `/api/v1`. Responses use the envelope from `laravel.md`. `{x}` path parameters are ULID `public_id`s, except `{salon}`, which accepts the slug or the public_id.

## Auth and tenant rules

| Guard | Who | Token | How the salon is known |
|---|---|---|---|
| `customer` | Customer app | Sanctum token on `customer_accounts`, `salon_id` null | From the **resource**: `{salon}` for public reads; for writes, the branch or booking named in the request, whose salon is looked up server-side. A client-supplied `salon_id` field is never read. |
| `staff` | Staff app | Sanctum token on `users`, bound to **one** membership (`personal_access_tokens.salon_id`) | From the token. Switching salon issues a new token. |
| `web` | Dashboard (Inertia) | Session cookie | From the subdomain `{slug}.smartbarber.app` and the user's membership in it. |
| none | Public | — | — |

Column meanings: **Auth** = guard (`public`, `customer`, `staff`). **Perm** = permission key from `permissions.md` (scope applies), or `own` for customer ownership. **Idem** = an `Idempotency-Key` header is required (✓) or accepted (○). **Ph** = phase. Every write endpoint is rate-limited per user and per salon.

---

## Phase 1 — Foundation

| Method | Path | Auth | Perm | Idem | Notes |
|---|---|---|---|---|---|
| GET | `/meta/app-config` | public | — | | Minimum app version, maintenance flag, supported locales |
| POST | `/customer/auth/otp` | public | — | | `{phone}`; throttled per phone and per IP; returns `retry_after` |
| POST | `/customer/auth/otp/verify` | public | — | | `{phone, code, device}` → access + refresh token; creates the `customer_account` on first login |
| POST | `/customer/auth/refresh` | public (refresh token) | — | | Rotates the refresh token |
| POST | `/customer/auth/logout` | customer | own | | Revokes the token and its device |
| GET | `/customer/me` | customer | own | | |
| PATCH | `/customer/me` | customer | own | | Name, email, locale |
| POST | `/staff/auth/login` | public | — | | `{email, password, device_name?}` → tokens; or 409 `TWO_FACTOR_REQUIRED` with `data.challenge_token`; or 409 `SALON_SELECTION_REQUIRED` with `data.selection_token` + `data.memberships[]`; or 403 `TWO_FACTOR_ENROLLMENT_REQUIRED` (Owner/GM must enrol in the dashboard first) |
| POST | `/staff/auth/2fa` | public (challenge) | — | | `{challenge_token, code}` (TOTP or recovery code) → tokens or 409 `SALON_SELECTION_REQUIRED` |
| POST | `/staff/auth/select-salon` | public (selection) | — | | `{selection_token, membership}` → salon-bound tokens |
| POST | `/staff/auth/refresh` | public (refresh token) | — | | |
| POST | `/staff/auth/logout` | staff | — | | |
| GET | `/staff/me` | staff | — | | User, current salon, roles, permissions, branches, enabled features |
| GET | `/staff/me/salons` | staff | — | | For the salon switcher |
| POST | `/devices` | customer | own | | `{fcm_token, platform, app, locale, app_version}` (upsert) |
| DELETE | `/devices/{fcm_token}` | customer | own | | |
| POST | `/staff/devices` | staff | — | | Same body; under `/staff` so the device records the token's salon |
| DELETE | `/staff/devices/{fcm_token}` | staff | — | | |

## Phase 2 — Salon, branches, staff, schedules

Customer-facing reads (staff and dashboard management goes through Inertia, listed below):

| Method | Path | Auth | Perm | Idem | Notes |
|---|---|---|---|---|---|
| GET | `/salons/{salon}` | public | — | | Name, logo, cover, contact, booking policy text, **enabled features** |
| GET | `/salons/{salon}/branches` | public | — | | Active branches with address, map pin, today's hours |
| GET | `/branches/{branch}` | public | — | | Weekly hours, upcoming closures |
| GET | `/branches/{branch}/barbers` | public | — | | Bookable barbers: photo, display name, bio, specialties, rating |
| GET | `/staff/schedule` | staff | `schedule.view` (O) | | `?from=&to=` (branch-local dates, ≤ 31 days). Own working intervals in UTC, grouped by branch |
| GET | `/staff/time-off` | staff | `timeoff.request` | | Own requests |
| POST | `/staff/time-off` | staff | `timeoff.request` | ○ | |
| POST | `/staff/time-off/{request}/cancel` | staff | `timeoff.request` | | Own requests: pending, or approved and not yet started |

## Phase 3 — Services catalog

| Method | Path | Auth | Perm | Idem | Notes |
|---|---|---|---|---|---|
| GET | `/branches/{branch}/service-categories` | public | — | | Only categories with services available in this branch |
| GET | `/branches/{branch}/services` | public | — | | `?category=`; branch price, duration, add-ons, bundles; online-bookable only |
| GET | `/branches/{branch}/services/{service}` | public | — | | Includes `barbers[]` who perform it, with their price when it differs |

## Phase 4 — Booking engine

| Method | Path | Auth | Perm | Idem | Notes |
|---|---|---|---|---|---|
| GET | `/branches/{branch}/slots` | public | — | | `?services[]=&addons[]=&barber=any\|{id}&date=YYYY-MM-DD`; display only, the write path re-checks |
| POST | `/customer/quotes` | customer | own | | `{branch, services[], addons[], barber}` → server quote (line items, tax, total) |
| POST | `/customer/bookings` | customer | own | ✓ | `{branch, services[], addons[], barber\|any, starts_at, notes}`; 409 `BOOKING_SLOT_TAKEN` with fresh slots |
| GET | `/customer/bookings` | customer | own | | `?scope=upcoming\|past`, cursor pagination, across salons |
| GET | `/customer/bookings/{booking}` | customer | own | | With the status timeline and the cancellation policy |
| POST | `/customer/bookings/{booking}/reschedule` | customer | own | ✓ | `{starts_at, barber?}`; policy window enforced |
| POST | `/customer/bookings/{booking}/cancel` | customer | own | ○ | `{reason}`; 422 `BOOKING_CANCEL_WINDOW_PASSED` |
| GET | `/customer/bookings/{booking}/calendar.ics` | customer | own | | Add to calendar |
| GET | `/staff/bookings` | staff | `booking.view` | | `?date=&barber=`; barbers get their own |
| GET | `/staff/bookings/{booking}` | staff | `booking.view` | | |
| POST | `/staff/bookings` | staff | `booking.create` | ✓ | Walk-in or phone booking; `{customer\|new_customer, …}` |
| POST | `/staff/bookings/{booking}/reschedule` | staff | `booking.reschedule` | ✓ | |
| POST | `/staff/bookings/{booking}/cancel` | staff | `booking.cancel` | ○ | |
| POST | `/staff/bookings/{booking}/confirm` | staff | `booking.status.update` | | |
| POST | `/staff/bookings/{booking}/arrive` | staff | `booking.status.update` | | |
| POST | `/staff/bookings/{booking}/start` | staff | `booking.status.update` | | |
| POST | `/staff/bookings/{booking}/complete` | staff | `booking.status.update` | ○ | |
| POST | `/staff/bookings/{booking}/no-show` | staff | `booking.no_show` | | |
| GET | `/staff/customers` | staff | `customer.view` | | `?q=` by name or phone (masked for barbers) |
| POST | `/staff/customers` | staff | `customer.create` | ○ | Quick create; returns the existing customer when the phone matches |

Broadcast channels (Reverb, private): `salon.{salon}.branch.{branch}` (calendar events), `customer.{account}` (own booking updates). Channel auth reuses the Policies.

## Phase 5 — Customer app core

| Method | Path | Auth | Perm | Idem | Notes |
|---|---|---|---|---|---|
| GET | `/salons/search` | public | — | | `?q=`; returns only salons that allow listing (see spec-review item 2) |
| GET | `/salons/resolve` | public | — | | `?code=` from a QR code or deep link → salon |
| GET | `/customer/salons` | customer | own | | Salons this account has a profile in, most recent first |
| GET | `/customer/home` | customer | own | | `?salon=`; one call returning the next appointment, "Book again" suggestion, popular services and feature flags |
| POST | `/customer/me/avatar` | customer | own | | Image upload (resized by a job) |
| GET | `/customer/me/notification-preferences` | customer | own | | |
| PUT | `/customer/me/notification-preferences` | customer | own | | |
| POST | `/customer/me/deletion-request` | customer | own | ○ | Starts the anonymisation flow (spec-review item 12) |
| POST | `/customer/bookings/{booking}/review` | customer | own | ○ | Rating 1–5 and a comment, completed bookings only (spec-review item 6) |

## Phase 6 — POS, payments, invoices

POS runs in the dashboard (Inertia, tablet-first) in Phase 6. The staff-app POS arrives in Phase 8 and will use these same staff endpoints.

| Method | Path | Auth | Perm | Idem | Notes |
|---|---|---|---|---|---|
| POST | `/staff/pos/orders` | staff | `pos.access` | ✓ | `{booking?}` opens a draft order, pre-filled from the booking |
| GET | `/staff/pos/orders/{order}` | staff | `pos.access` | | |
| POST | `/staff/pos/orders/{order}/items` | staff | `pos.access` | ○ | |
| DELETE | `/staff/pos/orders/{order}/items/{item}` | staff | `pos.access` | | Draft orders only |
| POST | `/staff/pos/orders/{order}/discounts` | staff | `pos.discount.apply` (+ `above_threshold`) | ○ | |
| POST | `/staff/pos/orders/{order}/complete` | staff | `payment.take` | ✓ | `{payments: [{method, amount, tendered?}], tip?}`; split payments allowed |
| POST | `/staff/pos/orders/{order}/refunds` | staff | `payment.refund` | ✓ | `{items: [{item, qty}], method, reason}`; creates reversal rows and a credit note |
| POST | `/staff/pos/orders/{order}/void` | staff | `pos.order.void` | | Draft orders only |
| POST | `/staff/invoices/{invoice}/send` | staff | `invoice.resend` | ○ | `{channel: email\|whatsapp}` sends a signed link |
| GET | `/customer/invoices` | customer | own | | |
| GET | `/customer/invoices/{invoice}` | customer | own | | Returns a signed, temporary PDF URL |
| POST | `/webhooks/payments/{provider}` | public (signature) | — | (event id) | Verifies the signature, stores `gateway_webhook_events`, returns 200 quickly, processes on the `webhooks` queue |
| GET | `/i/{signed}` (web route, not API) | signed URL | — | | Public invoice view and PDF |

---

## Dashboard (Inertia web routes), phases 1–6

These routes call the same Actions as the API. They are listed so permissions get tested on them too. All live under `{slug}.smartbarber.app`.

| Ph | Area | Routes (resourceful unless noted) | Perm |
|---|---|---|---|
| 1 | Auth | `login`, `two-factor`, `forgot-password`, `reset-password`, `logout` | — |
| 1 | Shell | `/` dashboard, `/dev/components` (local and staging only) | `dashboard.view` |
| 2 | Settings | `/settings/salon` (show, update; the booking policy is part of this form), `/settings/salon/images/{logo\|cover}` | `salon.settings.*` |
| 2 | Branches | `/branches` index, store, update (details and hours in one form), `/branches/{b}/status`; `/closures` store, `/closures/{c}` destroy | `branch.*` |
| 2 | Staff | `/staff` index; `/staff/invitations` store, `{i}/resend`, `{i}` destroy (revoke); `/staff/{m}/access` (roles and branches); `/staff/{m}/status`; `/barbers/{b}/profile`; public `/invitations/{token}` show and accept | `staff.*` |
| 2 | Schedules | `/schedules` (weekly grid), `/schedules/{barber}` update, `/schedules/{barber}/overrides` store, `/schedule-overrides/{o}` destroy; `/time-off` index and store, `/time-off/{r}/decision`, `/time-off/{r}/cancel` | `schedule.*`, `timeoff.*` |
| 2 | Audit | `/audit-log` (filter by event group, cursor pages) | `audit_log.view` |
| 3 | Catalog | `/service-categories` (+ reorder), `/services` (+ branch pricing, barbers, add-ons tabs), `/addons`, `/bundles` | `service.*` |
| 4 | Calendar | `/calendar` (day and week), JSON: `/calendar/events`, `/calendar/slots` | `booking.view` |
| 4 | Bookings | `/bookings` index; store, reschedule, cancel, status actions (JSON responses for drawer and drag) | `booking.*` |
| 4 | Customers | `/customers` index, show, store, update | `customer.*` |
| 6 | POS | `/pos` (screen), JSON: order, items, discounts, complete, refund | `pos.*`, `payment.*` |
| 6 | Shifts | `/cash-shifts` index, open, close, report | `cash_shift.*` |
| 6 | Invoices | `/invoices` index, show, PDF, resend | `invoice.*` |
| 6 | Reports | `/reports/sales` (by method, by barber, refunds) | `report.sales.view` |
| 6 | Payment methods | `/settings/payment-methods` | `payment_method.manage` |

## Error codes introduced in phases 1–6 (non-exhaustive)

`VALIDATION_FAILED`, `UNAUTHENTICATED`, `FORBIDDEN`, `NOT_FOUND`, `RATE_LIMITED`, `OTP_INVALID`, `OTP_EXPIRED`, `OTP_TOO_MANY_ATTEMPTS`, `TWO_FACTOR_REQUIRED`, `SALON_SELECTION_REQUIRED`, `SALON_SUSPENDED`, `FEATURE_NOT_AVAILABLE`, `IDEMPOTENCY_KEY_REQUIRED`, `IDEMPOTENCY_KEY_REUSED` (same key, different body), `IDEMPOTENCY_IN_PROGRESS`, `BOOKING_SLOT_TAKEN`, `BOOKING_OUTSIDE_HOURS`, `BOOKING_LEAD_TIME`, `BOOKING_TOO_FAR_AHEAD`, `BOOKING_INVALID_TRANSITION`, `BOOKING_CANCEL_WINDOW_PASSED`, `BARBER_NOT_ELIGIBLE`, `SERVICE_UNAVAILABLE_AT_BRANCH`, `POS_ORDER_NOT_DRAFT`, `POS_DISCOUNT_NEEDS_APPROVAL`, `PAYMENT_AMOUNT_MISMATCH`, `REFUND_EXCEEDS_PAID`, `CASH_SHIFT_NOT_OPEN`.
