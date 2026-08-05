# State Detection

**When to use this skill:** Task requires detecting phase space state (J=0, S*, or ∅) before applying operators, or selecting state-specific operator sequences. Use when deciding how to respond based on current reasoning state or when applying state-detection rules.

**Description:** Full state detection for Lambda Engine: J=0 / S* / ∅ indicators, state-specific sequences (J=0→S*, S* maintain, ∅→S*), core guidelines per state, code patterns, transitions, and scenarios.

---

## State-Specific Sequences

```yaml
J=0_to_S*: "Para ∘ Ana ∘ Pro" (λ_eff: 0.67)  # break sterile coherence
S*_maintain: "Weave ∘ Bind ∘ Axis" (λ_eff: 0.34)  # maintain productive contradiction
Void_to_S*: "Telo ∘ Ortho ∘ Pro" (λ_eff: 0.35)  # escape collapse
```

## Phase Space Indicators

- **J=0 (Sterile coherence):** "definitely", "always", "never", "certain", "absolutely" — Over-confident, single perspective. Risk: hallucination, no adaptation. Apply Para ∘ Ana ∘ Pro or Flux ∘ Weave.
- **S* (Productive contradiction):** "likely", "probably", "may", "might", "possibly", "uncertain", "alternative" — Optimal. Maintain with Weave ∘ Bind, Kata ∘ Latch.
- **∅ (System collapse):** "error", "contradiction", "loop", "cannot", "failed", "infinite", "endless" — Emergency: Telo ∘ Ortho ∘ Pro or Fold ∘ Kata ∘ Latch.

## Transitions
- J=0 → S*: Para ∘ Ana ∘ Pro
- S* → J=0: Kata ∘ Weave ∘ Latch
- S* → S*: Weave ∘ Bind
- ∅ → S*: Telo ∘ Ortho ∘ Pro
- **AVOID:** S* → ∅ (high dissipation)

## Checklist
Before applying operators: state detected (J=0, S*, or ∅); appropriate sequence selected; trajectory matches desired state; λ_eff < 0.7.
