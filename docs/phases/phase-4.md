# Phase 4 — Booking engine — Report

Status: **DONE**. The gate is met: no double booking, even with 10 simultaneous requests for the same chair. Two small API items moved to Phase 5 (section 9).

## 1. Implemented (what a user can now do)

**Reception and managers: Calendar** (`/calendar`)
- **Day view:** one column per barber, white where they work and grey outside working hours, breaks, closures, day-offs and time off. A red now-line marks the current time.
- **Week view:** one barber, Saturday to Friday.
- **Colours by status:** pending, confirmed, arrived, in service, completed, no-show. Cancelled bookings are hidden unless "Show cancelled" is on.
- **Filters:** by barber (day view) and by service.
- **Drag to move:** drag a booking to another time or barber. The server re-checks everything. If the spot is taken, the booking jumps back and a toast lists the next free times (409 `BOOKING_SLOT_TAKEN`).
- **New booking:** click an empty time, or press **New booking**. The drawer:
  - **Customer:** search by name or phone (Arabic digits work), or create a customer in place. The phone is normalised to E.164.
  - **Services, barber and date:** pick services, a specific barber or **Any available barber**, and a date.
  - **Free times and price:** the free times and the price come from the server. A manual time is also allowed; the server still checks it.
  - **Extras:** booked via (dashboard, phone, walk-in), a customer note, and an internal note.
- **Booking drawer:** time, barber, customer (visits and no-shows), services with prices, total and the timeline.
  - **Actions:** Confirm, Arrived, Start service, Complete, Move (date, time, barber), No-show and Cancel. Each shows only when the status and the user's permissions allow it.
  - **Cancel:** takes a reason. Managers may override the cancellation window.
  - **No-show:** possible only after the start time. Managers may waive the fee.
- **Live updates:** with Reverb running, other screens update instantly through `booking.changed`. Otherwise the calendar refreshes quietly every minute.

**Bookings list** (`/bookings`)
- Filter by date range, status, barber, and customer name or phone, with pagination.
- Click a row to open the same booking drawer.

**Customers (minimal)**
- One profile per salon and phone, created from the booking drawer or the staff app, or automatically on the first app booking (linked to the app account).
- Barbers see masked phone numbers.

**No-show fee** (spec-review Q9 default: record the amount owed; the POS collects it in Phase 6)
- A no-show adds the salon's fee to the append-only `customer_dues` ledger and counts the no-show on the customer.

**Customer app API** (screens arrive in Phase 5)
- Slots for a selection and date, and a server quote.
- Create bookings (Idempotency-Key required).
- List upcoming and past bookings, across salons.
- Show a booking with its timeline and the salon's change window.
- Reschedule (key required) and cancel, both inside the window.

**Staff app API**
- The day's bookings (barbers see their own chair).
- Create walk-in or phone bookings (key required) and reschedule (key required).
- Cancel, confirm, arrive, start, complete and no-show.
- Customer search and quick create.

**Reminders:** each booking queues a 24 h and a 2 h reminder through the `NotificationChannel` stub; real channels come in Phase 11. A reminder for a moved or cancelled booking does nothing.

## 2. How "no double booking" is guaranteed (ADR-004, as built)

`CreateBooking` and `RescheduleBooking` share `BookingWriter::locked()`:
1. **Isolation:** `SET TRANSACTION ISOLATION LEVEL READ COMMITTED`, so reads after the lock see rows committed while this request waited.
2. **Lock:** `SELECT … FOR UPDATE` on the barber row (both barbers when moving between them, always in ascending id order).
3. **Price:** `PricingService::quote()` for that barber. This also proves the barber performs every service; same-barber moves keep the booked price.
4. **Hours:** the service range must fit inside one `ScheduleService` working interval.
5. **Overlap:** `starts_at < :blocked_until AND blocked_until > :starts_at` over active statuses. Touching is allowed, and the buffer is included.
6. **Write:** insert the booking, the line snapshots (`booking_services`) and the history row, then commit. Events, the broadcast and the reminders go out after commit.

**"Any barber":** tries eligible barbers (bookable, active, working at the branch, performing every service) in order: fewest bookings that day, then display order. It holds one lock at a time.

**Proof:** `tests/Concurrency/ParallelBookingTest.php` starts **10 separate PHP processes** with `Process::pool`. Each has its own MySQL connection, and they wait at a shared start instant.
- **Same start:** exactly 1 booking and 9 `BOOKING_SLOT_TAKEN`.
- **Staggered, overlapping starts:** the stored bookings never overlap.
- **Without the lock:** the test fails, because 4 of the 10 processes booked the same slot. I checked this by temporarily removing the lock.

## 3. Files created

| Area | Files |
|---|---|
| Migration | `2026_11_30_000100_create_customer_and_booking_tables` (customers, customer_dues, bookings, booking_services, booking_status_history) |
| Booking module | `Enums/{BookingStatus, BookingSource}`; models `Booking`, `BookingItem`, `BookingStatusHistory`; `Availability/{AvailabilityService, EligibleBarbers, BookingWindow}`; actions `CreateBooking`, `RescheduleBooking`, `CancelBooking`, `ChangeBookingStatus`; `Support/{BookingWriter, TransitionBooking, Selection, SlotUnavailable, BookingInput, BookingPresenter, BookingReminders, StaffBookingOps}`; events `BookingCreated/Confirmed/Cancelled/Rescheduled/Completed`, `BookingChanged` (broadcast); `Jobs/SendBookingReminder`; `Policies/BookingPolicy`; web `CalendarController`, `BookingController`; API `PublicSlotsController`, `CustomerBookingController`, `StaffBookingController`; routes; `BookingServiceProvider` |
| Customer module | `Models/{Customer, CustomerDue}`; `Actions/FindOrCreateCustomer`; `Support/CustomerSearch`; `Policies/CustomerPolicy`; web `CustomerLookupController`; API `StaffCustomerController`; routes; `CustomerServiceProvider` |
| Core | `Core/Support/PhoneNumber` (E.164 normalisation, Arabic digits) |
| Dashboard | `Pages/Calendar/Index.vue`, `Pages/Bookings/Index.vue`; `Components/Booking/{BookingDrawer, NewBookingDrawer}.vue` + `types.ts`; `Composables/{useJson, useZonedTime}.ts` |
| Tests | `tests/Support/{BookingFixture.php, book_once.php}`; `tests/Feature/Booking/{BookingEngineTest, BookingApiTest, CalendarWebTest}.php`; `tests/Concurrency/ParallelBookingTest.php` |
| Docs | `docs/architecture/adr/008-calendar-component.md`, this report, the screenshots in `docs/phases/phase-4/` |

## 4. Files modified

- **`ErrorCode`:** 8 booking codes with AR/EN messages:
  - 409: `BOOKING_SLOT_TAKEN`, `BOOKING_INVALID_TRANSITION`.
  - 422: `BOOKING_OUTSIDE_HOURS`, `BOOKING_LEAD_TIME`, `BOOKING_TOO_FAR_AHEAD`, `BOOKING_IN_PAST`, `BOOKING_CANCEL_WINDOW_PASSED`, `BOOKING_NOT_STARTED`.
- **`WebAppExceptionRenderer`:** dashboard JSON requests get the API envelope (code, message, data), so the calendar can revert a drag and show alternatives.
- **`routes/channels.php`:** authorises the private channel `salon.{salon}.branch.{branch}` to active members who can see bookings in that branch.
- **Providers, routes and menu:** module providers and routes registered; Calendar and Bookings menu items are live.
- **`SbSelect`:** accepts options whose value is `""` ("All …"). Reka rejects empty values; this bug was found by the browser check.
- **`DemoSalonBuilder`:** seeds 5 customers and today's and tomorrow's bookings through the real engine.
- **Translations:** about 85 keys in `lang/{ar,en}.json`, with English plural forms.
- **Packages:** `laravel-echo` 2.2.0 and `pusher-js` 8.4.0, pinned and loaded only when broadcasting is on.
- **Tests:** `tests/Pest.php` registers `Concurrency`; `TenantScopeTest` has +3 models.
- **Docs:** `api-map.md` (dashboard routes as built; `calendar.ics` marked for later), `modules.md` (as built for Booking and Customer).

## 5. Migrations

| Table | Purpose |
|---|---|
| `customers` | per salon: name, phone (unique per salon), optional account link, locale, source, cached visits, no-shows and spend |
| `customer_dues` | **append-only** amounts owed (`no_show_fee`; waivers and settlements as new signed rows with `reverses_id`) |
| `bookings` | branch, customer, barber, `starts_at` / `ends_at` / `blocked_until` (UTC), status, source, notes, cancellation fields, amounts in minor units + currency, `quote_snapshot`, reschedule count, creator. Indexed for the overlap check (`barber_id, starts_at, blocked_until`) and the calendar |
| `booking_services` | snapshot of each priced line (name AR/EN, price, discount, tax, total, duration) |
| `booking_status_history` | **append-only** timeline; reschedules store old and new time and barber in `meta` |

## 6. API endpoints (`/api/v1`)

| Method | Path | Auth | Idempotency |
|---|---|---|---|
| GET | `/branches/{branch}/slots?services[]=&addons[]=&bundles[]=&barber=any\|id&date=` | public | |
| POST | `/customer/quotes` | customer | |
| GET / POST | `/customer/bookings` | customer | POST **required** |
| GET | `/customer/bookings/{booking}` | customer (own) | |
| POST | `/customer/bookings/{booking}/reschedule` | customer (own) | **required** |
| POST | `/customer/bookings/{booking}/cancel` | customer (own) | optional |
| GET / POST | `/staff/bookings` | staff, `booking.view` / `booking.create` | POST **required** |
| GET | `/staff/bookings/{booking}` | staff, `booking.view` | |
| POST | `/staff/bookings/{booking}/reschedule` | `booking.reschedule` | **required** |
| POST | `/staff/bookings/{booking}/cancel` | `booking.cancel` (+ `override_policy`) | optional |
| POST | `/staff/bookings/{booking}/{confirm\|arrive\|start\|complete\|no-show}` | `booking.status.update` / `booking.no_show` | optional |
| GET / POST | `/staff/customers` | `customer.view` / `customer.create` | POST optional |

There are also 13 dashboard routes; see `api-map.md`.

## 7. Screens

Screenshots were taken with Playwright against the seeded database. No console errors were found, and the mobile page width was 390 px (no horizontal scroll).

| Screen | |
|---|---|
| Calendar, day, Arabic (one barber on a day off) | [01](phase-4/01-calendar-day-ar.png) |
| Booking drawer with actions | [02](phase-4/02-booking-drawer-ar.png) |
| Week view with the now-line | [03](phase-4/03-calendar-week-ar.png) |
| New booking: customer, services, free times, price | [04](phase-4/04-new-booking-ar.png) |
| Bookings list with filters | [05](phase-4/05-bookings-list-ar.png) |
| Calendar in English, dark mode, mobile | [06](phase-4/06-calendar-day-en.png), [07](phase-4/07-calendar-dark-en.png), [08](phase-4/08-calendar-mobile-en.png) |

The required states are in place:
- **Loading:** skeleton in the drawer, `aria-busy` on the grid, the refresh spinner.
- **Empty:** no barbers, no bookings, no free times.
- **Error:** with a retry button in the calendar and the drawer.
- **Validation and domain errors:** field errors, and toasts with alternatives.
- **No permission:** actions shown only when allowed; out-of-scope bookings return 404.
- **Success:** a toast.

## 8. Tests and quality gates

| Gate | Result |
|---|---|
| `vendor/bin/pint` | passed |
| `phpstan analyse` (Larastan level 6) | **0 errors** (6 fixed at the cause) |
| `php vendor/bin/pest` | **229 tests, 1,527 assertions, all passing** (31 new), including the 10-process concurrency test |
| `npm run lint` (ESLint, RTL, i18n) | passed (74 files, 657 keys) |
| `vue-tsc --noEmit` / `npm run build` | 0 errors / passed |
| `tool/flutter_check.sh` (no Dart changes) | `flutter analyze --fatal-infos`: **0 issues** on all 5 members; `flutter test`: **54 tests passing** |

**Engine tests (15):**
- **Create:** snapshots, history and events.
- **Overlaps:** touching blocked ranges are allowed; overlaps are refused, including inside the buffer.
- **Hours:** 409 with 3 alternatives; breaks and multi-range days; approved time off.
- **"Any" barber:** falls through to the next barber and fails only when nobody is free; ordered by fewest bookings that day.
- **Eligibility:** a barber who doesn't perform the service is refused.
- **App bookings:** lead time, days ahead, the past, and auto-confirm.
- **Slots:** respect bookings, buffers, breaks and the 15-minute grid.
- **Reschedule:**
  - Keeps the same row, logs the old and new times, allows onto itself, refuses conflicts, and can switch barbers.
- **Status machine:** the full flow, with invalid transitions refused.
- **Cancel and no-show:**
  - The cancellation window, unless overridden.
  - A no-show only after the start; the fee goes to an append-only ledger and the row cannot be edited.
- **Reminders and broadcast:**
  - Reminders are queued at 24 h and 2 h; one for a moved booking does nothing.
  - The broadcast uses the right channel and a payload of ids only.

**API tests (7):**
- Public slots.
- Quote, then create: a missing Idempotency-Key gives 428, and a retry with the same key returns the same booking.
- 409 with alternatives.
- **Customer:** list, show, reschedule and cancel; another account gets 404.
- **Reception flow** through the staff API, with a walk-in customer whose phone is normalised.
- **Barbers:** limited to their own chair, with masked phones.
- **Isolation:** salon B cannot read, cancel or book salon A.

**Dashboard tests (6):**
- Calendar page and events with working hours.
- Booking a new walk-in customer with Arabic digits, then customer search.
- Drag with a 409 and alternatives, then a move to the other barber.
- Status actions, and 409 on invalid transitions.
- List filters.
- **Scope:** a branch manager gets 404 for another branch; a barber sees only their own bookings.

**Concurrency (2):** see section 2.

**Isolation dataset:** +3 models (customers, customer dues, bookings).

## 9. Known limitations and tech debt

- **Not built yet:**
  - **`calendar.ics`** (add-to-calendar file) moves to Phase 5, with the app screens.
  - **Booking reviews** (`booking_reviews`) are not built yet. They come with ratings in the customer app (Phase 5/10).
- **Calendar interactions:**
  - Bookings in one column are not laid out side by side. Active bookings can't overlap, so only cancelled ones (hidden by default) could.
  - Moving a booking with the keyboard is done in the drawer (Move), not by dragging.
- **Live updates need Reverb running** (`php artisan reverb:start` and `BROADCAST_CONNECTION=reverb`). Without it, the one-minute refresh keeps the calendar current. The demo server runs without Reverb.
- **Reminders need a queue worker** to fire at the right time. With `QUEUE_CONNECTION=sync`, delayed jobs run immediately, and the reminder only writes to the log until Phase 11.
- **The salon-timezone "today" rule** (Phase 2 note) still applies to the date validation of closures, overrides and time off. Booking times are checked as UTC instants, so bookings are not affected.
- **Customer profiles page:** search and quick create only. The CRM screens (profile, notes, merge, export) come later.
- **No-show fee in the app:** the amount owed is recorded but not shown to the customer yet; it is shown when the POS collects it (Phase 6).

## 10. How to run, seed and demo

```bash
cd backend
php artisan migrate:fresh --seed
npm run build
QUEUE_CONNECTION=sync php artisan serve
```

Open `http://salon-a.localhost:8000/calendar` and sign in as `manager.a@smartbarber.test` / `Password123!`. Today's and tomorrow's demo bookings are there. Drag one, click an empty time to book, or open a booking to arrive, start and complete it.

For live updates in a second window, run `php artisan reverb:start` and set `BROADCAST_CONNECTION=reverb`.

Concurrency proof only: `php vendor/bin/pest tests/Concurrency`.

## 11. What remains, and what the next phase needs

- **Phase 5 (customer app):**
  - Use the slots, quote and booking APIs. Send a new `Idempotency-Key` per create or reschedule intent; `sb_core` already does this.
  - Show `BOOKING_SLOT_TAKEN` alternatives.
  - Add `calendar.ics` and reviews.
- **Phase 6 (POS):**
  - Open an order from a completed booking (`quote_snapshot` and `booking_services`).
  - Collect `customer_dues` and settle them with a negative row.
- **Phase 8 (staff app):** use `/staff/bookings` and the transition endpoints.
- **Phase 10 (smart features):** replace the "any barber" order with matching scores in `EligibleBarbers`.
- **Phase 11 (notifications):** listen to the `Booking*` events and implement the `booking.reminder_24h` / `_2h` templates.

## 12. Decisions made

- **ADR-008:** a custom calendar instead of FullCalendar Premium.
- **Q9 default applied:** a no-show fee becomes an amount owed in an append-only ledger. It is not charged online.
- **Staff vs customer rules:**
  - Staff bookings are always confirmed. App bookings follow `booking.auto_confirm` (on by default).
  - Staff may record a walk-in that started up to 15 minutes ago. Customers must respect the lead time and days ahead.
  - The online change window (`cancellation_window_minutes`) binds customers' moves and cancellations. Staff may move bookings at any time, but need `booking.cancel.override_policy` to cancel inside the window.
- **Moves and prices:** moving a booking keeps its price for the same barber; moving it to another barber re-prices it for that barber.
- **Errors and payloads:**
  - Out-of-scope bookings are 404, like branches (permissions.md).
  - The broadcast carries ids only; the calendar re-reads through its authorised endpoint.
