# Motive-Grouped Commit

**When to use this skill:** User asks to commit, split commits, group changes by intent/motive, or prepare a multi-commit plan from a dirty working tree. Prefer this over path-only clustering or a single mixed commit.

**Description:** Partition git changes into motive-coherent commit groups using Λ-Engine phase/mode selection and a short Controlled Rupture Operator (CRO) map. Propose why-led messages; execute only when authorized. Normative operator semantics: `lambda-engine/CORE.md`. Load `operators-reference`, `state-detection`, `retro-operators`, or `forward-operators` only if operator detail is needed — do not paste full tables into proposals.

---

## Procedure

1. **Gather evidence** (parallel): `git status`, staged + unstaged `git diff`, recent `git log` (match message style).
2. **Detect phase** on the *grouping* problem (J=0 / S* / ∅) — see CORE / `state-detection`.
3. **Mode:** Mode 1 by default. Escalate to Mode 2 / HALIRA only if the working tree is foundationally contradictory (rare for commits).
4. **Per path / hunk — identify motive** with this CRO map (CORE names only):

| Step | CRO | Role |
|------|-----|------|
| Outcome → intent | Retro↶ | Why does this diff exist? |
| Goal check | Telo→ | What goal does it serve? |
| Label | Kata↓ | Compress to a short motive label |
| Boundary | Crux⚡ | Where must groups split? |
| Attack mix | Non¬ | Would this group hide a second motive? |
| Style | Ortho⊥ | Match repo `git log` tone/granularity |
| Lock | Weave🕸️ → Bind🔗 | Synthesize groups; lock the plan |

Prefer the **coarsest** motive that stays coherent (Ortho against recent log). Respect CORE hard constraints (e.g. Meta max 2 consecutive). Do not invent operators outside CORE.

5. **Partition** into motive groups. Flag mixed-motive files for split staging (`git add -p` / path filters) or document the mix if unsafe to split.
6. **Draft** one why-led message per group (see Output). Do not claim tests/docs/refactors absent from that group's diff.
7. **Propose** the plan. **Do not commit** unless the user already authorized executing commits in this request. When executing: one group at a time (stage → commit → next).

## Safety

- Commit only when the user requested commits; never update git config; never force-push; never skip hooks unless explicitly asked; never use interactive git flags (`-i`).
- Exclude secrets / credentials (e.g. `.env`, `credentials.json`) from groups and warn.
- Pass commit messages via HEREDOC; after commits, verify with `git status`.
- Optional: spawn `adversarial-reviewer` on the proposal only if the user asks for a pre-commit attack — not required for routine commits.
- **Not this skill:** restoring a fat `/commit` or `lambda-commit` slash command; auto-push; amend/rebase workflows.

## Output Format

```text
Motive groups:
  1. <motive-label> — CRO: Retro, Telo, Kata, …
     files: <paths>
     message: <why-led subject; optional body>
  2. …
Safety notes: <secrets excluded | mixed-motive flags | none>
Next: propose-only | execute (authorized)
```

When executing a group:

```bash
git add -- <paths-for-group>
git commit -m "$(cat <<'EOF'
<message>

EOF
)"
```
