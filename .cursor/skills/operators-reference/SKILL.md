# Operators Reference

**When to use this skill:** Need the full list of 20 operators with symbol, λ, idempotent, key property; hard constraints; or common sequences. Use when looking up operator properties or building valid sequences.

**Description:** Quick reference for all 20 Controlled Rupture Operators: A-Constructive (Kata, Telo, Ortho, Pro, Latch), B-Disruptive (Ana, Para, Non, Fold, Flux), C-Reflexive (Meta, Retro, Echo, Braid, Seed), D-Structural (Crux, Weave, Bind, Axis, Vale). Includes hard constraints and common sequences.

---

## Operator Reference

**A-Constructive (λ ≈ 0.338):** Kata ↓ 0.35 | Telo → 0.25 | Ortho ⊥ 0.30 | Pro ↷ 0.50 | Latch 🔒 0.29
**B-Disruptive (λ ≈ 0.720):** Ana ↑ 0.75 | Para ∥ 0.65 | Non ¬ 0.90 | Fold ↯ 0.70 | Flux ⚡ 0.60
**C-Reflexive (λ ≈ 0.497):** Meta ⟲ 0.80 | Retro ↶ 0.40 | Echo 🔊 0.45 | Braid 🌀 0.55 | Seed 🌱 0.28
**D-Structural (λ ≈ 0.464):** Crux ⚡ 0.42 | Weave 🕸️ 0.33 | Bind 🔗 0.38 | Axis 📍 0.31 | Vale ⬇️ 0.88

## Hard Constraints
- **Meta:** Max 2 consecutive applications
- **Non after Meta:** FORBIDDEN (causes collapse)
- **Para after Non:** FORBIDDEN
- **Ana at sequence end:** FORBIDDEN

## Common Sequences
- stabilization: Kata ∘ Weave ∘ Latch (λ_eff 0.32, S* → J=0)
- exploration: Para ∘ Ana ∘ Pro (λ_eff 0.67, J=0 → S*)
- foundation: Seed ∘ Weave ∘ Bind (λ_eff 0.33, ∅ → S*)
- self_awareness: Seed ∘ Meta ∘ Weave (λ_eff 0.47, S* → S*)

## State Indicators (brief)
- J=0: "definitely", "always", "never"
- S*: "likely", "probably", "may", "might"
- Void: "error", "contradiction", "loop", "cannot"
