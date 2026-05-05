# Customizations

This fork applies a small **semantic delta** on top of upstream
[`obsidian-tasks-group/obsidian-tasks`](https://github.com/obsidian-tasks-group/obsidian-tasks).
Everything else tracks upstream verbatim.

## What's customized

Priority levels are renamed and re-emoji'd:

| Upstream | This fork | Emoji |
|---|---|---|
| `Highest` | `Critical` | 🔥 (was 🔺) |
| `High`    | `High`     | 🚨 (was ⏫) |
| `Medium`  | `Normal`   | 🟢 (was 🔼) |
| `Low`     | `Low`      | 💤 (was 🔽) |
| `Lowest`  | `Wishlist` | 🔮 (was ⏬) |
| `None`    | `None`     | (unchanged) |

Plus one regex tweak: the priority-emoji regex in `DefaultTaskSerializer.ts`
intentionally drops the trailing `$` so the priority emoji can match anywhere
on a task line, not strictly at the end.

That's the entire customization. Everything in `customizations/src.patch` is in
service of those changes (filter parsing, Dataview format, edit modal,
urgency calc, suggestor list, etc).

## Files

- `customizations/src.patch` — the canonical, source-only delta against
  `upstream/main`. Single source of truth.
- `scripts/sync-fork.sh` — one command to fetch upstream, apply the patch,
  rebuild, and deploy to the vault.
- `scripts/regenerate-patch.sh` — after manual conflict resolution, captures
  the new state into `customizations/src.patch`.
- `scripts/deploy-to-vault.sh` — copies build artifacts to the local Obsidian
  vault.

## Workflow

### Routine sync (run monthly)

```bash
scripts/sync-fork.sh
```

This:

1. Fetches `upstream/main`
2. Creates a fresh branch `sync/upstream-YYYY-MM-DD` based on it
3. Applies `customizations/src.patch`
4. Bulk-renames `Priority.Highest|Medium|Lowest` references in `tests/`
   (these are downstream consequences of the source rename, not part of the
   patch — keeping the patch small means it stays applicable)
5. Commits, builds, and deploys to the vault

### When the patch fails to apply

Upstream refactored something that touches the customization (likely
`Priority` enum, `EditableTask.ts`, `EditTask.svelte`, `PriorityEditor.svelte`,
or one of the serializers). The script will stop with conflicts marked.

```bash
# 1. Resolve conflicts manually in src/
git status                           # see the conflicted files
# ... edit, taking upstream structure but preserving the rename intent ...
git add src/

# 2. Capture the resolved state as the new canonical patch
scripts/regenerate-patch.sh

# 3. Continue
git diff --cached customizations/src.patch   # review what changed
git commit -m "Resync customization patch against upstream/main"
```

### When you want to change the customization

Edit `src/` directly, then:

```bash
scripts/regenerate-patch.sh
git add customizations/src.patch src/
git commit -m "Update customization: <what changed>"
```

## Why this shape

Before: 8 commits + giant doc/test diffs sprawling across the fork. Two
years and 5772 upstream commits later, syncing was effectively impossible
and the test/doc commits were stale ghosts.

After: one patch file (~420 lines), three short scripts. Sync becomes
mechanical. When upstream touches the rename surface, the patch fails
loudly at the right line and we resolve it once. We never accumulate a
multi-year drift again because syncing is a one-command habit.

## Cadence

- **Monthly**: run `scripts/sync-fork.sh`. Even if it fails, you find out
  fast and fix one small thing instead of 5772 things.
- **Before any meaningful upstream release**: same.
- **Before changing the customization**: sync first so you're working
  against current upstream.
