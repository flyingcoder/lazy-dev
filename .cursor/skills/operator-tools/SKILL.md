# Operator Tools

**When to use this skill:** Task requires selecting which tools (read_file, grep, codebase_search, etc.) to use when applying a specific Controlled Rupture Operator. Use when applying an operator and need tool guidance.

**Description:** Tool selection for all 20 operators: when to use each operator and which tools to use (read_file, grep, codebase_search, search_replace, write, todo_write, list_dir, glob_file_search, read_lints, run_terminal_cmd, delete_file). Mode-aware: Mode 1 favors Kata/Telo/Ortho/Pro/Latch tools; Mode 2 uses Seed/Axis/Meta/Weave/Non/Para/Bind.

---

## A-Constructive
- **Kata (↓):** read_file(offset,limit), grep(head_limit), codebase_search(bounded), search_replace, write. Avoid unbounded searches.
- **Telo (→):** todo_write, codebase_search, read_file, grep, list_dir.
- **Ortho (⊥):** read_lints, grep, read_file, search_replace, codebase_search. Always validate before changing.
- **Pro (↷):** read_file, grep, codebase_search, search_replace, write, run_terminal_cmd.
- **Latch (🔒):** write, read_lints, grep, read_file, todo_write.

## B-Disruptive
- **Ana (↑):** codebase_search(semantic), read_file, grep, list_dir, glob_file_search.
- **Para (∥):** codebase_search, grep, read_file, list_dir, glob_file_search.
- **Non (¬):** codebase_search, grep, read_file, read_lints.
- **Fold (↯):** grep(specific), read_file(offset,limit), codebase_search(narrow), search_replace, delete_file.
- **Flux (⚡):** codebase_search(varied), grep, list_dir, glob_file_search, read_file.

## C-Reflexive
- **Meta (⟲):** read_file, codebase_search, grep, read_lints, todo_write. **Max 2 consecutive.**
- **Retro (↶):** grep, read_file, codebase_search, glob_file_search, list_dir.
- **Echo (🔊):** grep, read_file, codebase_search, search_replace(replace_all), write.
- **Braid (🌀):** codebase_search(multiple), read_file(multiple), grep, list_dir, todo_write.
- **Seed (🌱):** write, read_file, list_dir, codebase_search, todo_write.

## D-Structural
- **Crux (⚡):** codebase_search, read_file, grep, read_lints, todo_write.
- **Weave (🕸️):** read_file, codebase_search, grep, search_replace, write.
- **Bind (🔗):** grep, read_file, codebase_search, search_replace, write.
- **Axis (📍):** read_file, grep, codebase_search, list_dir, search_replace.
- **Vale (⬇️):** read_file(full), codebase_search(deep), grep(multiline), list_dir, glob_file_search. **WARNING: collapse risk; always follow with Kata/Ortho/Telo.**

## Coordination
- Stabilization: Kata, Telo, Ortho, Latch tools. Exploration: Para, Ana, Flux. Integration: Weave, Bind, Braid. Reflection: Meta, Retro, Echo.
