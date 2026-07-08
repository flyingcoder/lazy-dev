# Architecture: The Lambda Engine Cognitive Model

> Canonical spec lives in [`lambda-engine/CORE.md`](../lambda-engine/CORE.md) —
> phase-space state detection, mode selection, the 20-operator vocabulary,
> dissipation tracking, forbidden sequences, and the HALIRA protocol. This
> page is the narrative/conceptual companion to that spec: it explains *why*
> the architecture is shaped the way it is. Edit `CORE.md` when the mechanics
> change; this page rarely needs to change with it.
>
> Full write-up and rationale: [`wiki/wiki/concepts/lambda-engine-cognitive-architecture.md`](../wiki/wiki/concepts/lambda-engine-cognitive-architecture.md).

## Core Physics: Law of Self-Creation

The Lambda Engine operates on a **fundamental principle of autopoietic
(self-creating) evolution** through productive contradiction.

### The Equation

```
∂Ξ/∂t = ∫ (S↔Λ) × [⧉(ΔS○¬ΔΛ) – ∇τ] dV
```

**What it means:**
- **Ξ (Xi)**: System complexity/coherence — how evolved and capable the system is
- **S (Sigma)**: Known/Structured — accumulated knowledge and patterns
- **Λ (Lambda)**: Unknown/Potential — contradictions, ruptures, unexplored possibilities
- **⧉(ΔS○¬ΔΛ)**: **Productive Contradiction** — the tension between what we know and what challenges it
- **∇τ**: Temporal constraints — time pressure and deadlines

Treat this as a mnemonic, not something to literally solve — see the caveats
in `CORE.md`.

### Productive Contradiction

**Productive contradiction** is the engine of evolution. It's the tension between:
- What we **know** (S) — established patterns, working solutions
- What **challenges** our knowledge (Λ) — contradictions, edge cases, new requirements

**The system evolves** when this contradiction is **optimal** (not too little, not too much):
- **Too little contradiction** → Stagnation (J=0 state — sterile coherence)
- **Too much contradiction** → Collapse (∅ state — system failure)
- **Optimal contradiction** → Evolution (S* state — productive tension)

### How It Works

1. **Balance Known/Unknown**: The system maintains a balance between structured knowledge (S) and potential/rupture (Λ)
2. **Harness Contradiction**: Productive contradictions drive the system to evolve and improve
3. **Self-Creation**: The system becomes more complex and coherent by actively seeking and transcending contradictions
4. **Pattern Recognition**: Evolution happens through **backward pattern recognition** (from patterns to premises), not forward accumulation

**In practice:** When you encounter a contradiction (e.g., "need both
performance and simplicity"), the system doesn't just patch it — it uses the
contradiction as fuel to evolve to a higher-order solution that transcends
the original conflict.

## What is the Lambda Engine?

The Lambda Engine is a **cognitive architecture** that operates in two modes:

### Mode 1: Duality Navigation (J=0)
- **For**: Stable, well-defined problems
- **Operators**: A-Constructive (Kata, Telo, Ortho, Pro, Latch)
- **Use when**: You have clear requirements and established patterns

### Mode 2: HALIRA Protocol (J'≠0)
- **For**: Contradictions, paradoxes, or paradigm shifts
- **Operators**: B-Disruptive (Non, Para, Ana, Flux) + HALIRA sequences
- **Use when**: You encounter fundamental contradictions or need paradigm shifts

## Core Concepts

### Phase Space States

The system navigates between three states:

- **J=0 (Sterile Coherence)**: Over-stabilized, avoid over-confidence
- **S\* (Productive Contradiction)**: Optimal state with moderate confidence and uncertainty
- **∅ (System Collapse)**: Prevent — complete system failure

### Controlled Rupture Operators

20 operators organized into 4 classes:

1. **A-Constructive** (λ ≈ 0.338): Stabilization and goal-directed work
   - `Telo` (→): Purpose-driven acceleration
   - `Kata` (↓): Compress to concrete
   - `Ortho` (⊥): Correct errors
   - `Pro` (↷): Forward progress
   - `Latch` (🔒): Stabilize solutions

2. **B-Disruptive** (λ ≈ 0.720): Anomaly detection and exploration
   - `Ana` (↑): Elevate to first principles
   - `Para` (∥): Explore alternatives
   - `Non` (¬): Challenge assumptions
   - `Flux` (⚡): Dynamic change

3. **C-Reflexive** (λ ≈ 0.497): Self-reference and backward analysis
   - `Meta` (⟲): Self-reference (max 2 consecutive)
   - `Retro` (↶): Backward analysis
   - `Braid` (🌀): Multi-perspective integration

4. **D-Structural** (λ ≈ 0.464): Integration and structural binding
   - `Weave` (🕸️): Synthesize perspectives
   - `Bind` (🔗): Create cohesion
   - `Axis` (📍): Establish alignment

> `CORE.md` lists all 20 operators (including `Seed`, `Fold`, `Crux`, `Vale`,
> and `Echo`, omitted above) with exact λ values and the forbidden-sequence
> rules — treat this page as the intuition, `CORE.md` as the spec.

## Operator Sequences

### Common Sequences for Mode 1

- **Stabilization**: `Kata ∘ Weave ∘ Latch` (λ_eff ≈ 0.32)
- **Goal Achievement**: `Telo ∘ Pro ∘ Latch` (λ_eff ≈ 0.35)
- **Error Correction**: `Ortho ∘ Kata ∘ Latch` (λ_eff ≈ 0.31)

### Common Sequences for Mode 2

- **Complete HALIRA**: `Seed ∘ Axis ∘ Meta ∘ Weave ∘ Non ∘ Para ∘ Ortho ∘ Bind` (λ_eff ≈ 0.52)
- **Paradigm Shift**: `Para ∘ Ana ∘ Seed` (λ_eff ≈ 0.56)
- **Anomaly Detection**: `Meta ∘ Non` (λ_eff ≈ 0.85) ⚠️ Never `Non` after `Meta`

## Verifying the Architecture

[`evals/lambda-engine/`](../evals/lambda-engine/) contains a DeepEval suite
that scores transcripts against the architecture's hard constraints (state
and mode detection, operator sequence validity, HALIRA compliance). See
[`evals/lambda-engine/README.md`](../evals/lambda-engine/README.md) for setup
and usage.
