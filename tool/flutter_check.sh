#!/usr/bin/env bash
# Phase gate for the Flutter side: analyze, test every package and app, and fail if generated
# files are stale. Add `--build` to also build both Android APKs (dev flavor).
set -euo pipefail
cd "$(dirname "$0")/.."

flutter pub get
tool/flutter_codegen.sh >/dev/null
if ! git diff --quiet -- packages apps; then
  echo "Generated files are out of date. Run tool/flutter_codegen.sh and commit." >&2
  git --no-pager diff --stat -- packages apps >&2
  exit 1
fi

for dir in packages/sb_core packages/sb_api packages/sb_ui apps/customer apps/staff; do
  echo "== $dir"
  (cd "$dir" && flutter analyze --fatal-infos && flutter test)
done

if [[ "${1:-}" == "--build" ]]; then
  for app in customer staff; do
    (cd "apps/$app" && flutter build apk --debug --dart-define-from-file=env/dev.json)
  done
fi
