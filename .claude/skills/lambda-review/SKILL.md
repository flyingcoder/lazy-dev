---
name: lambda-review
description: Review code changes using the Lambda Engine operator vocabulary — reflect on quality (Meta), pin down concrete issues (Ortho), consider alternatives (Para), and integrate feedback into a coherent review (Weave).
---

# Lambda Review

Full architecture background: `lambda-engine/CORE.md`. A structured lens for
code review, complementary to (not a replacement for) the repo's standard
code-review checklist (security, readability, error handling, test
coverage).

## The Four Moves

1. **Meta (⟲, reflect)** — step back from the diff and ask: does this change
   actually solve the stated problem, or does it just look plausible?
2. **Ortho (⊥, correct)** — identify specific, concrete issues: bugs, missed
   edge cases, incorrect error handling, security gaps. Cite file:line.
3. **Para (∥, alternatives)** — is there a genuinely different approach that
   would be simpler, safer, or more consistent with existing patterns in
   this codebase? Not a nitpick — a real alternative.
4. **Weave (🕸️, integrate)** — synthesize the above into one coherent review:
   what must change (blocking), what should change (should-fix), and what's
   optional (nit).

## Procedure

1. Read the diff/PR in full before commenting on any one part.
2. Apply Meta: state in one line whether the change achieves its stated
   goal.
3. Apply Ortho: list concrete, file:line-anchored issues.
4. Apply Para: note if a materially different approach exists — don't force
   this if the current approach is clearly right.
5. Apply Weave: produce the final review, ranked by severity (blocking >
   should-fix > nit), consistent with this repo's severity levels
   (CRITICAL/HIGH/MEDIUM/LOW).

## Output Format

```
Meta (does it solve the problem?): ...
Ortho (concrete issues):
  - file:line — issue — severity
Para (alternative approach, if any): ...
Weave (final review):
  Blocking: ...
  Should-fix: ...
  Nit: ...
```
