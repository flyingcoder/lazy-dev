# /git vs /commit Command Comparison

## Overview

Both commands analyze git changes and understand developer intent, but serve different purposes:

- **`/git`**: **Workflow Designer** - Analyzes, verifies, and designs complete git workflows
- **`/commit`**: **Code Historian** - Creates commits with deep understanding of developer motives

## Key Differences

| Aspect | `/git` Command | `/commit` Command |
|--------|---------------|-------------------|
| **Primary Purpose** | Design complete git workflows | Create commits with historical context |
| **Output** | Workflow recommendations | Actual git commits |
| **Focus** | Strategic planning | Tactical execution |
| **When to Use** | Before committing (planning) | When ready to commit (execution) |
| **Action** | Analyzes and recommends | Analyzes and executes |

## Feature Comparison

| Feature | `/git` | `/commit` |
|---------|--------|-----------|
| Change Analysis | ✅ Comprehensive | ✅ Motive-driven |
| File Integrity Verification | ✅ Full verification | ✅ Special files only |
| File Impact Analysis | ✅ Yes | ❌ No |
| File Significance | ✅ Yes | ❌ No |
| File Location Verification | ✅ Yes | ❌ No |
| Branching Strategy | ✅ Designs strategy | ✅ Detects/creates |
| Commit Strategy | ✅ Designs strategy | ✅ Executes commits |
| PR Strategy | ✅ Designs strategy | ❌ No |
| Workflow Integration | ✅ Complete workflow | ✅ Commits only |
| Special File Handling | ❌ No | ✅ Yes (markdown, tests) |
| Documentation Validation | ❌ No | ✅ Yes (via /librarian) |
| Actual Git Operations | ❌ No | ✅ Yes (creates commits) |

## Use Cases

### Use `/git` When:
- Planning workflow before committing
- Need file verification (integrity, impact, significance, location)
- Want branching/commit/PR strategy recommendations
- Need comprehensive analysis without execution

### Use `/commit` When:
- Ready to create actual commits
- Have markdown files needing validation
- Want commits with historical context
- Need quick commit workflow

## Recommended Workflow

1. **Make changes**
2. **`/git verify`** - Verify file integrity, purpose, impact
3. **`/git strategy`** - Design branching, commit, PR strategy
4. **Follow recommendations** - Create branch, organize changes
5. **`/commit`** - Create commits with historical context
6. **Use `/git pr strategy`** - Get PR description and reviewers

## Summary

- **`/git`** = Strategic Planner (designs workflows)
- **`/commit`** = Tactical Executor (creates commits)
- **Together**: Plan with `/git`, execute with `/commit`
