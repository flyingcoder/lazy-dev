# /branch Command - Intelligent Branch Detection & Creation

## Description

An intelligent git branch detection system that analyzes developer goals, motives, and tasks to automatically suggest and create appropriate branch names. Integrates with the `/commit` command's motive understanding to provide a seamless git workflow experience for teams.

## Usage

```bash
# Auto-detect branch from current work
/branch

# Suggest branch from explicit goal/motive
/branch goal: <developer goal>
/branch motive: <developer intent>
/branch task: <task description>

# Create and checkout suggested branch
/branch create
/branch create goal: <goal>

# Analyze current work and suggest branch
/branch analyze
/branch suggest

# Check existing branches for similar work
/branch check
/branch list similar

# Interactive mode - confirm before creating
/branch interactive
/branch interactive goal: <goal>
```

**Parameters:**

- `goal: <text>`: Developer's goal or objective
- `motive: <text>`: Developer's intent or motivation
- `task: <text>`: Task description or user story
- `create`: Create and checkout the suggested branch
- `analyze` or `suggest`: Show analysis without creating
- `check` or `list similar`: Check for existing similar branches
- `interactive`: Prompt for confirmation before creating
- `from: <base-branch>`: Create branch from specific base (default: main)
- `prefix: <prefix>`: Override branch prefix (feature, fix, refactor, etc.)

## What It Does

### Phase 1: Intent Analysis

1. **Extract Developer Intent:**
   - From explicit `goal:`, `motive:`, or `task:` parameters
   - From current git changes (unstaged/staged files)
   - From current branch name (if already on a branch)
   - From recent commit messages
   - From file patterns and changes

2. **Analyze Current Work:**
   - Scan unstaged and staged changes
   - Identify file types and patterns
   - Detect change categories (feature, fix, refactor, etc.)
   - Understand scope (frontend, backend, docs, etc.)
   - Map to project architecture

3. **Infer Branch Type:**
   - **feature**: New functionality, features, enhancements
   - **fix**: Bug fixes, error corrections
   - **refactor**: Code restructuring, improvements
   - **chore**: Maintenance, dependencies, config
   - **docs**: Documentation changes
   - **test**: Test additions/modifications
   - **perf**: Performance improvements
   - **ci**: CI/CD changes
   - **build**: Build system changes

### Phase 2: Branch Name Generation

4. **Generate Branch Name:**
   - Format: `{type}/{kebab-case-description}`
   - Extract key terms from goal/motive/task
   - Convert to kebab-case (lowercase with hyphens)
   - Remove common words (the, a, an, etc.)
   - Keep descriptive and concise (max 50 chars)
   - Ensure uniqueness (check existing branches)

5. **Branch Name Examples:**
   - Goal: "Implement user authentication" → `feature/user-authentication`
   - Motive: "Fix login bug" → `fix/login-bug`
   - Task: "Refactor API routes" → `refactor/api-routes`
   - Goal: "Add rate limiting" → `feature/rate-limiting`
   - Motive: "Update documentation" → `docs/update-readme`

### Phase 3: Branch Management

6. **Check Existing Branches:**
   - Search for similar branch names
   - Detect if work already exists
   - Suggest switching to existing branch
   - Warn about potential conflicts

7. **Create Branch (if `create` specified):**
   - Verify base branch exists
   - Check if branch name already exists
   - Create branch: `git checkout -b <branch-name>`
   - Optionally set upstream: `git push -u origin <branch-name>`
   - Provide feedback on creation

8. **Integration with /commit:**
   - Branch name informs commit motive inference
   - Commit command uses branch name for context
   - Seamless workflow: `/branch create` → work → `/commit`

## Implementation Steps

When `/branch` is invoked:

### Step 1: Gather Intent

1. **Extract Explicit Intent:**
   - If `goal:` provided: Use as primary intent
   - If `motive:` provided: Use as primary intent
   - If `task:` provided: Use as primary intent
   - Priority: goal > motive > task

2. **Infer from Current Work:**
   - Get git status: `git status --porcelain`
   - Analyze changed files
   - Detect patterns:
     - New files → feature
     - Error handling changes → fix
     - Code restructuring → refactor
     - Test files → test
     - Documentation → docs

3. **Infer from Current Branch:**
   - If already on a branch: Extract intent from branch name
   - Check if branch matches work
   - Suggest staying on current branch if appropriate

4. **Infer from Recent Commits:**
   - Analyze last 5-10 commits
   - Detect ongoing work patterns
   - Understand work trajectory

### Step 2: Analyze Work Context

5. **Categorize Changes:**
   - **Feature Detection:**
     - New files with functionality
     - New functions/methods/classes
     - New API endpoints
     - New components/modules
     - Keywords: "add", "new", "create", "implement"

   - **Fix Detection:**
     - Error handling changes
     - Bug corrections
     - Exception fixes
     - Validation improvements
     - Keywords: "fix", "bug", "error", "correct"

   - **Refactor Detection:**
     - Code restructuring
     - Renaming without behavior change
     - Code organization improvements
     - Pattern extraction
     - Keywords: "refactor", "extract", "move", "reorganize"

   - **Scope Detection:**
     - `apps/dashboard/` → frontend/dashboard
     - `apps/ai-services/` → backend/ai-services
     - `docs/` → documentation
     - `tests/` → testing
     - `infrastructure/` → infrastructure

6. **Extract Key Terms:**
   - From goal/motive/task text
   - From file paths and names
   - From change patterns
   - Convert to kebab-case
   - Remove stop words
   - Keep meaningful terms

### Step 3: Generate Branch Name

7. **Determine Branch Type:**
   - Analyze intent and changes
   - Select appropriate type (feature, fix, refactor, etc.)
   - Override with `prefix:` if provided

8. **Build Branch Name:**
   - Format: `{type}/{description}`
   - Description: Key terms in kebab-case
   - Max length: 50 characters
   - Ensure readability and descriptiveness

9. **Check Uniqueness:**
   - List existing branches: `git branch -a`
   - Check for exact matches
   - Check for similar names
   - Suggest alternatives if conflict

### Step 4: Branch Operations

10. **If `analyze` or `suggest`:**
    - Display analysis
    - Show suggested branch name
    - Explain reasoning
    - Show alternative suggestions

11. **If `check` or `list similar`:**
    - Search existing branches
    - Find similar names
    - Show matches
    - Suggest switching if appropriate

12. **If `create`:**
    - Verify base branch exists (default: main)
    - Check if branch already exists
    - Create branch: `git checkout -b <branch-name> [<base-branch>]`
    - Set upstream if remote exists: `git push -u origin <branch-name>`
    - Provide success feedback

13. **If `interactive`:**
    - Show suggested branch name
    - Explain reasoning
    - Ask for confirmation
    - Allow name modification
    - Create if confirmed

## Examples

### Basic Usage

```bash
# Auto-detect from current work
/branch

# Suggest from explicit goal
/branch goal: Implement user authentication system

# Create branch from motive
/branch create motive: Fix login bug

# Analyze and suggest
/branch analyze task: Refactor API routes for better organization
```

### Interactive Mode

```bash
# Interactive branch creation
/branch interactive goal: Add rate limiting to API

# Output:
# 🔍 Analyzing your work...
# 
# Intent: Add rate limiting to API
# Changes detected: API route modifications, middleware additions
# Suggested branch: feature/api-rate-limiting
# 
# Create this branch? [y/N]: y
# ✅ Created and checked out: feature/api-rate-limiting
```

### Check Existing Branches

```bash
# Check for similar work
/branch check goal: User authentication

# Output:
# 🔍 Checking existing branches...
# 
# Found similar branches:
# - feature/user-auth (created 2 days ago)
# - feature/authentication-system (created 1 week ago)
# 
# Consider switching to existing branch or use a more specific name.
```

### Integration with /commit

```bash
# Complete workflow
/branch create goal: Implement user authentication
# ✅ Created: feature/user-authentication

# ... make changes ...

/commit
# Uses branch name to infer motive: "Implement user authentication"
# Creates commits with appropriate messages
```

## Branch Naming Conventions

### Standard Prefixes

- `feature/` - New features, functionality
- `fix/` - Bug fixes, error corrections
- `refactor/` - Code restructuring
- `chore/` - Maintenance, dependencies
- `docs/` - Documentation changes
- `test/` - Test additions/modifications
- `perf/` - Performance improvements
- `ci/` - CI/CD changes
- `build/` - Build system changes

### Naming Rules

1. **Format**: `{type}/{kebab-case-description}`
2. **Length**: Max 50 characters
3. **Case**: Lowercase with hyphens
4. **Descriptive**: Clear about what the branch contains
5. **Unique**: No conflicts with existing branches

### Examples

- ✅ `feature/user-authentication`
- ✅ `fix/login-bug`
- ✅ `refactor/api-routes`
- ✅ `docs/update-readme`
- ✅ `test/add-auth-tests`
- ❌ `feature/user-auth-system-implementation` (too long)
- ❌ `Feature/UserAuth` (wrong case)
- ❌ `feature/user auth` (spaces not allowed)

## Integration Points

### With /commit Command

- Branch name informs commit motive inference
- `/commit` analyzes branch name for context
- Seamless workflow: branch → work → commit

### With Git Hooks

- Pre-commit hooks can validate branch names
- Post-checkout hooks can update context
- Branch creation triggers can notify team

### With Team Workflow

- Consistent branch naming across team
- Easy to identify work purpose
- Better code review organization
- Clearer git history

## Error Handling

- **No git repository**: Error with instructions
- **No changes detected**: Suggest explicit goal/motive
- **Branch already exists**: Suggest alternative or switch
- **Base branch missing**: Error with suggestions
- **Invalid branch name**: Suggest valid alternative
- **Git errors**: Show error messages, suggest solutions

## Smart Detection Rules

### Intent Inference

- **From Goal/Motive/Task:**
  - Extract key terms
  - Identify action verbs (implement, fix, add, etc.)
  - Detect scope (API, UI, docs, etc.)
  - Understand purpose

- **From File Changes:**
  - New files → feature
  - Error handling → fix
  - Restructuring → refactor
  - Tests → test
  - Documentation → docs

- **From Branch Name:**
  - Parse existing branch name
  - Extract type and description
  - Check if matches current work

### Branch Type Detection

- **Feature**: New functionality, enhancements
- **Fix**: Bug fixes, corrections
- **Refactor**: Code improvements, restructuring
- **Chore**: Maintenance, dependencies
- **Docs**: Documentation updates
- **Test**: Test additions
- **Perf**: Performance improvements
- **CI**: CI/CD changes
- **Build**: Build system changes

## Related

- Use `/commit` to commit changes with motive understanding
- Use `git status` to see current changes
- Use `git branch -a` to list all branches
- See conventional commits: https://www.conventionalcommits.org/
- See `.cursor/commands/commit.md` for commit command integration
