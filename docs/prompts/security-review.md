# Security review / مراجعة أمنية

```
Act as a hostile tester. For every endpoint added in Phase N, try: another salon's ids,
a lower role, missing/forged Idempotency-Key, oversized/invalid uploads, replayed
webhooks, mass-assignment of salon_id/price/status. Write a failing test for each hole
you find, then fix it.
```
