# Spec review: contradictions, gaps, over-engineering

Status: **Accepted 2026-11-27.** The owner approved all recommendations and the default answers to Q1–Q8 (below). Q9–Q14 are still open and are due in the phase listed. Each item gives what the spec says, the problem, and the recommendation. The recommendations are already reflected in the ERD, ADRs and API map; changing an answer means updating those documents before Phase 1.

## A. Contradictions

**1. "Tenant comes from the user, never from the client" vs customers who use several salons.**
A customer token has no single salon.
→ Recommendation (ADR-001/002): customer requests take the salon from the **resource** (salon slug for public reads; branch or booking for writes), looked up server-side, never from a `salon_id` field. Staff tokens are bound to one salon.

**2. Phase 5 has salon "search", but the marketplace is "optional later".**
Public search turns the product into a marketplace, which brings ranking and fairness issues and may upset salons that do not want competitors next to them.
→ Recommendation: QR code and deep link are the main entry; search returns only salons that opt in (`settings: listing.enabled`, default off).

**3. Phase 1 is several weeks of work in one prompt** (Laravel core + auth + 2FA + dashboard shell + 16 components + two Flutter apps + goldens).
→ Recommendation: split into **1a** (backend core, auth, tenancy tests, dashboard shell and components) and **1b** (Flutter workspace, sb_core/sb_ui/sb_api, both app shells, goldens). Same gate, two sessions.

**4. "VAT %" and "VAT lines" vs Qatar launch.**
To my knowledge Qatar has not yet introduced VAT (please confirm with your accountant). Other GCC states have VAT at 5–15 %.
→ Recommendation: keep tax fully configurable, default **0 %** for Qatar, hide VAT lines on invoices when the rate is 0, and keep the QR/e-invoice placeholder.

**5. `rescheduled` is listed as a booking status, but reschedule is also an action on the same booking.**
If it is a status, a rescheduled booking would leave the active set and need a second row.
→ Recommendation: reschedule updates the same booking (same id, deep links keep working) and records old and new times in `booking_status_history`. `rescheduled` is not a status.

**6. Barber "rating" drives matching (Phase 10), KPIs (Phase 12) and barber cards, but no phase collects ratings.**
→ Recommendation: add `booking_reviews` and a "Rate your visit" prompt to **Phase 5** (customer app) with moderation in the dashboard.

**7. Phase 2 defines a "no-show fee", but nothing collects it** (no deposit, no card on file before Phase 6, maybe never in Phase 6).
→ Recommendation: in the MVP, record the fee as an **amount owed** on the customer, shown and charged at the next POS checkout. Online deposits or card-on-file come later with the gateway. *Needs your answer (Q9).*

**8. "Touching ends allowed" vs buffer minutes.**
If a buffer follows a service, the next booking may not touch the service end.
→ Recommendation: store `blocked_until = ends_at + buffer`; the overlap check uses the blocked range, and touching blocked ranges are allowed.

**10. Phase 1 seeds "1 barber", but barber profiles and the `barbers` table arrive in Phase 2.**
→ Recommendation: the Phase 1 seed creates a membership with the Barber role; Phase 2 adds the profile row (and the seeder is updated then).

**11. Super Admin is seeded in Phase 1, but its separate guard and console are in Phase 14.**
→ Recommendation: create `platform_admins` and the `platform` guard (login + 2FA + empty home page) in Phase 1 so the seed has somewhere to live; the console features stay in Phase 14.

## B. Gaps

**9. How bilingual content is stored.**
→ Recommendation: JSON columns `{"ar","en"}` via spatie/laravel-translatable, with a fallback to the other language when one is empty. Simple and fast; full-text search on names uses generated columns where needed.

**12. Account deletion vs immutable financial records.**
App stores require in-app deletion; ledgers must not be deleted.
→ Recommendation: deleting the `customer_account` revokes tokens and devices, deletes AI Studio photos and hair-history photos, and **anonymises** each linked salon `customers` row (name → "Deleted customer", phone replaced by a hash, notes cleared). Invoices and payments keep their snapshot as required for accounting retention. Check retention periods against Qatar's personal data law (Law No. 13 of 2016) with counsel.

**13. One barber per booking?** The spec assumes one barber per booking (the lock design depends on it).
→ Recommendation: one barber per booking in the MVP. "Hair with A, beard with B" is two linked bookings later. *Please confirm (Q7).*

**14. Who confirms a booking?** The status machine starts at `pending`, but nothing says when it becomes `confirmed`.
→ Recommendation: a salon setting `booking.auto_confirm` (default **on**); when off, reception confirms from the calendar, and the customer is notified.

**15. Fixed roles vs real salons.** Owners usually want "receptionist who can refund" or similar.
→ Recommendation: MVP ships the 8 template roles exactly as in `permissions.md`, not editable. Per-salon custom roles (clone a template, toggle keys) are a small later add-on, since the permission keys already exist.

**16. Pagination.** "Cursor pagination for lists" does not fit dashboard tables that show page numbers and totals.
→ Recommendation: cursor pagination on `/api/v1` (mobile infinite lists); offset pagination with totals on dashboard Inertia tables.

**17. Loyalty earning base is undefined.**
→ Recommendation: earn on the net paid amount for services and products, **excluding** tips, membership-covered items and amounts paid with loyalty itself; reverse proportionally on refund.

**18. Salon vs branch timezone.** Both exist.
→ Recommendation: schedules and slots use the **branch** timezone; reports and "today" boundaries for the salon use the **salon** timezone.

**19. Hosting, region and environments are unspecified.** They affect Reverb, S3, queues and data residency.
→ *Needs your answer (Q6)* before staging is set up (by Phase 4 at the latest).

## C. Over-engineering (keep the idea, shrink the scope)

**20. Custom domains for the dashboard (Phase 1 tenant resolution).** They need automated TLS and DNS verification.
→ Subdomains only until after launch; keep `salons.custom_domain` in the schema.

**21. Scribe → Flutter code generation.**
→ Keep Scribe docs from Phase 1; hand-write `sb_api` DTOs with Freezed and revisit generation once the API is stable (Phase 6+).

**22. Golden tests for every screen × 2 directions × 2 themes.**
→ Goldens for the shell, the booking stepper and the AI before/after slider; widget tests for the rest. This keeps CI fast and goldens meaningful.

**23. Command palette and help menu in Phase 1.**
→ Ship the palette with navigation commands only (as the prompt says); actions are added per module later. The help menu links to docs only.

**24. Calendar library.** FullCalendar's resource (per-barber column) views require a paid licence.
→ A one-day spike at the start of Phase 4: FullCalendar Premium vs a custom Vue time-grid. Record it as an ADR.

## Questions to answer before Phase 1

| # | Question | Why it matters | My default if you don't mind |
|---|---|---|---|
| Q1 | Product domain: is `smartbarber.app` the real domain (subdomains, deep links, bundle ids)? | Subdomain routing, cookies, deep links and store bundle ids are set in Phase 1 | Use `smartbarber.app` and change it via config |
| Q2 | Default language for new salons and first app launch: Arabic? | Seeds, fallbacks, store screenshots | Arabic default, English available |
| Q3 | Approve splitting Phase 1 into 1a (backend + dashboard) and 1b (Flutter)? | Session size and quality | Split |
| Q4 | Approve the customer identity model (global `customer_accounts` + per-salon `customers`, ADR-002)? | Irreversible schema shape | Approve |
| Q5 | Prices shown tax-inclusive or tax-exclusive? (Qatar: 0 % for now, item 4) | PricingService and invoice layout | Tax-inclusive, 0 % in Qatar |
| Q6 | Hosting: where will production run (provider and region), and is data residency in Qatar or the GCC required? | Reverb, S3, MySQL, backups, compliance | Decide by Phase 4; local Docker until then |
| Q7 | One barber per booking in the MVP? (item 13) | Locking design | Yes |
| Q8 | Is the brand name "Smart Barber" final, and do you have a logo? | Phase 1 shell, splash, fonts | Placeholder wordmark |

**Answered 2026-11-27:** the owner chose the defaults for Q1–Q8: `smartbarber.app` via config; Arabic default; Phase 1 split into 1a and 1b; customer identity model approved; prices tax-inclusive, 0 % in Qatar; hosting decided by Phase 4; one barber per booking; placeholder wordmark.

## Questions that can wait (with the phase that needs them)

| # | Question | Needed by |
|---|---|---|
| Q9 | No-show fee: record as owed and collect at the next visit, or require online deposits? | Phase 4 |
| Q10 | OTP delivery: SMS (which provider) or WhatsApp authentication templates (usually cheaper in the Gulf)? | Before the Phase 5 release (Phase 1 uses a log driver) |
| Q11 | Payment gateway for online payments and membership renewals (e.g. a Qatar-licensed gateway that supports tokenisation and refunds via API). Card terminals can be recorded without integration. | Phase 6 |
| Q12 | WhatsApp model: one platform sender for all salons, each salon's own number, or both by plan? | Phase 11 |
| Q13 | AI image provider and budget per generation | Phase 9 |
| Q14 | Staff app distribution: public store listing or private distribution? | Phase 8 |
