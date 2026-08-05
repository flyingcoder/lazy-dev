---
description: Debug a symptom via trace → retro → optional HALIRA → scored root-cause predictions
---

Orchestrate a debug pipeline for: $ARGUMENTS

Keep this session thin — spawn/delegate; do not paste operator tables, HALIRA
steps, or agent system prompts. Do not implement code fixes or create OpenSpec
artifacts as part of this command.

## Pipeline (in order)

1. **Trace** — Spawn `code-explorer` (`.cursor/agents/code-explorer` /
   `src/agents/`) scoped to the symptom. Ask for execution-path tracing and its
   standard handoff (paths, symbols, gaps).

2. **Retro** — Apply the `retro-operators` skill to the explorer handoff.
   Prefer **Retroductive** (symptom → root cause). Produce the skill’s output
   format (operation, target, backward chain, conclusion).

3. **HALIRA (conditional)** — If and only if the retro analysis leaves a
   foundational contradiction or Mode-1-unresolved rupture, spawn
   `halira-investigator` with the retro findings + original symptom. Otherwise
   skip Mode 2. Expect the investigator’s return contract.

4. **Predict** — Emit a technical prediction report. Do not patch code here;
   optionally suggest `/opsx:propose` or `/opsx:update` as a follow-up.

## Technical prediction (required)

Rank hypotheses by score descending. Each entry MUST include:

- **Root cause:** short technical statement
- **Score:** 0–100 confidence
- **Reasons:** evidence from explorer paths/symbols, retro backward chain,
  and HALIRA conclusion when stage 3 ran
- **Gaps:** label unknowns; do not over-score weak evidence
