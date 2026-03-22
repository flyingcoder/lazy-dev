# /git Command - Multi-Feature Scenario Handling

## Scenario: Developer Forgot to Commit

**Situation:**
- Developer finished Feature 1 (Authentication) but forgot to commit
- Started Feature 2 (User Management) without committing
- Continued with Feature 3 (Payment Processing) and Feature 4 (Notifications)
- Now has 50 files changed across 4 features
- Wants to commit everything properly

## How /git Handles This

### Step 1: Multi-Feature Detection (Ana Operator)

**Detection Process:**
```
📊 Analyzing 50 files...

Feature Boundary Detection:
→ Pattern: src/api/auth/* (12 files) → Feature 1: Authentication
→ Pattern: src/api/users/* (15 files) → Feature 2: User Management  
→ Pattern: src/api/payments/* (18 files) → Feature 3: Payment Processing
→ Pattern: src/api/notifications/* (5 files) → Feature 4: Notifications

Feature Independence Analysis:
→ Feature 1: Independent (no cross-dependencies)
→ Feature 2: Independent (no cross-dependencies)
→ Feature 3: Independent (no cross-dependencies)
→ Feature 4: Independent (no cross-dependencies)

Result: 4 distinct, independent features detected
```

### Step 2: Workflow Strategy Recommendation (Para Operator)

**Strategy Options:**

**Option A: Separate Branches (RECOMMENDED)**
```
✅ Recommended because:
- Features are independent
- Allows separate code review
- Enables staged rollout
- Easier to revert individual features
- Better for team collaboration

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
```

**Option B: Single Branch (Alternative)**
```
Branch: feature/multi-feature-update
- All 4 features in one branch
- Commits grouped by feature:
  - Commit 1: "feat(auth): implement authentication"
  - Commit 2: "feat(users): add user management"
  - Commit 3: "feat(payments): implement payment processing"
  - Commit 4: "feat(notifications): add notification system"
- Single PR with all features
```

### Step 3: Dry-Run Display

```bash
/git --dry-run

# Output:
📊 Multi-Feature Analysis:
- Total Files: 50
- Features Detected: 4
- Feature Independence: High (minimal cross-dependencies)

🎯 Feature Breakdown:

Feature 1: Authentication (12 files)
  Files: 
    - src/api/auth/login.ts
    - src/api/auth/logout.ts
    - src/api/auth/register.ts
    - src/api/auth/verify.ts
    - src/middleware/auth.ts
    - src/types/auth.ts
    - src/utils/jwt.ts
    - tests/api/auth/*.test.ts (4 files)
  
Feature 2: User Management (15 files)
  Files:
    - src/api/users/*.ts (10 files)
    - src/components/users/*.tsx (5 files)
  
Feature 3: Payment Processing (18 files)
  Files:
    - src/api/payments/*.ts (12 files)
    - src/services/payment.ts
    - src/utils/payment-helpers.ts
    - tests/payments/*.test.ts (4 files)
  
Feature 4: Notifications (5 files)
  Files:
    - src/api/notifications/*.ts (3 files)
    - src/utils/notify.ts
    - tests/notifications.test.ts

📋 Recommended Workflow Strategy:

**Option A: Separate Branches (RECOMMENDED)**
✅ Features are independent
✅ Allows separate review
✅ Enables staged rollout

Branch 1: feature/authentication (12 files)
  Commits: 3-4 logical groups
  PR: Separate PR for authentication
  
Branch 2: feature/user-management (15 files)
  Commits: 4-5 logical groups
  PR: Separate PR for user management
  
Branch 3: feature/payment-processing (18 files)
  Commits: 5-6 logical groups
  PR: Separate PR for payments
  
Branch 4: feature/notifications (5 files)
  Commits: 1-2 logical groups
  PR: Separate PR for notifications

**Option B: Single Branch (Alternative)**
Branch: feature/multi-feature-update
- All 4 features in one branch
- Commits grouped by feature
- Single PR with all features

⚠️  Which strategy? (A/B/C or 'custom')
```

### Step 4: Execution (If Option A Selected)

**Interactive Execution Flow:**

```
→ Creating branch 1/4: feature/authentication...
  → Staging Feature 1 files (12 files)
    → git add src/api/auth/*.ts
    → git add src/middleware/auth.ts
    → git add src/types/auth.ts
    → git add src/utils/jwt.ts
    → git add tests/api/auth/*.test.ts
  
  → Creating commits for Feature 1:
    → Commit 1/3: "feat(auth): implement core authentication API"
    → Commit 2/3: "feat(auth): add JWT token utilities"
    → Commit 3/3: "test(auth): add authentication test suite"
  
  → ✓ Feature 1 complete on branch: feature/authentication
  → Push branch? (y/n)
  
→ Creating branch 2/4: feature/user-management...
  → Staging Feature 2 files (15 files)
    → git add src/api/users/*.ts
    → git add src/components/users/*.tsx
  
  → Creating commits for Feature 2:
    → Commit 1/4: "feat(users): implement user management API"
    → Commit 2/4: "feat(users): add user list component"
    → Commit 3/4: "feat(users): add user detail component"
    → Commit 4/4: "test(users): add user management tests"
  
  → ✓ Feature 2 complete on branch: feature/user-management
  → Push branch? (y/n)
  
... (continues for Features 3 and 4)
```

## Key Features

### ✅ Automatic Feature Detection
- Detects distinct features from file patterns
- Identifies feature boundaries automatically
- Counts features accurately

### ✅ Independence Analysis
- Checks if features share dependencies
- Detects cross-feature modifications
- Assesses feature coupling

### ✅ Strategy Recommendation
- Recommends best workflow strategy
- Explains why each option is suitable
- Allows user to choose or customize

### ✅ Separate Branch Execution
- Creates separate branch for each feature
- Commits each feature properly
- Enables separate PRs for each feature

### ✅ Progress Tracking
- Shows "Feature 1/4, Feature 2/4, ..."
- Progress for each feature
- Clear status updates

## Benefits

1. **Proper Separation:** Each feature gets its own branch and PR
2. **Independent Review:** Features can be reviewed separately
3. **Staged Rollout:** Can deploy features independently
4. **Easy Revert:** Can revert individual features if needed
5. **Better History:** Clean git history with proper feature separation

## Alternative: Single Branch Strategy

**If features are related and should be released together:**

```bash
/git --dry-run

# If features are related, recommends Option B:
Branch: feature/multi-feature-update
- All 4 features in one branch
- Commits grouped by feature:
  - Commit 1: "feat(auth): implement authentication"
  - Commit 2: "feat(users): add user management"
  - Commit 3: "feat(payments): implement payment processing"
  - Commit 4: "feat(notifications): add notification system"
- Single PR with all features
```

## Usage

```bash
# Auto-detect multiple features
/git --dry-run

# With explicit goal (helps with feature detection)
/git --dry-run goal: Multiple features completed

# Execute with separate branches (Option A)
/git execute strategy: separate-branches

# Execute with single branch (Option B)
/git execute strategy: single-branch
```
