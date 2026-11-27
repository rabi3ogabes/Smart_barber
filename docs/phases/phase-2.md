# Phase 2 — Salon setup: profile, branches, staff, schedules — Report

Status: **DONE**. All Phase 2 items are built and tested. The gaps are listed in section 9: the map pin is entered as coordinates, there is no per-branch key/value settings screen, and approvers are not yet notified of new requests.

## 1. Implemented (what a user can now do)

**Salon settings** (`/settings/salon`, Owner and GM edit, Accountant reads)
- Edit the Arabic and English name, legal name, default language, logo and cover image.
- Edit contact phone and email, and Instagram, TikTok, Snapchat and website links.
- Choose the time zone. The currency is shown but locked.
- Set the tax number, VAT % (stored as basis points) and whether prices include VAT.
- Set the booking policy: minimum notice, how many days ahead, the free-cancellation window, and a no-show fee (stored in minor units).

**Branches** (`/branches`)
- Branch cards show status, address, phone, today's hours and team avatars.
- An edit drawer covers name, address (AR/EN), phone, map coordinates, time zone and opening hours. Each weekday takes up to 4 ranges, for example 10:00–13:00 and 16:00–23:00.
- Closures can be added per branch, or salon-wide for public holidays such as Eid.
- Branches can be deactivated and reactivated. The last active branch can never be deactivated.
- A Branch Manager sees only their own branches and may edit their hours and closures. They cannot create or deactivate branches, and other branches return 404.

**Staff** (`/staff`)
- **Team table:** avatar, roles as chips, branches, status, search, and tabs for Active, Deactivated and Invitations.
- **Invite by email or phone:** an email goes out as a queued notification, a phone invite as an SMS job. The link is valid for 7 days and stored only as a SHA-256 hash. Invitations can be resent with a fresh token, or revoked.
- **Who may give which roles:**
  - The owner may give any role.
  - A GM may give any role except Owner and GM.
  - A Branch Manager may give only Receptionist and Barber, and only in their own branches.
- **Accepting an invitation** (`/invitations/{token}` on the salon subdomain):
  - An existing account confirms with its password.
  - A new person creates an account.
  - The person is then signed in. Owners and GMs go on to the 2FA setup from Phase 1.
- **Roles and branches drawer:**
  - Owners and GMs change roles and branches.
  - A Branch Manager moves people only between their own branches and cannot change roles.
  - Nobody can change their own access.
  - The last active owner cannot be demoted.
  - Every change is audited with the old and new values.
- **Deactivate or reactivate** (Owner and GM only):
  - Deactivation immediately revokes the person's app tokens for this salon and makes them unbookable.
  - History is kept; nothing is ever hard-deleted.
- **Barber profile drawer:**
  - Fields: photo, display name AR/EN, bio AR/EN, specialties, years of experience.
  - Only managers can set "bookable" and the display order.
  - A barber can edit their own profile but nobody else's.
- **Automatic profiles:** giving someone the barber role creates their profile. Removing the role keeps the profile but makes it unbookable.

**Schedules** (`/schedules`)
- **Weekly grid** per branch: one row per barber, seven days in Saturday-first order.
- The grid shows working ranges, breaks, one-off changes and the week's net hours.
- **Edit drawer:**
  - Weekly hours, with a "copy branch hours" shortcut.
  - Breaks, for example prayer or lunch.
  - One-off changes: a day off, or different hours on one date.
- Barbers see only their own row, read-only.

**Time off** (`/time-off`)
- **Timeline:** an 8-week view with approved bars and dashed pending bars.
- **Pending approvals:** a card listing requests waiting for a decision, with approve or reject and an optional note.
- **Requests:**
  - A barber requests leave for themselves, and it waits for approval.
  - A manager can enter leave for a barber in their branches; it is approved at once.
- Overlapping requests are refused.
- A request can be cancelled while pending, or once approved if it has not started yet.

**Audit log** (`/audit-log`, Owner, GM and Accountant)
- Translated event names, actor, time and IP.
- Expandable before/after fields, a filter by area, and cursor pagination.

**Mobile API** (for the customer app in Phase 5 and the staff app in Phase 8)
- Public salon profile, branches and branch detail with the week's hours and closures.
- Bookable barbers for a branch.
- The barber's own schedule: UTC intervals grouped by branch.
- The barber's own time off: list, request (idempotent) and cancel.

**ScheduleService** (`app/Modules/Staff/Schedule`)
- Returns UTC working intervals for a barber, branch and date range.
- Formula: branch opening hours ∩ (one-off custom hours, or else weekly hours) − breaks.
- Days are skipped for branch or salon-wide closures and for day-off overrides. Approved time off is then subtracted.
- All interval maths is done on UTC instants built from branch-local wall-clock times.

## 2. Files created

| Area | Files |
|---|---|
| Migrations | `2026_11_28_000100_create_salon_profile_and_branch_tables`, `…000200_create_staff_tables`, `…000300_add_public_id_to_salon_user` |
| Salon module | `app/Modules/Salon/`: actions `UpdateSalonProfile`, `UploadSalonImage`, `SaveBranch`, `SetOpeningHours`, `DeactivateBranch`; models `BranchOpeningHour`, `BranchClosure`; `BranchPolicy`; web `SalonSettingsController`, `BranchController`; API `PublicSalonController`; `Support/WeekRanges`, `Support/MediaUrl`; routes; `SalonServiceProvider` |
| Staff module | `app/Modules/Staff/`: actions `InviteStaff`, `AcceptInvitation`, `UpdateMemberAccess`, `EnsureOwnerRemains`, `ChangeMemberStatus`, `UpdateBarberProfile`, `SetWeeklySchedule`, `RequestTimeOff`, `DecideTimeOff`; models `StaffInvitation`, `Barber`, `BarberWorkingHour`, `BarberBreak`, `BarberScheduleOverride`, `TimeOffRequest`; enums `TimeOffStatus`, `TimeOffType`; `Schedule/{Interval, Intervals, ScheduleService}`; policies `MemberPolicy`, `BarberPolicy`, `TimeOffPolicy`; `Listeners/SyncBarberProfile`; `Notifications/StaffInvitationMail`; `Jobs/SendStaffInvitationSms`; `Support/{RoleRules, SalonUrl}`; web controllers `Staff`, `BarberProfile`, `Schedule`, `TimeOff`, `InvitationAccept`; API `StaffScheduleApiController`, `PublicBarbersController`; routes (`web`, `public`, `api`); `StaffServiceProvider` |
| Core | `Core/Audit/Http/AuditLogController`, `Core/Tenancy/Events/MemberAccessChanged`, `Core/Http/WebAppExceptionRenderer` |
| Dashboard | Pages `Settings/Salon`, `Branches/Index`, `Staff/Index`, `Schedules/Index`, `TimeOff/Index`, `Invitations/Accept`, `AuditLog/Index`; `Components/Domain/WeekRangesEditor`; `Components/Ui/{SbAvatar, SbAvatarGroup, SbCheckbox, SbTextarea}`; `Composables/useWeekdays` |
| Translations | `lang/{ar,en}/invitations.php` (mail and SMS) |
| Data | `database/factories/BarberFactory.php` |
| Tests | `tests/Unit/IntervalsTest.php`; `tests/Feature/Salon/{SalonSettingsTest, BranchTest, PublicApiTest}.php`; `tests/Feature/Staff/{ScheduleServiceTest, InvitationTest, StaffManagementTest, ScheduleAndTimeOffTest}.php` |
| Docs | This report and the screenshots in `docs/phases/phase-2/` |

## 3. Files modified

- **Core models:**
  - `Salon`: profile, tax and policy fields; `no_show_fee_amount` uses `MoneyCast`; now `Auditable`.
  - `Branch`: address (translatable), lat/lng, phone, `openingHours()`; `Auditable`.
  - `SalonMembership`: `public_id`, date property types.
- **`AddMember`:** audits old and new roles and fires `MemberAccessChanged`.
- **Authorization:**
  - `Access`: added `allowsInBranches` / `allowsInAnyBranch`.
  - `PermissionCatalog`: `audit_log.view` is now Owner, GM and Accountant only. `permissions.md` footnote ⁰ explains why.
- **`ErrorCode`:** 10 new codes with AR/EN messages: last branch, last owner, own access, invitation invalid or mismatched, already a member, role not assignable, overlapping ranges, time off not pending, time off overlaps.
- **`Menu`:** Phase 2 items are live, and Time off was added.
- **Bootstrap and routes:**
  - `bootstrap/providers.php` registers both module providers.
  - `bootstrap/app.php` registers `WebAppExceptionRenderer`.
  - `routes/web.php` and `routes/api.php` include the module routes.
- **Components and seeder:**
  - `SbChip` gained a `disabled` prop.
  - `SbConfirmDialog` gained a default slot, used for the decision note.
  - `DatabaseSeeder` adds branch hours, a second barber per salon, weekly schedules and breaks.
- **Translations:**
  - `lang/{ar,en}.json` have about 265 new keys.
  - `lang/{ar,en}/errors.php` have the new error codes.
- **Tests:**
  - `TestCase` helpers are now public, so file-level helpers can call them.
  - `TenantScopeTest` gained 8 Phase 2 models.
- **Docs:**
  - `api-map.md`: dashboard routes as built.
  - `modules.md`: "As built" notes.
  - `permissions.md`: footnote ⁰.
- **`.gitignore`:** ignores `dump.rdb`.

## 4. Migrations

| Table | Purpose |
|---|---|
| `salons` (+ columns) | legal name, cover, tax number, `tax_rate_bp`, `prices_include_tax`, contact, `social_links`, `lead_time_minutes`, `max_days_ahead`, `cancellation_window_minutes`, `no_show_fee_amount` (minor units) |
| `branches` (+ columns) | `address` (json AR/EN), `lat`, `lng`, `phone` |
| `branch_opening_hours` | weekday (0 = Sunday … 6 = Saturday), `opens_at`, `closes_at`; several rows per day |
| `branch_closures` | date range, optional `branch_id` (null = salon-wide), reason AR/EN |
| `staff_invitations` | email/phone, roles, branch ids, `token_hash` (unique), expiry, accepted/revoked |
| `barbers` | profile per (salon, user): display name/bio AR/EN, photo, specialties, years, order, bookable, rating cache; soft deletes |
| `barber_branches` | barber ↔ branch |
| `barber_working_hours`, `barber_breaks` | weekly ranges per barber per branch |
| `barber_schedule_overrides` | one date: `day_off` or `custom_hours` (unique per barber, branch, date) |
| `time_off_requests` | UTC `starts_at`/`ends_at` (end exclusive), type, status, decision fields |
| `salon_user` (+ `public_id`) | memberships are addressed by ULID in URLs (backfilled) |

Every tenant table has `salon_id` and the fail-closed `SalonScope`.

## 5. API endpoints (`/api/v1`)

| Method | Path | Auth / permission |
|---|---|---|
| GET | `/salons/{slug or id}` | public (active salons only) |
| GET | `/salons/{salon}/branches` | public |
| GET | `/branches/{branch}` | public |
| GET | `/branches/{branch}/barbers` | public (bookable, active members only) |
| GET | `/staff/schedule?from=&to=` | staff token, own (≤ 31 days) |
| GET | `/staff/time-off` | staff token, own |
| POST | `/staff/time-off` | staff token, `timeoff.request`; honours `Idempotency-Key` |
| POST | `/staff/time-off/{id}/cancel` | staff token, own |

The 25 dashboard routes, plus the 2 public invitation routes, are listed in `api-map.md` ("Dashboard routes"). Each dashboard route is behind `auth`, salon membership and 2FA enforcement; the 6 pages also need a `can:` permission; and every action runs the policies above.

## 6. Screens

The screenshots were taken with Playwright against the seeded dev database at 1440 × 900 and at 390 px. No console errors were found, and the mobile page width was 390 px (no horizontal scroll).

| Screen | Arabic | English |
|---|---|---|
| Invitation accept (guest) | [01](phase-2/01-invitation-ar.png) | |
| Salon settings | [03](phase-2/03-settings-ar.png) | |
| Branch drawer (multi-range hours) | [05](phase-2/05-branch-drawer-ar.png) | |
| Staff table, invite modal | [06](phase-2/06-staff-ar.png), [07](phase-2/07-invite-modal-ar.png) | [12](phase-2/12-staff-en.png), mobile [17](phase-2/17-staff-mobile-en.png) |
| Weekly schedule grid, edit drawer | [08](phase-2/08-schedules-ar.png), [09](phase-2/09-schedule-drawer-ar.png) | [13](phase-2/13-schedules-en.png), dark [16](phase-2/16-schedules-en-dark.png) |
| Time-off timeline | [10](phase-2/10-timeoff-ar.png) | [14](phase-2/14-timeoff-en.png) |

Every page has the required states:
- **Loading:** Inertia progress, and buttons show a spinner.
- **Empty:** an empty state with a hint, for example no branches, no barbers in a branch, or no invitations.
- **Validation:** field errors.
- **Domain errors:** a translated toast plus field errors, via `WebAppExceptionRenderer`.
- **No permission:** the 403/404 error pages, and read-only controls when the user may view but not edit.
- **Success:** a flash toast.

The browser check found 3 bugs, all fixed:
- `/time-off` returned 500: barbers were lazy-loaded in strict mode. A regression test now covers it.
- The audit filter crashed: the select used an empty value.
- Avatar-group initials were clipped.

## 7. Tests and quality gates

| Gate | Result |
|---|---|
| `vendor/bin/pint --test` | passed |
| `vendor/bin/phpstan analyse` (Larastan level 6) | **0 errors** (12 fixed at the cause, no baseline or ignores) |
| `php vendor/bin/pest` | **154 tests, 1,083 assertions, all passing** (80 new in Phase 2) |
| `npm run lint` (ESLint, RTL check, i18n check) | passed: 58 files RTL-clean, 475 keys present in both languages |
| `vue-tsc --noEmit` | 0 errors |
| `npm run build` | passed |
| `tool/flutter_check.sh` (no Dart changes this phase) | `flutter analyze --fatal-infos`: **0 issues** on all 5 members; `flutter test`: **54 tests passing** (sb_core 17, customer 17, staff 11, sb_api 5, sb_ui 4) |

**Phase 2 tests**
- **Schedule engine:**
  - UTC conversion, merging, multi-range intersection, break subtraction.
  - Day-off and custom-hours overrides; branch and salon-wide closures.
  - Approved vs pending/rejected time off; multiple branches.
  - **DST:** Europe/London across 28 March 2027 keeps 09:00–17:00 local, which is 09:00Z then 08:00Z, while Asia/Qatar stays at UTC+3.
- **Week ranges:** overlap, inverted, bad format, bad weekday key and more than 4 ranges are all rejected.
- **Salon settings:** minor units and basis points stored, validation, audit; the Accountant can read but not write; logo upload size rule; a forged `salon_id` is ignored.
- **Branches:**
  - Create and edit with multi-range hours.
  - Branch Manager scope: edits their own branch; 403 for create and deactivate; 404 for another branch and its closures.
  - Last-active-branch guard; closures; hour changes audited.
- **Invitations:**
  - Email as a queued notification, phone as an SMS job.
  - A role matrix of 7 cases.
  - New account and existing account (wrong password, then right).
  - Expired, revoked and unknown tokens; a token from salon A is useless on salon B.
  - Resend rotates the token; revoke.
- **Staff management:**
  - Branch Manager visibility.
  - Access changes audited with old and new roles.
  - Barber profile synced, and unbookable when the role is removed.
  - A Branch Manager may move branches but not change roles.
  - A GM cannot touch Owner or GM; nobody changes their own access; last-owner guard.
  - Deactivation revokes API tokens (the next call returns 401), then reactivation.
  - Barber self-edit vs manager-only fields; specialty validation.
- **Schedules and time off:**
  - Grid totals; overlap rejection.
  - Barber, Receptionist and Branch Manager authorization (404 out of scope).
  - Overrides replace on the same date.
  - Full time-off flow: request, overlap, self-approval blocked, approve, decide twice, cancel.
  - Manager entry auto-approved; regression check for several requests on the page.
- **APIs:**
  - Public profile with money as `{amount, currency}`; suspended salons and inactive branches hidden.
  - Branch week and closures; only bookable barbers listed.
  - Staff schedule in UTC with the 31-day cap.
  - Time-off request replayed with the same `Idempotency-Key` returns the same record; a new key is refused as overlapping; cancel.
  - Cross-barber and cross-salon cancels return 404.
- **Tenant isolation:** the `isolates` dataset now covers opening hours, closures, invitations, barbers, working hours, breaks, overrides and time off. There are also explicit cross-salon HTTP tests for branches, staff, profiles, schedules and time off.
- **Route × role matrix:** it picks up the 6 new `can:` pages automatically, and every role gets 200 or 403 exactly as the catalog says.

## 8. Security checks

- **Tenant isolation:**
  - The tenant always comes from the subdomain or the token. A `salon_id` in a request body is ignored (tested).
  - Route-model binding goes through `SalonScope`, so another salon's ULID is a 404.
  - The public API resolves the salon itself and sets the tenant only for active salons.
- **Branch scope:** out-of-scope branch records return **404** (not 403) in `BranchPolicy::update` and `BarberPolicy::updateSchedule`, as `permissions.md` → Tests requires.
- **Privilege escalation:**
  - Role grants are checked server-side by `RoleRules` and `UpdateMemberAccess`. This covers the GM vs Owner/GM rules, Branch Managers not changing roles, no self-change, and the last owner.
  - **Found and fixed in this phase:** the first version let a Branch Manager change roles through the access endpoint.
- **Invitations:**
  - 48-character random tokens, stored only as SHA-256.
  - Valid for 7 days, single use, revocable, and rotated on resend.
  - Acceptance is rate-limited (10 per 10 minutes per IP).
  - An existing account must prove its password.
  - The invitation's email or phone must match the account.
- **Deactivation:** deletes Sanctum tokens and revokes refresh tokens for that salon at once. The web session is refused by `EnsureSalonMember` (Phase 1).
- **Uploads:**
  - Images only (jpg, png, webp), at most 4 MB, at least 200 × 200 px.
  - Stored privately through `StorageService` under the salon's folder, served by signed temporary URLs.
- **External calls:** invitation email and SMS run in queued jobs (rule 9).
- **Audit:** salon, branch, barber, membership and time-off changes are recorded, plus role/branch changes with old and new values, invitations, acceptances, hours and schedule changes.

## 9. Known limitations and tech debt

- **Map pin:** the location is entered as latitude/longitude fields. An interactive map picker needs a map provider and API key decision (Google Maps vs Mapbox, with the cost); proposed for Phase 5, where the customer app shows the map.
- **Per-branch settings:** a branch has its own time zone, phone, address, hours and closures. There is no screen for generic per-branch key/value settings, because no Phase 2 setting needs one. The `Settings` store from Phase 1 can take branch keys when a phase needs them.
- **Approvers are not notified yet:**
  - `RequestTimeOff` calls the `NotificationChannel` stub, addressed to the barber.
  - Push or WhatsApp to approvers arrives with notifications in Phase 11.
  - The `TimeOffRequested`/`StaffJoined` domain events listed in `modules.md` are not emitted yet (no listener needs them).
- **Audit log for Branch Managers:** hidden for now (catalog footnote ⁰). A branch-scoped audit view needs a `branch_id` on audit entries.
- **"Today" in validation:**
  - `after_or_equal:today` on closures, overrides and time off uses the app's UTC date.
  - Between midnight and 03:00 Qatar time, today's date can therefore be refused for about 3 hours.
  - Fix: a salon-timezone date rule, with the booking engine in Phase 4.
- **Schedule grid:** shows the current week only (Saturday start), with no week navigation yet. One-off changes are listed in the drawer.
- **Time inputs:** use the browser's native `<input type="time">`, which some browsers show in 12-hour format. Values are always sent as 24-hour `HH:MM`.
- **Staff app screens:** the staff app does not show schedules or time off yet. The API is ready; the screens belong to Phase 8 (staff app).
- **Media URLs in the public API:** signed and short-lived. The customer app should not cache them for more than an hour.

## 10. How to run, seed and demo

```bash
cd backend
php artisan migrate:fresh --seed
npm run build
QUEUE_CONNECTION=sync php artisan serve
```

Open `http://salon-a.localhost:8000`. All demo passwords are `Password123!`.
- `manager.a@smartbarber.test`: Branch Manager. Sees Branches, Staff, Schedules and Time off for West Bay.
- `owner.a@smartbarber.test`: Owner. Set up 2FA on first sign-in, then everything, including Settings and the Audit log.
- `barber.a@` / `barber2.a@smartbarber.test`: barbers with weekly schedules. Use them to request time off and see the read-only schedule.

Invitation emails go to the log mailer in dev: `storage/logs/laravel.log` contains the link. SMS invitations are logged by the fake SMS provider.

## 11. What remains, and what the next phase needs

- **Phase 3 (catalog):** services attach to barbers through `barbers` / `barber_branches`. Branch price overrides follow the branch scope helpers (`Access::allowsInBranches`).
- **Phase 4 (booking engine):** slots = `ScheduleService::workingIntervals()` − existing bookings, within `lead_time_minutes` and `max_days_ahead` from the salon profile. The engine must:
  - fix the salon-timezone "today" rule (section 9);
  - re-check availability inside the booking transaction.
- **Phase 5 (customer app):** use the public salon, branch and barber endpoints. Decide the map provider.
- **Phase 8 (staff app):** use `/staff/schedule` and `/staff/time-off`. Invitations can deep-link into the staff app later.
- **Phase 11 (notifications):** notify approvers about new time-off requests and staff about decisions.

## 12. Decisions made

- **Members are addressed by ULID:** `salon_user.public_id` was added so membership URLs never expose sequential ids.
- **Out-of-scope branch records return 404,** as `permissions.md` specifies. Records the user may see but not edit return 403.
- **Domain errors on dashboard requests** go back to the form with field errors and a translated toast, never a raw exception (`WebAppExceptionRenderer`, rule 11).
- **Roles and branches are edited together** in one audited action (`membership.access_changed`). Roles need `staff.roles.assign`; branch moves need only `staff.update`.
- **Removing the barber role pauses the profile** (unbookable) instead of deleting it, so history and future ratings stay attached.
- **Time off is stored as UTC instants** with an exclusive end, from whole salon-local days. Partial-day leave can be added later without a schema change.
- **Week order and weekday numbers:** the UI shows weeks starting on Saturday (Gulf convention), while storage uses ISO-like weekday numbers (0 = Sunday), matching Carbon's `dayOfWeek`.
- No new ADR: none of these changes the stack, tenancy, auth or money model.
