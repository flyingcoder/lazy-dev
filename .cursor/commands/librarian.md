# /librarian Command

## Description

Manages AI-generated documentation files by organizing, validating, categorizing, and maintaining documentation standards. Integrates with the automated documentation system to ensure AI-generated docs follow project conventions.

**CRITICAL RULE**: For `apps/ai-services/` directory, only `README.md` is allowed in root. All other documentation must be in root monorepo `docs/` directory (see "Monorepo Documentation Structure Rules" section below).

## Usage

```bash
/librarian <file-path>
/librarian organize: <file-path>
/librarian validate: <file-path>
/librarian categorize: <file-path>
/librarian check: <file-path>
/librarian evaluate: <file-path>
/librarian clean: <directory>
```

**Parameters:**

- `file-path`: Path to documentation file to manage
- `organize`: Organize file location, metadata, and structure
- `validate`: Validate documentation follows standards (metadata, format, location)
- `categorize`: Auto-categorize and suggest proper location
- `check`: Quick check for issues (duplicates, broken links, missing metadata)
- `evaluate`: Full evaluation (relevance, accuracy, value, completeness)
- `clean`: Clean and organize all docs in a directory

## Operator Formula

Organize: Retro + Ana + Axis + Bind
Validate: Ortho + Meta + Latch
Categorize: Ana + Axis + Bind
Check: Retro + Non + Weave
Evaluate: Retro + Ana + Non + Weave + Kata

## Operator Sequences

**Organize:** `Retro ∘ Ana ∘ Axis ∘ Bind` (λ_eff = 0.35)
**Validate:** `Ortho ∘ Meta ∘ Latch` (λ_eff = 0.47)
**Categorize:** `Ana ∘ Axis ∘ Bind` (λ_eff = 0.35)
**Check:** `Retro ∘ Non ∘ Weave` (λ_eff = 0.65)
**Evaluate:** `Retro ∘ Ana ∘ Non ∘ Weave ∘ Kata` (λ_eff = 0.55)

## Effective λ

- Organize: λ_eff = 0.35 (low dissipation - structural alignment)
- Validate: λ_eff = 0.47 (moderate dissipation - correction and reflection)
- Categorize: λ_eff = 0.35 (low dissipation - classification)
- Check: λ_eff = 0.65 (moderate-high dissipation - anomaly detection)
- Evaluate: λ_eff = 0.55 (moderate dissipation - comprehensive assessment)

## Trajectories

**Organize:** Unorganized Doc → Pattern Recognition → Classification → Structural Alignment → Organized Doc
**Validate:** Unvalidated Doc → Correction → Self-Reference → Stabilization → Validated Doc
**Categorize:** Uncategorized Doc → Classification → Alignment → Binding → Categorized Doc
**Check:** Unknown State → Backward Analysis → Anomaly Detection → Integration → Issue Report
**Evaluate:** Unassessed Doc → Relevance Check → Value Assessment → Contradiction Challenge → Coherent Evaluation → Action Decision

## What It Does

### Organize Mode
1. **Retro (↶)**: Work backward to understand doc context and existing patterns
2. **Ana (↑)**: Elevate to understand doc purpose and relationships
3. **Axis (📍)**: Align to proper category and location
4. **Bind (🔗)**: Create structural cohesion with cross-references

### Validate Mode
1. **Ortho (⊥)**: Correct metadata, format, and structure issues
   - Verify dates using file system properties (creation date, modification date)
   - Check `created_date` matches file creation date
   - Check `last_updated` is reasonable compared to file modification date
   - Flag discrepancies between metadata dates and file system dates
2. **Meta (⟲)**: Self-reference to verify completeness and standards compliance
3. **Latch (🔒)**: Stabilize validated documentation

### Categorize Mode
1. **Ana (↑)**: Elevate to understand document type and purpose
2. **Axis (📍)**: Determine proper category (decision, architecture, guide, reference, etc.)
3. **Bind (🔗)**: Suggest location and cross-references

### Check Mode
1. **Retro (↶)**: Trace backward to check references and dependencies
2. **Non (¬)**: Challenge to find issues (duplicates, broken links, missing metadata)
   - **Date verification**: Quick check if metadata dates match file system dates
   - Compare `created_date` vs file creation date
   - Compare `last_updated` vs file modification date
   - Flag discrepancies (file system is source of truth)
3. **Weave (🕸️)**: Integrate findings into issue report

### Evaluate Mode (Full Documentation Evaluation Framework)

Applies the complete 6-criteria evaluation framework from `.cursor/rules/workflow/documentation-evaluation.mdc`:

**Operator Sequence:** `Retro ∘ Ana ∘ Non ∘ Weave ∘ Kata` (λ_eff = 0.55)

**Evaluation Process:**

1. **Retro (↶)**: Work backward to assess relevance (Criterion 1)
   - Trace documentation to code/decision it describes
   - Check if referenced files exist (use `codebase_search`, `grep`)
   - Verify if decisions are still valid
   - Identify what changed since creation
   - **Decision**: >80% valid → Keep | 50-80% → Update | <50% → Trash

2. **Ana (↑)**: Elevate to understand value and purpose (Criterion 3)
   - Identify document's purpose
   - Assess if purpose is ongoing or completed
   - Check cross-references from other docs
   - Evaluate reference frequency
   - **Decision**: Ongoing reference → Keep | One-time → Trash | Historical → Archive

3. **Non (¬)**: Challenge to find contradictions and inaccuracies (Criterion 2)
   - Compare documentation with current codebase
   - Test examples and commands
   - Check for contradictions with other docs
   - **Verify dates using file system properties** (CRITICAL):
     - Check `created_date` matches file creation date (use `stat` command)
     - Check `last_updated` is reasonable compared to file modification date
     - Flag discrepancies: metadata dates vs file system dates
     - File system dates are source of truth, not content
   - Identify discrepancies
   - **Decision**: All correct → Keep | Minor errors → Update | Major errors → Update/Trash

4. **Weave (🕸️)**: Integrate evaluation results (Criterion 4 + Synthesis)
   - Check completeness (metadata, sections, cross-references)
   - Compare with template requirements
   - Synthesize findings from all criteria
   - Create coherent assessment
   - **Decision**: Complete → Keep | Missing fields → Update

5. **Para (∥) + Non (¬)**: Check duplication (Criterion 5)
   - Search for similar content elsewhere
   - Check if superseded by newer documentation
   - Identify canonical documentation
   - **Decision**: Unique → Keep | Duplicate → Trash | Can merge → Merge

6. **Axis (📍) + Bind (🔗)**: Check categorization (Criterion 6)
   - Identify document type
   - Assess content characteristics
   - Determine proper category and location
   - **Decision**: Correct location → Keep | Wrong location → Move

7. **Kata (↓)**: Compress to clear decision
   - Make final decision (keep/update/move/deprecate/trash)
   - Define action items
   - Generate evaluation report

## Examples

```bash
/librarian validate: docs/new-feature.md
# Validates metadata, format, and structure
# Verifies dates using file system properties:
# - created_date vs file creation date
# - last_updated vs file modification date
# - Flags discrepancies (file system is source of truth)

/librarian categorize: docs/untitled-doc.md
# Auto-categorizes and suggests proper location

/librarian organize: docs/ai-generated/decision-123.md
# Organizes location, metadata, and cross-references

/librarian check: docs/
# Quick check for all common issues

/librarian evaluate: docs/old-guide.md
# Full evaluation using 6-criteria framework:
# 1. Relevance (Retro) - Are references valid?
# 2. Accuracy (Non) - Is information correct?
# 3. Value (Ana) - Is it useful?
# 4. Completeness (Weave) - Is it complete?
# 5. Duplication (Para + Non) - Is it unique?
# 6. Categorization (Axis) - Is it in right place?
# Output: Complete evaluation report with action items

/librarian clean: docs/ai-generated/
# Clean and organize all AI-generated docs in directory
```

## Output

### Validate Mode
- Metadata validation results
- **Date verification** (file system vs metadata):
  - File creation date vs `created_date` in metadata
  - File modification date vs `last_updated` in metadata
  - Discrepancies flagged with file system dates as source of truth
- Format compliance check
- Location validation
- Missing required fields
- Fixes applied or suggested

### Categorize Mode
- Suggested category (decision, architecture, guide, reference, etc.)
- Suggested location (`docs/decisions/`, `docs/guides/`, etc.)
- Required metadata fields
- Suggested cross-references

### Organize Mode
- File moved to proper location (if needed)
- Metadata updated/added
- Cross-references created
- Index updated
- Summary of changes

### Check Mode
- Duplicate detection
- Broken link detection
- Missing metadata fields
- **Date verification** (quick check):
  - Metadata dates vs file system dates
  - Discrepancies flagged
- Outdated references
- Quick issue report

### Evaluate Mode (Full Evaluation Report)

**Evaluation Report Format:**

```markdown
## Document Evaluation: {FILENAME}

**Evaluated**: {YYYY-MM-DD}
**Evaluator**: /librarian command

### Step 1: Relevance (Retro) - "Is it still relevant?"

**Referenced Files**: 
- ✅ {file1} - exists
- ❌ {file2} - not found
- ⚠️ {file3} - moved to {new_location}

**Referenced Decisions**:
- ✅ {decision1} - still valid
- ❌ {decision2} - superseded by {new_decision}

**Relevance Score**: {percentage}%
**Decision**: Keep | Update | Trash

### Step 2: Accuracy (Non) - "Is it correct?"

**Code Matches**: ✅ Yes | ❌ No
**Commands Work**: ✅ Yes | ❌ No
**Contradictions**: None | {list}

**Date Verification** (File System vs Metadata):
- **File Creation Date** (from file system): {YYYY-MM-DD}
- **created_date** (from metadata): {YYYY-MM-DD}
- **Match**: ✅ Yes | ❌ No | ⚠️ Close (within 1 day)
- **File Modification Date** (from file system): {YYYY-MM-DD}
- **last_updated** (from metadata): {YYYY-MM-DD}
- **Match**: ✅ Yes | ❌ No | ⚠️ Close (within 1 day)
- **Discrepancy**: {description if dates don't match}
- **Source of Truth**: File system dates (not metadata content)

**Accuracy Score**: {percentage}%
**Decision**: Keep | Update | Trash

### Step 3: Value (Ana) - "Is it useful?"

**Purpose**: {ongoing_reference | completed_task | historical_record}
**Cross-References**: {count} other docs reference this
**Frequency**: {frequent | occasional | one-time}

**Value Assessment**: Useful | Historical | One-time
**Decision**: Keep | Archive | Trash

### Step 4: Completeness (Weave) - "Is it complete?"

**Metadata**: ✅ Complete | ⚠️ Missing {fields} | ❌ Incomplete
**Sections**: ✅ Complete | ⚠️ Missing {sections} | ❌ Incomplete
**Cross-References**: ✅ All valid | ⚠️ {count} broken

**Completeness Score**: {percentage}%
**Decision**: Keep | Update | Trash

### Step 5: Duplication (Para + Non) - "Is it duplicated?"

**Similar Docs**: {list or none}
**Canonical**: {canonical_doc or none}
**Superseded**: No | Yes by {doc}

**Duplication Status**: Unique | Duplicate | Superseded
**Decision**: Keep | Merge | Trash

### Step 6: Categorization (Axis) - "Is it in right place?"

**Current Category**: {category}
**Correct Category**: {category}
**Location**: ✅ Correct | ❌ Should be {location}

**Categorization**: ✅ Correct | ⚠️ Move to {location}

### Final Decision

**Overall Assessment**: Keep | Update | Move | Deprecate | Trash

**Reasoning**: {brief explanation}

**Actions**:
- [ ] {action1}
- [ ] {action2}
```

**Quick Decision Matrix:**

✅ **Keep if ALL of these are true:**
- Referenced code/files exist (>80% valid)
- Information is accurate
- Provides ongoing value (not one-time use)
- Content is unique (not duplicate)
- In correct category

⚠️ **Update if:**
- Minor errors or outdated info (fixable)
- Missing metadata or sections
- Some references broken (50-80% valid)
- Wrong category (but content is good)

📦 **Move if:**
- Wrong category but content is good
- Location doesn't match content type

⚠️ **Deprecate if:**
- Superseded by newer documentation
- Still has historical value
- Information is outdated but important to preserve

🗑️ **Trash if:**
- Referenced code/files don't exist (<50% valid)
- Information is wrong and unfixable
- One-time use (task complete)
- Duplicate of other docs
- No longer relevant
- Migration complete (if no historical value)

## When to Use

- After AI generates documentation
- Before committing new documentation
- When documentation structure is unclear
- When organizing multiple AI-generated docs
- When validating documentation standards
- When evaluating documentation lifecycle
- When cleaning up documentation

## Integration with Documentation System

The `/librarian` command integrates with:
- `.cursor/rules/workflow/automated-documentation.mdc` - Creation and organization rules
- `.cursor/rules/workflow/documentation-evaluation.mdc` - **Complete evaluation framework (6 criteria)**
- `.cursor/rules/workflow/documentation-pre-commit-validation.mdc` - Validation standards
- `.cursor/rules/workflow/documentation-templates.mdc` - Documentation templates
- `docs/guides/documentation-evaluation-quick-reference.md` - Quick reference guide

## Monorepo Documentation Structure Rules

### AI Services Documentation Location Rule

**CRITICAL RULE**: For `apps/ai-services/` directory:

1. **Root Level**: Only `README.md` is allowed in `apps/ai-services/` root
   - ❌ **NO** status files (NEXT_STEPS.md, REFACTORING_STATUS.md, etc.) in root
   - ❌ **NO** separate `docs/` folder in `apps/ai-services/`
   - ✅ **ONLY** `README.md` in root

2. **All Documentation Location**: All documentation must be in root monorepo `docs/` directory
   - ✅ **Guides**: `docs/guides/ai-services/` (e.g., `orm-connection-guide.md`)
   - ✅ **Migration/Status**: `docs/migration/ai-services/` (e.g., `REFACTORING_STATUS.md`, `NEXT_STEPS.md`)
   - ✅ **Test Documentation**: `apps/ai-services/tests/` (test-specific docs can stay in tests/)

3. **When Cleaning `apps/ai-services/`**:
   - Move all `.md` files (except `README.md`) to appropriate `docs/` subdirectories
   - Move guides to `docs/guides/ai-services/`
   - Move status/migration docs to `docs/migration/ai-services/`
   - Remove any `apps/ai-services/docs/` directory
   - Update all cross-references to reflect new locations

4. **Cross-Reference Updates**:
   - Update relative paths in moved files
   - Update references in `apps/ai-services/README.md`
   - Update references in other documentation files

**Example Structure**:
```
apps/ai-services/
├── README.md ✅ (only file allowed in root)
└── tests/
    ├── README.md ✅ (test docs can stay)
    └── docs/ ✅ (test-specific docs)

docs/
├── guides/
│   └── ai-services/
│       └── orm-connection-guide.md ✅
└── migration/
    └── ai-services/
        ├── REFACTORING_STATUS.md ✅
        ├── REFACTORING_FINAL_SUMMARY.md ✅
        ├── REFACTORING_COMPLETE.md ✅
        └── NEXT_STEPS.md ✅
```

**Date Verification Integration:**

The librarian command verifies dates using file system properties (not trusting content):

1. **File System Date Retrieval:**
   - Use `stat` command to get file creation date
   - Use `stat` command to get file modification date
   - File system dates are the source of truth

2. **Date Comparison:**
   - Compare `created_date` (metadata) with file creation date (file system)
   - Compare `last_updated` (metadata) with file modification date (file system)
   - Flag discrepancies as validation errors

3. **Date Correction:**
   - Suggest updating metadata to match file system dates
   - Use file system dates when metadata is missing or incorrect
   - Follow temporal reference system: `{file.creationDate}`, `{file.modificationDate}`

**Evaluation Framework Integration:**

The `evaluate` mode fully implements the documentation evaluation framework with:

1. **6 Evaluation Criteria:**
   - **Relevance (Retro)**: Are referenced files/decisions still valid?
   - **Accuracy (Non)**: Does documentation match codebase?
   - **Value (Ana)**: Is it useful or one-time use?
   - **Completeness (Weave)**: Has required metadata and sections?
   - **Duplication (Para + Non)**: Is content unique or duplicate?
   - **Categorization (Axis)**: Is it in correct category/location?

2. **Decision Trees:** Each criterion has clear decision logic
3. **Evaluation Checklist:** Systematic evaluation process
4. **Evaluation Template:** Standardized report format
5. **Action Recommendations:** Clear next steps (keep/update/move/deprecate/trash)

## Validation Standards

Validates against:
- Required YAML frontmatter (documentation_type, purpose, status, dates)
- **Date Verification** (CRITICAL):
  - `created_date` must match file creation date (from file system)
  - `last_updated` must be reasonable compared to file modification date
  - File system dates are source of truth, not metadata content
  - Use `stat` command to get file system dates:
    - macOS/Linux: `stat -f "%Sm" -t "%Y-%m-%d" <file-path>` (creation)
    - macOS/Linux: `stat -f "%Sm" -t "%Y-%m-%d" <file-path>` (modification)
  - Flag discrepancies as validation errors
- Proper location patterns (decisions/, guides/, architecture/, etc.)
- Metadata completeness
- Cross-reference validity
- File naming conventions

## Categories Supported

- **decisions**: Architectural Decision Records (ADRs) - `docs/decisions/DDD-description.md`
- **architecture**: System architecture docs - `docs/architecture/TOPIC.md` or root
- **guides**: How-to and setup guides - `docs/guides/TOPIC.md`
- **workflows**: Process documentation - `docs/workflows/WORKFLOW.md`
- **migrations**: Migration plans - `docs/NAME_MIGRATION_PLAN.md`
- **status**: Implementation status - `docs/IMPLEMENTATION_STATUS.md`
- **reference**: Quick references - `docs/QUICK_REFERENCE.md` or `docs/reference/TOPIC.md`
- **uncategorized**: Documents needing manual review - `docs/uncategorized/FILENAME.md`

## Evaluation Framework Details

### Quick Decision Tree

```
Is documentation still relevant?
├─ No (<50% valid) → TRASH
└─ Yes (>50% valid)
    ↓
Is documentation accurate?
├─ Completely wrong → TRASH
├─ Major errors (fixable) → UPDATE
├─ Minor errors → UPDATE
└─ Accurate
    ↓
Is documentation useful?
├─ One-time use (task complete) → TRASH
├─ Historical value → Keep or archive
└─ Ongoing reference → Keep
    ↓
Is documentation complete?
├─ Missing major sections → UPDATE
├─ Missing minor fields → UPDATE
└─ Complete
    ↓
Is documentation unique?
├─ Duplicate → TRASH (link to canonical)
├─ Can merge → MERGE
└─ Unique → Keep
    ↓
Is documentation in correct category?
├─ Wrong category → MOVE
└─ Correct category → KEEP
```

### Common Evaluation Scenarios

**Scenario 1: Migration Complete**
- **Indicators**: Migration status complete, work done
- **Action**: Move to `docs/.trash/` (one-time use)

**Scenario 2: Decision Superseded**
- **Indicators**: Newer decision exists, old decision superseded
- **Action**: Mark `status: deprecated`, add `replaced_by:`, keep for reference

**Scenario 3: Outdated Commands/Examples**
- **Indicators**: Commands don't work, examples broken
- **Action**: If fixable → Update, else → Trash

**Scenario 6: Date Discrepancy**
- **Indicators**: 
  - `created_date` in metadata doesn't match file creation date (from file system)
  - `last_updated` in metadata doesn't match file modification date (from file system)
  - Dates in metadata are inconsistent with file system
- **Action**: 
  - Update metadata dates to match file system dates (file system is source of truth)
  - Flag as validation error
  - Suggest correction: Use file system dates when metadata is missing or incorrect
  - Use temporal reference system: `{file.creationDate}`, `{file.modificationDate}`

**Scenario 4: Duplicate Content**
- **Indicators**: Same content in another doc, canonical exists
- **Action**: Move to `docs/.trash/`, update references to canonical

**Scenario 5: Wrong Category**
- **Indicators**: Content doesn't match location, type mismatch
- **Action**: Move to correct category with proper metadata

## Related

- Use `/goal` to define documentation goals
- Use `/attack` to find flaws in documentation structure
- See `.cursor/rules/workflow/automated-documentation.mdc` for creation rules
- See `.cursor/rules/workflow/documentation-evaluation.mdc` for complete evaluation framework
- See `docs/guides/documentation-evaluation-quick-reference.md` for quick reference
- See `.cursor/rules/workflow/documentation-pre-commit-validation.mdc` for validation standards

