# ADR-002 — Authentication and identities

Status: Accepted (2026-11-27, owner approved defaults) · Phase 0 · Irreversible (identity model)

## Context
There are three kinds of people: salon staff (who may work in several salons with different roles), customers (phone-first, Gulf market, may visit several salons), and platform staff (Super Admin). Mobile apps need long sessions, and the dashboard needs SPA-grade security.

## Decision
Three separate identity tables and guards:

| Identity | Table | Login | Guard / transport |
|---|---|---|---|
| Staff | `users` (global) + `salon_user` memberships | Email + password; 2FA (TOTP) **mandatory** for anyone holding Owner or GM, optional for others | `web` session (Sanctum SPA cookies) on the salon subdomain; `staff` Sanctum tokens for the staff app |
| Customer | `customer_accounts` (global, phone UQ) + `customers` (one per salon) | Phone + OTP | `customer` Sanctum tokens |
| Platform | `platform_admins` | Email + password + mandatory TOTP | `platform` session on `admin.smartbarber.app` |

- **Customer split.** `customer_accounts` is the login identity. `customers` is the salon's own record of that person (notes, visits, spend, tags). A walk-in with no app has a `customers` row with `customer_account_id` null. When that phone later signs in to the app, `LinkCustomerAccount` links them by matching phone within the salon. This keeps salon data owned by the salon and lets one person use several salons.
- **Staff tokens are bound to one salon** (`personal_access_tokens.salon_id`). A staff member in two salons picks one at login (`select-salon`) and switches by getting a new token, so the salon is never ambiguous on a request.
- **Mobile tokens:** a short-lived access token (60 min) plus a rotating refresh token (60 days, stored hashed, single-use; reuse revokes the whole family). Both are kept in `flutter_secure_storage`.
- **OTP:** 6 digits, 5-minute expiry, at most 5 attempts per code, at most 3 sends per 15 minutes per phone and a per-IP limit. Codes are stored hashed. Sending goes through `OtpProvider` (log driver in dev; SMS or WhatsApp authentication template in prod, see the open questions).
- Login throttling on every credential endpoint; lockout notification to the owner on repeated staff failures.
- Super Admin impersonation (Phase 14) starts a time-limited session as a salon user, requires a reason, writes `impersonation_logs`, stamps `audit_logs.impersonator_id`, and shows a banner. The owner can see the history.

## Consequences
- + No cross-salon role confusion; "never trust a client salon_id" holds naturally.
- + Customer data stays per salon (salon A cannot see salon B's notes about the same person).
- − Two "customer" tables need clear naming in code (`CustomerAccount` vs `Customer`).
- − Deletion must cascade from the account to every linked salon profile (anonymisation; see spec-review item 12).

## Alternatives rejected
- One `users` table for everyone with a type column: it mixes very different security requirements and makes customer-in-many-salons messy.
- Customers scoped only per salon with no global account: the customer would repeat OTP and profile setup per salon and could not see all bookings in one app.
