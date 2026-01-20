# Setting Up the `/generate-rule` Slash Command

According to the [official Cursor documentation](https://cursor.com/docs), custom slash commands are created by placing Markdown files in the `.cursor/commands/` directory. The command file is already created at `.cursor/commands/generate-rule.md` and will be automatically available!

## How It Works (Official Method)

Per [Cursor's documentation](https://cursor.com/changelog/1-6), custom slash commands work as follows:

1. **Commands Directory:**
   - Commands are stored as Markdown files in `.cursor/commands/` directory
   - Each `.md` file becomes a slash command
   - The filename (without extension) becomes the command name

2. **Using the Command:**
   - Type `/` in the Agent chat input
   - Select `generate-rule` from the dropdown menu
   - The command will execute with the content from `.cursor/commands/generate-rule.md`

3. **Command is Ready:**
   - ✅ The file `.cursor/commands/generate-rule.md` already exists
   - ✅ It contains the rule generation instructions
   - ✅ It references your project's rule templates and validators

## What the Command Does

When you use `/generate-rule`, the AI will:

1. **Reference the rule generation guide** at `.cursor/rules/meta/rule-generation-guide.mdc`
2. **Validate against** `.cursor/rules/meta/rule-generator.mdc` requirements
3. **Ask for:**
   - Rule purpose (what should it enforce?)
   - Category (backend/frontend/general/workflow/meta)
   - Rule type (always/manual/guideline/autoAttached)
4. **Generate the rule** using the proper template
5. **Place it** in the correct category folder
6. **Ensure** all required fields are present

## Additional Support

The rule handler at `.cursor/rules/meta/generate-rule-command.mdc` will also automatically detect when you ask to generate rules (even without the slash command) and provide guidance.

## Quick Reference

- **Template:** `.cursor/rules/meta/rule-generation-guide.mdc`
- **Validation:** `.cursor/rules/meta/rule-generator.mdc`
- **Command Doc:** `.cursor/commands/generate-rule.md`

