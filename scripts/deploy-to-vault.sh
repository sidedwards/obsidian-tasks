#!/usr/bin/env bash
# Copy build artifacts to the local Obsidian vault plugin dir.
set -euo pipefail

cd "$(dirname "$0")/.."

VAULT_PLUGIN="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vault/.obsidian/plugins/obsidian-tasks-plugin"

if [ ! -d "$VAULT_PLUGIN" ]; then
    echo "ERROR: vault plugin dir not found:" >&2
    echo "  $VAULT_PLUGIN" >&2
    exit 1
fi

for f in main.js styles.css manifest.json; do
    if [ ! -f "$f" ]; then
        echo "ERROR: $f missing — run 'npm run build' first" >&2
        exit 1
    fi
done

cp main.js styles.css manifest.json "$VAULT_PLUGIN/"
echo "✅ Deployed main.js, styles.css, manifest.json to vault."
echo "   Restart Obsidian (Cmd+R) to load."
