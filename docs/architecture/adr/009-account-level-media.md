# ADR-009 — Account-level media for the customer avatar

Status: Accepted (2026-11-28) · Phase 5 · Reversible (one table, one column)

## Context
The customer app lets a person upload a profile photo (Phase 5). The photo belongs to the global
`customer_accounts` identity, which spans every salon the person visits (ADR-002). The existing
`media` table is tenant-owned: `salon_id` is required and every read goes through the fail-closed
`SalonScope` (ADR-001). An avatar has no salon to belong to.

## Options
1. **Make `media.salon_id` nullable.** Every `media` query would need to handle "no tenant" rows. The
   fail-closed scope would have to be loosened for one collection. That weakens rule 2 for all files.
2. **Copy the avatar into every salon's `media`.** Many copies; deleting the account has to find
   them all.
3. **A small `account_media` table owned by the account.** No `salon_id`; it lives next to the identity
   tables.

## Decision
Option 3:
- **Table:** `account_media` (`customer_account_id`, collection, disk, path, mime, size, width, height),
  on the same private disk as tenant media.
- **URLs:** served only through temporary signed URLs, like tenant media.
- **Resize:** `UploadAvatar` stores the file, points `customer_accounts.avatar_media_id` at it and
  removes the previous photo. The queued `ResizeAvatar` job (rule 9) square-crops it to 512×512 JPEG,
  which also strips EXIF location data.
- **Allow-list:** `AccountMedia` is in the architecture test's `NON_TENANT_MODELS`, with this reason.

## Consequences
- + Tenant media keeps its fail-closed scope unchanged.
- + Account deletion removes one row and one file (spec-review item 12).
- − A second media table. If more account-level files appear (for example, ID documents), they go
  here too, not into `media`.
