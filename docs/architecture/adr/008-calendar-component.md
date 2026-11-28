# ADR-008 — Dashboard calendar: a custom component, not FullCalendar Premium

Status: Accepted (2026-11-28) · Phase 4 · Reversible (the calendar is one page and its JSON endpoints)

## Context
The dashboard needs a day view with one column per barber, a week view, drag to move, click on an empty
time to book, working-hours shading, a now-line and status colours, in Arabic (RTL) and English.
ADR-005 deferred the choice between FullCalendar and a custom calendar to a Phase 4 spike.

## The spike (one day)
| | FullCalendar | Custom (Vue + CSS grid) |
|---|---|---|
| Columns per barber | Only in the **Premium** "resource" views: a paid licence per developer per year, and a premium package for every build | Columns are just a list of barbers |
| Working hours, breaks, closures | Business hours per resource can express weekly hours; one-off overrides, closures and time off would have to be converted into background events | The page draws `ScheduleService` intervals from the server as they are |
| RTL | Supported, but the time axis, drag and our logical-property rules need overrides | Logical properties throughout (`start`/`end`), tested by the RTL lint |
| Drag & drop + server validation | Its own optimistic model; reverting on our 409 needs an `eventDrop` revert hook | Same optimistic move, reverted on 409 with the server's alternatives |
| Design tokens | Its own CSS to restyle | Tokens only (rule 8) |
| Bundle | ~250 kB with the resource plugins | The page chunk is about 20 kB |

## Decision
A custom calendar (`resources/js/Pages/Calendar/Index.vue`):
- **Server-first:** it never decides availability. It asks `GET /calendar/events` for bookings and working
  intervals, and `GET /calendar/slots` / `POST /calendar/quote` when booking.
- **Drag to move:** moves optimistically and reverts when the server answers 409 or 422.
- **Week view:** shows one barber's week, Saturday first (Gulf convention).
- **Updates:** live through Reverb (`booking.changed` on `private-salon.{salon}.branch.{branch}`, ids only),
  with a quiet refresh every minute as a fallback.

## Consequences
- + No licence cost, full RTL and token control, a small bundle.
- − We own the code for keyboard drag and overlapping-event layout. Today, overlapping bookings in one
  column (rare: only cancelled ones can overlap) are drawn on top of each other, and moving a booking by
  keyboard is done in the booking drawer, not by dragging. Revisit if salons need resource views beyond barbers.
