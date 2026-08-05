# Claude Code Instructions

## Reasoning Discipline: Lambda Engine

Operate under the **Lambda Engine (Λ-Engine)** cognitive architecture for any
non-trivial reasoning task in this repo. Skip it for trivial one-line
lookups.

@lambda-engine/CORE.md

OpenSpec SDD is the default engineering lifecycle for behavior changes;
Λ-Engine binds to it via @lambda-engine/OPENSPEC-BINDING.md.

See `AGENTS.md` for the cross-tool pointer and packaging tiers. On-demand
skills and thin slash wrappers live in the shared `.cursor/` tree; this
repo’s `.claude` is a symlink to `.cursor`, so `.claude/skills/` and
`.claude/commands/` resolve to the same files Cursor uses (e.g. `halira`,
`state-detection`, Explicit wrappers including `/debug`). Author skills once under `src/skills/` (discovered via `.cursor/skills` →
`src/skills`) — do not maintain a separate Claude-only catalog.
Workspace `/opsx:*` remains the sole SDD slash-command surface.

### Cognitive-control agents

Three project agents live under `src/agents/` (via `.cursor/agents` → `src/agents`, also `.claude/agents/`):
`halira-investigator` (Mode 2 / HALIRA), `mode1-navigator` (heavy Mode 1),
`adversarial-reviewer` (pre-commit adversarial). Spawn for heavy isolated
work; keep trivial / light Mode 1 in the parent. Each reuses skills +
`CORE.md`. Provenance: `recursive-ai-framework/` (read-only). Claude Code
may not treat Cursor agent files as native custom agents — follow the same
spawn heuristics in-session when a Claude-native mirror is unavailable.
