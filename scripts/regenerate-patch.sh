#!/usr/bin/env bash
# Capture the current src/ state vs upstream/main as the canonical
# customizations patch. Run after manually resolving conflicts during a sync.
set -euo pipefail

cd "$(dirname "$0")/.."

git fetch upstream main

# Only source files — tests are derived via the bulk-rename in sync-fork.sh.
git diff upstream/main -- 'src/' > customizations/src.patch

LINES=$(wc -l < customizations/src.patch | tr -d ' ')
echo "✅ Wrote customizations/src.patch ($LINES lines)"
echo
git diff --stat upstream/main -- 'src/'
