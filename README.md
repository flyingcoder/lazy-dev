# Λ-Engine (Lambda Engine) — Cross-Tool Cognitive Architecture

A cognitive architecture that uses **Controlled Rupture Operators** to guide
AI-assisted development, providing adaptive problem-solving through two
operational modes and a 20-operator vocabulary. Instead of leaving an agent
to either overcommit to a first idea or spiral in open-ended uncertainty, the
Lambda Engine gives it a way to detect its own reasoning state and pick a
matched next move — stabilize, escalate, or attack — so contradictions become
fuel for a better answer instead of stalls.

The portable core works with **Codex, Claude Code, Cursor, Windsurf, and any
other AI agent**. Cursor ships on-demand skills plus thin Explicit-tier
command wrappers; always-on Lambda surface is a **single** umbrella stub under
the discoverable [`.cursor/`](.cursor/) tree. Default engineering lifecycle for
behavior changes: **OpenSpec SDD** — see
[`lambda-engine/OPENSPEC-BINDING.md`](lambda-engine/OPENSPEC-BINDING.md).

**Provenance:** theoretical Controlled Rupture / Λ-Engine materials live in the
workspace [`recursive-ai-framework`](../recursive-ai-framework/) corpus.
**Runtime norm** for this project remains
[`lambda-engine/CORE.md`](lambda-engine/CORE.md) plus skills under
[`src/skills/`](src/skills/) (discovered via `.cursor/skills` → `src/skills`) —
do not rewrite the theoretical corpus to change agent behavior.

## Visual Preview

```
┌─────────────────────────────────────────────────────────────┐
│                    lambda-engine/CORE.md                     │
│   (single source of truth: states, modes, 20 operators,      │
│    dissipation tracking, forbidden sequences, HALIRA)        │
└───────────────┬───────────────┬───────────────┬──────────────┘
                │               │               │
        ┌───────▼──────┐ ┌──────▼──────┐ ┌──────▼───────┐
        │  AGENTS.md   │ │ CLAUDE.md   │ │.windsurfrules│
        │  (Codex, and │ │ (Claude     │ │  (Windsurf)  │
        │  most agents)│ │  adapter)   │ │              │
        └──────────────┘ └──────┬──────┘ └──────────────┘
                │               │
                │               │  .claude → .cursor
                │               ▼
        ┌───────▼─────────────────────┐
        │  .cursor/  (discovery tree: │
        │  skills/cmds/rules/agents   │
        │  → ../src/<cat>; Claude via │
        │  .claude → .cursor)         │
        └──────────────┬───────────────┘
                       │
        ┌──────────────▼───────────────┐
        │  src/{skills,commands,rules, │
        │  agents}  (canonical package │
        │  sources for autopoetic init)│
        └──────────────────────────────┘
```

## Table of Contents

- [Cross-Tool Support](#cross-tool-support)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Cross-Tool Support

| Tool | Entry point | Notes |
|---|---|---|
| Codex (and most other agents) | [`AGENTS.md`](AGENTS.md) | Universal fallback convention |
| Claude Code | [`CLAUDE.md`](CLAUDE.md) | Auto-imports `lambda-engine/CORE.md`; skills/commands via [`.claude`](.claude/) → [`.cursor/`](.cursor/) |
| Windsurf | [`.windsurfrules`](.windsurfrules) | Read by Cascade at repo root |
| Cursor | [`.cursor/rules/`](.cursor/rules/) + [`.cursor/skills/`](.cursor/skills/) | Discovery via `.cursor/` (symlinked to [`src/`](src/)); **one** always-on umbrella stub + on-demand skills; see [`docs/cursor-native-guide.md`](docs/cursor-native-guide.md) |

All adapters point to **[`lambda-engine/CORE.md`](lambda-engine/CORE.md)**,
the single source of truth for the architecture. Edit `CORE.md` when the
architecture changes — the adapters are thin pointers and shouldn't need to
change with it. Non-Λ always-on process rules (docs/git/memory/meta hygiene)
were retired; use OpenSpec SDD + skills instead. Prefer not committing
one-off scratch scripts (`test-*.sh`, `tmp/`, `scratch/`). Cognitive-control
sub-agents ship under [`.cursor/agents/`](.cursor/agents/); Mode 2 also uses
the `halira` skill + CORE.

### Future: delivery-pipeline cognitive control

Near-term control plane is Λ-Engine + OpenSpec SDD
([`OPENSPEC-BINDING.md`](lambda-engine/OPENSPEC-BINDING.md)). A later
project-engineering delivery pipeline may reuse the same CORE and adapters;
that pipeline is **not** implemented in this repo yet.

## Prerequisites

- Git
- One AI coding agent that can read a repo-root instructions file: [Cursor](https://cursor.com), [Claude Code](https://claude.com/claude-code), [Codex](https://openai.com/codex/), [Windsurf](https://windsurf.com), or any other agent that follows the `AGENTS.md` convention
- Python 3.9+ and `pip` — only needed to run the eval suite in [`evals/lambda-engine/`](evals/lambda-engine/)

## Installation

There are two distinct steps:

1. **Machine install** — put the `autopoetic` CLI on your PATH.
2. **Project init** — copy the portable Λ surface into a target repo (`autopoetic init`).

### 1. Machine install (CLI on PATH)

Clone the repo, then install the CLI (preferred):

```bash
git clone https://github.com/flyingcoder/autopoetic-agent.git
cd autopoetic-agent
./bin/autopoetic install
```

Defaults:

- Prefix: `~/.local` → launcher at `~/.local/bin/autopoetic`, package data at `~/.local/share/autopoetic/`
- Self-contained copy (survives moving/deleting the checkout)

Options:

```bash
./bin/autopoetic install --prefix /opt/autopoetic   # custom prefix (bin + share under it)
./bin/autopoetic install --link                    # link to this checkout (dev / editable)
./bin/autopoetic uninstall                         # remove launcher + share from the prefix
./bin/autopoetic uninstall --prefix /opt/autopoetic
```

If the install prints a PATH warning, add the bin dir:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Optional Python packaging escape hatch (from the checkout): `pip install -e .` — still prefer `./bin/autopoetic install` for a self-contained machine copy of the portable assets.

### 2. Project init (adopt into a target repo)

The portable set is defined by [`config.yaml`](config.yaml) (schema
`autopoetic-portable/v2`). Distributable skills, commands, rules, and agents
live under [`src/`](src/) and install to `.cursor/` in the target. Use the
installer — do not hardcode path lists outside that manifest:

```bash
# After machine install (from any directory):
autopoetic init /path/to/target-repo                  # profile: full (default)
autopoetic init /path/to/target-repo --profile lambda-only
autopoetic init /path/to/target-repo --profile core-only
autopoetic init /path/to/target-repo --include tuts

# Or from a checkout without machine install:
./bin/autopoetic init /path/to/target-repo
```

- **`full`** — Λ adapters, Explicit wrappers (including `/debug`), skills,
  cognitive-control agents + `code-explorer`, then stock `openspec init`
  (Cursor tools; Claude discovers the same tree via `.claude` → `.cursor`),
  plus the symlink itself.
- **`lambda-only`** — same Λ surface, no OpenSpec init.
- **`core-only`** — `lambda-engine/` + thin adapters only (no skills/commands/agents).

`/opsx:*` commands stay **stock OpenSpec** — this installer never rewrites them.
Λ binds via the copied adapters, skills, agents, and
[`lambda-engine/OPENSPEC-BINDING.md`](lambda-engine/OPENSPEC-BINDING.md).

Optional bundles (`tuts`, `hooks`) stay off unless you pass `--include`.
`code-explorer` ships in the default agent set (required by `/debug`). Wiki,
evals, and worktrees metadata are hard-excluded.

### Manual `cp` fallback

If you cannot run the CLI, copy each `source` → `destination` pair listed in
`config.yaml` yourself (keep the set in sync with that file):

```bash
# Required core (see config.yaml → core.required)
cp -r lambda-engine <target-repo>/
cp AGENTS.md CLAUDE.md <target-repo>/

# Instruction assets: copy from src/ to the .cursor/ destinations in config.yaml
# (do not copy src/ into the consumer; Cursor discovers .cursor/ only)
mkdir -p <target-repo>/.cursor/{rules/general,commands,skills,agents}
# …then copy each listed source → destination from config.yaml…

ln -s .cursor <target-repo>/.claude   # do not install a second Claude tree
```

Then update relative paths inside adapters if `lambda-engine/` is not at the
target root. On Windows or checkouts that flatten symlinks, recreate
`.claude` → `.cursor` and the `.cursor/{skills,commands,rules,agents}` →
`../src/<cat>` links after clone (this package's discovery layout).

To run the DeepEval suite that verifies the architecture's hard constraints:

```bash
cd evals/lambda-engine
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Usage

Once an adapter is in place, your agent applies the discipline automatically
on any non-trivial reasoning task — bug investigation, design decisions,
ambiguous requirements. It:

1. Detects its own phase-space state (overconfident, productively uncertain, or stuck) from its own hedge language
2. Defaults to **Mode 1** (stable problems) or escalates to **Mode 2 / HALIRA** for foundational contradictions
3. Selects operators from the 20-operator vocabulary matched to that state
4. Adversarially checks a conclusion before committing to it

**In Cursor**, type `/` in chat to drive this explicitly:

```bash
/detect-state Need both performance and simplicity
/mode Need both consistency and scalability
/operator-sequence Seed → Weave → Ortho
/halira Foundational contradiction that survived Mode 1
/debug Login fails with 500 after password reset
```

For behavior changes, use workspace OpenSpec `/opsx:*` commands. Normal git
replaces the retired project-local git/docs commands.

**In Claude Code**, the same Explicit wrappers are available through the
shared `.claude` → `.cursor` tree (skills load on trigger):

```bash
/detect-state Need both performance and simplicity
/mode Need both consistency and scalability
/operator-sequence Seed → Weave → Ortho
/halira Foundational contradiction that survived Mode 1
/debug Login fails with 500 after password reset
```

**In Codex, Windsurf, or any other agent**, no slash commands are needed —
the discipline is described in prose in `AGENTS.md` / `.windsurfrules` and
applies automatically once the agent reads its instructions file.

## Documentation

- [`docs/architecture.md`](docs/architecture.md) — the cognitive model: the productive-contradiction principle, phase-space states, the operator vocabulary, and dissipation tracking
- [`docs/cursor-native-guide.md`](docs/cursor-native-guide.md) — skills-first Cursor packaging and Explicit wrapper reference
- [`lambda-engine/CORE.md`](lambda-engine/CORE.md) — the canonical, machine-facing spec that every adapter points to
- [`wiki/wiki/concepts/lambda-engine-cognitive-architecture.md`](wiki/wiki/concepts/lambda-engine-cognitive-architecture.md) — full narrative write-up and rationale
- [`evals/lambda-engine/`](evals/lambda-engine/) — DeepEval suite scoring transcripts against the architecture's hard constraints

## Contributing

- **Architecture changes** (states, modes, operators, dissipation rules, HALIRA): edit [`lambda-engine/CORE.md`](lambda-engine/CORE.md) only — every adapter points there, so changes propagate without touching adapter files.
- **Canonical instruction sources:** edit under [`src/skills/`](src/skills/), [`src/commands/`](src/commands/), [`src/rules/`](src/rules/), and [`src/agents/`](src/agents/). Repository `.cursor/<category>` paths are symlinks to those directories for Cursor/Claude discovery — do not maintain a second copy.
- **New skills:** add under `src/skills/<name>/SKILL.md`, update `src/skills/README.md`, and list the path in [`config.yaml`](config.yaml). Claude picks them up via `.claude` → `.cursor` → `src`. Keep always-apply at the single umbrella stub; do not reintroduce fat always-on process rules or a divergent `claude/` tree.
- **Commands:** keep Explicit wrappers thin under `src/commands/` (Mode/Λ wrappers + `/debug`). Put operational detail in skills; use workspace `/opsx:*` for SDD.
- **Installer changes:** update [`bin/autopoetic`](bin/autopoetic) + `config.yaml` together; run `python3 -m pytest tests/test_autopoetic_init.py`.
- **Before submitting changes to `CORE.md`**: run the eval suite in `evals/lambda-engine/` to confirm the hard constraints (Meta max 2 consecutive, never `Non` immediately after `Meta`, HALIRA step order, etc.) still hold.

## License

No `LICENSE` file is currently included in this repository. Treat the code
and content as all-rights-reserved until one is added; open an issue or PR
if you'd like a specific license applied.
