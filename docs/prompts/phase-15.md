# Phase 15 — Hardening and release / التدقيق النهائي والإطلاق

الهدف: مراجعة أمان وأداء كاملة ثم النشر على المتاجر.

```
Implement PHASE 15 only. Act as an external auditor first, engineer second.

Audit (write docs/audit/report.md with findings ranked critical/high/medium/low):
- Security: OWASP ASVS L2 checklist, authz on every route (generate a route × role test
  matrix), tenant isolation re-run on all endpoints, mass assignment, file upload, SSRF
  in webhooks, secrets in apps (scan the Flutter builds), rate limits, session/2FA, CSP.
- Data: index review with EXPLAIN on the 20 heaviest queries, N+1 detection,
  backup + restore drill, PII map and retention/deletion jobs.
- Reliability: queue failure handling, webhook replay, payment idempotency under retry
  storm, Reverb reconnection, scheduler single-run (onOneServer).
- Mobile: crash handling, memory/leaks on long sessions, startup time, image caching,
  RTL sweep of every screen, accessibility (screen reader, contrast, text scaling 200%).
Fix all critical and high findings.

Release:
- Infrastructure as documented code: environments, env vars list, queue workers
  (Horizon), scheduler, Redis, S3 + CDN, Reverb, logging, error reporting (Sentry or
  equivalent), uptime monitoring, daily encrypted backups with 30-day retention.
- CI/CD: on PR run lint, static analysis, tests for backend and both apps; on main
  deploy to staging; tagged release to production with zero-downtime migrations.
- App stores: bundle ids, signing, privacy manifests, data-safety forms, store listing
  text in ar/en, screenshots, review notes with demo account.
Deliver a go-live checklist and a rollback plan.
```
