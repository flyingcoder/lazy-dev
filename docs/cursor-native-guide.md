# Cursor-Native Implementation Guide

Cursor discovers this project through `.cursor/`. Canonical package sources
for distributable instruction assets live under `src/{skills,commands,rules,agents}`;
in this repository `.cursor/<category>` symlinks to `../src/<category>`. The
instruction surface is skills-first:

- one thin always-on Lambda umbrella rule;
- on-demand operational skills under `.cursor/skills/` → `src/skills/`;
- workspace OpenSpec `/opsx:*` commands for spec-driven development;
- Explicit thin wrappers under `.cursor/commands/` → `src/commands/`
  (four Mode/Λ wrappers plus `/debug` orchestration).

Normative runtime semantics live in
[`lambda-engine/CORE.md`](../lambda-engine/CORE.md). Theoretical provenance
lives in the workspace
[`recursive-ai-framework`](../../recursive-ai-framework/) corpus; it is
reference material, not a second runtime specification.

## Explicit entry points

| Wrapper | Routes to |
|---|---|
| `/halira` | `halira-investigator` (loads `halira` skill + `CORE.md`) |
| `/detect-state` | `state-detection` skill (in-parent) |
| `/mode` | `mode-operator-selection` skill (in-parent) |
| `/operator-sequence` | `operators-reference` skill (in-parent) |
| `/debug` | Pipeline: `code-explorer` → `retro-operators` → optional `halira-investigator` → scored predictions |

`/halira` spawns the project sub-agent; Mode-1 wrappers apply their skills
in-parent. `/debug` is a thin orchestrator: trace with `code-explorer`, analyze
with `retro-operators` (prefer Retroductive), spawn `halira-investigator` only
for foundational ruptures, then emit ranked root-cause predictions (score
0–100 + evidence-backed reasons). Operator tables, sequence constraints, and
HALIRA steps do not belong in command files.

For behavior changes, use workspace `/opsx:*` or the equivalent OpenSpec
skills. Project-local `/spec`, `/plan`, `/implement`, `/scope`, `/status`,
`/scaffold`, `/review`, `/refactor`, and `/eval` are intentionally absent.
Project-local git/docs/meta commands are also retired; use normal git and
OpenSpec artifacts. `/debug` diagnoses and predicts; it does not auto-fix.

## Examples

```text
/detect-state Need both performance and simplicity
/mode Is this contradiction foundational?
/operator-sequence Seed → Weave → Ortho
/halira A foundational contradiction survived repeated Mode 1 attempts
/debug Login fails with 500 after password reset
```

## Packaging constraints

- Keep command files thin and keep operational detail in skills (and agent
  prompts for cognitive-control isolation).
- The approved Explicit set is the four Mode/Λ wrappers plus `/debug`; do not
  add further wrappers without a new OpenSpec change.
- Claude Code discovers the same command tree via `.claude` → `.cursor`.
- Do not recreate engineering-domain commands or per-domain sub-agents.
- Mode 2 isolation ships as `halira-investigator` under `.cursor/agents/`
  (canonical `src/agents/`); `/halira` is its Explicit spawn entry.
- `code-explorer` is a non-cognitive exploration agent required by `/debug`
  and ships in the default portable agent set.

See [the command quick reference](../.cursor/tuts/COMMANDS.md) and
[`lambda-engine/OPENSPEC-BINDING.md`](../lambda-engine/OPENSPEC-BINDING.md).

## Contributing to the Cursor implementation

Edit skills, commands, rules, and agents under `src/`, not a duplicated
`.cursor/` copy. Improve existing skills when operational guidance is missing.
Architecture changes belong in `lambda-engine/CORE.md`; SDD workflow changes
belong in OpenSpec. Keep the fixed wrapper set unchanged unless an approved
OpenSpec change revises the Explicit-tier contract. On Windows checkouts that
flatten symlinks, recreate `.cursor/{skills,commands,rules,agents}` →
`../src/<category>` and `.claude` → `.cursor`.
