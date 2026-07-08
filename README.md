# Λ-Engine (Lambda Engine) — Cross-Tool Cognitive Architecture

A cognitive architecture that uses **Controlled Rupture Operators** to guide
AI-assisted development, providing adaptive problem-solving through two
operational modes and a 20-operator vocabulary. Instead of leaving an agent
to either overcommit to a first idea or spiral in open-ended uncertainty, the
Lambda Engine gives it a way to detect its own reasoning state and pick a
matched next move — stabilize, escalate, or attack — so contradictions become
fuel for a better answer instead of stalls.

The portable core works with **Codex, Claude Code, Cursor, Windsurf, and any
other AI agent**; Cursor additionally ships a native, fully-featured
implementation with 50+ commands and 60+ rules.

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
        │  (Codex, and │ │ + .claude/  │ │  (Windsurf)  │
        │  most agents)│ │ skills+cmds │ │              │
        └──────────────┘ └─────────────┘ └──────────────┘
                │
        ┌───────▼─────────────────────┐
        │  .cursor/  (native, predates │
        │  the portable spec: 50+     │
        │  commands, 60+ rules)       │
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
| Claude Code | [`CLAUDE.md`](CLAUDE.md) | Auto-imports `lambda-engine/CORE.md`; also ships skills/commands in [`.claude/`](.claude/) |
| Windsurf | [`.windsurfrules`](.windsurfrules) | Read by Cascade at repo root |
| Cursor | [`.cursor/rules/`](.cursor/rules/) | Native implementation, predates the portable spec — see [`docs/cursor-native-guide.md`](docs/cursor-native-guide.md) |

All adapters point to **[`lambda-engine/CORE.md`](lambda-engine/CORE.md)**,
the single source of truth for the architecture. Edit `CORE.md` when the
architecture changes — the adapters are thin pointers and shouldn't need to
change with it.

## Prerequisites

- Git
- One AI coding agent that can read a repo-root instructions file: [Cursor](https://cursor.com), [Claude Code](https://claude.com/claude-code), [Codex](https://openai.com/codex/), [Windsurf](https://windsurf.com), or any other agent that follows the `AGENTS.md` convention
- Python 3.9+ and `pip` — only needed to run the eval suite in [`evals/lambda-engine/`](evals/lambda-engine/)

## Installation

Clone the repo to use it as-is:

```bash
git clone https://github.com/flyingcoder/autopoetic-agent.git
cd autopoetic-agent
```

To adopt the architecture inside an **existing** project instead, copy the
core spec plus whichever adapter(s) match your tooling:

```bash
# Required: the portable core spec
cp -r lambda-engine <target-repo>/

# Pick the adapter(s) for your tool(s)
cp AGENTS.md <target-repo>/          # Codex / generic agents
cp CLAUDE.md <target-repo>/          # Claude Code
cp -r .claude <target-repo>/         # Claude Code skills + slash commands
cp .windsurfrules <target-repo>/     # Windsurf
cp -r .cursor <target-repo>/         # Cursor-native implementation (optional, large)
```

Then update the relative paths inside the copied adapter files if
`lambda-engine/` doesn't land at your target repo's root.

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
/goal define: Build user authentication system
/plan create: Implement authentication feature
/spec feature: User authentication with JWT tokens
/implement feature: User authentication with JWT
/commit
```

**In Claude Code**, the equivalent slash commands live in
[`.claude/commands/`](.claude/commands/) (backed by skills in
[`.claude/skills/`](.claude/skills/)):

```bash
/detect-state analyze: Need both performance and simplicity but they conflict
/halira contradiction: Need both consistency and scalability but they conflict
/attack design: Event sourcing + CQRS architecture
/retro active src/legacy/auth.ts
/lambda-commit
```

**In Codex, Windsurf, or any other agent**, no slash commands are needed —
the discipline is described in prose in `AGENTS.md` / `.windsurfrules` and
applies automatically once the agent reads its instructions file.

## Documentation

- [`docs/architecture.md`](docs/architecture.md) — the cognitive model: the productive-contradiction principle, phase-space states, the operator vocabulary, and dissipation tracking
- [`docs/cursor-native-guide.md`](docs/cursor-native-guide.md) — full Cursor-native command reference, rule catalogue, workflows, and examples
- [`lambda-engine/CORE.md`](lambda-engine/CORE.md) — the canonical, machine-facing spec that every adapter points to
- [`wiki/wiki/concepts/lambda-engine-cognitive-architecture.md`](wiki/wiki/concepts/lambda-engine-cognitive-architecture.md) — full narrative write-up and rationale
- [`evals/lambda-engine/`](evals/lambda-engine/) — DeepEval suite scoring transcripts against the architecture's hard constraints

## Contributing

- **Architecture changes** (states, modes, operators, dissipation rules, HALIRA): edit [`lambda-engine/CORE.md`](lambda-engine/CORE.md) only — every adapter points there, so changes propagate without touching adapter files.
- **New Cursor commands or rules**: add to `.cursor/commands/` or `.cursor/rules/<category>/` and update `.cursor/tuts/COMMANDS.md`; see [Contributing to the Cursor Implementation](docs/cursor-native-guide.md#contributing-to-the-cursor-implementation).
- **New Claude Code skills or commands**: add to `.claude/skills/<name>/SKILL.md` and `.claude/commands/<name>.md`.
- **Before submitting changes to `CORE.md`**: run the eval suite in `evals/lambda-engine/` to confirm the hard constraints (Meta max 2 consecutive, never `Non` after `Meta`, HALIRA step order, etc.) still hold.

## License

No `LICENSE` file is currently included in this repository. Treat the code
and content as all-rights-reserved until one is added; open an issue or PR
if you'd like a specific license applied.
