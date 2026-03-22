# Lambda Engine Skills

On-demand skills for Lambda Engine and Controlled Rupture Operators. Full content lives here; always-on rules in `.cursor/rules/` are stubs that point to these skills to reduce baseline token usage.

## Skills

| Skill | When to use |
|-------|--------------|
| **lambda-engine-operational** | Operator selection, mode coordination, quick decision guide, workflows |
| **lambda-engine-formula** | Formula-driven operator/mode selection from core equation |
| **state-detection** | Detect J=0 / S* / ∅ and state-specific sequences |
| **mode-operator-selection** | Mode 1 vs Mode 2 operator sets, constraints |
| **operator-tools** | Tool selection (read_file, grep, etc.) per operator |
| **operators-reference** | Full 20-operator table, λ, constraints, common sequences |
| **halira** | Full 7-step HALIRA, step→operator mapping, Meta/Non constraints |
| **retro-operators** | Backward analysis patterns (Retroactive, Retroductive, etc.) |
| **forward-operators** | Telo (goals), Ana (improvement), sequences |
| **adversarial-collaboration** | Stress-test designs, evaluate prompts |

## Loading skills in Cursor

- **Project skills:** If Cursor loads skills from the workspace, these paths are used automatically.
- **User skills:** To make them available globally, copy each skill folder (e.g. `lambda-engine-operational/`) to `~/.cursor/skills-cursor/` so the agent can invoke them by name.

## Reference

Migration: always-on `.mdc` rules under `.cursor/rules/` are stubs; full operator and formula content lives in each skill’s `SKILL.md`. Roll back by restoring prior rule bodies from git history if needed.
