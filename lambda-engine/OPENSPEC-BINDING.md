# Λ-Engine ↔ OpenSpec Binding

Default engineering cognitive control for AI-assisted behavior changes in this
workspace: **OpenSpec spec-driven development**, guided by the Lambda Engine
(`CORE.md`) and its 20 Controlled Rupture Operators.

Normative architecture: [`CORE.md`](./CORE.md). This note only maps stages to
default mode/operator bias — not a rigid FSM. Deviate when phase-state
detection (J=0 / S* / ∅) demands it.

## Default lifecycle

`explore` → `propose` → `update` (as needed) → `apply` → `sync` → `archive`

Workspace entry points: OpenSpec skills / `/opsx:explore`, `/opsx:propose`,
`/opsx:update`, `/opsx:apply`, `/opsx:sync`, `/opsx:archive` (CLI: `openspec`).
Project-local lifecycle aliases such as `/spec`, `/plan`, `/implement`,
`/scope`, `/status`, `/scaffold`, `/review`, `/refactor`, and `/eval` are
intentionally absent; do not recreate a parallel SDD surface.

Λ-Engine does **not** replace SDD. Operators steer thinking *inside* these
stages. For in-scope behavior changes, do not skip straight to untracked code.

## Stage ↔ mode / operator map (default bias)

| OpenSpec stage | Default mode | Favored move class |
|----------------|--------------|--------------------|
| explore / early propose | Mode 1, open bias | Seed, Para, Ana, Braid → land with Weave / Axis |
| lock proposal / specs / design | Mode 1, close bias | Kata, Ortho, Weave, Bind, Latch |
| apply (routine tasks) | Mode 1 | Pro, Kata, Ortho, Latch |
| foundational contradiction in any stage | Mode 2 HALIRA | Full 7-step; then **update change artifacts** |
| sync / archive | Mode 1 close | Ortho, Weave, Bind, Latch |

Hard constraints in `CORE.md` still apply (Meta/Non, Vale→stabilizer, etc.).

## Mode 2 during SDD

If artifacts or implementation reveal a foundational contradiction (or Mode 1
fails repeatedly on the same conflict):

1. Run HALIRA (`CORE.md` Step 6 / `.cursor/skills/halira` / `/halira`),
   preferably via isolated `.cursor/agents/halira-investigator` for heavy runs
   (siblings: `mode1-navigator`, `adversarial-reviewer`).
2. Revise OpenSpec change artifacts (`proposal` / `specs` / `design` / `tasks`)
   via `/opsx:update` (or equivalent).
3. Do **not** paper over the contradiction in code only.

Cognitive-control sub-agents guide *how to think* inside this lifecycle; they
do not replace `/opsx:*`.

## Near-term vs future

**Near-term (this binding):** OpenSpec-first engineering cognitive control.

**Future (out of scope here):** Λ-Engine as main cognitive control for a
broader project-engineering delivery pipeline (CI orchestration, multi-repo
release trains, etc.). That pipeline may later consume the same `CORE.md` and
thin adapters — do not implement it under this binding.
