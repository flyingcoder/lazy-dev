# Retro Operators

**When to use this skill:** Task involves understanding old code, debugging by working backward, learning from past decisions, tracing history, or root cause analysis. Use when working backward from patterns or conclusions.

**Description:** Retro-operators for backward analysis: Retro (λ=0.40) mapping; Retroactive (Retro ∘ Ana ∘ Weave); Retroductive (Retro ∘ Non ∘ Weave); Retrojection (Retro ∘ Echo ∘ Weave); Retroagnostic (Retro ∘ Ana ∘ Para); Retrognostic (formal reconstruction of a prior state); Retrosynthesis (Retro ∘ Ana ∘ Kata); compound operations (retro², retro-meta). When to use each pattern.

---

## Retro (↶) λ=0.40
- Backward, backtracking; never idempotent; trajectory S* → S*

## Patterns
- **Retroactive:** Apply current knowledge to past. Sequence: Retro ∘ Ana ∘ Weave (λ_eff ≈ 0.49). Use for "why was this done this way?", understanding old code with current patterns.
- **Retroductive:** Symptom → root cause. Sequence: Retro ∘ Non ∘ Weave (λ_eff ≈ 0.65). Use for debugging, root cause analysis.
- **Retrojection:** Map past patterns onto current work. Sequence: Retro ∘ Echo ∘ Weave (λ_eff ≈ 0.39). Use for learning from past mistakes, preventing recurrence.
- **Retroagnostic:** Recognize what past couldn't know. Sequence: Retro ∘ Ana ∘ Para (λ_eff ≈ 0.60). Use for understanding limitations of past context.
- **Retrognostic:** Build a formal, evidence-backed account of a prior state:
  what existed, which constraints held, and what was knowable then. Start
  from the observed outcome and work backward; do not fill evidence gaps with
  present-day assumptions.
- **Retrosynthesis:** Backward assembly. Sequence: Retro ∘ Ana ∘ Kata (λ_eff ≈ 0.50). Use for deconstructing complex legacy systems.

## Compound
- retro²: Retro ∘ Retro ∘ Weave
- retro-meta / meta-retro: involve Meta (max 2 consecutive)

## Procedure

1. Select the operation that matches the task: debugging → deductive; legacy
   code review → active or agnostic; prior architecture → synthesis or
   gnostic; preventing recurrence from a known pattern → ject.
2. State the code, decision, or symptom being analyzed.
3. Work backward explicitly from outcome through intermediate causes to the
   root cause.
4. Distinguish what the original author could know then from what is known
   now.

## Output Format

```text
Operation: active | deductive | ject | agnostic | gnostic | synthesis
Target: [file/decision/symptom]
Backward chain: [outcome] ← [intermediate cause] ← [root cause]
Context the past could not have had (if agnostic): ...
Conclusion: ...
```

## Primary tools for Retro
Retro (backward), Ana (elevate), Weave (integrate). For root cause: Retro ∘ Non. For pattern learning: Retro ∘ Echo.
