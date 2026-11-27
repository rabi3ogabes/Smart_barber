# Phase 11 — Notifications, WhatsApp, marketing / الإشعارات وواتساب والتسويق

الهدف: رسائل رسمية فقط (لا أتمتة غير رسمية)، حملات مستهدفة بموافقة الصالون.

```
Implement PHASE 11 only.

Notifications hub:
- NotificationService routes an event to channels (push, in-app, email, WhatsApp, SMS)
  by salon settings + customer preferences + consent; every send is a queued job with
  retries and a notification_logs row (status, provider id, error).
- Templates per event and locale (ar/en) with variables; in-app notification centre in
  both apps and the dashboard bell. Wire all earlier events: booking confirm/reminder/
  cancel/reschedule, queue updates, membership expiry, loyalty reward, receipt, staff alerts.

WhatsApp:
- WhatsAppProvider interface; adapter for the official WhatsApp Business Platform (Cloud
  API) or an official BSP. Template registry synced with approved templates, per-salon
  sender number and credentials (encrypted), delivery/read webhooks (signed, idempotent).
- 24-hour customer-service window rule respected; opt-in/opt-out ("STOP") handled.

Marketing:
- Segments builder: last visit, inactive days, total spend, visit count, favourite
  service, branch, barber, membership, loyalty level, birthday, custom tags; live count.
- Campaigns: channel, template, segment, schedule, A/B optional, offer code linked to a
  discount rule; status draft → pending_approval → approved → sending → sent. Sending
  requires an approver with campaign.approve. Throttled batches, frequency cap per customer.
- Reactivation automation (e.g. 45 days inactive) as a saved campaign rule.
- Reports: sent, delivered, read, clicked, bookings attributed within N days.
Tests: consent and opt-out, approval required, cap, webhook status updates, templates RTL.
```
