# /commit Command - Sophisticated Code Historian

## Description

A sophisticated code historian that understands the deeper context of changes: developer motives, file purposes, creation/deletion reasons, and project goals. Goes beyond analyzing diffs to understand WHY changes were made, WHAT purpose files serve, and HOW they fit into the project's evolution. Writes commit messages that reflect developer intent and project history. Each commit improves understanding of change patterns, which improves future commit analysis (Ana- operator: self-improving improvement).

## Usage

```bash
# Auto-commit with motive understanding
/commit
/commit motive: <goal or intent>
/commit goal: <developer goal>

# Analysis and preview
/commit dry run
/commit preview
/commit interactive
/commit analyze

# Scope and options
/commit scope: <scope>
/commit no verify
/commit push
/commit push branch: <branch-name>

# Historical context
/commit context: <number>
/commit learn from history
```

**Parameters:**

- `motive: <text>`: Explicitly state developer motive or goal for these changes
- `goal: <text>`: Specify the goal these changes are working toward
- `dry run` or `preview`: Show what commits would be created without executing them
- `interactive`: Prompt for confirmation before creating each commit
- `analyze`: Deep analysis mode - show motive understanding, file purposes, historical context
- `scope: <scope>`: Limit analysis to specific scope (e.g., `scope: frontend`, `scope: backend`)
- `no verify`: Skip git hooks when committing
- `push`: Push commits to remote repository after creating them
- `push branch: <name>`: Specify branch to push to (defaults to current branch)
- `context: <n>`: Analyze last N commits for historical context (default: 10)
- `learn from history`: Learn from commit history patterns to improve understanding

## What It Does

### Phase 0: Special File Type Detection & Handling

**Before analyzing changes, detect and handle special file types:**

1. **Markdown Files (`.md`, `.mdc`):**
   - **CRITICAL: Call `/librarian validate` for each markdown file before committing**
   - **Documentation Validation (via /librarian):**
     - **Date Verification (CRITICAL - File System is Source of Truth):**
       - `/librarian validate` verifies dates using file system properties (not content)
       - Check `created_date` matches file creation date (from file system via `stat` command)
       - Check `last_updated` is reasonable compared to file modification date (from file system)
       - File system dates are source of truth, not metadata content
       - Flag discrepancies as validation errors (blocking unless `no verify` used)
     - **Location Validation:**
       - Verify file is in correct directory per documentation organization rules
       - Check filename follows naming conventions (DDD-description.md for decisions, etc.)
       - Validate against location patterns in `.cursor/rules/workflow/automated-documentation.mdc`
     - **Metadata Validation:**
       - Check for required YAML frontmatter (documentation_type, purpose, status, dates)
       - Verify `documentation_type` is valid (decision, architecture, guide, reference, status, migration)
       - Verify `status` is valid (active, deprecated, superseded)
       - Verify dates are in YYYY-MM-DD format
       - Verify dates match file system dates (critical - file system is source of truth)
     - **Cross-Reference Validation:**
       - Verify all relative links resolve to existing files
       - Check external links are absolute URLs
       - Validate anchor links reference existing sections
   - **Validation Process:**
     ```
     For each markdown file (.md, .mdc):
     1. Call: /librarian validate: <file-path>
     2. Parse validation results:
        - Date verification (file system vs metadata) - CRITICAL
        - Location validation
        - Metadata completeness
        - Cross-reference validity
     3. If blocking errors found (date mismatches, missing required metadata):
        - Show errors to user
        - Block commit (unless no verify flag used)
        - Suggest fixes using file system dates
     4. If warnings found (broken cross-references, missing optional metadata):
        - Show warnings
        - Allow commit (non-blocking)
        - Add [VALIDATION: WARN] to commit message
        - Include warnings in commit body
     5. If validation passes:
        - Add [VALIDATION: PASS] to commit message
        - Proceed with commit
     ```
   - **Commit Message Enhancement:** Add validation status from `/librarian validate` results
   - **Integration with /librarian:** Use `/librarian validate` for all validation checks (dates, location, metadata, cross-references)
   - **Special Commit Type:** Use `docs` type with appropriate scope (e.g., `docs(decisions)`, `docs(guides)`)
   - **Validation Status Tags:**
     - `[VALIDATION: PASS]` - All checks passed, dates verified against file system
     - `[VALIDATION: WARN]` - Non-blocking warnings (broken links, optional metadata missing)
     - `[VALIDATION: ERROR]` - Blocking errors (date mismatches, missing required metadata)
   - **Metadata Updates:** For existing docs, ensure `last_updated` matches file modification date (from file system, not content)

2. **One-Time Test Scripts:**
   - **Detection Patterns:**
     - Files matching `test-*.sh`, `test-*.py`, `test-*.ts`, `test-*.js`
     - Files in `scripts/test-*.{sh,py,ts,js}`
     - Files with names containing `one-time`, `temporary`, `temp`, `scratch`, `quick-test`
     - Files in `tmp/`, `temp/`, `scratch/` directories
   - **Commit Message Indicator:** Add `[ONE-TIME]` or `[TEMPORARY]` tag to commit message
   - **Commit Body Note:** Explain why it's temporary and when it can be deleted
   - **Special Handling:** Group separately from other changes
   - **Lifecycle Tracking:** Suggest adding note about deletion timeline
   - **Example Commit:**
     ```
     test(scripts): [ONE-TIME] add quick auth test script
     
     Temporary script for testing authentication flow during development.
     Can be deleted after auth implementation is complete (expected: 2026-01-15).
     ```

3. **Suspicious Files:**
   - **Detection Patterns:**
     - Files with suspicious extensions: `.exe`, `.dll`, `.bat`, `.cmd`, `.scr`, `.vbs`
     - Files with suspicious names: containing `password`, `secret`, `key`, `token`, `credential`
     - Files in suspicious locations: root directory with unusual names
     - Large binary files (> 10MB) not in expected locations
     - Files with suspicious permissions or unusual git attributes
   - **Verification Required:** Always prompt user before committing suspicious files
   - **Commit Message Warning:** Add `[REVIEW REQUIRED]` tag if user confirms
   - **Security Check:** Scan for potential secrets, API keys, credentials in content
   - **Separate Commit:** Always commit suspicious files separately with explicit review
   - **Interactive Mode:** Force interactive confirmation for suspicious files
   - **Commit Body Security Note:** Document why file is necessary and security considerations
   - **Example Commit:**
     ```
     chore(config): [REVIEW REQUIRED] add deployment credentials template
     
     Template file for deployment credentials. Contains placeholder values only.
     Security review completed: 2026-01-08
     Contains no actual secrets or credentials.
     ```

### Phase 1: Historical Context Analysis (Historian Mode)

1. **Understands Developer Motive:**
   - Extracts motive from `motive:` or `goal:` parameters
   - Infers motive from branch name (e.g., `feature/auth`, `fix/login-bug`)
   - Analyzes recent commit history for patterns
   - Examines related issues/PRs if available
   - Understands project goals from documentation

2. **Analyzes File Purpose & Lifecycle:**
   - **For New Files:**
     - Understands why file was created (purpose, role in system)
     - Identifies file's intended function from structure and content
     - Maps to project architecture and patterns
     - Determines if it's a new feature, refactor, or infrastructure

   - **For Modified Files:**
     - Understands original file purpose (from git history, comments, structure)
     - Identifies what changed and why (motive-driven analysis)
     - Determines if change aligns with file's original purpose
     - Detects purpose evolution (file's role changing over time)

   - **For Deleted Files:**
     - Understands why file existed (from git history)
     - Determines reason for deletion (obsolete, refactored, replaced)
     - Identifies if deletion is cleanup, migration, or removal of feature
     - Maps to replacement files if applicable

3. **Builds Historical Context:**
   - Analyzes last N commits (configurable via `context:` parameter)
   - Identifies patterns in recent changes
   - Understands project evolution trajectory
   - Maps current changes to ongoing work streams
   - Recognizes related changes across time

### Phase 2: Deep Change Analysis

4. **Analyzes Git Changes:**
   - Gets all unstaged and staged changes
   - Reads file diffs to understand what changed
   - Identifies file types and patterns
   - Detects relationships between changes
   - **Motive-Aware Analysis:** Interprets changes through lens of developer goal

5. **Categorizes Changes (Motive-Enhanced):**
   - **feat**: New features, functionality additions (understands feature purpose)
   - **fix**: Bug fixes, error corrections (understands what was broken and why)
   - **chore**: Maintenance tasks, dependencies, config changes (understands maintenance goal)
   - **refactor**: Code restructuring without behavior change (understands refactoring motive)
   - **docs**: Documentation changes (understands documentation purpose)
   - **test**: Test additions or modifications (understands testing strategy)
   - **style**: Formatting, whitespace, style-only changes
   - **perf**: Performance improvements (understands performance goal)
   - **ci**: CI/CD configuration changes (understands CI/CD purpose)
   - **build**: Build system changes (understands build system evolution)
   - **revert**: Reverts previous commits (understands why revert was necessary)

6. **Groups Related Changes (Purpose-Aware):**
   - Groups files that change together for the same purpose
   - Identifies feature sets (multiple files for one feature)
   - Separates unrelated changes into different commits
   - Handles dependencies (e.g., tests with implementation)
   - **Motive-Based Grouping:** Groups by shared developer goal, not just file relationships

### Phase 3: Intelligent Commit Message Generation

7. **Generates Motive-Based Commit Messages:**
   - Follows conventional commit format: `type(scope): description`
   - **Motive-Driven:** Writes messages that reflect developer intent
   - **Purpose-Aware:** Includes file purpose context when relevant
   - **Historical Context:** References related work when appropriate
   - Creates clear, descriptive messages that explain WHY, not just WHAT
   - Uses present tense, imperative mood
   - Optional body explains motive, purpose, or historical context for complex changes

8. **Executes Commits:**
   - Stages files for each commit group
   - Creates commits with generated messages
   - Provides feedback on what was committed and why
   - Shows motive understanding in feedback

9. **Pushes to Remote (if `push` parameter):**
   - Pushes all created commits to remote repository
   - Uses current branch or specified `branch:` parameter
   - Provides feedback on push success/failure

### Phase 4: Learning & Improvement (Ana- Operator)

10. **Learns from Patterns:**
    - Records successful motive interpretations
    - Learns file purpose patterns from history
    - Improves categorization based on outcomes
    - Builds knowledge base of change patterns
    - Each commit improves future commit understanding

## Implementation Steps

When `/commit` is invoked:

### Phase 0: Motive & Context Gathering (Historian Foundation)

1. **Extract Developer Motive:**
   - If `motive:` or `goal:` provided: Use explicit motive
   - Otherwise: Infer from branch name patterns:
     - `feature/*`, `feat/*` → Feature development
     - `fix/*`, `bugfix/*` → Bug fixing
     - `refactor/*` → Code restructuring
     - `chore/*` → Maintenance
     - `perf/*` → Performance improvement
   - Analyze recent commit messages (last N commits via `context:` parameter)
   - Check for related issues/PRs in commit messages
   - Understand project state from documentation

2. **Build Historical Context:**
   - Analyze last N commits (default: 10, configurable via `context:` parameter)
   - Identify ongoing work streams
   - Map current changes to recent patterns
   - Understand project evolution trajectory
   - Recognize related work across time

3. **Check Git Status:**
   - Verify we're in a git repository
   - Get list of modified, added, deleted files
   - Check if there are any changes to commit
   - Get current branch name for motive inference

4. **Detect Special File Types:**
   - Scan all changed files for special types (markdown, one-time tests, suspicious)
   - **Markdown Detection:**
     - Files matching `*.md` or `*.mdc` patterns
     - Check against documentation validation rules
     - Validate location, metadata, cross-references
   - **One-Time Test Detection:**
     - Match against one-time test patterns
     - Identify temporary test scripts
     - Determine lifecycle (when can be deleted)
   - **Suspicious File Detection:**
     - Scan for suspicious patterns (extensions, names, sizes, locations)
     - Check for potential secrets or credentials
     - Flag for user review
   - **Separate Special Files:** Group special files separately for special handling

### Phase 1: File Purpose & Lifecycle Analysis

5. **Handle Special File Types:**
   - **For Markdown Files:**
     - **STEP 1: Call `/librarian validate` for each markdown file**
       - Execute: `/librarian validate: <file-path>` for each `.md` or `.mdc` file
       - Parse validation results including:
         - **Date Verification (CRITICAL):**
           - File creation date (from file system via `stat` command)
           - `created_date` in metadata
           - File modification date (from file system)
           - `last_updated` in metadata
           - Flag discrepancies: file system dates are source of truth
         - Location validation status
         - Metadata completeness
         - Cross-reference validity
     - **STEP 2: Process Validation Results:**
       - **If blocking errors (date mismatches, missing required metadata):**
         - Show detailed error messages
         - Block commit (unless `no verify` flag used)
         - Suggest fixes: "Update metadata dates to match file system dates"
         - Show file system dates for reference
       - **If warnings (broken cross-references, missing optional metadata):**
         - Show warning messages
         - Allow commit (non-blocking)
         - Add `[VALIDATION: WARN]` to commit message
         - Include warnings in commit body
       - **If validation passes:**
         - Add `[VALIDATION: PASS]` to commit message
         - Proceed with commit
     - **STEP 3: Generate Commit Message:**
       - Use `docs(scope)` type where scope is category
       - Include validation status tag from `/librarian validate`: `[VALIDATION: PASS/WARN/ERROR]`
       - Include purpose from metadata if available
       - Reference `/librarian validate` results in commit body
       - Include date verification status in commit body
       - Example: `docs(decisions): add API separation decision [VALIDATION: PASS]`
     - **For new docs:** Use `/librarian categorize` if location is unclear
     - **For existing docs:** Verify `last_updated` matches file modification date (via `/librarian validate`)
   
   - **For One-Time Test Scripts:**
     - Mark with `[ONE-TIME]` or `[TEMPORARY]` tag
     - Add lifecycle note in commit body (when to delete)
     - Group separately from other changes
     - Use `test` type with `(scripts)` scope
     - Suggest adding to `.gitignore` if appropriate
   
   - **For Suspicious Files:**
     - **ALWAYS require user confirmation** (even if not in interactive mode)
     - Show file details and why it's flagged as suspicious
     - If user confirms: Add `[REVIEW REQUIRED]` tag
     - Commit separately with security notes
     - Document security review in commit body
     - Warn if potential secrets detected

6. **Analyze File Purposes:**
   - **For New Files:**
     - Read file content to understand purpose
     - Analyze structure (exports, classes, functions)
     - Map to project architecture
     - Determine role in system
     - Identify if it's feature, infrastructure, or refactor

   - **For Existing Files (Modified):**
     - Read git history to understand original purpose
     - Analyze file's role from structure and comments
     - Understand file's place in project architecture
     - Determine if purpose is evolving
     - Map to related files and dependencies

   - **For Deleted Files:**
     - Read file from git history before deletion
     - Understand why file existed (purpose, role)
     - Analyze deletion context (what replaced it, why removed)
     - Determine deletion type: cleanup, migration, feature removal
     - Check if functionality moved elsewhere

7. **Analyze Changes (Motive-Aware):**
   - For each changed file:
     - Read the diff (staged and unstaged)
     - Identify file type and purpose
     - Detect change patterns (additions, deletions, modifications)
     - Extract key indicators (function names, class names, imports, etc.)
     - **Interpret through motive lens:** How do changes align with developer goal?
     - **Purpose-aware analysis:** Do changes align with file's purpose?

8. **Categorize by Type (Motive-Enhanced):**
   - **Feature Detection:**
     - New files with functionality (understands feature purpose)
     - New functions/methods/classes (understands what they enable)
     - New API endpoints (understands API purpose)
     - New components or modules (understands component role)
     - Keywords: "add", "new", "create", "implement"
     - **Motive Context:** Aligns with feature development goal

   - **Fix Detection:**
     - Changes to error handling (understands what was broken)
     - Bug corrections (understands bug impact)
     - Exception fixes (understands exception scenario)
     - Validation improvements (understands validation gap)
     - Keywords: "fix", "bug", "error", "correct", "handle", "catch"
     - **Motive Context:** Aligns with bug fixing goal

   - **Refactor Detection:**
     - Code restructuring (understands refactoring purpose)
     - Renaming without behavior change (understands naming improvement)
     - Code organization improvements (understands organization goal)
     - Pattern extraction (understands pattern purpose)
     - Keywords: "refactor", "extract", "move", "reorganize", "restructure"
     - **Motive Context:** Aligns with code quality improvement goal

   - **Chore Detection:**
     - Dependency updates (understands update reason)
     - Configuration changes (understands config purpose)
     - Build tool changes (understands build system evolution)
     - File deletions (understands cleanup purpose)
     - Keywords: "update", "bump", "config", "setup", "remove"
     - **Motive Context:** Aligns with maintenance goal

   - **Documentation Detection:**
     - Changes to `.md` files (understands documentation purpose)
     - Comments and docstrings (understands documentation goal)
     - README updates (understands project documentation evolution)
     - API documentation (understands API documentation purpose)
     - **Motive Context:** Aligns with documentation improvement goal

   - **Test Detection:**
     - Test file changes (understands testing strategy)
     - Test additions/modifications (understands test coverage goal)
     - Test configuration (understands test infrastructure purpose)
     - Files matching test patterns (`*.test.*`, `*.spec.*`, `__tests__/`)
     - **Motive Context:** Aligns with testing/quality assurance goal

9. **Group Related Changes (Motive-Aware):**
   - **Special File Grouping:**
     - Markdown files: Group by documentation category (decisions, guides, architecture, etc.)
     - One-time test scripts: Group separately with `[ONE-TIME]` tag
     - Suspicious files: Always commit separately, never auto-group
   - **Standard Grouping:**
     - **By Motive:** Files that share the same developer goal
     - **By Feature:** Files that implement a single feature (with purpose understanding)
     - **By Component:** Files in the same directory/module (with architectural context)
     - **By Dependency:** Implementation + tests, API + types, etc. (with relationship understanding)
     - **By Purpose:** Files that serve the same purpose in the system
     - **By Type:** Same commit type changes that are related
     - **Separate Unrelated:** Different features/fixes in separate commits
     - **Lifecycle-Aware:** Groups file creation/deletion with related modifications
   - **By Motive:** Files that share the same developer goal
   - **By Feature:** Files that implement a single feature (with purpose understanding)
   - **By Component:** Files in the same directory/module (with architectural context)
   - **By Dependency:** Implementation + tests, API + types, etc. (with relationship understanding)
   - **By Purpose:** Files that serve the same purpose in the system
   - **By Type:** Same commit type changes that are related
   - **Separate Unrelated:** Different features/fixes in separate commits
   - **Lifecycle-Aware:** Groups file creation/deletion with related modifications

10. **Generate Motive-Based Commit Messages:**
   - **For Markdown Files:**
     - Use `docs(scope)` type where scope is category (decisions, guides, architecture, etc.)
     - Add validation status from `/librarian validate` results: `[VALIDATION: PASS/WARN/ERROR]`
     - Include purpose from metadata if available
     - Reference `/librarian validate` results in commit body
     - **Include date verification status in commit body:**
       - If dates match: "Dates verified: created_date and last_updated match file system dates"
       - If dates mismatch: "⚠️ Date mismatch: metadata dates don't match file system dates (file system is source of truth)"
     - Example: `docs(decisions): add API separation decision [VALIDATION: PASS]`
     - Example with warnings: `docs(guides): add setup guide [VALIDATION: WARN]` (with warnings in body)
     - Example with errors: `docs(architecture): update system design [VALIDATION: ERROR]` (blocked unless no verify)
   
   - **For One-Time Test Scripts:**
     - Use `test(scripts)` type with `[ONE-TIME]` tag
     - Include lifecycle note in body (when to delete)
     - Explain temporary purpose
     - Example: `test(scripts): [ONE-TIME] add auth flow test script`
   
   - **For Suspicious Files:**
     - Use appropriate type with `[REVIEW REQUIRED]` tag
     - Always include security review notes in body
     - Document why file is necessary
     - Example: `chore(config): [REVIEW REQUIRED] add credentials template`
   
   - **Standard Messages:**
     - Determine primary type (if mixed, use most significant)
     - Extract scope from file paths or context
     - **Motive Integration:** Incorporate developer goal into message
     - **Purpose Context:** Include file purpose when relevant
     - **Historical Context:** Reference related work when appropriate
     - Create descriptive message that explains WHY, not just WHAT
     - Format: `type(scope): motive-driven description`
     - Optional body explains motive, purpose, or historical context for complex changes
   - Determine primary type (if mixed, use most significant)
   - Extract scope from file paths or context
   - **Motive Integration:** Incorporate developer goal into message
   - **Purpose Context:** Include file purpose when relevant
   - **Historical Context:** Reference related work when appropriate
   - Create descriptive message that explains WHY, not just WHAT
   - Format: `type(scope): motive-driven description`
   - Optional body for complex changes:
     - Explains developer motive/goal
     - Describes file purposes and lifecycle
     - References historical context
     - Explains relationships to other work

11. **Execute Commits:**
   - **Pre-Commit Validation:**
     - **For markdown files:**
       - Call `/librarian validate: <file-path>` for each markdown file
       - Show documentation validation status from `/librarian` results
       - **Date Verification Display:**
         - Show file system dates (creation, modification)
         - Show metadata dates (created_date, last_updated)
         - Flag discrepancies if dates don't match
         - Show validation status: PASS/WARN/ERROR
       - **Blocking Errors:** Date mismatches or missing required metadata block commit (unless `no verify`)
       - **Non-Blocking Warnings:** Broken cross-references or missing optional metadata allow commit
     - For suspicious files: Require explicit user confirmation (blocking)
     - For one-time tests: Show lifecycle note and deletion timeline
   
   - **Commit Execution:**
     - If `dry run` or `preview`: Display what would be committed with motive analysis, `/librarian` validation results, and special file handling
     - If `analyze`: Show deep analysis (motive, file purposes, historical context, special file status, `/librarian` validation results)
     - If `interactive`: Show each commit with motive understanding, `/librarian` validation status, special file warnings, and ask for confirmation
     - For suspicious files: Always prompt (even in non-interactive mode)
     - **For markdown files with validation errors:** Block commit unless `no verify` used
     - Stage files for each group
     - Create commit with generated message (including validation status from `/librarian`)
     - Report success/failure with context
     - Show validation status for markdown files (from `/librarian validate` results)

12. **Push to Remote (if `push` parameter):**
    - Verify remote repository is configured
    - Determine branch to push (current or `--branch` option)
    - Push commits to remote: `git push origin <branch>`
    - If branch doesn't exist remotely: `git push -u origin <branch>`
    - Report push success/failure
    - Handle push errors (conflicts, authentication, etc.)

### Phase 4: Learning & Pattern Recognition (Ana- Self-Improvement)

13. **Learn from Commit Patterns:**
    - Record successful motive interpretations
    - Learn file purpose patterns from history
    - Build knowledge base of change patterns
    - Improve categorization based on outcomes
    - Each commit improves future commit understanding
    - Pattern recognition enables better motive inference

14. **Improve Historical Understanding:**
    - Strengthen file purpose knowledge base
    - Improve motive inference from branch names
    - Better pattern recognition for change grouping
    - Enhanced context analysis from commit history
    - Self-improving improvement: better understanding → better commits → better patterns

## Examples

### Basic Usage
```bash
# Auto-commit with motive understanding from branch/context
/commit

# Explicitly state developer motive
/commit motive: Implement user authentication system

# Specify goal these changes work toward
/commit goal: Enable secure user login and session management
```

### Analysis & Preview
```bash
# See what would be committed with motive analysis
/commit dry run
/commit preview

# Deep analysis mode - show motive, file purposes, historical context
/commit analyze

# Confirm each commit with motive understanding
/commit interactive
```

### Historical Context
```bash
# Analyze last 20 commits for context
/commit context: 20

# Learn from commit history patterns
/commit learn from history

# Combine context analysis with commit
/commit context: 15 motive: Refactor authentication
```

### Scope & Options
```bash
# Only analyze frontend changes
/commit scope: frontend

# Skip git hooks
/commit no verify

# Commit and push to remote
/commit push

# Commit and push to specific branch
/commit push branch: feature/new-feature

# Interactive commit with push
/commit interactive push
```

### Sophisticated Historian Workflows
```bash
# Understand motive + analyze file purposes + learn from history
/commit motive: Migrate to new auth system context: 20 learn from history

# Deep analysis before committing
/commit analyze motive: Add rate limiting

# Full historian mode: motive + context + analysis + commit
/commit goal: Improve API security context: 15 analyze interactive
```

## Example Output

### Standard Mode
```
Analyzing git changes with historical context...

Inferred motive from branch 'feature/user-auth': Implementing user authentication system
Analyzing last 10 commits for context...
- Recent pattern: API development and security improvements
- Related work: Authentication middleware added in commit abc123

Found 8 changed files:
- src/components/Button.tsx (modified)
  Purpose: UI component for user interactions
  Change: Enhanced validation for auth-related buttons
- src/components/Button.test.tsx (modified)
  Purpose: Test suite for Button component
  Change: Added auth validation test cases
- src/utils/validation.ts (modified)
  Purpose: Shared validation utilities
  Change: Added email and password validation functions
- package.json (modified)
  Purpose: Project dependencies and configuration
  Change: Added bcrypt and jwt dependencies
- README.md (modified)
  Purpose: Project documentation
  Change: Updated with authentication setup instructions
- src/api/users.ts (new)
  Purpose: User management API endpoints
  Change: New file - implements user CRUD operations
- src/api/users.test.ts (new)
  Purpose: Test suite for user API
  Change: New file - tests for user endpoints
- .github/workflows/ci.yml (modified)
  Purpose: CI/CD pipeline configuration
  Change: Added auth-related test steps

Grouping changes by motive and purpose...

Group 1: Feature - User Authentication API (Motive: Implement user auth system)
  - src/api/users.ts (new) - Purpose: User management API
  - src/api/users.test.ts (new) - Purpose: User API tests
  Commit: feat(api): implement user authentication endpoints
  Body: Adds user CRUD operations and authentication endpoints as part of
  implementing the user authentication system. Enables secure user management.

Group 2: Fix - Button Validation for Auth (Motive: Support auth UI)
  - src/components/Button.tsx (modified) - Purpose: UI component
  - src/components/Button.test.tsx (modified) - Purpose: Component tests
  Commit: fix(components): enhance button validation for authentication flows
  Body: Updates Button component validation to properly handle authentication-related
  interactions. Aligns with user authentication system implementation.

Group 3: Enhancement - Validation Utilities (Motive: Support auth validation)
  - src/utils/validation.ts (modified) - Purpose: Shared validation
  Commit: feat(utils): add email and password validation functions
  Body: Adds validation utilities needed for user authentication. Supports
  the authentication system implementation.

Group 4: Chore - Dependencies (Motive: Add auth dependencies)
  - package.json (modified) - Purpose: Project dependencies
  Commit: chore(deps): add bcrypt and jwt for authentication
  Body: Adds required dependencies for implementing user authentication system.

Group 5: Docs - Setup Instructions (Motive: Document auth setup)
  - README.md (modified) - Purpose: Project documentation
  Commit: docs: add authentication setup instructions
  Body: Documents authentication system setup as part of user auth implementation.

Group 6: CI - Test Pipeline (Motive: Test auth in CI)
  - .github/workflows/ci.yml (modified) - Purpose: CI/CD pipeline
  Commit: ci: add authentication tests to pipeline
  Body: Ensures authentication functionality is tested in CI as part of auth system.

Creating commits...
✅ Created commit: feat(api): implement user authentication endpoints
✅ Created commit: fix(components): enhance button validation for authentication flows
✅ Created commit: feat(utils): add email and password validation functions
✅ Created commit: chore(deps): add bcrypt and jwt for authentication
✅ Created commit: docs: add authentication setup instructions
✅ Created commit: ci: add authentication tests to pipeline

All changes committed successfully!
Motive understood: Implementing user authentication system
File purposes analyzed: 8 files with purpose context
Historical context: Aligned with recent API and security work

Pushing to remote...
✅ Pushed 6 commits to origin/feature/user-auth
```

### Analysis Mode (`--analyze`)
```
Deep Analysis Mode - Sophisticated Historian

Developer Motive:
  Inferred: Implementing user authentication system
  Source: Branch name 'feature/user-auth'
  Confidence: High

Historical Context (last 10 commits):
  - Pattern: API development and security improvements
  - Related: Authentication middleware added 3 commits ago
  - Trajectory: Building toward secure user management system

File Purpose Analysis:

1. src/api/users.ts (NEW)
   Purpose: User management API endpoints
   Role: Core authentication API layer
   Architecture: RESTful endpoints for user CRUD
   Related: Connects to auth middleware from commit abc123
   Lifecycle: New file created for auth system

2. src/utils/validation.ts (MODIFIED)
   Original Purpose: Shared validation utilities
   Change Purpose: Add auth-specific validation
   Evolution: Expanding from general to include auth validation
   Related: Used by Button component and user API

3. src/components/Button.tsx (MODIFIED)
   Original Purpose: Reusable UI button component
   Change Purpose: Support authentication flows
   Evolution: Enhancing for auth context
   Related: Uses validation utilities

[... continues for all files ...]

Motive-Based Grouping:
  All changes align with "Implement user authentication system" goal
  Files grouped by their role in achieving this goal
  Dependencies properly identified (API + tests, component + validation)

Recommended Commits:
  [Shows same grouping as above with full analysis]
```

## Error Handling

- **No git repository:** Error message with instructions
- **No changes to commit:** Inform user, suggest `git status`
- **Git errors:** Show git error messages, suggest solutions
- **File read errors:** Skip problematic files, continue with others
- **Empty commit groups:** Skip empty groups, continue with valid ones
- **Commit failures:** Report which commits failed, continue with others
- **Documentation validation errors:**
  - **Blocking errors:** Show errors, suggest fixes, prevent commit unless `no verify` used
  - **Non-blocking warnings:** Show warnings, allow commit, suggest fixes
  - **Missing metadata:** Show which fields are missing, suggest adding them
- **Suspicious file warnings:**
  - **Always block:** Require explicit user confirmation before committing
  - **Show details:** Display why file is flagged as suspicious
  - **Security scan results:** Show if potential secrets detected
  - **User rejection:** Skip suspicious file if user rejects
- **Push errors:**
  - **No remote configured:** Error message, suggest `git remote add`
  - **Authentication failures:** Suggest checking credentials/SSH keys
  - **Remote conflicts:** Inform user, suggest pulling first
  - **Branch doesn't exist:** Create and push with `-u` flag
  - **Network errors:** Show error, suggest retry

## Smart Detection Rules

### Motive Inference:
- Branch patterns: `feature/*`, `fix/*`, `refactor/*`, `chore/*`, `perf/*`
- Commit history patterns: Recent commits indicate ongoing work
- File patterns: New files in feature directory suggest feature development
- Change patterns: Multiple related files suggest unified goal

### File Purpose Detection:
- **From Structure:**
  - Exports/API endpoints → API layer purpose
  - Components/UI elements → UI layer purpose
  - Utils/helpers → Utility/shared purpose
  - Tests → Testing purpose
  - Config files → Configuration purpose

- **From Git History:**
  - Original commit message → Original purpose
  - Evolution over time → Purpose changes
  - Related files → Purpose relationships

- **From Architecture:**
  - Directory structure → Architectural role
  - Import relationships → System dependencies
  - File naming → Purpose indicators

### File Pattern Detection:
- `*.test.*`, `*.spec.*`, `__tests__/` → test (testing purpose)
- `*.md`, `docs/` → docs (documentation purpose)
- `package.json`, `requirements.txt`, `*.lock` → chore (dependency management purpose)
- `.github/`, `.gitlab-ci.yml`, `Jenkinsfile` → ci (CI/CD purpose)
- `Dockerfile`, `docker-compose.yml` → build (build system purpose)
- `*.config.*`, `*.conf` → chore or config (configuration purpose)

### Content Pattern Detection:
- New exports/functions → feat (new functionality purpose)
- Error handling changes → fix (error correction purpose)
- Import additions → feat or fix (dependency purpose)
- Type definitions → feat or refactor (type system purpose)
- Test assertions → test (testing purpose)
- Configuration values → chore (configuration purpose)

### Relationship Detection:
- Implementation + test files → group together (testing relationship)
- Component + styles → group together (UI relationship)
- API + types → group together (type system relationship)
- Related directory changes → group together (architectural relationship)
- **Motive-based:** Files sharing same developer goal → group together
- **Purpose-based:** Files serving same system purpose → group together
- **Lifecycle-based:** File creation/deletion with related changes → group together

### Historical Pattern Learning:
- Successful motive interpretations → improve future inference
- File purpose patterns → build knowledge base
- Change grouping patterns → improve grouping accuracy
- Commit message patterns → improve message quality
- Each commit improves future understanding (Ana- self-improvement)

## Self-Improving Features (Ana- Operator)

The historian elevates itself through structure:

1. **Motive Understanding Improvement:**
   - Learns from successful motive interpretations
   - Improves branch name pattern recognition
   - Better context analysis from commit history
   - Each commit improves future motive inference

2. **File Purpose Knowledge Base:**
   - Builds knowledge of file purposes over time
   - Learns architectural patterns
   - Understands file lifecycle evolution
   - Better purpose inference for new files

3. **Historical Pattern Recognition:**
   - Recognizes change patterns across time
   - Understands project evolution trajectories
   - Identifies related work streams
   - Better context for future changes

4. **Commit Message Quality:**
   - Learns from effective commit messages
   - Improves motive integration
   - Better purpose context inclusion
   - Enhanced historical reference accuracy

5. **Change Grouping Optimization:**
   - Learns effective grouping patterns
   - Better motive-based grouping
   - Improved purpose-aware relationships
   - Enhanced lifecycle understanding

**Ana² (Ascension of Ascension):** The system that improves its own improvement mechanisms
- Better understanding → better commits → better patterns → better understanding
- Each improvement enables further improvements
- Self-improving improvement loop

## Special File Handling Examples

### Markdown Documentation Example
```bash
# Committing documentation changes
/commit

# Output shows:
📄 Documentation Validation:
- docs/decisions/002-api-separation.md [VALIDATION: PASS]
  ✓ Location correct: docs/decisions/
  ✓ Metadata complete: documentation_type, purpose, status, dates
  ✓ Cross-references valid
  
Commit: docs(decisions): add API separation decision [VALIDATION: PASS]
Body: Documents architectural decision to separate AI services (Flask) 
from dashboard data (Next.js). Follows documentation organization rules.
Validation: All checks passed.
```

### One-Time Test Script Example
```bash
# Committing temporary test script
/commit

# Output shows:
⚠️  One-Time Test Script Detected:
- scripts/test-auth-quick.sh
  Lifecycle: Temporary script for auth testing
  Suggested deletion: After auth implementation complete (2026-01-15)
  
Commit: test(scripts): [ONE-TIME] add quick auth test script
Body: Temporary script for testing authentication flow during development.
Can be deleted after auth implementation is complete (expected: 2026-01-15).
This is a one-time test script and should not be part of permanent test suite.
```

### Suspicious File Example
```bash
# Committing suspicious file
/commit

# Output shows:
🔒 SUSPICIOUS FILE DETECTED:
- config/credentials.template.json
  Reason: Contains "credentials" in filename
  Security scan: No secrets detected (placeholder values only)
  
⚠️  REVIEW REQUIRED: This file is flagged as suspicious.
Continue with commit? [y/N]: y

Commit: chore(config): [REVIEW REQUIRED] add credentials template
Body: Template file for deployment credentials. Contains placeholder values only.
Security review completed: 2026-01-08
Contains no actual secrets or credentials.
File flagged for review due to filename pattern.
```

## Related

- Use `git status` to see current changes
- Use `git diff` to review changes before committing
- Use `git log` to understand historical context
- See conventional commits spec: https://www.conventionalcommits.org/
- Use `/learn` to research commit patterns and best practices
- See `/librarian` command for documentation validation (date verification, location, metadata, cross-references)
- See `.cursor/rules/workflow/documentation-pre-commit-validation.mdc` for documentation validation rules
- See `.cursor/rules/workflow/documentation-evaluation.mdc` for complete evaluation framework
