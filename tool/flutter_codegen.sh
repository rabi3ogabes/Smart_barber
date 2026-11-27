#!/usr/bin/env bash
# Regenerates every committed generated file in the Flutter workspace.
set -euo pipefail
cd "$(dirname "$0")/.."

flutter pub get
(cd packages/sb_ui && dart run tool/generate_tokens.dart && flutter gen-l10n)
(cd packages/sb_api && dart run build_runner build -d)
for app in apps/customer apps/staff; do
  (cd "$app" && flutter gen-l10n && dart run build_runner build -d)
done
