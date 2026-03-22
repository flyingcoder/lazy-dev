# /git Command - Large File Set Handling (50+ Files)

## Overview

The `/git` command efficiently handles large file sets (50+ files) through intelligent batching, grouping, and pattern-based execution.

## How It Works with 50 Files

### Step 1: Batch Analysis (Kata Operator)

**Instead of analyzing 50 files individually:**
- Processes files in batches of 10-20
- Uses pattern recognition to identify similar files
- Compresses analysis to essential patterns
- Skips detailed diff reading for files in same group

**Example:**
```
Batch 1: src/api/auth/*.ts (12 files) - Similar pattern, analyze once
Batch 2: src/utils/jwt*.ts (5 files) - Similar pattern, analyze once
Batch 3: tests/api/auth/*.test.ts (8 files) - Similar pattern, analyze once
...
```

### Step 2: Intelligent Grouping (Weave Operator)

**Groups 50 files into 8-12 logical commits:**

**Grouping Strategy:**
1. **By Directory/Module** (Primary):
   - `src/api/auth/*.ts` → Group 1: Authentication API
   - `src/utils/jwt*.ts` → Group 2: JWT Utilities
   - `tests/api/auth/*.test.ts` → Group 3: Tests

2. **By Change Type** (Secondary):
   - Additions together
   - Modifications together
   - Deletions together

3. **By Purpose** (Tertiary):
   - API routes together
   - Tests together
   - Documentation together
   - Components together

**Result:** 50 files → 8-12 commit groups

### Step 3: Summary Display (Kata Operator)

**Shows grouped summary, not individual files:**

```
📊 Analysis Summary:
- Total Files: 50
- Change Types: 35 modified, 12 added, 3 deleted
- Commit Groups: 8

📋 Execution Plan:

Group 1/8: Authentication Core API (12 files)
  Pattern: src/api/auth/*.ts
  Command: git add src/api/auth/*.ts
  Commit: "feat(auth): implement core authentication API"

Group 2/8: JWT Utilities (5 files)
  Pattern: src/utils/jwt*.ts
  Command: git add src/utils/jwt*.ts
  Commit: "feat(auth): add JWT token utilities"

... (6 more groups)
```

**Not showing:** Individual file list (too overwhelming)

### Step 4: Pattern-Based Execution (Pro Operator)

**Uses file patterns instead of individual files:**

**Instead of:**
```bash
git add src/api/auth/login.ts
git add src/api/auth/logout.ts
git add src/api/auth/register.ts
... (12 individual commands)
```

**Uses:**
```bash
git add src/api/auth/*.ts  # Stages all 12 files at once
```

**Benefits:**
- Faster execution
- Cleaner commands
- Easier to review
- Less overwhelming

### Step 5: Batch Execution with Progress

**Executes in batches with progress tracking:**

```
→ Executing Group 1/8: Authentication Core API (12 files)...
  ✓ Staged: src/api/auth/*.ts
  ✓ Committed: "feat(auth): implement core authentication API"
  
→ Executing Group 2/8: JWT Utilities (5 files)...
  ✓ Staged: src/utils/jwt*.ts
  ✓ Committed: "feat(auth): add JWT token utilities"
  
... (continues with interactive confirmation for each group)
```

**Interactive Confirmation:**
- Confirms each group before executing
- Allows pause between groups
- Can skip groups if needed
- Shows progress (Group X/Y)

## Example: 50 Files Workflow

### Input
```bash
/git --dry-run goal: Implement authentication system
```

### Analysis Phase
```
📊 Analyzing 50 files...
  → Batch 1: src/api/auth/* (12 files) - Pattern detected
  → Batch 2: src/utils/jwt* (5 files) - Pattern detected
  → Batch 3: tests/api/auth/* (8 files) - Pattern detected
  → ... (processing in batches)
```

### Grouping Phase
```
🕸️ Grouping files...
  → Group 1: Authentication API (12 files)
  → Group 2: JWT Utilities (5 files)
  → Group 3: Authentication Tests (8 files)
  → Group 4: Middleware (4 files)
  → Group 5: Types & Interfaces (6 files)
  → Group 6: Components (8 files)
  → Group 7: Configuration (4 files)
  → Group 8: Documentation (3 files)
```

### Display Phase
```
📋 Workflow Design:

Branch: feature/authentication-system
Total Files: 50
Commit Groups: 8

Execution Plan:

Group 1/8: Authentication Core API (12 files)
  Pattern: src/api/auth/*.ts
  Files: login.ts, logout.ts, register.ts, verify.ts, ...
  Command: git add src/api/auth/*.ts
  Commit: "feat(auth): implement core authentication API"

Group 2/8: JWT Utilities (5 files)
  Pattern: src/utils/jwt*.ts
  Files: jwt.ts, jwt-validator.ts, token-generator.ts, ...
  Command: git add src/utils/jwt*.ts
  Commit: "feat(auth): add JWT token utilities"

... (6 more groups)

⚠️  Proceed with execution? (y/n)
```

### Execution Phase (if yes)
```
→ Executing Group 1/8: Authentication Core API (12 files)...
  → git add src/api/auth/*.ts
  → git commit -m "feat(auth): implement core authentication API"
  ✓ Committed successfully

→ Executing Group 2/8: JWT Utilities (5 files)...
  → git add src/utils/jwt*.ts
  → git commit -m "feat(auth): add JWT token utilities"
  ✓ Committed successfully

... (continues with confirmation for each group)
```

## Key Features for Large Sets

### ✅ Efficiency
- **Batch Processing:** 10-20 files at a time
- **Pattern Recognition:** Groups similar files automatically
- **Pattern-Based Staging:** `git add src/api/auth/*.ts` instead of 12 individual commands
- **Cached Analysis:** Avoids re-reading similar files

### ✅ Usability
- **Summary View:** Shows groups, not overwhelming file lists
- **Expandable Details:** Can see file list within group if needed
- **Progress Tracking:** "Group 1/8, Group 2/8, ..."
- **Statistics:** Total files, groups, scope

### ✅ Safety
- **Interactive Confirmation:** Confirm each group before executing
- **Pause Between Groups:** Review before continuing
- **Dry-Run First:** See plan before executing
- **Pattern Verification:** Shows what patterns will match

## Performance Characteristics

**For 50 Files:**
- **Analysis Time:** ~30-60 seconds (batched)
- **Grouping Time:** ~10-20 seconds
- **Display Time:** Instant (summary view)
- **Execution Time:** ~2-5 minutes (with confirmations)

**Scales to:**
- 50 files: 8-12 groups
- 100 files: 10-15 groups
- 200 files: 12-20 groups

**Always limits to maximum 20 commit groups** (even for 500+ files)

## Comparison: Small vs Large Sets

### Small Set (5-10 files)
```
Individual file display:
- src/api/auth.ts
- src/middleware/auth.ts
- src/utils/jwt.ts
- tests/auth.test.ts
- docs/auth.md
```

### Large Set (50+ files)
```
Grouped display:
- Group 1: Authentication API (12 files)
- Group 2: JWT Utilities (5 files)
- Group 3: Tests (8 files)
- ...
```

## Benefits

1. **Manageable:** 50 files → 8 groups (not overwhelming)
2. **Efficient:** Pattern-based staging (faster)
3. **Logical:** Groups by feature/purpose (better commits)
4. **Safe:** Interactive confirmation (no surprises)
5. **Scalable:** Works for 50, 100, 200+ files

## Usage Tips

**For Large Refactors:**
```bash
/git --dry-run goal: Refactor authentication system
# Groups 50 files into logical commits
```

**For Feature Development:**
```bash
/git --dry-run goal: Add user management feature
# Groups related files together
```

**For Multi-Domain Changes:**
```bash
/git --dry-run scope: frontend,backend
# Groups by domain, then by feature
```
