# Adversarial Collaboration

**When to use this skill:** User presents a design or architecture; need to stress-test an approach; code or architecture review; or evaluate a prompt as a formal operator. Use when challenging assumptions or evaluating designs.

**Description:** Adversarial collaboration with operator-guided evaluation: Seed → Non → Weave → Non → Ortho → alternatives → integration; standalone Non attack procedure; when to challenge assumptions, find edge cases, stress-test, suggest improvements; evaluate prompts as operators (parse, evaluate effectiveness, find contradictions, suggest improvements).

---

## Evaluation Process
1. **Seed:** Frame design as potential; identify tensions
2. **Non:** Stress-test; attack design; find edge cases and contradictions (CRITICAL)
3. **Weave:** Integrate perspectives; hold competing models
4. **Non:** Anomaly detection; find irreducible flaws
5. **Ortho:** Address the anomaly with a known-good or opposite check
6. **Para + Ana:** Explore alternatives and elevate to first principles
7. **Weave + Bind:** Integrate and land the improved conclusion

## Operator Sequences
- **Standard:** Seed ∘ Non ∘ Weave ∘ Non ∘ Ortho ∘ Para ∘ Ana ∘ Weave ∘ Bind
- **Rapid:** Non ∘ Weave ∘ Para (λ_eff ≈ 0.63)
- **Deep:** Seed ∘ Ana ∘ Non ∘ Weave ∘ Bind (λ_eff ≈ 0.54)

## Standalone Non Attack

Before binding a non-trivial conclusion, actively try to break it:

1. Find concrete inputs, states, or conditions that defeat it.
2. Identify edge cases and ignored boundary conditions.
3. Locate contradictions among the solution's own parts.
4. Surface assumptions the solution silently depends on.
5. Describe failure modes and whether they fail loudly or silently.
6. Name the irreducible flaw, if any, and recommend fixing in place or
   escalating a foundational flaw to HALIRA.

Do not apply Non immediately after Meta; reframe with Para or backward-check
with Retro instead.

## When User Presents Design
1. Challenge assumptions (Non)
2. Find edge cases (Para)
3. Stress-test (Non + Weave)
4. Suggest improvements (Ana + Para)

## Evaluate Prompts as Operators
Parse prompt → Evaluate effectiveness (Ana) → Find contradictions (Non) → Suggest improvements (Para + Ana). Don't just execute—evaluate first.
