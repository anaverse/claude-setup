---
description: Save session state for seamless continuation later
allowed-tools: Read, Write, Glob, Bash, Skill, mcp__MCP_DOCKER__obsidian_append_content, mcp__MCP_DOCKER__obsidian_simple_search, mcp__MCP_DOCKER__obsidian_get_file_contents, mcp__MCP_DOCKER__obsidian_list_files_in_dir, mcp__MCP_DOCKER__obsidian_patch_content, mcp__omni-cortex__cortex_remember, mcp__omni-cortex__cortex_end_session, mcp__omni-cortex__cortex_get_session_context, mcp__omni-cortex__cortex_link_memories
model: sonnet
argument-hint: [optional: topic name]
---

# Session Handoff

## Purpose

Create a structured handoff file capturing your current work state. Use this before ending a session so you (or someone else) can pick up exactly where you left off. Pairs with `/pickup`.

## Variables

TOPIC: $ARGUMENTS
HANDOFF_DIR: specs/handoffs/

## Instructions

- Review the current conversation to capture context
- Include specific file paths, not vague descriptions
- Number handoffs sequentially (001, 002, 003...)
- Be detailed about next steps - future you will thank present you

## Workflow

1. **Ensure folder exists**
   - Run `mkdir -p specs/handoffs`

2. **Determine handoff number**
   - List existing files in `specs/handoffs/`
   - Find the highest number and increment by 1
   - Format: `001`, `002`, `003`, etc.

3. **Generate filename**
   - Format: `[NNN]-[YYYY-MM-DD]-[topic].md`
   - Example: `001-2026-01-24-api-setup.md`
   - If no topic provided, use "session"

4. **Gather context from conversation**
   - What task/feature we were working on
   - What was completed
   - What is still in progress
   - What the next steps are
   - Any blockers or important decisions
   - Key files that were modified or are relevant

5. **Create handoff file**
   - Write to `specs/handoffs/[filename]`
   - Use the structured format below

6. **Write lean session summary to Obsidian vault (best-effort)**
   - This step is NON-BLOCKING — if Obsidian is unreachable, skip it and continue
   - Determine filename: `Claude/Sessions/YYYY-MM-DD-[project-name].md`
     - If a file with that name already exists, append `-2`, `-3`, etc.
     - Project name = current directory name in kebab-case
   - Write a lean summary using `obsidian_append_content`:
     ```markdown
     ---
     date: YYYY-MM-DD
     project: [project-name]
     tags: #claude/session
     ---

     # [project-name] — YYYY-MM-DD

     ## Worked on
     - [Item 1]
     - [Item 2]

     ## Decisions
     - [Decision 1]
     - [Decision 2]

     ## Next steps
     - [Step 1]
     - [Step 2]
     ```
   - If the vault write fails, log a note in the report but don't fail the handoff

7. **Save key decisions and solutions to Cortex (best-effort)**
   - This step is NON-BLOCKING — if Cortex is unreachable, skip and continue
   - Review the conversation for important decisions, solutions, and patterns
   - For each significant item, call `cortex_remember` — all fields MUST be nested inside a `params` object:
     ```
     cortex_remember({ params: { content: "...", tags: [...], type: "...", importance: N, context: "..." } })
     ```
     - **Decisions**: type "decision", importance 70-90
       - e.g. "Chose X over Y for [reason]"
     - **Solutions**: type "solution", importance 60-80
       - e.g. "Fixed [problem] by [approach]"
     - **Patterns/Learnings**: type "learning", importance 50-70
       - e.g. "This codebase uses [pattern] for [purpose]"
   - Tag each memory with: project name, relevant technologies, client name if applicable
   - If multiple memories are created, use `cortex_link_memories` to connect related ones
   - Aim for 2-5 memories per session — only save what's genuinely worth recalling later

8. **End the Cortex session (best-effort)**
   - This step is NON-BLOCKING — if Cortex is unreachable, skip and continue
   - Call `cortex_end_session` with:
     - The session_id from the current session (if `/daily` was run, reuse that ID; otherwise use the auto-generated one)
     - A brief summary of what was accomplished
     - key_learnings: list of 2-3 key takeaways from this session

9. **Generate Excalidraw session diagram (best-effort)**
   - This step is NON-BLOCKING — if it fails, skip and continue
   - Use the `/excalidraw-diagram` skill to generate the diagram
   - **Diagram layout** — hybrid timeline + project state:
     - **Left side**: Flowchart/timeline of completed items and in-progress work (top to bottom)
     - **Right side**: Mind map of project state — key files, decisions, blockers, connections
     - **Bottom**: Next steps as a horizontal row
   - **Filename**: `Claude/Sessions/YYYY-MM-DD-[project-name].diagram.md` (same base name as session note)
   - Write the Excalidraw `.md` file to the vault using `obsidian_append_content`
   - Append an embed link to the bottom of the session note using `obsidian_patch_content`:
     ```markdown

     ## Visual Map
     ![[YYYY-MM-DD-[project-name].diagram]]
     ```

10. **Confirm creation**
   - Report the handoff filename, vault summary status, Cortex status, and diagram status
   - Remind user to run `/pickup` in next session

## Handoff File Format

```markdown
# Session Handoff - [YYYY-MM-DD]

## Context
[1-2 sentences: What we were working on and why]

## Completed
- [Item 1]
- [Item 2]

## In Progress
- [Current state/status of ongoing work]

## Next Steps
1. [Most important next action]
2. [Second priority]
3. [Third priority]

## Key Files
- [path/to/file1] - [brief description]
- [path/to/file2] - [brief description]

## Blockers / Notes
- [Any issues, decisions, or context needed]
```

## Report

```
Handoff Created

File: specs/handoffs/[filename]
Vault: Claude/Sessions/[filename] [written / skipped - Obsidian unreachable]
Cortex: [N memories saved / skipped] | Session [ended / skipped]
Diagram: Claude/Sessions/[filename].diagram [written / skipped]
Number: [NNN]
Topic: [topic]

To resume: Run `/daily` (full briefing) or `/pickup` (handoff only) in your next session
```
