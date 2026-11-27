# Roadmap — 16 phases

The original 21 phases are regrouped into 16 so each one ends in something a salon can use. Phases 0–6 are the sellable MVP; 7 onward are premium modules. — المراحل 0–6 = نسخة قابلة للبيع، والباقي وحدات مدفوعة.

| # | Phase / المرحلة | Done when (gate) |
|---|---|---|
| 0 | Architecture plan / التخطيط | ERD, module map, ADRs approved; no code |
| 1 | Foundation / الأساس | Login works in both apps and dashboard, AR/EN switch, tenant isolation tests green |
| 2 | Salon, branches, staff, schedules / الصالون والفروع والموظفون | Owner sets up a salon with 2 branches, barbers and working hours |
| 3 | Services catalog / الخدمات | Services, add-ons, per-branch prices, barber skills |
| 4 | Booking engine / محرك الحجز | Calendar works; concurrent-booking test proves no double booking |
| 5 | Customer app core / تطبيق العميل | Customer books, reschedules and cancels from the phone in AR and EN |
| 6 | POS, payments, invoices / نقطة البيع والدفع | Checkout, split payment, refund as reversal, printable bilingual invoice |
| 7 | Loyalty and memberships / الولاء والاشتراكات | "Buy 5 get 1" and points configurable; membership usage tracked |
| 8 | Staff app and haircut history / تطبيق الحلاق والسجل | Barber runs the day from the phone; "Same as last time" rebooks in one tap |
| 9 | AI Hair Studio and recommendations / استوديو الذكاء الاصطناعي | Photo → style preview with before/after slider → "Book this style" |
| 10 | Smart features / الميزات الذكية | Rebooking reminders, barber match %, live walk-in queue |
| 11 | Notifications, WhatsApp, marketing / الإشعارات والتسويق | Official WhatsApp templates, segments, approved campaigns with delivery status |
| 12 | Analytics and AI assistant / التحليلات والمساعد | KPI dashboard; assistant answers only from real queries |
| 13 | Inventory and commissions / المخزون والعمولات | Traceable stock movements; commission statements |
| 14 | SaaS billing and Super Admin / الفوترة والإدارة العليا | Plans, add-on modules, trials, feature gating, MRR/ARR console |
| 15 | Hardening and release / التدقيق والإطلاق | Security audit passed, CI/CD, backups, monitoring, store submissions |

Feature gating (which salon has which module) is built as a simple `salon_features` table in Phase 1, so every later module checks it from day one; full billing arrives in Phase 14. — التحكم في الوحدات يبدأ من المرحلة 1.
