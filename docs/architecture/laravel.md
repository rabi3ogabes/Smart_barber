# Laravel architecture

The backend is a modular monolith with single-database tenancy. One deployable app, one MySQL database, strict module boundaries. — تطبيق واحد مقسّم إلى وحدات، وقاعدة بيانات واحدة مع عزل صارم بين الصالونات.

| Decision | Choice | Why |
|---|---|---|
| Structure | Modules under `app/Modules/{Name}` (Booking, Catalog, Pos, Loyalty, Membership, AiStudio, Marketing, Inventory, Billing…) each with Models, Actions, Http, Policies, Events, Jobs, routes, ServiceProvider | Features ship as sellable add-ons; boundaries stop spaghetti |
| Tenancy | Single DB, `salon_id` on every tenant table, `BelongsToSalon` trait + global scope, `CurrentSalon` singleton set by middleware | Cheapest to run for thousands of small salons; one migration path |
| Tenant resolution | Dashboard: subdomain (`{slug}.smartbarber.app`) or custom domain → salon. API: from the token's user/membership. Never from request body | Prevents cross-tenant spoofing |
| Permissions | spatie/laravel-permission with **teams** (team = salon); branch scope checked in Policies | Same user can be staff in two salons with different roles |
| Auth | Sanctum: SPA cookies for dashboard, tokens for mobile; customer login by phone OTP; 2FA (TOTP) for owners/admins | Gulf users expect phone login |
| Business logic | Single-purpose Action classes (`CreateBooking`, `CompletePosOrder`), called by controllers, jobs and commands | One place per rule, easy to test |
| Validation / output | FormRequests in, API Resources out, one response envelope | Consistent API for both apps |
| Money | Integer minor units + `currency` column; brick/money for maths; a `Money` value object cast | No rounding bugs |
| IDs | Big-int PK internally, ULID `public_id` exposed in URLs/API | No enumerable ids, fast joins |
| Queues | Redis + Horizon; queues: `default`, `notifications`, `ai`, `webhooks`, `reports` | AI and WhatsApp never block requests |
| Realtime | Laravel Reverb (WebSockets) on private salon channels | Live calendar, queue and POS updates |
| Files | S3-compatible disk, private by default, signed temporary URLs; images resized by a job | Customer photos are sensitive |
| Audit | `audit_logs` table written by model observers + explicit events (who, what, old, new, IP, device) | Owners need to trust refunds and price changes |
| API docs | Scribe-generated OpenAPI at `/docs/api`; Flutter models generated from it where practical | Keeps apps in sync |
| Tests | Pest; a shared `actingAsSalonUser()` helper; tenant-isolation dataset run against every endpoint | Isolation is proven, not assumed |

## Booking conflict prevention (the hardest part) / منع الحجز المزدوج

MySQL has no exclusion constraints, so the engine uses a lock plus a re-check inside one transaction:

1. `CreateBooking` opens a DB transaction.
2. It runs `SELECT … FOR UPDATE` on the barber's row in `barbers` (the lock key for that chair).
3. It re-checks overlap: `starts_at < :end AND ends_at > :start AND status IN (active statuses)` on `bookings(barber_id, starts_at, ends_at)` (indexed).
4. It re-checks working hours, breaks, holidays and buffer time from the branch schedule.
5. It inserts the booking and its `booking_services`, then commits. Two simultaneous requests serialise on the lock; the second sees the first and fails with a 409 and fresh slots.
6. "Any available barber" picks candidates by matching score, then tries each with the same locked check.

Availability (`GET /slots`) is a read-only calculation for display; the write path never trusts it.

## Folder sketch

```
backend/app/
  Core/            Tenancy, Money, Idempotency, ApiResponse, Audit, Settings, Features
  Modules/
    Salon/  Staff/  Catalog/  Booking/  Customer/  Pos/  Payment/
    Loyalty/  Membership/  HairHistory/  AiStudio/  Smart/  Notification/
    Marketing/  Analytics/  Assistant/  Inventory/  Commission/  Billing/  Admin/
      Models/ Actions/ Http/Controllers/ Http/Requests/ Http/Resources/
      Policies/ Events/ Listeners/ Jobs/ Enums/ Contracts/ routes/api.php
  Providers/
resources/js/      Vue 3 + TS dashboard (Pages/, Components/, Layouts/, i18n/)
```

## Provider interfaces (create in Phase 1, implement later)

`PaymentGateway`, `WhatsAppProvider`, `SmsProvider`, `PushProvider`, `AiImageProvider`, `AiTextProvider`, `StorageService`. Each has a fake implementation used in tests and local dev. — كل مزود خارجي خلف واجهة برمجية مع نسخة وهمية للاختبار.

## API conventions

- Prefix `/api/v1`. Plural nouns: `/bookings`, `/bookings/{id}/cancel` for state actions.
- Success: `{ "success": true, "message": "…", "data": {}, "meta": {} }`. Error: `{ "success": false, "message": "…", "code": "BOOKING_SLOT_TAKEN", "errors": {} }`.
- Machine-readable `code` on every error so apps show translated messages.
- `Accept-Language: ar|en` sets locale; messages come from `lang/ar` and `lang/en`.
- Cursor pagination for lists; `?include=` for optional relations; rate limits per user and per salon.
