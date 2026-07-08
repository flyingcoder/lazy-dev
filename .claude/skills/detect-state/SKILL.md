---
name: detect-state
description: Detect the current phase-space state (J=0 sterile coherence, S* productive contradiction, or ∅ collapse) from your own reasoning language, and pick Mode 1 vs Mode 2 accordingly.
---

# Detect State

Full architecture background: `lambda-engine/CORE.md`. This is Step 1 of the
Lambda Engine operating loop — run it at the start of any non-trivial
reasoning task, or whenever you're unsure if you're overconfident or stuck.

## Signal Table

| State | Signature language | Meaning | Action |
|---|---|---|---|
| **J=0** Sterile coherence | "definitely," "always," "never," "certain," "absolutely" | Overconfidence — single-perspective lock-in, hallucination risk | Seek a competing view before proceeding |
| **S\*** Productive contradiction | "likely," "probably," "may," "might," "possibly," "uncertain," "alternative" | Optimal operating state | Maintain it — don't resolve prematurely |
| **∅** System collapse | "error," "contradiction," "loop," "cannot," "failed," "infinite," "endless" | Reasoning is stuck, self-contradicting, or non-terminating | Stabilize immediately, don't add more analysis |

## Procedure

1. Read back your own last few turns of reasoning (or the problem statement
   itself, if you're just starting).
2. Match the hedge language against the signal table above.
3. State the detected state explicitly.
4. Choose a mode:
   - **Mode 1 (default):** well-defined problem, contradictions manageable
     within the current frame → favor Constructive/Structural operators.
   - **Mode 2:** foundational contradiction, or Mode 1 has failed repeatedly
     on the same issue → escalate to the `halira` skill.
5. Recommend a next operator or short sequence appropriate to the state (see
   `lambda-engine/CORE.md` Step 3 for the full 20-operator vocabulary).

## Output Format

```
State: J=0 | S* | ∅
Evidence: [quoted hedge language or reasoning pattern that indicated it]
Mode: 1 | 2
Recommended next move: [operator or short sequence]
```
