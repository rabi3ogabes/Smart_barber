# Smart Barber

Multi-tenant SaaS for luxury barbershops: Laravel backend + dashboard, Flutter customer and staff apps.

- `CLAUDE.md` — project brief and non-negotiable rules (read every session)
- `docs/architecture/` — Laravel, Flutter and design-system references
- `docs/roadmap.md` — 16 phases and their done-when gates
- `docs/prompts/` — one prompt per phase plus helper prompts (continue, fix, design QA, security review, change request)
- `docs/phases/` — one report per finished phase (created as phases complete)

- `backend/` — Laravel API + dashboard (Phase 1a); see `backend/README.md` to run it
- `apps/customer/`, `apps/staff/` — Flutter apps; `packages/sb_core`, `sb_api`, `sb_ui` — shared Dart packages (one pub workspace, see below)
- `design/tokens.json` — design tokens shared by the dashboard and the Flutter apps

Progress: Phases 0, 1a and 1b done — see `docs/phases/`.

## Flutter apps

Requirements: Flutter 3.50+ (Dart 3.14), Android SDK for Android builds, Xcode for iOS.

```bash
flutter pub get                      # once, at the repo root (pub workspace)
cd apps/customer && flutter run --dart-define-from-file=env/dev.json
cd apps/staff && flutter run --dart-define-from-file=env/dev.json
```

`env/dev.json` points at `http://10.0.2.2:8000/api/v1` (the host machine from the Android emulator). Run the backend first (`backend/README.md`).

Quality gate: `tool/flutter_check.sh` (codegen up to date, `flutter analyze --fatal-infos`, all tests); add `--build` to build both APKs. Regenerate code with `tool/flutter_codegen.sh`; regenerate goldens with `flutter test --update-goldens` on Linux.
