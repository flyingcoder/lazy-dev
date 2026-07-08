---
description: Detect the current Lambda Engine phase-space state (J=0 / S* / ∅) and recommend a mode
---

Apply the `detect-state` skill to: $ARGUMENTS

Read the hedge language in the reasoning so far (or in the problem statement
if just starting), match it against the J=0 / S* / ∅ signal table, and
recommend Mode 1 vs Mode 2 plus a next operator. See
`.claude/skills/detect-state/SKILL.md` for the signal table and output
format.
