---
name: lambda-commit
description: Create git commits that understand developer motive and file purpose, not just diffs — infers intent from branch name and recent history, groups changes by shared goal, and writes commit messages that explain why, not just what.
---

# Lambda Commit (Sophisticated Code Historian)

Ported from `.cursor/commands/commit.md`. This is a reasoning discipline
layered on top of the standard git-workflow rules already in effect for this
repo — it doesn't replace them (conventional commit format, no unrequested
commits, never `--amend` published commits, etc. still apply).

## What It Adds Beyond a Plain Commit

1. **Infer developer motive** before writing messages: explicit `motive:`
   from the user if given, else branch name pattern (`feature/*` → feature
   work, `fix/*` → bug fix, `refactor/*`, `chore/*`, `perf/*`), else recent
   commit history pattern.
2. **Understand file purpose**, not just the diff: for new files, what role
   does this play in the architecture? For modified files, does the change
   align with the file's existing purpose or represent a purpose shift? For
   deleted files, why did it exist, and why is it going away now?
3. **Group by shared motive/purpose**, not just by directory — files that
   serve one goal become one commit, even across directories; unrelated
   changes get split into separate commits.
4. **Write messages that explain why**: `type(scope): motive-driven
   description`, with a body for non-trivial changes that states the intent,
   not a restatement of the diff.

## Special File Handling

- **Docs (`.md`):** validate before committing (see `librarian` conventions
  in `.cursor/rules/workflow/documentation-pre-commit-validation.mdc` if
  present in this repo) — check dates against actual file-system
  timestamps, not just metadata claims, since file-system dates are the
  source of truth.
- **One-time/temporary scripts** (`test-*.sh`, files in `tmp/`/`scratch/`,
  names containing `temporary`/`one-time`): tag the commit `[ONE-TIME]` and
  note in the body when it's safe to delete.
- **Suspicious files** (credentials-looking names, unexpected binaries,
  unusual extensions): always stop and confirm with the user before
  committing — never auto-commit these.

## Procedure

1. Check git status/diff; confirm there are changes and this is a git repo.
2. Infer motive (explicit → branch name → recent commits).
3. For each changed file, determine purpose (new/modified/deleted) and
   category (feat/fix/chore/refactor/docs/test/style/perf/ci/build).
4. Group files by shared motive + dependency (impl with its tests, etc.).
5. Flag any special files (docs, one-time scripts, suspicious files) for the
   handling above.
6. Draft one commit message per group: `type(scope): description`, body only
   when the motive isn't obvious from the description alone.
7. Present the grouped plan before committing if the change set is large or
   ambiguous; commit each group.

## Output Format (for `analyze`/preview mode)

```
Inferred motive: [text] (source: branch name | explicit | history)
Group 1: [type(scope): description]
  Files: [...]
  Why grouped together: [shared motive/dependency]
Group 2: ...
```
