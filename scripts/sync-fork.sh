#!/usr/bin/env bash
# Sync this fork against upstream/main, reapply customizations, build, deploy.
# See CUSTOMIZATIONS.md for the why.
set -euo pipefail

cd "$(dirname "$0")/.."

if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "ERROR: working tree is dirty. Commit or stash first." >&2
    exit 1
fi

git fetch upstream main

# The overlay (CUSTOMIZATIONS.md + scripts/ + customizations/) lives only on
# the fork; upstream doesn't have these paths. Stash them out before we reset
# the working tree to upstream/main, then restore.
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT
echo "→ Saving overlay to $TMPDIR"
cp -R CUSTOMIZATIONS.md scripts customizations "$TMPDIR/"

BRANCH="sync/upstream-$(date +%Y-%m-%d)"
echo "→ Creating branch $BRANCH off upstream/main"
git checkout -B "$BRANCH" upstream/main

echo "→ Restoring overlay"
cp -R "$TMPDIR/CUSTOMIZATIONS.md" "$TMPDIR/scripts" "$TMPDIR/customizations" .

echo "→ Applying customizations/src.patch"
if ! git apply --3way customizations/src.patch; then
    cat <<'EOF' >&2

ERROR: patch did not apply cleanly. Upstream refactored something the
customization touches.

To recover:
  1. Resolve conflicts in src/ manually
  2. git add src/
  3. scripts/regenerate-patch.sh
  4. Re-run this script, OR continue manually:
     - run the test bulk-rename (see this script)
     - npm run build
     - scripts/deploy-to-vault.sh
EOF
    exit 1
fi

echo "→ Bulk-renaming Priority enum references in tests/"
# Downstream consequences of the rename, not part of the patch
# (keeping the patch small means it stays applicable longer).
git ls-files 'tests/*.ts' \
    | xargs grep -l -E 'Priority\.(Highest|Medium|Lowest)|prioritySymbols\.(Highest|Medium|Lowest)' 2>/dev/null \
    | xargs sed -i '' \
        -e 's/Priority\.Highest/Priority.Critical/g' \
        -e 's/Priority\.Medium/Priority.Normal/g' \
        -e 's/Priority\.Lowest/Priority.Wishlist/g' \
        -e 's/prioritySymbols\.Highest/prioritySymbols.Critical/g' \
        -e 's/prioritySymbols\.Medium/prioritySymbols.Normal/g' \
        -e 's/prioritySymbols\.Lowest/prioritySymbols.Wishlist/g' \
    || true

# Priority-name string arrays in serializer round-trip tests.
sed -i '' \
    -e "s/'Highest', 'High', 'Medium', 'Low', 'Lowest'/'Critical', 'High', 'Normal', 'Low', 'Wishlist'/g" \
    -e "s/'Highest', 'High', 'None', 'Medium', 'Low', 'Lowest'/'Critical', 'High', 'None', 'Normal', 'Low', 'Wishlist'/g" \
    tests/TaskSerializer/DataviewTaskSerializer.test.ts \
    tests/TaskSerializer/DefaultTaskSerializer.test.ts 2>/dev/null || true

echo "→ Committing"
git add -A
git commit -m "Sync upstream/main and reapply customizations

Customization: rename Highest/Medium/Lowest priority levels to
Critical/Normal/Wishlist with custom emoji set 🔥🚨🟢💤🔮.
See CUSTOMIZATIONS.md for details."

echo "→ Building"
npm run build

echo "→ Deploying"
"$(dirname "$0")/deploy-to-vault.sh"

cat <<EOF

✅ Sync complete.
   Branch: $BRANCH
   Restart Obsidian (Cmd+R) or toggle the Tasks plugin to load.
   Tests are likely stale (approval files reference old emoji); run
   'npm test' if you want to triage them.
EOF
