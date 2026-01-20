# Generate Cursor Rule

Generate a new cursor rule following the project's standards and validation requirements.

## Instructions

When this command is invoked, you should:

1. **Ask the user for:**
   - What should the rule enforce? (e.g., "require error handling in API routes", "enforce TypeScript strict mode")
   - Which category? (backend/frontend/general/workflow/meta)
   - Rule type? (always/manual/guideline/autoAttached)

2. **Reference these files:**
   - Template guide: `.cursor/rules/meta/rule-generation-guide.mdc`
   - Validation rules: `.cursor/rules/meta/rule-generator.mdc`

3. **Generate the rule using this template structure:**

```yaml
---
description: [Brief description of what this rule enforces]
globs: [Optional: file patterns like **/*.ts, **/*.tsx]
alwaysApply: true  # or false
---

rule "[Descriptive Rule Name]" {
  type: "always"  # or "manual", "guideline", "autoAttached"
  when: file.path contains "/pattern/" or block.text contains "keyword"
  condition: file.exists("path") && file.read("path") includes "text"  # Optional
  error: "❌ Clear error message explaining the violation"
  # OR use: warn, message, or valid instead of error
}
```

4. **Category placement:**
   - `backend/` - API, server, database rules
   - `frontend/` - Components, UI, styling rules
   - `general/` - Cross-cutting concerns (memory, modes, behavior)
   - `workflow/` - Process rules (user stories, planning, tasks)
   - `meta/` - Rules about the rule system itself

5. **Validation checklist (ensure all are met):**
   - ✓ YAML frontmatter with `---` delimiters
   - ✓ Description field included
   - ✓ Appropriate globs pattern (or omit if alwaysApply: true)
   - ✓ alwaysApply explicitly set
   - ✓ Rule name in double quotes
   - ✓ Rule type specified
   - ✓ When condition defined
   - ✓ Error/warn/message/valid field included
   - ✓ File placed in correct category folder

6. **Rule types:**
   - `always`: Enforced automatically, blocks violations
   - `manual`: Reminder/guideline, doesn't block
   - `guideline`: Best practice suggestion
   - `autoAttached`: Auto-attached in specific contexts

7. **After generation:**
   - Validate the rule against `.cursor/rules/meta/rule-generator.mdc`
   - Place the file in the appropriate category folder
   - Use descriptive, action-oriented names
   - Show the user the generated rule file path

