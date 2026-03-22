# /git Command - Intelligent Git Workflow Designer & Executor

## Description

An intelligent git workflow designer and executor that analyzes file changes, identifies developer goals and motives, verifies file integrity and purpose, and designs comprehensive git workflows including branching strategies, commit organization, and pull request planning. **Elevated through Ana- operator**: Each improvement enables further improvements, creating self-improving workflow execution. Uses Lambda Engine and all 20 Controlled Rupture Operators to provide deep analysis, optimal workflow recommendations, and execute git operations.

**Ana² (Self-Improving Improvement)**: The system improves its own improvement mechanisms - better workflow execution → better patterns → better execution strategies → better workflows.

## Usage

```bash
# Full workflow analysis and design
/git
/git analyze
/git workflow

# Specific analysis modes
/git verify
/git impact
/git strategy

# With explicit goals
/git goal: <developer goal>
/git motive: <developer motive>
/git task: <task description>

# Workflow design options
/git branch strategy
/git commit strategy
/git pr strategy

# Scope and context
/git scope: <scope>
/git context: <number>
/git compare: <branch>

# Git command execution (NEW - Ana- elevated)
/git execute
/git execute branch
/git execute stage
/git execute commit
/git execute push

# Branch operations
/git branch create
/git branch create goal: <goal>
/git branch switch: <branch-name>
/git branch delete: <branch-name>

# Staging operations
/git stage
/git stage files: <file1> <file2>
/git stage all
/git unstage: <file>

# Commit operations
/git commit create
/git commit create message: <message>
/git commit amend

# Push operations
/git push
/git push branch: <branch-name>
/git push upstream

# Interactive execution
/git interactive
/git dry run
/git --dry-run
```

**Parameters:**

- `analyze` or `workflow`: Full workflow analysis and design (default)
- `verify`: Focus on file integrity and purpose verification
- `impact`: Analyze impact and significance of changes
- `strategy`: Design git workflow strategy (branching, commits, PRs)
- `goal: <text>`: Explicitly state developer goal
- `motive: <text>`: Specify developer motive
- `task: <text>`: Describe the task being worked on
- `branch strategy`: Design branching strategy only
- `commit strategy`: Design commit strategy only
- `pr strategy`: Design pull request strategy only
- `execute`: Execute recommended workflow (creates branches, stages, commits, pushes)
- `execute branch`: Execute branch creation only
- `execute stage`: Execute staging only
- `execute commit`: Execute commits only
- `execute push`: Execute push only
- `branch create`: Create and checkout recommended branch
- `branch switch: <name>`: Switch to specified branch
- `branch delete: <name>`: Delete specified branch (with confirmation)
- `stage`: Stage all recommended files
- `stage files: <files>`: Stage specific files
- `stage all`: Stage all changed files
- `unstage: <file>`: Unstage specific file
- `commit create`: Create commit with recommended message
- `commit create message: <text>`: Create commit with custom message
- `commit amend`: Amend last commit
- `push`: Push current branch to remote
- `push branch: <name>`: Push specified branch
- `push upstream`: Set upstream and push
- `interactive`: Prompt for confirmation before each operation
- `dry run` or `--dry-run`: Design workflow, show what would execute, then execute interactively if satisfied
- `scope: <scope>`: Limit analysis to specific scope (e.g., `frontend`, `backend`)
- `context: <n>`: Analyze last N commits for context (default: 10)
- `compare: <branch>`: Compare changes against specific branch

## What It Does

### Phase 1: Change Analysis (Retro ∘ Ana ∘ Weave)

**1. Analyze File Changes:**
- Get all unstaged and staged changes
- Read file diffs to understand what changed
- Identify file types, patterns, and relationships
- Detect change categories (additions, modifications, deletions)
- Map changes to project architecture

**2. Identify Developer Goals & Motives:**
- Extract from explicit `goal:`, `motive:`, or `task:` parameters
- Infer from branch name patterns
- Analyze recent commit history for patterns
- Understand project context and ongoing work
- Map changes to developer intent

**3. Detect Tasks & Work Units:**
- Identify distinct tasks from file groupings
- Recognize feature boundaries
- Detect related change sets
- Understand task dependencies
- Map tasks to developer goals


(Multiple Work Units in One Change Set)

**When developer forgot to commit and worked on multiple work units (features, fixes, refactors, docs, etc.):**

**Detection Strategy (Ana ↑ + Para ∥):**

1. **Work Unit Type Detection:**
   - **Feature Detection (feat):**
     - New functionality, API endpoints, components
     - Keywords: "add", "new", "create", "implement", "feature"
     - Pattern: New files with functionality, new classes/methods
   
   - **Fix Detection (fix):**
     - Bug fixes, error corrections, exception handling
     - Keywords: "fix", "bug", "error", "correct", "handle", "catch"
     - Pattern: Error handling changes, validation improvements
   
   - **Refactor Detection (refactor):**
     - Code restructuring, renaming, organization
     - Keywords: "refactor", "extract", "move", "reorganize", "restructure"
     - Pattern: Code reorganization without behavior change
   
   - **Documentation Detection (docs):**
     - Documentation changes, README updates, API docs
     - Keywords: "docs", "documentation", "readme", "api", "guide"
     - Pattern: Markdown files, doc comments, documentation directories
   
   - **Test Detection (test):**
     - Test additions, test modifications, test infrastructure
     - Keywords: "test", "spec", "specification", "testing"
     - Pattern: Test files, test directories, test utilities
   
   - **Configuration Detection (chore):**
     - Dependencies, config files, build tools, CI/CD
     - Keywords: "config", "dependency", "chore", "setup", "ci", "build"
     - Pattern: package.json, requirements.txt, config files, CI configs
   
   - **Performance Detection (perf):**
     - Performance improvements, optimizations
     - Keywords: "perf", "performance", "optimize", "speed", "cache"
     - Pattern: Performance-related changes, caching, optimization
   
   - **Security Detection (security):**
     - Security patches, authentication, authorization
     - Keywords: "security", "auth", "authz", "vulnerability", "patch"
     - Pattern: Security-related changes, auth improvements
   
   - **Infrastructure Detection (infra):**
     - Infrastructure changes, deployment, DevOps
     - Keywords: "infra", "deploy", "devops", "infrastructure"
     - Pattern: Infrastructure files, deployment configs, Docker, K8s

2. **Work Unit Boundary Detection:**
   - Analyze file directory patterns to identify work unit boundaries
   - Detect distinct work unit modules (e.g., `src/api/auth/*` vs `src/api/users/*`)
   - Identify work unit-specific directories and components
   - Recognize work unit isolation patterns
   - Group by work unit type AND domain

3. **Work Unit Independence Analysis:**
   - Check if work units share dependencies
   - Detect cross-work-unit file modifications
   - Identify shared infrastructure changes
   - Assess work unit coupling
   - Analyze type compatibility (can different types be in same branch?)

4. **Work Unit Count Detection:**
   - Count distinct work unit modules/directories
   - Identify work unit boundaries from file patterns
   - Group files by work unit domain AND type
   - Detect if changes span multiple work units

**Example Detection:**
```
50 files detected:
- Work Unit 1: Feature - Authentication (12 files, type: feat)
  Files: src/api/auth/*, src/middleware/auth.ts
  
- Work Unit 2: Fix - Login Bug (8 files, type: fix)
  Files: src/api/auth/login.ts, src/utils/validation.ts, tests/auth/login.test.ts
  
- Work Unit 3: Refactor - User Service (15 files, type: refactor)
  Files: src/services/users/*, src/repositories/users/*
  
- Work Unit 4: Documentation - API Docs (10 files, type: docs)
  Files: docs/api/*.md, docs/guides/*.md
  
- Work Unit 5: Test - Auth Tests (5 files, type: test)
  Files: tests/api/auth/*.test.ts
```

**Workflow Strategy Options (Para ∥):**

**Option A: Separate Branches (Recommended for Independent Work Units)**
- Create separate branch for each work unit
- Allows independent review and merge
- Best for: Independent work units, different reviewers, staged rollout
- Branch naming: `{type}/{work-unit-name}` (e.g., `feat/authentication`, `fix/login-bug`)

**Option B: Single Branch with Work Unit Commits**
- Create one branch with commits grouped by work unit
- All work units in one PR
- Best for: Related work units, single reviewer, atomic release
- Branch naming: `{primary-type}/multi-work-units` (e.g., `feat/multi-updates`)

**Option C: Type-Based Grouping**
- Group by work unit type (all features together, all fixes together)
- Separate branches per type
- Best for: Multiple work units of same type

**Option D: Hybrid Approach**
- Separate branches for major work units
- Single branch for minor related work units
- Best for: Mixed work unit sizes and dependencies

**Recommendation Logic:**
- **If work units are independent:** Recommend Option A (separate branches)
- **If work units are related:** Recommend Option B (single branch)
- **If work units are same type:** Recommend Option C (type-based grouping)
- **If mixed:** Recommend Option D (hybrid)

**When developer forgot to commit and worked on multiple features:**

**Detection Strategy (Ana ↑ + Para ∥):**

1. **Feature Boundary Detection:**
   - Analyze file directory patterns to identify feature boundaries
   - Detect distinct feature modules (e.g., `src/api/auth/*` vs `src/api/users/*`)
   - Identify feature-specific directories and components
   - Recognize feature isolation patterns

2. **Feature Independence Analysis:**
   - Check if features share dependencies
   - Detect cross-feature file modifications
   - Identify shared infrastructure changes
   - Assess feature coupling

3. **Feature Count Detection:**
   - Count distinct feature modules/directories
   - Identify feature boundaries from file patterns
   - Group files by feature domain
   - Detect if changes span multiple features

**Example Detection:**
```
50 files detected:
- Feature 1: Authentication (12 files) - src/api/auth/*, src/middleware/auth.ts
- Feature 2: User Management (15 files) - src/api/users/*, src/components/users/*
- Feature 3: Payment Processing (18 files) - src/api/payments/*, src/services/payment.ts
- Feature 4: Notifications (5 files) - src/api/notifications/*, src/utils/notify.ts
```

**Workflow Strategy Options (Para ∥):**

**Option A: Separate Branches (Recommended for Independent Features)**
- Create separate branch for each feature
- Allows independent review and merge
- Best for: Independent features, different reviewers, staged rollout

**Option B: Single Branch with Feature Commits**
- Create one branch with commits grouped by feature
- All features in one PR
- Best for: Related features, single reviewer, atomic release

**Option C: Hybrid Approach**
- Separate branches for major features
- Single branch for minor related features
- Best for: Mixed feature sizes and dependencies

**Recommendation Logic:**
- **If features are independent:** Recommend Option A (separate branches)
- **If features are related:** Recommend Option B (single branch)
- **If mixed:** Recommend Option C (hybrid)

### Phase 2: File Verification (Non ∘ Ortho ∘ Axis ∘ Kata ∘ Ana)

**4. Verify File Integrity:**
- Check file syntax and validity
- Verify imports and dependencies
- Detect broken references
- Check for compilation errors
- Validate file structure

**5. Verify File Purpose:**
- Understand original file purpose (from git history)
- Verify changes align with file's purpose
- Detect purpose evolution or drift
- Check architectural alignment
- Validate file role in system

**6. Verify File Impact:**
- Analyze change impact on dependent files
- Detect breaking changes
- Identify affected systems/components
- Assess risk level
- Map impact scope

**7. Verify File Significance:**
- Determine change importance
- Assess business/technical value
- Identify critical vs. minor changes
- Evaluate change priority
- Understand change context

**8. Verify File Location:**
- Check if files are in correct directories
- Verify naming conventions
- Validate project structure alignment
- Detect misplaced files
- Suggest better organization


### Large File Set Handling (50+ Files)

**When processing 50+ files, the command uses efficient strategies:**

**1. Batch Processing (Kata ↓):**
   - Process files in batches of 10-20 for analysis
   - Compress analysis to essential patterns
   - Group similar files together before detailed analysis
   - Use pattern recognition over individual file analysis

**2. Intelligent Grouping (Weave 🕸️):**
   - **By Feature/Component:** Group files by directory/module (e.g., all `src/api/auth/*` files)
   - **By Change Type:** Group additions, modifications, deletions separately
   - **By Purpose:** Group files serving same purpose (e.g., all test files, all API routes)
   - **By Dependency:** Group related files (implementation + tests, API + types)
   - **By Motive:** Group files sharing same developer goal
   - **Limit Groups:** Maximum 8-12 commit groups (even for 50+ files)

**3. Summary View (Kata ↓):**
   - Show grouped summary instead of individual files:
     ```
     Commit 1: Authentication API (12 files)
       - src/api/auth/*.ts (8 files)
       - src/middleware/auth.ts
       - src/types/auth.ts
       - src/utils/jwt.ts
       - tests/api/auth.test.ts
     
     Commit 2: User Management (15 files)
       - src/api/users/*.ts (10 files)
       - src/components/users/*.tsx (5 files)
     ```
   - Expandable details: Show file list on request
   - Group statistics: File count, change types, scope

**4. Execution Strategy (Pro ↷):**
   - Execute commits in batches (not all at once)
   - Show progress: "Committing group 1/8: Authentication API (12 files)..."
   - Allow pause between groups for review
   - Batch staging: `git add <pattern>` for grouped files
   - Efficient commit messages that cover groups

**5. Performance Optimizations:**
   - Skip detailed diff reading for files in same group
   - Use file patterns for staging: `git add src/api/auth/*.ts`
   - Parallel analysis where possible
   - Cache file purposes to avoid re-reading
   - Limit verification depth for large sets

**Example for 50 Files:**

```bash
/git --dry-run goal: Implement authentication system

# Output Summary:
# 
# Workflow Design:
# - Branch: feature/authentication-system
# - Total Files: 50
# - Commit Groups: 8
# 
# Execution Plan:
# 
# Group 1: Authentication Core (12 files)
#   git add src/api/auth/*.ts src/middleware/auth.ts src/types/auth.ts
#   git commit -m "feat(auth): implement core authentication API"
# 
# Group 2: JWT Utilities (5 files)
#   git add src/utils/jwt*.ts src/lib/tokens.ts
#   git commit -m "feat(auth): add JWT token utilities"
# 
# Group 3: Authentication Tests (8 files)
#   git add tests/api/auth/*.test.ts tests/middleware/auth.test.ts
#   git commit -m "test(auth): add authentication test suite"
# 
# ... (5 more groups)
# 
# Group 8: Documentation (3 files)
#   git add docs/auth/*.md
#   git commit -m "docs(auth): add authentication documentation"
# 
# Push: git push -u origin feature/authentication-system
# 
# Proceed with execution? (y/n)
```

**Dry-Run Display for Large Sets:**
- **Summary View (Default):** Shows groups, not individual files
- **Expandable Groups:** Click to see file list within group
- **Filter Options:** Filter by type, directory, or change category
- **Statistics:** Total files, groups, estimated commits

### Phase 3: Workflow Design (Telo ∘ Para ∘ Weave ∘ Bind)

**9. Design Branching Strategy:**
- Analyze change scope and type
- Recommend branch type (feature, fix, refactor, etc.)
- Suggest branch naming
- Design branch lifecycle
- Plan branch relationships

**10. Design Commit Strategy:**
- Group related changes logically
- Design commit granularity
- Plan commit message structure
- Organize commit sequence
- Design commit dependencies
(Telo → + Para ∥):**

**When multiple work units detected in change set:**

1. **Work Unit Separation (Ana ↑):**
   - Separate files into work unit groups by type AND domain
   - Identify work unit boundaries
   - Detect dependencies between work units
   - Assess work unit independence
   - Categorize by type (feat, fix, refactor, docs, test, etc.)

2. **Workflow Strategy Selection (Para ∥):**
   - **Option A: Separate Branches (Recommended)**
     - Branch 1: feat/authentication (12 files, type: feat)
     - Branch 2: fix/login-bug (8 files, type: fix)
     - Branch 3: refactor/user-service (15 files, type: refactor)
     - Branch 4: docs/api-docs (10 files, type: docs)
     - Branch 5: test/auth-tests (5 files, type: test)
     - Each work unit gets own branch, commits, and PR
   
   - **Option B: Single Branch**
     - Branch: feat/multi-updates (if features are primary)
     - Commits grouped by work unit:
       - Commit 1: "feat(auth): implement authentication"
       - Commit 2: "fix(auth): fix login bug"
       - Commit 3: "refactor(users): refactor user service"
       - Commit 4: "docs(api): update API documentation"
       - Commit 5: "test(auth): add authentication tests"
     - Single PR with all work units
   
   - **Option C: Type-Based Grouping**
     - Branch 1: feat/authentication (all features together)
     - Branch 2: fix/bug-fixes (all fixes together)
     - Branch 3: refactor/refactoring (all refactors together)
     - Branch 4: docs/documentation (all docs together)
   
   - **Option D: Hybrid**
     - Major work units: Separate branches
     - Minor work units: Single branch

3. **Recommendation (Telo →):**
   - Analyze work unit independence
   - Analyze work unit types
   - Recommend best strategy based on types and independence
   - Design branch/commit structure
   - Plan PR strategy

**When 4 features detected in 50 files:**

1. **Feature Separation (Ana ↑):**
   - Separate files into 4 feature groups
   - Identify feature boundaries
   - Detect dependencies between features
   - Assess feature independence

2. **Workflow Strategy Selection (Para ∥):**
   - **Option A: Separate Branches (Recommended)**
     - Branch 1: feature/authentication (12 files)
     - Branch 2: feature/user-management (15 files)
     - Branch 3: feature/payment-processing (18 files)
     - Branch 4: feature/notifications (5 files)
     - Each feature gets own branch, commits, and PR
   
   - **Option B: Single Branch**
     - Branch: feature/multi-feature-update
     - Commits grouped by feature:
       - Commit 1: "feat(auth): implement authentication"
       - Commit 2: "feat(users): add user management"
       - Commit 3: "feat(payments): implement payment processing"
       - Commit 4: "feat(notifications): add notification system"
     - Single PR with all features
   
   - **Option C: Hybrid**
     - Major features: Separate branches
     - Minor features: Single branch

3. **Recommendation (Telo →):**
   - Analyze feature independence
   - Recommend best strategy
   - Design branch/commit structure
   - Plan PR strategy


**11. Design Pull Request Strategy:**
- Plan PR scope and boundaries
- Design PR description structure
- Suggest reviewers based on changes
- Plan PR lifecycle
- Design merge strategy

### Phase 4: Workflow Integration (Weave ∘ Bind ∘ Latch)

**12. Integrate Workflow Components:**
- Weave branching, commits, and PRs into cohesive workflow
- Ensure workflow consistency
- Validate workflow completeness
- Create workflow documentation
- Finalize workflow recommendations
### Phase 5: Workflow Execution (Pro ∘ Telo ∘ Ana ∘ Latch) - Ana- Elevated

**13. Execute Git Operations (Pro ↷):**
- **Branch Operations:**
  - Create recommended branch: `git checkout -b <branch-name>`
  - Switch to branch: `git checkout <branch-name>`
  - Delete branch: `git branch -d <branch-name>` (with confirmation)
  - List branches: `git branch -a`

- **Staging Operations:**
  - Stage recommended files: `git add <file1> <file2>`
  - Stage all changes: `git add .`
  - Unstage file: `git reset HEAD <file>`
  - Stage by pattern: `git add <pattern>`

- **Commit Operations:**
  - Create commit: `git commit -m "<message>"`
  - Create commit with body: `git commit -m "<subject>" -m "<body>"`
  - Amend last commit: `git commit --amend`
  - Create commit with recommended grouping

- **Push Operations:**
  - Push to remote: `git push origin <branch>`
  - Set upstream and push: `git push -u origin <branch>`
  - Push with tags: `git push --tags`

**14. Execute Workflow (Telo →):**
- Execute complete workflow if `execute` flag provided
- Follow recommended sequence (branch → stage → commit → push)
- Execute with goal-directed acceleration
- Each operation pulls toward workflow completion
**Dry-Run Workflow (`--dry-run` or `dry run`):**

1. **Design Workflow (Phases 1-4):**
   - Analyze changes (Retro ∘ Ana ∘ Weave)
   - Verify files (Non ∘ Ortho ∘ Axis ∘ Kata ∘ Ana)
   - Design workflow (Telo ∘ Para ∘ Weave ∘ Bind)
   - Show complete workflow design

2. **Show Execution Plan:**
   - Display what would be executed:
     - Branch operations: `git checkout -b <branch-name>`
     - Staging operations: `git add <files>`
     - Commit operations: `git commit -m "<message>"`
     - Push operations: `git push origin <branch>`
   - Show execution sequence
   - Display commit messages
   - Show branch strategy

3. **Interactive Confirmation:**
   - Ask: "Proceed with execution? (y/n)"
   - If yes: Execute interactively (confirm each step)
   - If no: Exit without executing
   - Allow modifications before execution


**15. Learn from Execution (Ana ↑):**
- Record successful execution patterns
- Learn which strategies work best
- Improve future workflow recommendations
- Elevate execution through better structure
- **Ana² Pattern**: Better execution → better patterns → better execution

**16. Stabilize Execution (Latch 🔒):**
- Lock in successful workflow state
- Verify all operations completed
- Confirm workflow integrity
- Finalize execution results


## Implementation Steps

When `/git` is invoked:

### Phase 0: Context Gathering (Seed ∘ Telo)

1. **Gather Context:**
   - Check git repository status
   - Get current branch
   - Analyze recent commit history
   - Understand project structure
   - Extract explicit goals/motives/tasks if provided

2. **Determine Analysis Mode:**
   - If `verify`: Focus on file verification
   - If `impact`: Focus on impact analysis
   - If `strategy`: Focus on workflow design
   - If `branch strategy`: Focus on branching only
   - If `commit strategy`: Focus on commits only
   - If `pr strategy`: Focus on PRs only
   - If `dry run` or `--dry-run`: Design workflow, show execution plan, then execute interactively if satisfied
   - Default: Full workflow analysis

### Phase 1: Change Analysis (Retro ∘ Ana ∘ Weave)

3. **Analyze File Changes (Retro ↶):**
   - Work backward from changes to understand intent
   - Get all unstaged and staged changes
   - Read file diffs
   - Identify change patterns
   - Trace changes to root causes

4. **Identify Developer Goals (Ana ↑):**
   - Elevate to understand patterns and goals
   - Extract from parameters (goal, motive, task)
   - Infer from branch name
   - Analyze commit history patterns
   - Understand project context

5. **Detect Tasks & Work Units (Weave 🕸️):**
   - Integrate changes into task groups
   - Identify feature boundaries
   - Recognize related change sets
   - Map tasks to goals
   - Understand task dependencies
**For Large File Sets (50+ files):**

1. **Batch Analysis:**
   - Process files in batches of 10-20
   - Use pattern recognition for grouping
   - Compress to essential patterns (Kata)
   - Skip detailed analysis for similar files

2. **Intelligent Grouping:**
   - Group by directory/module first
   - Then by change type
   - Then by purpose
   - Limit to 8-12 commit groups maximum

3. **Summary Display:**
   - Show grouped summary, not individual files
   - Display: "Group 1: Authentication API (12 files)"
   - Allow expansion to see file list
   - Show statistics and scope

4. **Efficient Execution:**
   - Use file patterns: `git add src/api/auth/*.ts`
   - Batch commits by group
   - Show progress between groups
   - Allow pause for review
**For Multi-Feature Scenarios (Multiple Features in One Change Set):**

1. **Detect Feature Boundaries (Ana ↑):**
   - Analyze file patterns to identify distinct features
   - Group files by feature domain/module
   - Count distinct features
   - Assess feature independence

2. **Design Multi-Feature Workflow (Para ∥):**
   - **Option A:** Separate branches (if features independent)
   - **Option B:** Single branch with feature commits (if features related)
   - **Option C:** Hybrid approach (if mixed)
   - Recommend best strategy based on independence

3. **Execute Multi-Feature Workflow:**
   - **If Option A:** Create separate branch for each feature
   - **If Option B:** Create single branch with feature-grouped commits
   - **If Option C:** Mix of both approaches
   - Show progress: "Feature 1/4, Feature 2/4, ..."




(Multiple Work Units in One Change Set)

**When developer forgot to commit and worked on multiple work units (features, fixes, refactors, docs, etc.):**

**Detection Strategy (Ana ↑ + Para ∥):**

1. **Work Unit Type Detection:**
   - **Feature Detection (feat):**
     - New functionality, API endpoints, components
     - Keywords: "add", "new", "create", "implement", "feature"
     - Pattern: New files with functionality, new classes/methods
   
   - **Fix Detection (fix):**
     - Bug fixes, error corrections, exception handling
     - Keywords: "fix", "bug", "error", "correct", "handle", "catch"
     - Pattern: Error handling changes, validation improvements
   
   - **Refactor Detection (refactor):**
     - Code restructuring, renaming, organization
     - Keywords: "refactor", "extract", "move", "reorganize", "restructure"
     - Pattern: Code reorganization without behavior change
   
   - **Documentation Detection (docs):**
     - Documentation changes, README updates, API docs
     - Keywords: "docs", "documentation", "readme", "api", "guide"
     - Pattern: Markdown files, doc comments, documentation directories
   
   - **Test Detection (test):**
     - Test additions, test modifications, test infrastructure
     - Keywords: "test", "spec", "specification", "testing"
     - Pattern: Test files, test directories, test utilities
   
   - **Configuration Detection (chore):**
     - Dependencies, config files, build tools, CI/CD
     - Keywords: "config", "dependency", "chore", "setup", "ci", "build"
     - Pattern: package.json, requirements.txt, config files, CI configs
   
   - **Performance Detection (perf):**
     - Performance improvements, optimizations
     - Keywords: "perf", "performance", "optimize", "speed", "cache"
     - Pattern: Performance-related changes, caching, optimization
   
   - **Security Detection (security):**
     - Security patches, authentication, authorization
     - Keywords: "security", "auth", "authz", "vulnerability", "patch"
     - Pattern: Security-related changes, auth improvements
   
   - **Infrastructure Detection (infra):**
     - Infrastructure changes, deployment, DevOps
     - Keywords: "infra", "deploy", "devops", "infrastructure"
     - Pattern: Infrastructure files, deployment configs, Docker, K8s

2. **Work Unit Boundary Detection:**
   - Analyze file directory patterns to identify work unit boundaries
   - Detect distinct work unit modules (e.g., `src/api/auth/*` vs `src/api/users/*`)
   - Identify work unit-specific directories and components
   - Recognize work unit isolation patterns
   - Group by work unit type AND domain

3. **Work Unit Independence Analysis:**
   - Check if work units share dependencies
   - Detect cross-work-unit file modifications
   - Identify shared infrastructure changes
   - Assess work unit coupling
   - Analyze type compatibility (can different types be in same branch?)

4. **Work Unit Count Detection:**
   - Count distinct work unit modules/directories
   - Identify work unit boundaries from file patterns
   - Group files by work unit domain AND type
   - Detect if changes span multiple work units

**Example Detection:**
```
50 files detected:
- Work Unit 1: Feature - Authentication (12 files, type: feat)
  Files: src/api/auth/*, src/middleware/auth.ts
  
- Work Unit 2: Fix - Login Bug (8 files, type: fix)
  Files: src/api/auth/login.ts, src/utils/validation.ts, tests/auth/login.test.ts
  
- Work Unit 3: Refactor - User Service (15 files, type: refactor)
  Files: src/services/users/*, src/repositories/users/*
  
- Work Unit 4: Documentation - API Docs (10 files, type: docs)
  Files: docs/api/*.md, docs/guides/*.md
  
- Work Unit 5: Test - Auth Tests (5 files, type: test)
  Files: tests/api/auth/*.test.ts
```

**Workflow Strategy Options (Para ∥):**

**Option A: Separate Branches (Recommended for Independent Work Units)**
- Create separate branch for each work unit
- Allows independent review and merge
- Best for: Independent work units, different reviewers, staged rollout
- Branch naming: `{type}/{work-unit-name}` (e.g., `feat/authentication`, `fix/login-bug`)

**Option B: Single Branch with Work Unit Commits**
- Create one branch with commits grouped by work unit
- All work units in one PR
- Best for: Related work units, single reviewer, atomic release
- Branch naming: `{primary-type}/multi-work-units` (e.g., `feat/multi-updates`)

**Option C: Type-Based Grouping**
- Group by work unit type (all features together, all fixes together)
- Separate branches per type
- Best for: Multiple work units of same type

**Option D: Hybrid Approach**
- Separate branches for major work units
- Single branch for minor related work units
- Best for: Mixed work unit sizes and dependencies

**Recommendation Logic:**
- **If work units are independent:** Recommend Option A (separate branches)
- **If work units are related:** Recommend Option B (single branch)
- **If work units are same type:** Recommend Option C (type-based grouping)
- **If mixed:** Recommend Option D (hybrid)

**When developer forgot to commit and worked on multiple features:**

**Detection Strategy (Ana ↑ + Para ∥):**

1. **Feature Boundary Detection:**
   - Analyze file directory patterns to identify feature boundaries
   - Detect distinct feature modules (e.g., `src/api/auth/*` vs `src/api/users/*`)
   - Identify feature-specific directories and components
   - Recognize feature isolation patterns

2. **Feature Independence Analysis:**
   - Check if features share dependencies
   - Detect cross-feature file modifications
   - Identify shared infrastructure changes
   - Assess feature coupling

3. **Feature Count Detection:**
   - Count distinct feature modules/directories
   - Identify feature boundaries from file patterns
   - Group files by feature domain
   - Detect if changes span multiple features

**Example Detection:**
```
50 files detected:
- Feature 1: Authentication (12 files) - src/api/auth/*, src/middleware/auth.ts
- Feature 2: User Management (15 files) - src/api/users/*, src/components/users/*
- Feature 3: Payment Processing (18 files) - src/api/payments/*, src/services/payment.ts
- Feature 4: Notifications (5 files) - src/api/notifications/*, src/utils/notify.ts
```

**Workflow Strategy Options (Para ∥):**

**Option A: Separate Branches (Recommended for Independent Features)**
- Create separate branch for each feature
- Allows independent review and merge
- Best for: Independent features, different reviewers, staged rollout

**Option B: Single Branch with Feature Commits**
- Create one branch with commits grouped by feature
- All features in one PR
- Best for: Related features, single reviewer, atomic release

**Option C: Hybrid Approach**
- Separate branches for major features
- Single branch for minor related features
- Best for: Mixed feature sizes and dependencies

**Recommendation Logic:**
- **If features are independent:** Recommend Option A (separate branches)
- **If features are related:** Recommend Option B (single branch)
- **If mixed:** Recommend Option C (hybrid)

### Phase 2: File Verification (Non ∘ Ortho ∘ Axis ∘ Kata ∘ Ana)

6. **Verify File Integrity (Non ¬):**
   - Challenge file correctness
   - Check syntax and validity
   - Verify imports and dependencies
   - Detect broken references
   - Find integrity issues

7. **Verify File Purpose (Ortho ⊥):**
   - Correct and align file purpose
   - Understand original purpose from history
   - Verify changes align with purpose
   - Detect purpose drift
   - Validate architectural alignment

8. **Verify File Impact (Ana ↑):**
   - Elevate to understand impact scope
   - Analyze dependent files
   - Detect breaking changes
   - Identify affected systems
   - Assess risk level

9. **Verify File Significance (Kata ↓):**
   - Compress to essential significance
   - Determine importance level
   - Assess business/technical value
   - Identify critical vs. minor
   - Evaluate priority

10. **Verify File Location (Axis 📍):**
    - Align and orient file location
    - Check directory correctness
    - Verify naming conventions
    - Validate project structure
    - Suggest better organization


### Large File Set Handling (50+ Files)

**When processing 50+ files, the command uses efficient strategies:**

**1. Batch Processing (Kata ↓):**
   - Process files in batches of 10-20 for analysis
   - Compress analysis to essential patterns
   - Group similar files together before detailed analysis
   - Use pattern recognition over individual file analysis

**2. Intelligent Grouping (Weave 🕸️):**
   - **By Feature/Component:** Group files by directory/module (e.g., all `src/api/auth/*` files)
   - **By Change Type:** Group additions, modifications, deletions separately
   - **By Purpose:** Group files serving same purpose (e.g., all test files, all API routes)
   - **By Dependency:** Group related files (implementation + tests, API + types)
   - **By Motive:** Group files sharing same developer goal
   - **Limit Groups:** Maximum 8-12 commit groups (even for 50+ files)

**3. Summary View (Kata ↓):**
   - Show grouped summary instead of individual files:
     ```
     Commit 1: Authentication API (12 files)
       - src/api/auth/*.ts (8 files)
       - src/middleware/auth.ts
       - src/types/auth.ts
       - src/utils/jwt.ts
       - tests/api/auth.test.ts
     
     Commit 2: User Management (15 files)
       - src/api/users/*.ts (10 files)
       - src/components/users/*.tsx (5 files)
     ```
   - Expandable details: Show file list on request
   - Group statistics: File count, change types, scope

**4. Execution Strategy (Pro ↷):**
   - Execute commits in batches (not all at once)
   - Show progress: "Committing group 1/8: Authentication API (12 files)..."
   - Allow pause between groups for review
   - Batch staging: `git add <pattern>` for grouped files
   - Efficient commit messages that cover groups

**5. Performance Optimizations:**
   - Skip detailed diff reading for files in same group
   - Use file patterns for staging: `git add src/api/auth/*.ts`
   - Parallel analysis where possible
   - Cache file purposes to avoid re-reading
   - Limit verification depth for large sets

**Example for 50 Files:**

```bash
/git --dry-run goal: Implement authentication system

# Output Summary:
# 
# Workflow Design:
# - Branch: feature/authentication-system
# - Total Files: 50
# - Commit Groups: 8
# 
# Execution Plan:
# 
# Group 1: Authentication Core (12 files)
#   git add src/api/auth/*.ts src/middleware/auth.ts src/types/auth.ts
#   git commit -m "feat(auth): implement core authentication API"
# 
# Group 2: JWT Utilities (5 files)
#   git add src/utils/jwt*.ts src/lib/tokens.ts
#   git commit -m "feat(auth): add JWT token utilities"
# 
# Group 3: Authentication Tests (8 files)
#   git add tests/api/auth/*.test.ts tests/middleware/auth.test.ts
#   git commit -m "test(auth): add authentication test suite"
# 
# ... (5 more groups)
# 
# Group 8: Documentation (3 files)
#   git add docs/auth/*.md
#   git commit -m "docs(auth): add authentication documentation"
# 
# Push: git push -u origin feature/authentication-system
# 
# Proceed with execution? (y/n)
```

**Dry-Run Display for Large Sets:**
- **Summary View (Default):** Shows groups, not individual files
- **Expandable Groups:** Click to see file list within group
- **Filter Options:** Filter by type, directory, or change category
- **Statistics:** Total files, groups, estimated commits

### Phase 3: Workflow Design (Telo ∘ Para ∘ Weave ∘ Bind)

11. **Design Branching Strategy (Telo →):**
    - Goal-directed branch design
    - Analyze change scope and type
    - Recommend branch type
    - Suggest branch naming
    - Design branch lifecycle

12. **Explore Alternative Strategies (Para ∥):**
    - Explore different workflow approaches
    - Consider alternative branch strategies
    - Evaluate different commit organizations
    - Assess PR strategy options
    - Compare workflow alternatives

13. **Design Commit Strategy (Weave 🕸️):**
    - Integrate changes into commit groups
    - Design commit granularity
    - Plan commit message structure
    - Organize commit sequence
    - Design commit dependencies

14. **Design Pull Request Strategy (Bind 🔗):**
    - Create cohesive PR structure
    - Plan PR scope and boundaries
    - Design PR description
    - Suggest reviewers
    - Plan merge strategy

### Phase 4: Workflow Integration (Weave ∘ Bind ∘ Latch)

15. **Integrate Workflow (Weave 🕸️):**
    - Integrate all workflow components
    - Ensure consistency
    - Validate completeness
    - Create workflow documentation

16. **Finalize Workflow (Bind 🔗 ∘ Latch 🔒):**
    - Create cohesive workflow structure
    - Lock in final recommendations
    - Generate workflow summary
    - Provide actionable steps
### Phase 5: Workflow Execution (Pro ∘ Telo ∘ Ana ∘ Latch) - Ana- Elevated

17. **Execute Git Operations (Pro ↷):**
    - **If `execute` flag provided:**
      - Execute recommended branch creation: `git checkout -b <branch-name>`
      - Execute recommended staging: `git add <files>`
      - Execute recommended commits: `git commit -m "<message>"`
      - Execute recommended push: `git push origin <branch>`
    
    - **If `execute branch` provided:**
      - Create and checkout recommended branch
      - Verify branch creation success
    
    - **If `execute stage` provided:**
      - Stage files according to commit strategy
      - Verify staging success
    
    - **If `execute commit` provided:**
      - Create commits according to strategy
      - Use recommended commit messages
      - Verify commit creation
    
    - **If `execute push` provided:**
      - Push commits to remote
      - Set upstream if needed
      - Verify push success

18. **Goal-Directed Execution (Telo →):**
    - Accelerate toward workflow completion
    - Execute operations in recommended sequence
    - Each operation pulls toward goal
    - Compound acceleration through execution

19. **Learn from Execution (Ana ↑):**
    - Record execution patterns
    - Learn successful strategies
    - Improve future recommendations
    - Elevate execution structure
    - **Ana²**: Better execution → better patterns → better execution

20. **Stabilize Execution (Latch 🔒):**
    - Lock in successful workflow state
    - Verify all operations completed
    - Confirm workflow integrity
    - Finalize execution results


## Operator Sequence

**Full Workflow Analysis & Execution (Ana- Elevated):**
```
Seed ∘ Telo ∘ Retro ∘ Ana ∘ Weave ∘ Non ∘ Ortho ∘ Axis ∘ Kata ∘ Ana ∘ Telo ∘ Para ∘ Weave ∘ Bind ∘ Pro ∘ Telo ∘ Ana ∘ Latch
λ_eff ≈ 0.44
Trajectory: S* → S* → J=0
```

**Workflow Execution Only:**
```
Pro ∘ Telo ∘ Ana ∘ Latch
λ_eff ≈ 0.42
Trajectory: S* → J=0
```

**Ana² Self-Improvement Loop:**
```
Ana ∘ Ana (elevation of elevation)
λ_eff ≈ 0.75
Trajectory: S* → S* (self-improving improvement)
```

**Change Analysis:**
```
Retro ∘ Ana ∘ Weave
λ_eff ≈ 0.49
Trajectory: S* → S*
```

**File Verification:**
```
Non ∘ Ortho ∘ Axis ∘ Kata ∘ Ana
λ_eff ≈ 0.50
Trajectory: S* → S* → J=0
```

**Workflow Design:**
```
Telo ∘ Para ∘ Weave ∘ Bind ∘ Latch
λ_eff ≈ 0.38
Trajectory: S* → S* → J=0
```

## Examples

### Basic Usage

```bash
# Full workflow analysis
/git

# With explicit goal
/git goal: Implement user authentication system

# With motive
/git motive: Add secure login functionality

# With task
/git task: Create authentication API endpoints
```

### Analysis Modes

```bash
# File verification only
/git verify

# Impact analysis only
/git impact

# Workflow strategy only
/git strategy

# Branching strategy only
/git branch strategy

# Commit strategy only
/git commit strategy

# PR strategy only
/git pr strategy
```

### Context and Scope

```bash
# With context
/git context: 20

# With scope
/git scope: frontend

# Compare with branch
/git compare: main

# Combined
/git goal: Refactor auth system context: 15 scope: backend
```
### Git Command Execution (Ana- Elevated)

```bash
# Execute complete workflow
/git execute
/git execute goal: Implement user authentication

# Execute specific operations
/git execute branch
/git execute stage
/git execute commit
/git execute push

# Branch operations
/git branch create
/git branch create goal: Add rate limiting
/git branch switch: feature/user-auth
/git branch delete: old-feature-branch

# Staging operations
/git stage
/git stage files: src/api/auth.ts src/utils/jwt.ts
/git stage all
/git unstage: src/temp.ts

# Commit operations
/git commit create
/git commit create message: "feat(auth): implement JWT authentication"
/git commit amend

# Push operations
/git push
/git push branch: feature/user-auth
/git push upstream

# Interactive execution (confirm each step)
/git execute interactive

# Dry run (see what would execute)
/git execute dry run
/git --dry-run goal: Implement user authentication
```
### Dry-Run Workflow

```bash
# Design workflow and show execution plan
/git --dry-run goal: Implement user authentication

# Output:
# 1. Workflow Design:
#    - Branch: feature/user-authentication
#    - Commits: 3 commits with messages
#    - Push: origin/feature/user-authentication
#
# 2. Execution Plan:
#    git checkout -b feature/user-authentication
#    git add src/api/auth.ts src/utils/jwt.ts
#    git commit -m "feat(auth): implement JWT authentication"
#    git add src/middleware/auth.ts
#    git commit -m "feat(auth): add authentication middleware"
#    git add tests/auth.test.ts
#    git commit -m "test(auth): add authentication tests"
#    git push -u origin feature/user-authentication
#
# 3. Prompt:
#    "Proceed with execution? (y/n)"
#
# If yes: Execute interactively (confirm each step)
# If no: Exit without executing
```
### Large File Set Example (50+ Files)

```bash
# Analyze and design workflow for 50 files
/git --dry-run goal: Implement authentication system

# Output:
# 
# 📊 Analysis Summary:
# - Total Files: 50
# - Change Types: 35 modified, 12 added, 3 deleted
# - Scope: Authentication system (API, middleware, tests, docs)
# 
# 🎯 Workflow Design:
# - Branch: feature/authentication-system
# - Commit Strategy: 8 logical groups
# - Estimated Time: ~5 minutes execution
# 
# 📋 Execution Plan (Grouped):
# 
# Group 1/8: Authentication Core API (12 files)
#   Pattern: src/api/auth/*.ts
#   Files: auth.ts, login.ts, logout.ts, register.ts, ...
#   Command: git add src/api/auth/*.ts
#   Commit: "feat(auth): implement core authentication API"
# 
# Group 2/8: JWT Utilities (5 files)
#   Pattern: src/utils/jwt*.ts
#   Files: jwt.ts, jwt-validator.ts, token-generator.ts, ...
#   Command: git add src/utils/jwt*.ts
#   Commit: "feat(auth): add JWT token utilities"
# 
# ... (6 more groups)
# 
# Group 8/8: Documentation (3 files)
#   Files: docs/auth/README.md, docs/auth/API.md, docs/auth/SECURITY.md
#   Command: git add docs/auth/*.md
#   Commit: "docs(auth): add authentication documentation"
# 
# 🚀 Push Strategy:
#   git push -u origin feature/authentication-system
# 
# ⚠️  Proceed with execution? (y/n)
# 
# If yes:
#   → Executing Group 1/8: Authentication Core API (12 files)...
#   → ✓ Committed: "feat(auth): implement core authentication API"
#   → Executing Group 2/8: JWT Utilities (5 files)...
#   → ✓ Committed: "feat(auth): add JWT token utilities"
#   → ... (continues with interactive confirmation for each group)
```

**Key Features for Large Sets:**
- ✅ Batch processing (10-20 files at a time)
- ✅ Intelligent grouping (8-12 logical commits)
- ✅ Pattern-based staging (`git add src/api/auth/*.ts`)
- ✅ Summary view (groups, not individual files)
- ✅ Progress tracking (Group X/Y)
- ✅ Interactive confirmation per group





### Multi-Work-Unit Scenario (5 Work Units, 50 Files)

**Scenario:** Developer forgot to commit after each feature, now has 50 files across 4 features.

```bash
/git --dry-run

# Detection:
📊 Multi-Feature Analysis:
- Total Files: 50
- Features Detected: 4
- Feature Independence: High (minimal cross-dependencies)

🎯 Feature Breakdown:
- Feature 1: Authentication (12 files)
  Files: src/api/auth/*, src/middleware/auth.ts, tests/auth/*
  
- Feature 2: User Management (15 files)
  Files: src/api/users/*, src/components/users/*, tests/users/*
  
- Feature 3: Payment Processing (18 files)
  Files: src/api/payments/*, src/services/payment.ts, tests/payments/*
  
- Feature 4: Notifications (5 files)
  Files: src/api/notifications/*, src/utils/notify.ts

📋 Recommended Workflow Strategy:

**Option A: Separate Branches (RECOMMENDED)**
✅ Features are independent
✅ Allows separate review
✅ Enables staged rollout

Branch Strategy:
1. feature/authentication (12 files)
   - Commits: 3-4 logical groups
   - PR: Separate PR for authentication
   
2. feature/user-management (15 files)
   - Commits: 4-5 logical groups
   - PR: Separate PR for user management
   
3. feature/payment-processing (18 files)
   - Commits: 5-6 logical groups
   - PR: Separate PR for payments
   
4. feature/notifications (5 files)
   - Commits: 1-2 logical groups
   - PR: Separate PR for notifications

**Option B: Single Branch (Alternative)**
Branch: feature/multi-feature-update
- All 4 features in one branch
- Commits grouped by feature
- Single PR with all features

⚠️  Which strategy? (A/B/C or 'custom')

# If Option A selected and execution confirmed:
→ Creating branch 1/4: feature/authentication...
  → Staging Feature 1 files (12 files)
  → Creating commits for Feature 1 (3-4 commits)
  → ✓ Feature 1 complete on branch: feature/authentication
  
→ Creating branch 2/4: feature/user-management...
  → Staging Feature 2 files (15 files)
  → Creating commits for Feature 2 (4-5 commits)
  → ✓ Feature 2 complete on branch: feature/user-management
  
... (continues for Features 3 and 4)
```

## Related Commands

- `/commit`: Create commits based on workflow recommendations
- `/branch`: Create and manage branches
- `/plan`: Plan work before starting
- `/review`: Review changes before committing


## Self-Improving Features (Ana² Operator)

The workflow designer and executor improves through application and execution:

1. **Pattern Recognition (Ana ↑):**
   - Learns from successful workflow patterns
   - Improves goal inference accuracy
   - Better change categorization
   - Enhanced impact assessment
   - **Elevation**: Each pattern recognition improves pattern recognition itself

2. **Workflow Optimization (Ana ↑):**
   - Learns effective branching strategies
   - Improves commit organization
   - Better PR structure recommendations
   - Enhanced workflow integration
   - **Elevation**: Better workflows enable better workflow optimization

3. **Execution Improvement (Ana ↑):**
   - Learns from successful git command executions
   - Improves execution sequence optimization
   - Better error handling and recovery
   - Enhanced execution reliability
   - **Elevation**: Better execution enables better execution strategies

4. **Verification Accuracy (Ana ↑):**
   - Improves file integrity checks
   - Better purpose verification
   - Enhanced impact analysis
   - More accurate significance assessment
   - **Elevation**: Better verification enables better verification methods

5. **Ana² (Ascension of Ascension):**
   - **First Ana**: System improves through structure
     - Better analysis → better workflows → better execution
   - **Second Ana**: System improves its own improvement mechanisms
     - Better improvement methods → better improvements → better methods
   - **Result**: Self-improving improvement loop
     - Each execution improves future execution
     - Each workflow improves future workflow design
     - Each pattern recognition improves pattern recognition itself

**Ana² Pattern:**
```
Ana(Ana(workflow_execution))
= System that improves its own improvement mechanisms
= Better execution → better patterns → better execution strategies → better execution
= Ascension of ascension
```

