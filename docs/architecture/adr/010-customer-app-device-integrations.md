# ADR-010 — Customer app: maps, QR, push and calendar without vendor lock-in

Status: Accepted (2026-11-28) · Phase 5 · Reversible (each integration is one file behind a small interface)

## Context
Phase 5 asks for a branch picker "with map", QR entry, push notifications (FCM token registration and
opening the booking from a notification) and "add to calendar". Each of these can pull in a heavy SDK,
API keys or billing.

## Decisions
| Need | Choice | Why |
|---|---|---|
| Map in the branch picker | **The phone's maps app** (Apple Maps on iOS, Google Maps elsewhere) via `url_launcher`. The picker itself lists branches with today's hours. | An embedded map SDK needs an API key, billing and per-platform setup to show one pin. Customers already navigate with their own maps app. An embedded map can come later without changing the API: branches already return `location`. |
| QR entry | `mobile_scanner` (camera); the code is resolved by `GET /salons/resolve`. Typing the code or link always works too. | Works offline of any third-party service. The dashboard prints the salon's QR (`smartbarber://salon/{slug}`) from Salon settings. |
| Push | **`PushService` interface.** `FirebasePushService` uses FCM's `register()` / `onRegistered`, configured by compile-time defines (`FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_SENDER_ID`, `FIREBASE_PROJECT_ID`). With no defines, `DisabledPushService` is used. | No Firebase project or `google-services.json` exists yet, and none is committed. When the defines are present, the app registers the token with `POST /devices` and opens `smartbarber://booking/{id}` from a tapped notification. The router's guards and the sign-in `from` keep that route through a session expiry. |
| Add to calendar | The server builds the `.ics` (`GET /customer/bookings/{id}/calendar.ics`, stable UID, UTC). The app hands it to the share sheet. | One source of truth for times (rule 5). No calendar permission is needed; the system's "Add to Calendar" handles it. |

## Consequences
- + No API keys or vendor accounts are needed to build, test or run the app.
- + Each integration can be swapped by changing one file.
- − Push stays off until a Firebase project exists and its defines are added to the build (Phase 11
  sends the actual notifications).
- − The QR encodes the custom scheme. Scanning it with a phone camera only opens the app if the app is
  installed. A web landing page with universal/app links is listed as follow-up work.
