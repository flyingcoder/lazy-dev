---
description: Commit changes with motive/purpose-aware grouping and messages (Lambda Engine historian mode)
---

Apply the `lambda-commit` skill to commit the current changes. Arguments
(optional): $ARGUMENTS — may include an explicit motive (e.g. `motive:
implement rate limiting`), `analyze` for a dry-run preview, or `context: N`
to widen history lookback.

Infer developer motive, understand each changed file's purpose, group by
shared motive/dependency, and write commit messages that explain why, not
just what — following this repo's standard git-workflow rules (conventional
commits, no `--amend` on published commits, confirm before pushing). See
`.claude/skills/lambda-commit/SKILL.md` for the full procedure.
