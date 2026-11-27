# Phase 12 — Analytics and AI business assistant / التحليلات والمساعد الذكي

الهدف: أرقام حقيقية فقط — المساعد يشرح الأرقام ولا يخترعها.

```
Implement PHASE 12 only.

Analytics:
- Daily aggregate tables (metrics_daily per salon/branch/barber/service) filled by a
  scheduled job from source tables; dashboards read aggregates, not raw scans.
- KPIs: revenue (today/week/month/year, vs previous period), bookings by status,
  utilisation % (booked minutes / available minutes), new vs returning vs inactive
  customers, top services by revenue and count, barber revenue/customers/rating/
  commission, loyalty issued vs redeemed, membership MRR, no-show rate.
- Dashboard home: bento grid of KPI tiles + 3–4 charts max, date range + branch filter,
  export CSV. Respect permissions (accountant vs barber).

AI business assistant:
- A fixed library of safe, parameterised query tools (revenue_by_period, top_services,
  inactive_customers, busiest_hours, barber_performance, …), each tenant-scoped and
  permission-checked. The LLM only chooses tools and parameters (function calling) and
  writes the explanation. It never writes raw SQL and never sees other salons' data.
- Every number in the answer must come from a tool result; responses show the source
  metric chips and the date range used. If data is missing, it says so.
- Suggestions are framed as suggestions ("Consider a weekday offer…") with a link to
  create a campaign or open the report.
- Chat UI in the dashboard (side drawer + full page), ar/en, history per user, usage limits.
Tests: aggregate correctness against raw data, tool isolation, answer contains no number
that is absent from tool outputs (assert in tests with the fake AiTextProvider).
```
