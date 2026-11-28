# Phase 5 — Customer app core — Report

Status: **DONE**. The customer app now covers the whole customer journey, from finding the salon to rating the visit. Every gate passes. Push stays off until a Firebase project is configured (section 9).

## 1. Implemented (what a user can now do)

**Customers: find the salon** (spec-review item 2: QR and link first)
- **Ways in:**
  - Scan the salon's QR code with the in-app scanner.
  - Open a `smartbarber://salon/{slug}` link.
  - Type the salon code or paste its link.
  - Pick from **Your salons** (every salon booked with before).
- **Search** by name. It finds only salons that opted in (`listing.enabled`, off by default) and says so when nothing matches.
- **Remembered:** the app remembers the last salon and, per salon, the chosen branch. **Change salon** is in Home and Profile.
- **Branch picker:** each branch with today's hours ("Open today 10:00–22:00" / "Closed today") and a **Directions** button that opens the phone's maps app (ADR-010).

**Home**
- **Greeting** by time of day and name.
- **Next appointment card:** time in the branch's timezone, services, salon, branch and barber, with **Reschedule** and **Cancel**.
- **Rate your last visit:** a prompt for a completed visit from the last 14 days.
- **Book again** chip: pre-fills the same services, add-ons and barber, then jumps to the barber step.
- **Popular services:** the most booked in the last 90 days, with branch prices. Tapping one starts a booking.
- **AI Studio and Rewards** cards appear only when the salon has those features ("Coming soon").
- **States:** pull to refresh, skeletons, and an error state with retry.

**Book (stepper, 4 steps with a progress bar)**
1. **Services** with their add-ons (chips under a selected service), plus packages.
2. **Barber:** **Any available barber**, or a barber with photo or initial, rating and specialties.
3. **Date and time:** a date strip in the branch timezone (as far ahead as the salon allows) and free times from the API.
4. **Summary:** the server's quote (lines, discount, VAT when added on top, total, duration), date, time, barber, an optional note and "You pay at the salon".

On **Confirm**:
- **Slot taken (409):** the app returns to the time step with an inline notice ("Someone just booked that time"), refreshed times, and the server's suggested times listed first.
- **Network error:** shown inline above the button. Confirming again **reuses the same Idempotency-Key**, so a retry can never book twice.
- **Done:** "You're booked" (or "Request sent" when the salon confirms manually), with **View appointment**.

**Visits** (Upcoming / Past tabs)
- **List:** cards with status, paging as you scroll, pull to refresh, and friendly empty states.
- **Appointment detail:**
  - Date and time range (branch timezone), barber and branch.
  - **Add to calendar** (the server's `.ics`, handed to the system share sheet), **Directions** and **Call**.
  - Priced lines and total, the status **timeline**, and your rating if given.
- **Reschedule:** same services and barber; pick a new day and time. A 409 shows the same inline notice and refreshed times.
- **Cancel:** asks first. Above the buttons, the policy reads "Free changes until Sat 28 Nov, 09:00". The server enforces the window.
- **Rate your visit** (completed visits): 1–5 stars, required, plus an optional comment. Sent once, with an Idempotency-Key.
- **Notification links:** `smartbarber://booking/{id}` (the target of booking notifications) opens this screen. When signed out, it opens after sign-in.

**Profile**
- **Account:** photo (pick from the gallery; the server resizes it), edit name, and the phone number.
- **App settings:** current salon with **Change salon**, **Notifications** (booking updates, reminders, offers), language (AR/EN) and appearance (light, dark, system).
- **Sign out.**
- **Delete my account:** confirmation, then sign-out everywhere (store compliance; see section 2).

**Dashboard: Reviews** (`/reviews`, `review.moderate`: owner and general manager; branch-scoped where the role is)
- Summary (average, published, hidden), filters by status and rating, newest first.
- Each review shows stars, comment, customer, barber, branch, visit date, and who changed it and when.
- **Hide** and **Publish** take an optional internal note and are audited. A hidden review stops counting toward the barber's rating; the rating is recomputed every time.

**Dashboard: Salon settings → Customer app**
- The salon code and app link, with a **printable QR code** (and a download).
- The **Show my salon in app search** switch (off by default).

## 2. Account deletion (spec-review item 12, as built)

`POST /customer/me/deletion-request` → `RequestAccountDeletion`:
1. **Immediately:**
   - Marks `deletion_requested_at`.
   - Deletes every access token, revokes every refresh token and removes every push device.
   - Audits the request.
   - A repeat request does nothing.
2. **Queued `AnonymiseCustomerAccount`:** dispatches Core's `CustomerAccountErasing` while the salon profiles are still linked. Each module erases what it owns, without any upward dependency:
   - **Customer** (`AnonymiseAccountProfiles` → `AnonymiseCustomer`), inside each profile's own tenant:
     - Name → "Deleted customer"; phone → `del-` + a keyed one-way hash.
     - Email, birthday, notes and tags are cleared, and the link to the account is removed.
     - Media flagged as personal data is deleted (AI Studio and hair history photos when those phases land).
     - Personal values in that profile's **audit trail** are redacted to `[erased]`.
     - The update runs at query level, so the audit hook does not copy the old values into a new row.
   - **Booking** (`ClearAnonymisedCustomerBookings`, on Customer's `CustomerAnonymising`):
     - Upcoming bookings are cancelled with the policy overridden, freeing the chairs.
     - Booking notes and review comments are cleared. Ratings stay, anonymous.
   - **The account:** anonymised (phone hashed; name, email, avatar and preferences cleared) and soft-deleted; the avatar file is deleted.
3. **What stays:** bookings, prices and dues keep their own snapshots, untouched. Invoices and payments will do the same (Phase 6). The same phone can sign up again as a new account.

## 3. Files created

| Area | Files |
|---|---|
| Migration | `2026_12_01_000100_create_review_and_account_tables` (`booking_reviews`, `account_media`, `customer_accounts.notification_preferences`) |
| Booking module | `Models/BookingReview`; `Actions/{SubmitReview, ModerateReview}`; `Support/{BarberRating, BookingCalendar, CustomerBookings}`; `Policies/BookingReviewPolicy`; `Listeners/ClearAnonymisedCustomerBookings`; API `CustomerHomeController`, `CustomerReviewController`; web `ReviewController` |
| Customer module | `Actions/AnonymiseCustomer`; `Events/CustomerAnonymising`; `Listeners/AnonymiseAccountProfiles` |
| Salon module | `Http/Controllers/Api/SalonDirectoryController` (search, resolve); `Support/{SalonCode, SalonSummary, SalonQr}` |
| Core / Identity | `Models/AccountMedia`; `Actions/{UploadAvatar, RequestAccountDeletion}`; `Jobs/{ResizeAvatar, AnonymiseCustomerAccount}`; `Events/CustomerAccountErasing` |
| Dashboard | `Pages/Reviews/Index.vue` |
| sb_api | models `money`, `salon`, `catalog`, `booking`, `home`, `converters`; repositories `salon`, `catalog`, `booking`, `customer_home` |
| sb_ui | `zoned_time.dart` (`SbZonedTime`: branch-timezone formatting, Latin digits in both languages) |
| Customer app | `app/current_salon.dart`; `features/common/{async_view, display, external_links}`; `features/salon/{salon_entry_screen, salon_link_screen, qr_scan_screen, branch_picker, salon_providers}`; `features/home/{home_screen, home_providers}`; `features/booking/{booking_stepper_screen, booking_draft, slot_picker}`; `features/appointments/{appointments_screen, appointments_providers, booking_detail_screen, reschedule_screen, rate_visit_sheet}`; `features/profile/notification_settings_screen`; `features/push/{push_service, push_registration}` |
| Tests | Backend: `tests/Feature/CustomerApp/{CustomerAppTest, CustomerAccountTest}.php`. Flutter: `test/{fake_api, fixtures, booking_flow_test, customer_screens_test, booking_stepper_golden_test, screens_golden_test}.dart`, `test/flows/booking_flow.dart`, `integration_test/booking_flow_test.dart`, `packages/sb_api/test/phase5_models_test.dart`; 12 new goldens (the 4 shell goldens were regenerated) |
| Docs | `adr/009-account-level-media.md`, `adr/010-customer-app-device-integrations.md`, this report and `phase-5/*.png` |

## 4. Files modified

- **Backend:**
  - **`CustomerBookingController`:** `calendar.ics`; shares `CustomerBookings::own()`.
  - **`BookingPresenter::forCustomer`:** adds the branch (timezone, location, phone), salon, `review` and `can_review`.
  - **`CustomerProfileController`:** avatar, notification preferences, deletion request. `CustomerAccount` gains preferences; its resource adds `avatar_url`.
  - **`SendBookingReminder`:** skips customers who turned reminders off.
  - **`SalonSettingsController` and `Settings/Salon.vue`:** listing switch, app link, QR. `Salon::RESERVED_SLUGS` adds `search` and `resolve`.
  - **Navigation:** `Menu` adds Reviews (Phase 5 shipped); `icons.ts` adds `star`.
  - **`ErrorCode`:** `REVIEW_NOT_ALLOWED` (422), `REVIEW_ALREADY_SUBMITTED` (409), `INVALID_SALON_CODE` (404). Translations are added in `lang/{ar,en}` (errors, messages, 34 dashboard keys).
  - **`DemoSalonBuilder`:** seeds 4 past visits with reviews.
  - **Fixes:**
    - **Architecture suite:** `phpunit.xml` now runs the Architecture and Concurrency suites. Until now `php artisan test` skipped them, which hid a Phase 2 Core → Salon import in `Branch` (an unused relation, now removed).
    - **Flaky test:** a Phase 4 cancellation-window test depended on the time of day; fixed.
- **Flutter:**
  - **Customer app:**
    - **Routes:** salon entry, link and QR routes; booking detail and reschedule; notification settings.
    - **Redirect guard:** Home and Book need a salon. Deep links keep working through sign-in.
    - **`app.dart`:** keeps push registration alive.
    - **`ProviderScope`:** providers no longer auto-retry. The network layer already retries safe calls, and errors must reach the screen with a retry button.
    - **Profile:** rebuilt.
    - **Placeholder tabs:** reduced to AI Studio.
    - **Session:** `updated()` and `accountDeleted()`.
    - **Strings:** 142 new ARB keys in AR and EN.
  - **Packages:** `sb_core` `AppPreferences.remove`; `CustomerAccount.avatarUrl`.
  - **New dependencies:** `url_launcher`, `image_picker`, `share_plus`, `mobile_scanner`, `path_provider`, `firebase_core`, `firebase_messaging`, `timezone` (sb_ui), `integration_test` (dev).
- **Docs:** `api-map.md` (Phase 5 as built, `calendar.ics`, dashboard routes) and `modules.md` (Booking and Customer as built; the deletion events).

## 5. Migrations

| Table / column | Purpose |
|---|---|
| `booking_reviews` | One per booking (unique `booking_id`): salon, branch, customer, barber, `rating` 1–5, `comment`, `status` (published, hidden), moderation note, moderator and time. Indexed by salon, status and date, and by barber and status |
| `account_media` | Files owned by a global customer account, its avatar (ADR-009); no `salon_id` |
| `customer_accounts.notification_preferences` | JSON `{booking_updates, reminders, offers}`; null = defaults |

`barbers.rating_avg` / `rating_count` (Phase 2 columns) are now filled. They are a cache, always recomputed from published reviews (rule 4).

## 6. API endpoints (`/api/v1`)

| Method | Path | Auth | Idempotency |
|---|---|---|---|
| GET | `/salons/search?q=` | public (opt-in salons only) | |
| GET | `/salons/resolve?code=` | public | |
| GET | `/customer/salons` | customer | |
| GET | `/customer/home?salon=&branch=` | customer | |
| POST | `/customer/me/avatar` | customer | |
| GET / PUT | `/customer/me/notification-preferences` | customer | |
| POST | `/customer/me/deletion-request` | customer | optional |
| POST | `/customer/bookings/{booking}/review` | customer (own, completed) | optional (unique index) |
| GET | `/customer/bookings/{booking}/calendar.ics` | customer (own) | |

Dashboard: `GET /reviews`, `PUT /reviews/{review}`; `PUT /settings/salon` takes `listing_enabled`. See `api-map.md` for the fields.

## 7. Screens

**Customer app** (from the goldens; 390 × 844, real fonts):

| Screen | |
|---|---|
| Home, Arabic and English (review prompt, next appointment, Book again, popular services) | [AR](phase-5/home_ar.png), [EN](phase-5/home_en.png) |
| Find your salon (QR, code, your salons, search) | [AR](phase-5/salon_entry_ar.png) |
| Stepper: services with an add-on (AR), time (EN), summary with the server quote (AR, EN) | [1](phase-5/booking_services_ar.png), [2](phase-5/booking_time_en.png), [3](phase-5/booking_summary_ar.png), [4](phase-5/booking_summary_en.png) |
| Appointment: timeline, directions, call, Rate your visit | [AR](phase-5/booking_detail_ar.png), [EN](phase-5/booking_detail_en.png) |
| Profile: photo, salon, notifications, delete account | [EN](phase-5/profile_en.png) |

**Dashboard** (Playwright against the seeded database; no console errors; 390 px mobile width with no horizontal scroll):

| Screen | |
|---|---|
| Reviews, Arabic | [01](phase-5/01-reviews-ar.png) |
| Hide with a note | [02](phase-5/02-hide-review-ar.png) |
| After hiding (toast, "changed by", recomputed summary) | [03](phase-5/03-review-hidden-ar.png) |
| Reviews, English | [04](phase-5/04-reviews-en.png) |
| Salon settings → Customer app (QR, listing switch) | [05](phase-5/05-settings-app-en.png) |
| Reviews, mobile | [06](phase-5/06-reviews-mobile-en.png) |

**States** (each covered by a widget test):

| State | Where |
|---|---|
| Loading | Skeletons on every list and step |
| Empty | No salons, no search results, no services, no free times, no upcoming or past visits, no next appointment |
| Error with retry | Translated messages; a server error that contains SQL is never shown |
| Offline and timeout | The global offline banner, plus a timeout on free times that recovers on retry |
| Validation | Salon code required or not found, stars required |
| No permission | 403 maps to the no-permission state; another account's booking reads "not found" |
| Success | Booking confirmed, rating saved, photo updated, booking cancelled |

## 8. Tests and quality gates

| Gate | Result |
|---|---|
| `vendor/bin/pint --test` | passed |
| `phpstan analyse` (Larastan level 6) | **0 errors** |
| `php artisan test` | **250 tests, 1,770 assertions, all passing**: 13 new, and the 8 Architecture/Concurrency tests now run every time |
| `npm run lint` (ESLint, RTL, i18n) / `vue-tsc --noEmit` / `npm run build` | passed (75 files, 691 keys) / 0 errors / passed |
| `tool/flutter_check.sh --build` | generated files current; `flutter analyze --fatal-infos` **0 issues** on all 5 members; **84 Flutter tests passing** (sb_core 17, sb_api 9, sb_ui 4, customer 43, staff 11); **both APKs build** |

**Backend, customer app (9):**
- **Search:** returns only opted-in salons and needs at least 2 characters.
- **Resolve:** slug, upper case, subdomain link, `/s/` link, custom scheme and public id. Unknown, foreign or suspended → `INVALID_SALON_CODE`.
- **"My salons":** shows only your own.
- **Home:** next appointment with branch timezone, Book again ids, review prompt, popular services with branch price, and feature flags.
- **Home isolation:** another salon and another customer show nothing; no token → 401.
- **Reviews:**
  - Only for completed visits, rating 1–5, comment trimmed, once (409), and it updates the barber rating shown on the public barbers list.
  - Another account gets 404.
- **Moderation:**
  - Hide and publish recompute the rating.
  - A barber gets 403; another salon's owner gets 404.
- **`.ics`:** correct `DTSTART` and UID; another account gets 404.
- **Settings:** the listing switch saves and makes the salon searchable.

**Backend, account (4):**
- **Avatar:** cropped to 512 px JPEG by the job; replacing it deletes the old file; non-images are refused.
- **Preferences:** defaults, partial update, unknown keys ignored, validation.
- **Reminders:** skipped when turned off.
- **Deletion, end to end over two salons:**
  - Tokens and devices are gone, and the next call gets 401.
  - The account is anonymised and soft-deleted, and the avatar is deleted.
  - Both profiles are anonymised and unlinked, with no phone, notes or email left.
  - The upcoming booking is cancelled; the completed booking keeps its total, loses its note, and its review keeps its rating but not its comment.
  - The audit trail holds no phone, note or email.
  - The phone can sign up again.

**Flutter.** A scripted HTTP adapter serves server-shaped JSON, so the tests run the real repositories and parsing.
- **Booking flow, AR and EN:**
  - Service → barber → time → quote → confirm, with a 409 on the first try, then the refreshed times, the suggested time and success.
  - Two intents with two different Idempotency-Keys.
  - The body sends ids only, and never a price.
- **Retry:** an offline confirm, retried, reuses the same key.
- **Screen states (13):** salon entry by code, not-found, empty and search-empty, and the deep link; home content and features, error with retry, Book again; visits empty tabs; booking detail by deep link with timeline, policy and cancel with a key; not found; rating validation and submit; notification switches saving and reverting on a server error; account deletion back to sign-in; timeout with retry on free times.
- **Redirects:** a salon is required for Home and Book only; deep links survive sign-in.
- **Models:** `[]` translations, a week as a map, unknown status, the ids-only query.
- **Goldens:** stepper RTL/LTR at 3 steps, plus home, salon entry, detail and profile (12 new files).
- **Integration test:** `integration_test/booking_flow_test.dart` runs the same booking flow (AR, EN, retry) on a device.

## 9. Known limitations and tech debt

- **Push is off in this build:**
  - **What's wired:** the full flow (permission → FCM `register()` → `POST /devices` → tapping a notification opens the booking).
  - **What's missing:** it needs the four `FIREBASE_*` defines from a real Firebase project (ADR-010). Sending notifications is Phase 11.
- **On-device integration test not run here:** this container has no emulator or device. The same flow passes as a widget test in AR and EN.
- **Map:** the branch picker lists branches and opens the phone's maps app; there is no embedded map (ADR-010).
- **QR on a phone camera:** the QR holds the custom scheme, so the camera opens it only when the app is installed; the in-app scanner always works. A web landing page with universal/app links is follow-up work.
- **Reschedule searches free times for the booking's services and barber.** Add-ons are not part of that search, because booking lines don't carry the add-on id. The server re-checks the real duration under the lock, so the worst case is a 409 and fresh times.
- **Not used yet:** the "booking updates" and "offers" preferences are stored but not read until Phase 11 sends messages.
- **No public review list:** reviews feed the barber rating (shown in the barber picker); there is no public listing of comments.
- **Deletion has no grace period:** it is immediate. Invoices and payments do not exist yet; when they arrive (Phase 6) they must keep their own snapshots, as bookings do.
- **Local only:** the dashboard screenshots used a local general-manager account, because owners and general managers moderate and branch managers do not, by design.
- **Not deployed:** Phase 4 and Phase 5 are not on https://barbers.athardesign.qa. That needs the server connection back and a go-ahead. The deploy runs the new migration; no new server settings are needed.
