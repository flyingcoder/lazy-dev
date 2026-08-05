# Agent Instructions

## Reasoning Discipline: Lambda Engine

Operate under the **Lambda Engine (Λ-Engine)** cognitive architecture for any
non-trivial reasoning task in this repo — bug investigation, design
decisions, ambiguous requirements, anything with real uncertainty. Skip it
for trivial one-line lookups.

Full spec: [`lambda-engine/CORE.md`](lambda-engine/CORE.md) — read it before
applying the discipline the first time. Quick summary:

1. Detect your phase state from your own hedge language (overconfident →
   seek a counter-view; hedged/uncertain → maintain it; stuck/looping →
   stabilize immediately).
2. Default to Mode 1 (stable problems). Escalate to Mode 2 / HALIRA only for
   foundational contradictions that survive repeated Mode 1 attempts.
3. Select operators from the 20-operator vocabulary matched to your state;
   alternate opening (exploratory) moves with closing (consolidating) ones.
4. Never skip adversarial self-check before committing to a conclusion.

## Default engineering workflow: OpenSpec SDD

For AI-assisted **behavior changes**, default to OpenSpec spec-driven
development (`/opsx:*` / `openspec` CLI). Λ-Engine guides *how to think*
inside that lifecycle — see
[`lambda-engine/OPENSPEC-BINDING.md`](lambda-engine/OPENSPEC-BINDING.md).

## Packaging (thin adapters)

| Tier | Where | Cost |
|------|--------|------|
| Always-on | This file, `CLAUDE.md`, one Cursor umbrella rule under `.cursor/rules/` | Tiny |
| On-demand | Shared skills (canonical `src/skills/`; discovered via `.cursor/skills` → `src/skills`; Claude via `.claude` → `.cursor`) | On trigger |
| Explicit | Workspace `/opsx:*`; skills; thin wrappers (`/halira`, `/detect-state`, `/mode`, `/operator-sequence`, `/debug`); cognitive-control sub-agents under `.cursor/agents/` → `src/agents/` | Invoked / isolated |

Canonical package sources for rules, skills, commands, and agents live under
`src/`. Cursor discovers them through `.cursor/<category>` symlinks; Claude
Code discovers the same tree through `.claude` → `.cursor` (no divergent
`claude/` copy). Always-apply budget: **≤2 thin stubs** (this repo uses
**exactly one** — `lambda-engine-operational.mdc`). OpenSpec stays in these
adapters + `OPENSPEC-BINDING.md` (no second always-on OpenSpec rule).

### Cognitive-control agents (context isolation)

Fixed roster — exactly three cognitive roles (not domain/operator specialists).
Each loads skills + `CORE.md`; prompts stay thin. Provenance:
`recursive-ai-framework/` (read-only); normative truth remains `CORE.md`.

| Agent | Spawn when | Stay in parent when |
|-------|------------|---------------------|
| `halira-investigator` | Foundational contradiction / repeated Mode 1 failure → Mode 2 HALIRA | Trivial lookups; short Mode 1 |
| `mode1-navigator` | Turn would load ≥2 operator-related skills or a long Mode 1 sequence | Light single-skill Mode 1 |
| `adversarial-reviewer` | Dedicated pre-commit adversarial pass before binding a non-trivial conclusion | Trivial claims; already-covered light checks |

Parent stays the thin orchestrator. Sub-agents return a structured handoff
(State / Mode / Operators / Dissipation? / Conclusion / OpenSpec follow-ups).
They guide *how to think* inside `/opsx:*` — they are not a parallel SDD surface.

Edit `CORE.md` when architecture changes — not these adapters.

For repo-level build/test instructions, see `README.md`.
