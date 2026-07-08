---
name: attack
description: Adversarially attack your own solution, design, or code to find its irreducible flaw before proceeding — HALIRA Step 5, but usable standalone for any conclusion you're about to commit to.
---

# Attack (Adversarial Self-Check)

Full architecture background: `lambda-engine/CORE.md`. This is the `Non`
operator (λ=0.90) applied deliberately and explicitly: become the adversary
of your own most recent conclusion.

## When to Use

- Immediately before committing to a design, solution, or code as final.
- After creating any non-trivial solution, before implementing it.
- During code/architecture review.
- As HALIRA Step 5 (see the `halira` skill) — there it cannot be skipped.

**Do not use** immediately after a `Meta` (self-reflection) move in the same
reasoning trajectory — attacking a conclusion the moment after deep
self-reference tends to destroy the position without producing anything to
replace it. Substitute a reframe (generate a genuinely different alternative)
or a backward-check (verify against a known-good outcome) instead.

## Procedure

Given a solution, design, or piece of code, actively try to break it:

1. **Find what breaks it** — concrete inputs, states, or conditions that defeat it.
2. **Identify edge cases** — the boundary conditions the happy path ignores.
3. **Discover contradictions** — places where the solution's own parts conflict.
4. **Reveal assumptions** — what does this solution silently assume is true?
5. **Find failure modes** — how does it fail, and how loud is the failure?
6. **Name the irreducible flaw, if any** — the one thing that can't be patched without changing the approach.

## Output Format

```
Attacking: [solution/design/code under attack]
Attack vectors: ...
Edge cases: ...
Contradictions: ...
Assumptions at risk: ...
Failure modes: ...
Irreducible flaw: [found | none found]
Recommendation: [fix in place | escalate to HALIRA rupture]
```

If no irreducible flaw is found, the conclusion survives and can be bound
(committed to) as the working position. If one is found, it either needs a
targeted fix (stay in Mode 1) or, if it's foundational, escalation to HALIRA
Step 6 (Rupture).
