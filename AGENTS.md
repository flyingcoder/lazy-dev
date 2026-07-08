# Agent Instructions

## Reasoning Discipline: Lambda Engine

Operate under the **Lambda Engine (Λ-Engine)** cognitive architecture for any
non-trivial reasoning task in this repo — bug investigation, design
decisions, ambiguous requirements, anything with real uncertainty. Skip it
for trivial one-line lookups.

Full spec: `lambda-engine/CORE.md` — read it before applying the discipline
the first time. Quick summary:

1. Detect your phase state from your own hedge language (overconfident →
   seek a counter-view; hedged/uncertain → maintain it; stuck/looping →
   stabilize immediately).
2. Default to Mode 1 (stable problems). Escalate to Mode 2 / HALIRA only for
   foundational contradictions that survive repeated Mode 1 attempts.
3. Select operators from the 20-operator vocabulary matched to your state;
   alternate opening (exploratory) moves with closing (consolidating) ones.
4. Never skip adversarial self-check before committing to a conclusion.

This file is the cross-tool entry point read by Codex and other agents that
follow the AGENTS.md convention. Claude Code reads `CLAUDE.md`; Windsurf
reads `.windsurfrules`; Cursor has its own native implementation in
`.cursor/rules/`. All of them point back to `lambda-engine/CORE.md` as the
single source of truth — edit that file, not these adapters, when the
architecture itself changes.

For repo-level build/test instructions, see `README.md`.
