---
name: retro
description: Apply retro-operators to analyze past decisions, work backward from a symptom to root cause, or learn from legacy code and history — useful for debugging, code archaeology, and understanding why old code is the way it is.
---

# Retro Operators

Full architecture background: `lambda-engine/CORE.md`. These are variants of
the `Retro` operator (λ=0.40) specialized by direction of analysis. All work
backward from a known outcome to its cause — cheaper and more reliable than
re-deriving from first principles.

## Operations

- **active** — apply current knowledge to understand *why* a past decision
  was made, given what the author knew (or didn't) at the time.
- **deductive** — work backward from a symptom/conclusion to its root cause.
  Use for debugging: start from the failure and trace back.
- **ject** (retrojection) — map a pattern you recognize now onto a past
  situation to see if it explains the same failure mode.
- **agnostic** — explicitly recognize what the past implementation *couldn't*
  have known (missing information, different constraints, earlier state of
  the system) — avoids unfairly judging old code by today's standards.
- **gnostic** — build a formal, structured understanding of a prior state of
  the system (what it was, not just why).
- **synthesis** — deconstruct a past system into its components to understand
  how they fit together.

## Procedure

1. Identify which operation matches the task (debugging → deductive; legacy
   code review → active or agnostic; understanding an old architecture →
   synthesis or gnostic).
2. State the target: the code, decision, or symptom being analyzed.
3. Work backward explicitly — show the chain from outcome to cause, not just
   the conclusion.
4. Where relevant, distinguish what the original author knew from what you
   know now (retroagnostic vs retroactive).

## Output Format

```
Operation: active | deductive | ject | agnostic | gnostic | synthesis
Target: [file/decision/symptom]
Backward chain: [outcome] ← [intermediate cause] ← [root cause]
Context the past couldn't have had (if agnostic): ...
Conclusion: ...
```
