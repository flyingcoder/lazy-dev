# Lambda Engine Skills

Canonical package source: `src/skills/` (this directory). Repository
`.cursor/skills` is a symlink here for Cursor/Claude discovery;
`autopoetic init` copies these paths to consumer `.cursor/skills/`.

On-demand skills for Lambda Engine and Controlled Rupture Operators. Full
content lives here; Cursor always-on surface is a **single umbrella stub**
(`.cursor/rules/general/lambda-engine-operational.mdc`) plus thin
`AGENTS.md` / `CLAUDE.md` adapters. Duplicate Lambda `.mdc` bodies and
non-Λ always-on process rules have been **deleted** — load skills (or
OpenSpec) instead.

## Three-tier packaging

| Tier | Surface | When loaded |
|------|---------|-------------|
| Always-on | `AGENTS.md`, `CLAUDE.md`, one umbrella operational rule | Every turn (keep tiny) |
| On-demand | Skills in this directory | Description / task trigger |
| Explicit | Workspace `/opsx:*`; skills; Cursor `/halira`, `/detect-state`, `/mode`, `/operator-sequence`, `/debug`; cognitive-control sub-agents (`.cursor/agents/`) | User or agent invokes / isolates |

**Normative semantics:** `lambda-engine/CORE.md`

**OpenSpec engineering binding:** `lambda-engine/OPENSPEC-BINDING.md`

**Theoretical provenance:** workspace `recursive-ai-framework/` (Controlled
Rupture Compiler / 20-operator algebra, dissipation). Consult for fidelity;
do not treat it as the runtime source of truth — `CORE.md` + these skills are
normative. Do not edit that corpus from packaging changes.

### Cognitive-control agents (skill reuse under isolation)

Fixed roster under `.cursor/agents/` — thin prompts that **load skills below**,
not fork tables:

| Agent | Skills / CORE |
|-------|----------------|
| `halira-investigator` | `halira` + `CORE.md` |
| `mode1-navigator` | `state-detection`, `mode-operator-selection`, `operators-reference` (+ related) |
| `adversarial-reviewer` | `adversarial-collaboration` + `CORE.md` adversarial rules |

Spawn for heavy Mode 2, long Mode 1, or dedicated adversarial passes; keep
trivial / light Mode 1 in the parent. No per-domain or per-operator agents.

For behavior changes, default to OpenSpec SDD; use CRO selection to steer
thinking inside propose → apply → archive (see binding doc).

Retired always-on docs/git/memory/meta/hygiene rules are **not** replaced by
new always-apply stubs. Unique engineering process lives in OpenSpec + this
skill set. Prefer not committing one-off scratch scripts (`test-*.sh`,
`tmp/`, `scratch/`, files marked temporary).

## Skills

| Skill | When to use |
|-------|--------------|
| **lambda-engine-operational** | Operator selection, mode coordination, quick decision guide, situational cues, sequence optimization |
| **lambda-engine-formula** | Formula-driven operator/mode selection from core equation |
| **state-detection** | Detect J=0 / S* / ∅ and state-specific sequences |
| **mode-operator-selection** | Mode 1 vs Mode 2 operator sets, constraints, mode transitions |
| **operator-tools** | Tool selection (read_file, grep, etc.) per operator |
| **operators-reference** | 20-operator table, λ, constraints, dissipation trajectories |
| **halira** | Full 7-step HALIRA, step→operator mapping, Meta/Non constraints |
| **retro-operators** | Backward analysis patterns (Retroactive, Retroductive, etc.) |
| **forward-operators** | Telo (goals), Ana (improvement), sequences |
| **adversarial-collaboration** | Stress-test designs, evaluate prompts |
| **motive-grouped-commit** | Commit by motive: Λ + CRO analyze diffs, group files, why-led messages (propose-first) |

## Inventory note (post-migration)

- **Always-apply budget:** exactly one Cursor rule —
  `lambda-engine-operational.mdc` (points at CORE, skills, OpenSpec binding).
- **Discovery:** instruction tree is the dotted `.cursor/` path (Cursor-loadable).
  An undotted-only `cursor/` layout is a packaging defect; if a symlink probe
  flakes, keep `.cursor/` as the canonical tree.
- **Deleted:** non-Λ always-on process rules and duplicate optional Lambda
  `.mdc` bodies after merge into the skills above.
- **Cognitive-control agents:** shipped under `.cursor/agents/` —
  `halira-investigator`, `mode1-navigator`, `adversarial-reviewer`. Thin
  skill/CORE pointers; Mode 2 uses this **halira** skill inside
  `halira-investigator` (Explicit `/halira` spawns that agent).
- **Claude packaging:** `.claude` → `.cursor` so Claude Code loads this same
  skill tree (and Explicit wrappers / agents). Do not maintain a
  divergent undotted `claude/` catalog.

## Loading skills in Cursor

- **Project skills:** Cursor discovers skills under `.cursor/skills/` when the
  project instruction path is loadable.
- **User skills:** To make them available globally, copy each skill folder
  (e.g. `lambda-engine-operational/`) to `~/.cursor/skills-cursor/` so the
  agent can invoke them by name.

## Reference

Rollback deleted `.mdc` bodies from git history only if a skill merge missed
a unique constraint — prefer fixing the skill, not restoring always-apply.
