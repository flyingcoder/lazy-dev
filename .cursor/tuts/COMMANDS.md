# Lambda Engine Command Quick Reference

Cursor exposes Explicit thin wrappers: four Mode/Λ entries plus `/debug`
orchestration. Operational behavior lives in skills, `lambda-engine/CORE.md`,
and cognitive/exploration agents where noted.

| Command | Routes to | Example |
|---|---|---|
| `/halira` | `halira-investigator` (loads `halira` + `CORE.md`) | `/halira <foundational contradiction>` |
| `/detect-state` | `state-detection` | `/detect-state <reasoning context>` |
| `/mode` | `mode-operator-selection` | `/mode <problem>` |
| `/operator-sequence` | `operators-reference` | `/operator-sequence <operators>` |
| `/debug` | `code-explorer` → `retro-operators` → optional `halira-investigator` → scored predictions | `/debug <symptom>` |

`/debug` pipeline: spawn `code-explorer` for tracing; apply `retro-operators`
(prefer Retroductive); spawn `halira-investigator` only if retro leaves a
foundational contradiction; emit ranked root-cause hypotheses with scores
(0–100) and evidence-backed reasons. Do not auto-fix from `/debug`.

Use workspace `/opsx:*` commands for spec-driven engineering. Use normal git
for repository operations. Retired project-local lifecycle, git/docs/meta,
and engineering-domain slash commands are intentionally unavailable.

Do not expand a wrapper with operator tables or workflow prose. Update the
matching skill (or agent prompt for `/halira`) instead.
