# /timer Command - Hubstaff Time Tracking

## Description

Analyzes current chat context (goals, tasks, work being discussed) and suggests Hubstaff tasks to track time. Automatically creates or switches to appropriate Hubstaff tasks based on what you're working on.

## Usage

```bash
/timer
/timer start
/timer suggest
/timer switch: <task-name>
```

**Parameters:**

- No parameters: Analyze chat context and suggest tasks, then start timer
- `start`: Start timer on suggested task (after analysis)
- `suggest`: Only suggest tasks, don't start timer
- `switch: <task-name>`: Switch to specific task by name

## What It Does

1. **Analyzes Chat Context** (Retro ∘ Ana):
   - Reviews conversation history for goals and tasks
   - Identifies what you're currently working on
   - Extracts feature areas, components, or work items
   - Detects project context from file paths and discussions

2. **Extracts Task Information** (Kata):
   - Compresses context to task name
   - Identifies Hubstaff project from workspace
   - Determines if task already exists or needs creation

3. **Suggests Hubstaff Tasks** (Weave):
   - Matches work context to Hubstaff projects
   - Suggests existing tasks or proposes new ones
   - Provides task details and rationale

4. **Starts Timer** (Telo ∘ Latch):
   - Matches to existing Hubstaff project/task via CLI
   - Stops current time entry if running
   - Starts new time entry on suggested task via CLI
   - Confirms timer started

## Operator Sequence

Retro ∘ Ana ∘ Kata ∘ Weave ∘ Telo ∘ Latch

**Effective λ:** 0.47 (moderate dissipation)

**Trajectory:** Chat Context → Understanding → Task Extraction → Integration → Goal Achievement → Stabilization

## Analysis Process

### Step 1: Context Analysis

Analyzes:
- **Recent messages**: What goals/tasks were discussed
- **File references**: What files/components are being worked on
- **Git context**: Current branch, recent commits
- **Project structure**: Workspace name, project type
- **Feature areas**: Auth, API, UI, docs, etc.

### Step 2: Task Extraction

Extracts task name from:
1. **Explicit goals**: "I want to implement user authentication"
2. **Branch names**: `feature/user-auth` → "User Authentication"
3. **File paths**: `app/auth/login.tsx` → "Authentication - Login"
4. **Feature areas**: Auth files → "User Authentication"
5. **Component names**: Working on Button component → "Button Component"

### Step 3: Hubstaff Integration

Uses Hubstaff Desktop CLI ([Scripted Control](https://support.hubstaff.com/what-is-scripted-control/)):
- `/Applications/Hubstaff.app/Contents/MacOS/HubstaffCLI organizations` - Get organizations
- `/Applications/Hubstaff.app/Contents/MacOS/HubstaffCLI projects` - Get projects
- `/Applications/Hubstaff.app/Contents/MacOS/HubstaffCLI tasks <project_id>` - Get tasks
- `/Applications/Hubstaff.app/Contents/MacOS/HubstaffCLI status` - Check current tracking
- `/Applications/Hubstaff.app/Contents/MacOS/HubstaffCLI start_project <id>` - Start project
- `/Applications/Hubstaff.app/Contents/MacOS/HubstaffCLI start_task <id>` - Start task
- `/Applications/Hubstaff.app/Contents/MacOS/HubstaffCLI stop` - Stop current tracking

## Examples

### Basic Usage

```bash
# Analyze context and suggest task
/timer

# Output:
# 🔍 Analyzing your current work...
# 
# 📋 Task Suggestions:
# 1. User Authentication (existing)
#    - Matched from: branch "feature/user-auth"
#    - Project: Metacerius Agent
# 
# Start timer on this task? [Yes] [No] [Suggest more]
```

### Start Timer

```bash
# Start timer on suggested task
/timer start

# Output:
# ✅ Started timer on: User Authentication
# ⏱️  Time tracking active
# 📁 Project: Metacerius Agent
```

### Only Suggest

```bash
# Just get suggestions without starting
/timer suggest

# Output:
# 📋 Task Suggestions:
# 1. User Authentication (existing)
# 2. API Development (existing)
# 3. Frontend Components (existing)
# 
# Which task should I start? [1] [2] [3] [Create new]
```

### Switch to Specific Task

```bash
# Switch to specific task
/timer switch: User Authentication

# Output:
# ✅ Switched to: User Authentication
# ⏱️  Stopped previous task
# ▶️  Started tracking on: User Authentication
```

## Context Analysis Examples

### Example 1: Working on Authentication

**Chat context:**
- "I need to implement user login"
- Files: `app/auth/login.tsx`
- Branch: `feature/user-auth`

**Analysis:**
```
🔍 Analyzing context...
- Goal: Implement user login
- Files: app/auth/login.tsx
- Branch: feature/user-auth
- Feature area: authentication

📋 Suggested Task: User Authentication
```

### Example 2: Working on API

**Chat context:**
- "Let's add the user endpoint"
- Files: `apps/backend/app/routes/users.py`
- Branch: `feature/user-api`

**Analysis:**
```
🔍 Analyzing context...
- Goal: Add user endpoint
- Files: apps/backend/app/routes/users.py
- Branch: feature/user-api
- Feature area: api

📋 Suggested Task: User API Endpoint
```

### Example 3: Multiple Tasks Discussed

**Chat context:**
- Discussed authentication, then switched to UI components
- Multiple files: `app/auth/*`, `app/components/Button.tsx`

**Analysis:**
```
🔍 Analyzing context...
- Recent focus: UI components
- Files: app/components/Button.tsx
- Feature area: ui

📋 Suggested Task: Button Component
```

## Output Format

### Task Suggestion

```
🔍 Analyzing your current work...

📋 Task Suggestions:

1. [Task Name] ([status])
   - Matched from: [source]
   - Project: [project name]
   - Details: [description if available]

2. [Alternative Task] ([status])
   - Matched from: [source]
   - Project: [project name]

Start timer on task #1? [Yes] [No] [Show more]
```

### Timer Started

```
✅ Timer Started!

📁 Project: [Project Name]
📝 Task: [Task Name]
⏱️  Started at: [timestamp]
🔄 Switched from: [previous task] (if applicable)
```

### Error Messages

```
⚠️  No matching Hubstaff project found
Available projects:
- Metacerius Agent (ID: 123)
- Other Project (ID: 456)

Should I use "Metacerius Agent"? [Yes] [No]
```

```
❌ Could not connect to Hubstaff MCP server
Please check your MCP configuration in Cursor settings.
See: docs/HUBSTAFF_MCP_SETUP.md
```

## Integration with Chat Context

The command analyzes:

1. **Explicit Goals**: "I want to...", "Let's implement...", "Need to add..."
2. **File References**: Files mentioned or being edited
3. **Git Context**: Branch names, commit messages
4. **Project Structure**: Workspace name, project type
5. **Feature Patterns**: Auth, API, UI, docs, testing

## Smart Matching

### Project Matching

- Matches workspace name to Hubstaff project
- Fuzzy matching: "metacerius-agent" → "Metacerius Agent"
- Falls back to first available project if no match

### Task Matching

- Exact match: "User Authentication" → existing task
- Partial match: "auth" → "User Authentication"
- Creates new if no match found

### Context Priority

1. **Explicit goals** in chat (highest priority)
2. **Branch names** (feature/fix prefixes)
3. **File paths** (component/module names)
4. **Feature areas** (auth, api, ui, etc.)
5. **Generic** ("Development Work" as fallback)

## Error Handling

### No Context Found

```
⚠️  Could not determine what you're working on.
Please provide more context or use:
/timer switch: <task-name>
```

### Multiple Matches

```
Found multiple similar tasks:
1. User Authentication (ID: 100)
2. User Auth Refactor (ID: 101)

Which one should I use? [1] [2] [Create new]
```

### Hubstaff App Not Running

```
⚠️  Hubstaff desktop app is not running
The CLI will auto-start the app, but you may need to:
1. Open Hubstaff desktop app manually
2. Ensure you're logged in
3. Grant scripted control permissions in app preferences
```

## When to Use

- **Starting new work**: Analyze context and start tracking
- **Switching tasks**: Automatically switch when context changes
- **Quick tracking**: Fast way to start timer on current work
- **Task discovery**: Find existing tasks related to current work

## Related Commands

- `/goal`: Define goals that timer can track
- `/status`: Check current work status
- `/plan`: Create plans that timer can reference

## References

- [Hubstaff Scripted Control](https://support.hubstaff.com/what-is-scripted-control/) - Official CLI documentation
- [Hubstaff Auto Task Switching](../docs/HUBSTAFF_AUTO_TASK_SWITCHING.md)

