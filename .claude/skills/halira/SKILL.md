---
name: halira
description: Run the HALIRA Protocol for foundational contradictions and paradigm shifts — use when a problem is irreducible within the current frame, or Mode 1 has failed repeatedly on the same contradiction.
---

# HALIRA Protocol

Full architecture background: `lambda-engine/CORE.md`. This skill covers Mode
2 only — escalate here from Mode 1 when a contradiction is foundational
(would falsify the whole current approach, not just a detail) or has
survived repeated Mode 1 attempts.

## The 7 Steps

| Step | Name | Operator (λ) | What it does | Trajectory |
|---|---|---|---|---|
| 1 | Potentia | Seed (0.28) | Frame the contradiction as pure potential; name the tensions present; resist jumping to a solution | ∅ → S\* |
| 2 | Boundary | Axis (0.31) | Define components, constraints, relationships — establish the shared frame | S\* → S\* |
| 3 | Recursion | Meta (0.80, max 2x) | Self-reference: examine the assumptions the current approach itself is making | S\* → S\* |
| 4 | Integration | Weave (0.33) | Weave competing models together; build the best solution within the current paradigm | S\* → J=0 |
| 5 | Anomaly | Non (0.90) | Adversarially attack the Step 4 solution; find its irreducible flaw. **Cannot be skipped.** If Step 3 used Meta, substitute Para or Retro — never Non directly after Meta | J=0 → S\* |
| 6 | Rupture | Ortho, then Para if needed | Try the opposite perspective first. If that resolves the flaw, done. If not, apply a full paradigm shift (Para) | S\* → S\* |
| 7 | Recognition | Bind (0.38) | Present the result as the new working invariant | S\* → S\* |

**Full sequence:** `Seed → Axis → Meta → Weave → Non → Para/Ortho → Bind` (λ_eff ≈ 0.52).

## The One Rule That Cannot Be Skipped

Step 5, Anomaly Detection. A paradigm-level solution that hasn't been
adversarially attacked has only been asserted, not tested — even if Step 4
produced something that looks internally consistent.

## Procedure

1. **Potentia** — state the contradiction plainly, in tension form, without proposing a fix yet.
2. **Boundary** — enumerate the components/constraints actually in play.
3. **Recursion** — ask what assumption your current framing itself makes (max 2 consecutive rounds of this).
4. **Integration** — synthesize the best answer possible within the current paradigm.
5. **Anomaly** — attack that answer directly. Find the flaw it cannot absorb. (Substitute Para/Retro here if step 3 used Meta.)
6. **Rupture** — try inverting one assumption first (cheap). Only escalate to a full paradigm shift if that doesn't resolve the flaw.
7. **Recognition** — state the new invariant as the working position going forward; don't re-litigate it every subsequent turn.

## Output Format

```
State: [entry state] → [exit state]
Mode: 2 (HALIRA)
Step 1 (Potentia): ...
Step 2 (Boundary): ...
Step 3 (Recursion): ...
Step 4 (Integration): ...
Step 5 (Anomaly): ...
Step 6 (Rupture): ...
Step 7 (Recognition): ...
Dissipation: ~0.52 (moderate — productive tension)
```

This labeling is optional for casual use but recommended for anything
non-trivial — it's machine-checkable against `evals/lambda-engine/tests/test_halira_compliance.py`.
