# Phase 3 — Services catalog — Report

Status: **DONE**. Everything in the Phase 3 prompt is built and tested. Section 9 lists what was deliberately left for later phases.

## 1. Implemented (what a user can now do)

**Services page** (`/services`; every role can read it, Owner and GM can change it)
- **Categories:**
  - Arabic and English names, one of 10 icons, active or inactive.
  - Reorder by dragging, or with the move-up and move-down buttons, which also work from the keyboard.
  - A category can only be deleted when it is empty.
- **Services table:**
  - Filter by category and search by name.
  - Each row shows the image, category, duration, base price, status, and an "in salon only" badge.
  - Each row counts its add-ons and its branch changes.
- **Service drawer, four tabs:**
  - **Details:**
    - Name and description (AR/EN), category, base price, duration and clean-up (buffer) time.
    - Tax class (standard, zero-rated, exempt), active, bookable in the app.
    - An image picked, then cropped to 4:3 in the browser and uploaded.
  - **Pricing per branch:** offered or not at each branch, and an optional branch price. An empty price means the base price.
  - **Barbers:**
    - Tick which barbers perform the service.
    - Each barber can have their own price (e.g. a senior barber charges more) and their own duration.
  - **Add-ons:** choose which extras can be added to this service.
- **Add-ons tab:**
  - An add-on has a name, price, extra minutes, tax class and active flag.
  - It also records which services it can be added to.
- **Bundles tab:**
  - Two or more services at one price, for example Haircut + Beard.
  - The card shows the bundle price, the separate price struck through, the saving and the total duration. All of these are computed by the server.
- **Branch Managers:**
  - Can set availability and the branch price, but only for their own branches. Other branches return 404.
  - Cannot change base, barber, add-on or bundle prices, or the catalog itself.

**PricingService** (`app/Modules/Catalog/Pricing`): the only place prices are computed.
- **What it does:** `quote(branch, services, addons, barber, customer, bundles)` returns line items, discount, tax and total as `Money`, plus the duration and buffer.
- **Price precedence:** barber override > branch override > base price.
  - Each line records which rule set its price (`price_source`).
  - Bundles and add-ons have one salon-wide price; barber overrides do not change a bundle.
- **Duration and buffer:**
  - A barber's duration override replaces the service duration.
  - A bundle lasts as long as its services together; add-ons add extra minutes.
  - The buffer is the largest buffer among the services.
- **Tax:**
  - Calculated per line and rounded half up (ADR-003).
  - Prices can include VAT or have it added on top, per salon.
  - Zero-rated and exempt lines pay no tax.
  - Works for 3-decimal currencies such as KWD.
- **Validation:**
  - Every service, including those inside a bundle, must be active and offered at the branch.
  - A chosen barber must work at the branch and perform every service.
  - An add-on must belong to one of the chosen services.
  - Nothing may be chosen twice.
- **`PriceAdjuster` contract** (`adjust` + `commit`):
  - Loyalty, memberships and offer codes will register adjusters in later phases. Adjusters discount lines with `QuoteLine::withDiscount()`, and tax is recomputed on the discounted amount.
  - Booking and the POS will only ever call PricingService.

**Public catalog API** for the customer app
- **Categories:** only those with bookable services at the branch.
- **Services:** active, online-bookable and offered at the branch, with the branch price and add-ons, plus the bundles whose services are all available.
- **One service:** with the barbers who perform it there. A barber's price is shown only when it differs from the branch price.

**Audit:** every price change is recorded as `catalog.price_changed`, with the scope (base, branch, barber, addon or bundle) and the old and new minor units. Each change also emits `ServicePriceChanged`. Saving without a change records nothing.

## 2. Files created

| Area | Files |
|---|---|
| Migration | `2026_11_29_000100_create_catalog_tables` |
| Catalog module | `app/Modules/Catalog/`: `CatalogServiceProvider`; models `ServiceCategory`, `Service`, `ServiceAddon`, `ServiceBundle`, `BranchService`, `BarberService`, trait `PricedInSalonCurrency`; `Enums/TaxClass`; `Pricing/{PricingService, Quote, QuoteLine, QuoteContext}`; `Contracts/PriceAdjuster`; `Events/ServicePriceChanged`; actions `SaveCategory`, `ReorderCategories`, `DeleteCategory`, `SaveService`, `SetBranchPricing`, `AssignBarberServices`, `SaveAddon`, `SaveBundle`, `UploadServiceImage`; `Support/{CatalogMoney, PriceAudit}`; `Policies/CatalogPolicy`; web `CatalogController`, `ServiceController`, `AddonController`, `BundleController`; API `PublicCatalogController`; `routes/{web,api}.php` |
| Dashboard | `Pages/Services/Index.vue`; `Components/Catalog/{ServiceDrawer, AddonDrawer, BundleDrawer, CategoryModal, CategoryIcon}.vue` + `types.ts`; `Components/Domain/ImageCropper.vue`; `Composables/useTr.ts` |
| Data | `database/factories/{ServiceCategoryFactory, ServiceFactory}.php` |
| Tests | `tests/Feature/Catalog/{PricingServiceTest, CatalogManagementTest, PublicCatalogApiTest}.php` |
| Docs | This report and the screenshots in `docs/phases/phase-3/` |

## 3. Files modified

- **`ErrorCode`:** 4 new codes with AR/EN messages: `SERVICE_UNAVAILABLE_AT_BRANCH`, `BARBER_NOT_ELIGIBLE`, `CATALOG_SELECTION_INVALID`, `CATEGORY_NOT_EMPTY`.
- **`Menu`:** Services is live (Phase 3 shipped).
- **Bootstrap and routes:** `bootstrap/providers.php` and `routes/{web,api}.php` register the module.
- **`DatabaseSeeder`:** adds a demo menu per salon:
  - 3 categories and 6 services, plus 2 add-ons and the "Haircut + Beard" bundle.
  - A branch price for the facial and a senior-barber price for the haircut.
- **`app.ts` — fixes a bug from Phase 1 and 2:** the app is now wrapped in Reka's `ConfigProvider` with the locale's direction.
  - Before, every Reka primitive (tabs, selects, menus) rendered left-to-right in Arabic. The browser check caught this on the Services tabs.
- **`SbTabs`:** the active-tab underline is anchored correctly in RTL.
- **Audit log page:** new "Catalog and prices" and "Services" filters, and labels for the catalog events.
- **Translations:**
  - `lang/{ar,en}.json` have about 100 new keys, with English plural forms where counts appear.
  - `lang/{ar,en}/errors.php` have the new codes.
- **`package.json`:** adds `cropperjs` pinned to 1.6.2.
- **Tests:** `TenantScopeTest` covers 6 more models.
- **Docs:**
  - `api-map.md`: the catalog rows as built.
  - `modules.md`: "As built" notes for Catalog.

## 4. Migrations

| Table | Purpose |
|---|---|
| `service_categories` | name AR/EN, icon, order, active; soft deletes |
| `services` | category, name/description AR/EN, image, `base_price` (minor units of the salon currency), duration, buffer, `tax_class`, active, bookable online, order; soft deletes |
| `service_addons` | name, `price`, extra minutes, tax class, active; soft deletes |
| `service_addon_service` | which add-ons go with which services |
| `service_bundles` | name/description, `price`, tax class, active, order; soft deletes |
| `service_bundle_items` | bundle ↔ service with order |
| `branch_service` | per-branch `is_available` and `price_override` (no row means available at the base price) |
| `barber_service` | barber performs service; `price_override`, `duration_override`, `commission_rate_bp` (placeholder for Phase 13) |

All tables carry `salon_id` with the fail-closed `SalonScope`. Prices are BIGINT minor units; the currency is the salon's (erd.md §4).

## 5. API endpoints (`/api/v1`, public, rate-limited)

| Method | Path | Notes |
|---|---|---|
| GET | `/branches/{branch}/service-categories` | Active categories with bookable services here, in order, with counts |
| GET | `/branches/{branch}/services?category=` | `{services[], bundles[]}`, with branch prices as `{amount, currency, formatted}` |
| GET | `/branches/{branch}/services/{service}` | Service + `barbers[]` (price only when it differs, own duration) |

There are 15 dashboard routes, listed in `api-map.md`. The page needs `can:service.view`; every write goes through `CatalogPolicy`.

## 6. Screens

Screenshots were taken with Playwright against the seeded database. No console errors were found, and the mobile page width was 390 px (no horizontal scroll).

| Screen | Screenshot |
|---|---|
| Services, Arabic | [01](phase-3/01-services-ar.png) |
| Service drawer: Details, Pricing per branch, Barbers, Add-ons | [02](phase-3/02-service-details-ar.png), [03](phase-3/03-service-pricing-ar.png), [04](phase-3/04-service-barbers-ar.png), [05](phase-3/05-service-addons-ar.png) |
| Image crop (4:3) | [06](phase-3/06-cropper-ar.png) |
| Bundles, Add-ons | [08](phase-3/08-bundles-ar.png), [09](phase-3/09-addons-ar.png) |
| Services, English light and dark, mobile | [10](phase-3/10-services-en.png), [11](phase-3/11-services-en-dark.png), [12](phase-3/12-services-mobile-en.png) |
| Branch Manager: branch pricing only | [13](phase-3/13-bm-pricing.png) |

The page has every required state:
- **Empty:** no categories yet, no services in a category, no add-ons, no bundles.
- **No permission:** the fields are disabled, with a note that only the Owner or GM can change prices; Branch Managers see only their own branches.
- **Validation:** field errors.
- **Domain errors:** a translated toast, e.g. "Move or remove the services in this category first".
- **Loading:** buttons show a spinner, plus the Inertia progress bar.
- **Success:** a toast.

## 7. Tests and quality gates

| Gate | Result |
|---|---|
| `vendor/bin/pint` | passed |
| `phpstan analyse` (Larastan level 6) | **0 errors** |
| `php vendor/bin/pest` | **198 tests, 1,316 assertions, all passing** (44 new) |
| `npm run lint` (ESLint, RTL, i18n) | passed (67 files, 574 keys in both languages) |
| `vue-tsc --noEmit` | 0 errors |
| `npm run build` | passed |
| `tool/flutter_check.sh` (no Dart changes) | `flutter analyze --fatal-infos`: **0 issues** on all 5 members; `flutter test`: **54 tests passing** |

**Pricing tests (17):**
- Base prices.
- **Precedence barber > branch > base:** each line's price source is checked, including a branch row with no price override falling back to the base price.
- **VAT:**
  - Added on top: 5 % on 100.00 gives 5.00.
  - Included in the price: 6000 × 5/105 rounds to 286 and 4000 × 5/105 to 190, per line.
  - Zero-rated and exempt lines pay nothing.
- **Rounding:** half up per line, with totals that always reconcile (3333 and 3337 at 15 % give 500 + 501).
- **Currencies:** KWD at 3 decimals.
- **Bundles:** bundle price, summed duration with barber duration overrides, largest buffer.
- **Add-ons:** linked add-ons only.
- **Refusals:**
  - A service unavailable at the branch, an inactive service, a duplicate, or an empty selection.
  - A barber who doesn't perform the service, or works at another branch.
- **Adjusters:**
  - A registered adjuster's discount recomputes tax.
  - A discount larger than the line is refused.
- **JSON:** money is serialised as `{amount, currency}`.

**Dashboard tests (16):**
- **Categories:** reorder, including refusing an incomplete order and an invalid icon; delete only when empty.
- **Services:** create with minor units; validation, including more than 3 decimals.
- **Audit:**
  - Base, branch and barber price changes each give one audit entry with old and new values, plus 3 events; saving without a change gives none.
  - Clearing a branch price removes the row.
- **Branch Manager:**
  - Branch price only in their own branch; another branch returns 404.
  - 403 on base price, categories and barbers.
- **Roles (5 cases):** each can read the catalog; only owners and GMs can write.
- **Add-ons:** linking and unlinking; add-on price audit.
- **Bundles:** at least 2 services required; saving computed on the server.
- **Image:** the cropped image uploads; images under 400 × 300 are refused.
- **Isolation:** salon B's services and categories can't be edited or used from salon A.

**API tests (5):**
- Category filter and order.
- Branch prices, add-ons and bundles.
- Services off at a branch are hidden, and so are bundles containing them.
- Barber prices only when they differ.
- Suspended salons and other salons' services are hidden.

**Isolation dataset:** `+6` models (categories, services, add-ons, bundles, branch prices, barber prices).

**Route × role matrix:** covers the new `/services` page for all 8 roles.

## 8. Security checks

- **Tenant isolation:**
  - Every catalog table is salon-scoped, and route binding is by ULID through `SalonScope`.
  - Another salon's category ULID can't be attached to a service (404), and can't be used in a bundle (refused).
  - The public API resolves the salon from the branch and hides suspended salons.
- **Permissions:** enforced in `CatalogPolicy`, following permissions.md footnote 5.
  - Base, barber, add-on and bundle prices need `service.price.update` for the whole salon.
  - Branch prices need it for that branch; an out-of-scope branch returns 404.
  - Structure changes need `service.manage`.
  - The UI only reflects this; the server decides.
- **Money:**
  - Input decimals are converted with brick/money in the salon's currency, never floats.
  - At most 3 decimals and an upper bound are validated.
  - Pages receive amounts already formatted and never compute prices; bundle savings come from the server.
- **Uploads:** images only, at most 4 MB, at least 400 × 300. Stored privately through `StorageService` and served by signed URLs. Cropping in the browser is a convenience; the server validates again.
- **Audit:** price changes carry the actor, IP and old/new values.

## 9. Known limitations and tech debt

- **No quote endpoint yet:** the customer app's booking summary will call `PricingService` through the booking API in Phase 4, so there is no separate public quote endpoint.
- **Service order within a category:** services are ordered by creation inside a category; only categories can be dragged. Drag-reordering of services can come with the booking UX if salons ask.
- **Bundle prices are salon-wide:** a bundle has no per-branch price, as the ERD specifies.
- **Commission rate:** `commission_rate_bp` exists but has no screen; Phase 13 will add one.
- **Lookup services:** `CatalogQuery` and `EligibleBarbers` from `modules.md` are not separate classes yet. The public controller and the pricing rules cover them; Booking will extract them when it needs them.

## 10. How to run, seed and demo

```bash
cd backend
php artisan migrate:fresh --seed
npm run build
QUEUE_CONNECTION=sync php artisan serve
```

Open `http://salon-a.localhost:8000/services`:
- `owner.a@smartbarber.test` (set up 2FA first) can change everything.
- `manager.a@smartbarber.test` can set branch prices for West Bay only.

All demo passwords are `Password123!`. In the demo data, the haircut is QAR 60 for the second barber and QAR 80 for the senior barber, and the facial is QAR 95 at West Bay instead of 90.

## 11. What remains, and what the next phase needs

- **Phase 4 (booking engine):**
  - Call `PricingService::quote()` inside the booking transaction.
  - Store `Quote::toArray()` as `bookings.quote_snapshot`, and booking lines from `QuoteLine`.
  - Block the slot for `durationMinutes() + bufferMinutes`.
  - Eligible barbers are those with `barber_service` rows who work at the branch.
- **Phase 6 (POS):** uses the same quote, with `PriceAdjuster::commit()` inside the order transaction.
- **Phase 7 (loyalty and memberships):** register adjusters with `app()->tag([...], PriceAdjuster::TAG)`.
- **Phase 13 (commissions):** reads `barber_service.commission_rate_bp`.

## 12. Decisions made

- **Missing branch row = available at the base price.** Rows exist only for exceptions, so adding a branch needs no catalog work.
- **Buffer = the largest buffer of the chosen services:** one clean-up after the appointment, not one per service.
- **Bundles and add-ons ignore barber price overrides;** they have one salon price.
- **A barber who performs no service cannot be booked for it.** Eligibility is explicit (`barber_service`), not implied by working at the branch.
- **Catalog tables hold no currency column:** the currency is always the salon's, read through `PricedInSalonCurrency`, as the ERD specifies.
- **The direction fix is global:** Reka's `ConfigProvider` at the app root, not per-component props.
- No new ADR: the schema follows the approved ERD and ADR-003.
