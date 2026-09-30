---
name: session-handoff
description: Save current work state to a handoff file and mirror a lean session note into Obsidian for later continuation. Use when the user says handoff, save session, wrap up, leave notes, pause work, save to Obsidian, second brain, or prepare to resume later.
---

# Session Handoff

Create a structured handoff file under `specs/handoffs/` and mirror a concise session note into the user's Obsidian vault.

## Workflow

1. Ensure `specs/handoffs/` exists.
2. Determine the next sequential number from existing files.
3. Generate filename: `[NNN]-[YYYY-MM-DD]-[topic].md`.
4. Capture:
   - Current task and why it matters.
   - Completed work.
   - In-progress state.
   - Concrete next steps.
   - Key files and their purpose.
   - Blockers, decisions, and verification status.
5. Write the handoff file.
6. Mirror a lean session note to Obsidian, best-effort:
   - Default vault root: `/Users/ana/Documents/flowlabs`.
   - If unavailable, try `/Users/ana/Documents/Documents - Ana’s Mac mini/flowlabs`.
   - If `CODEX_OBSIDIAN_VAULT` is set, use that path first.
   - Create the note under `Claude/Sessions/`.
   - Filename format: `[YYYY-MM-DD]-[project-name].md`.
   - If the file already exists, append a new section instead of overwriting it.
   - If the vault write fails, keep the project handoff and report the Obsidian write as skipped.
7. Report both paths and how to resume.

Do not depend on Cortex or Claude-specific session tools. Keep all writes file-based and portable.

## File Format

```markdown
# Session Handoff - [YYYY-MM-DD]

## Context
[1-2 sentences.]

## Completed
- [Item.]

## In Progress
- [Current state.]

## Next Steps
1. [Most important next action.]
2. [Second action.]

## Key Files
- [path] - [why it matters.]

## Validation
- [What passed, failed, or was not run.]

## Blockers / Notes
- [Important context.]
```

## Obsidian Note Format

```markdown
---
date: [YYYY-MM-DD]
project: [project-name]
tags:
  - codex/session
  - handoff
---

# [project-name] - [YYYY-MM-DD]

## Worked On
- [Item.]

## Decisions
- [Decision.]

## Next Steps
- [Step.]

## Local Handoff
- [relative path to specs/handoffs file]

## Validation
- [What passed, failed, or was not run.]
```

## Report Format

```markdown
Handoff created.

File: specs/handoffs/[filename]
Obsidian: Claude/Sessions/[filename] [written / skipped - reason]

To resume: ask Codex to "pickup from the latest handoff".
```
