# Design system and RTL/LTR

One token set feeds Tailwind (dashboard) and `sb_ui` (Flutter), so web and mobile look like one brand. — مصدر واحد للألوان والخطوط للويب والجوال.

Direction: deep charcoal and warm white, one champagne-gold accent used sparingly (active state, primary CTA, loyalty progress). Starting values below; refine once in Phase 1 and then never hard-code. — ذهبي واحد باعتدال فقط.

| Token | Light | Dark | Use |
|---|---|---|---|
| background | #F7F5F1 | #0E0E0F | App canvas |
| surface | #FFFFFF | #17171A | Cards, sheets |
| surfaceElevated | #FFFFFF + shadow-sm | #1F1F23 | Menus, popovers |
| textPrimary | #141414 | #F2EFEA | Body and titles |
| textSecondary | #6B6760 | #A39E95 | Meta, captions |
| border | #E6E1D8 | #2A2A2F | Dividers, inputs |
| primary | #1A1A1C | #F2EFEA | Main buttons |
| accent | #B8975A | #C9A96E | Active, highlights |
| success / warning / error / info | #2F7D5B / #B7791F / #B42318 / #2E5E8C | lighter tints | Status only |
| disabled | #CFCAC1 | #3A3A40 | Disabled controls |

Typography: English — Inter (UI) with a refined display serif for hero titles only (e.g. Fraunces). Arabic — IBM Plex Sans Arabic (UI and headings). Scale: Display 40, H1 32, H2 24, H3 20, H4 17, Body 15, Label 13, Caption 12, Button 15/600, Numeric uses tabular figures. Radius: 8 (inputs), 12 (cards), 20 (sheets); spacing scale 4-8-12-16-24-32-48. Motion: 150–250 ms ease-out, disabled under reduced motion.

## Layout patterns (NameThatUI vocabulary) / أنماط الواجهة

| Surface | Desktop | Tablet | Mobile |
|---|---|---|---|
| Dashboard navigation | Permanent collapsible sidebar (expanded / icon-only, tooltips, badge counters, nested groups, permission-based) | Collapsed sidebar, expands as overlay | Navigation drawer from the start edge + bottom navigation (5 items) |
| Header | Sidebar toggle, global search, Command Palette (Ctrl/⌘+K), branch selector, notifications, language, theme, help, profile menu | Same, search collapses to icon | Compact top app bar |
| Data | Data tables with sticky header, filters as chips, pagination | Tables scroll horizontally in a bounded region | Tables become cards |
| Forms and details | Right-side drawer (end edge) for quick edit, modal for confirm | Drawer | Full-screen form or bottom sheet |
| Overview | Bento grid of KPI cards | 2-column bento | Single column, swipeable carousel |
| Feedback | Toast, skeleton loading, empty state, confirmation dialog | Same | Snackbar |

## RTL rules (Arabic) / قواعد العربية

- Direction is global: `<html dir="rtl" lang="ar">` on web; `Directionality` from locale in Flutter. No per-component hacks.
- Tailwind uses logical utilities only: `ms-*`, `me-*`, `ps-*`, `pe-*`, `start-*`, `end-*`, `text-start`, `rtl:` variants for icon flips. Lint rule bans `ml-`, `mr-`, `left-`, `right-`.
- In Arabic the sidebar sits on the right, drawers open from the left (end edge), breadcrumbs, pagination, timelines and steppers run right-to-left.
- Charts mirror their axis order; numbers inside charts stay readable. Date pickers start the week on Saturday when locale is ar-QA.
- Mixed text (Arabic sentence with an English service name or phone number) uses bidi isolation (`<bdi>` / `⁨…⁩`).
- Every PR that touches UI includes an Arabic screenshot or a golden test.
