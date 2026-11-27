# Phase 0 — Architecture plan (no code) / التخطيط بدون كود

الهدف: مخطط قاعدة البيانات والوحدات والقرارات قبل كتابة أي سطر.

```
Read CLAUDE.md and docs/architecture/*. Do NOT write application code in this phase.

Produce, as files under docs/architecture/:
1. erd.md — full entity list grouped by module, every table with columns, types, FKs,
   indexes, unique constraints, soft-delete yes/no, and which tables carry salon_id/branch_id.
   Include a Mermaid ER diagram per module.
2. modules.md — each module: responsibility, public Actions, events it emits/listens to,
   which other modules it may depend on (no cycles).
3. permissions.md — every permission key (booking.view, payment.refund, …) and the default
   matrix for: Super Admin, Owner, General Manager, Branch Manager, Receptionist, Barber,
   Accountant, Marketing Manager, Inventory Manager, Customer.
4. api-map.md — every /api/v1 endpoint planned for phases 1–6 with method, auth, permission.
5. adr/001..006 — tenancy, auth, money, booking locking, dashboard stack, two Flutter apps.
6. risks.md — top 10 technical risks and the mitigation for each.

Challenge my spec: list anything contradictory, missing or over-engineered, with your
recommendation. End with questions you need answered before Phase 1.
```
