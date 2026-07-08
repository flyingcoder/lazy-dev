---
title: "Lambda Engine — Source Extraction from lazy-dev .cursor Rules"
source: "local repo: lazy-dev/.cursor/rules/ and .cursor/skills/"
type: notes
ingested: 2026-07-08
tags: [lambda-engine, cognitive-architecture, controlled-rupture-operators, cursor-rules, ai-agent-reasoning, halira-protocol, dissipation-calculus]
summary: "Extraction of the Lambda Engine (Λ-Engine) cognitive architecture — the physics-flavored core equation, phase-space states, two operating modes, 20 Controlled Rupture Operators, dissipation calculus, and the HALIRA 7-step protocol — as implemented in the lazy-dev repository's Cursor IDE rules and skills."
---

# Lambda Engine — Source Extraction from lazy-dev .cursor Rules

This note records the primary-source extraction used to compile
[Lambda Engine: A Controlled-Rupture Cognitive Architecture for AI Agents](../../wiki/concepts/lambda-engine-cognitive-architecture.md).
The `lazy-dev` repository ships a Cursor IDE rule/skill system called the
**Λ-Engine (Lambda Engine)** — see repo root `README.md` (git log:
`refactor(.cursor): slim always-on rules; add Lambda Engine skills`,
`docs: add core physics explanation before Quick Start`). It is implemented as
`alwaysApply: true` `.mdc` rule files plus companion `SKILL.md` reference files
that Cursor loads on demand.

## Files Extracted

- `.cursor/rules/general/lambda-engine-core-integrated.mdc` — identity statement, core
  equation, pointer to the `lambda-engine-formula` skill.
- `.cursor/rules/general/lambda-operators-unified.mdc` — unified identity: "You operate
  as a Λ-Engine controlled by Controlled Rupture Operators"; Mode 1 vs Mode 2 summary.
- `.cursor/skills/lambda-engine-formula/SKILL.md` — the core equation
  `∂Ξ/∂t = ∫ (S↔Λ) × [⧉(ΔS○¬ΔΛ) – ∇τ] dV`, formula-to-operator mapping, formula-to-mode
  selection (J=0 vs J'≠0), trajectory formulas.
- `.cursor/skills/lambda-engine-operational/SKILL.md` — operational quick-decision guide,
  four operational workflows, state-specific actions, critical rules (never Non after Meta,
  always adversarial-check before acceptance).
- `.cursor/rules/general/operators-reference.mdc` and
  `.cursor/rules/general/dissipation-lookup.mdc` — full operator table (20 operators, 4
  classes, symbol/λ/idempotence), pairwise and effective dissipation formulas, half-life
  formula, pre-calculated sequences, forbidden sequences.
- `.cursor/skills/state-detection/SKILL.md` — phase-space state indicators (J=0 / S* / ∅)
  derived from linguistic hedge markers, and state-transition sequences.
- `.cursor/skills/mode-operator-selection/SKILL.md` — Mode 1 (Duality Navigation) vs Mode 2
  (HALIRA) operator sets, escalation criteria, constraints.
- `.cursor/skills/halira/SKILL.md` — full 7-step HALIRA Protocol (Potentia, Boundary,
  Recursion, Integration, Anomaly, Rupture, Recognition) with per-step operator, λ, and
  trajectory; the Meta/Non constraint and its resolution options.
- `.cursor/skills/operator-tools/SKILL.md` — per-operator Cursor tool bindings
  (read_file, grep, codebase_search, search_replace, write, etc.) — this layer is
  **Cursor-specific** and is intentionally *not* carried into the generalized wiki
  article; only the underlying cognitive-move categories are.
- `README.md` (repo root) — "Core Physics: Law of Self-Creation" narrative explanation
  of the equation and productive contradiction, plus the full command/operator catalogue
  used to drive Cursor slash commands.

## What Was Generalized vs. Dropped

The compiled article keeps: the core equation and its interpretation as a design
metaphor, the three phase-space states and their linguistic self-diagnosis cues, the
two-mode structure, the 20-operator vocabulary with symbols/λ values/descriptions
(reframed as generic cognitive moves rather than Cursor actions), the dissipation
calculus and its interpretation thresholds, the hard constraints/forbidden sequences,
and the full HALIRA protocol.

The compiled article drops or generalizes: all references to specific Cursor tool
names (`read_file`, `grep`, `codebase_search`, `search_replace`, `write`,
`run_terminal_cmd`, `todo_write`, `read_lints`, `delete_file`, `list_dir`,
`glob_file_search`) and all references to Cursor slash commands (`/goal`, `/plan`,
`/spec`, `/halira`, `/commit`, `/librarian`, etc.), since those are implementation
details of one IDE integration, not part of the underlying cognitive architecture.
