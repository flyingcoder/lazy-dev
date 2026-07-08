---
title: "Lambda Engine Topic Guide"
schema_state: advisory
created: 2026-07-08
updated: 2026-07-08
summary: "Human-owned topic guide for local vocabulary and conventions in the lambda-engine wiki."
---

# Lambda Engine Topic Guide

> This is not a database schema and it does not make existing wiki content invalid.

## State

- `schema_state`: `advisory`

## Entity Types

| Type | Meaning |
|------|---------|
| `concept` | A bounded idea or mechanism (e.g. an operator, a phase-space state, a mode). |
| `protocol` | A named multi-step procedure (e.g. HALIRA). |

## Relationship Verbs

- `cites`
- `supports`
- `contradicts`
- `supersedes`
- `depends-on`
- `implements`
- `generalizes` — an article describes a tool-agnostic version of a tool-bound source

## Source Conventions

Primary sources are local `.mdc` rule files and `SKILL.md` files extracted from
the `lazy-dev` repository's `.cursor/` directory. These are internal-tool
implementations of the architecture, not external publications — treat them as
`type: notes` in `raw/` and cite the specific file paths extracted from.
