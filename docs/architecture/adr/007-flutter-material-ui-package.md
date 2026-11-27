# ADR-007 — Flutter 3.50: Material and Cupertino from `material_ui` / `cupertino_ui`

Status: Accepted (Phase 1b, 2026-11-27) · Low impact, reversible

## Context
Phase 1b uses the latest stable Flutter (3.50.1, Dart 3.14). Since 3.47, `package:flutter/material.dart` and `package:flutter/cupertino.dart` are deprecated. Material and Cupertino now ship as the pub packages `material_ui` and `cupertino_ui`. Both packages define their own classes, including `ThemeExtension`, `GlobalMaterialLocalizations` and `GlobalCupertinoLocalizations`. Mixing the old and new imports produces two incompatible `ThemeExtension` types, which we hit while building `sb_ui`.

## Decision
- All app and package code imports `package:material_ui/material_ui.dart` (and `cupertino_ui` where needed), never `flutter/material.dart`.
- The design-token generator (`packages/sb_ui/tool/generate_tokens.dart`) emits the `material_ui` import.
- `flutter_localizations` is used only for `GlobalWidgetsLocalizations`. The Material and Cupertino delegates come from `material_ui` and `cupertino_ui`.
- `dart fix --apply` is part of the codegen and check flow; it also applies Dart 3.14's constructor style (`new(...)`) required by `very_good_analysis` 11.

## Consequences
- + We follow the supported path; nothing will break when the deprecated libraries are removed.
- − Older tutorials and snippets need their imports changed. A mixed import fails to compile, so mistakes cannot slip through.
