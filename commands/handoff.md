---
description: Save session state for seamless continuation later
allowed-tools: Read, Write, Glob, Bash, mcp__MCP_DOCKER__obsidian_append_content, mcp__MCP_DOCKER__obsidian_simple_search, mcp__MCP_DOCKER__obsidian_get_file_contents, mcp__MCP_DOCKER__obsidian_list_files_in_dir, mcp__MCP_DOCKER__obsidian_patch_content, mcp__omni-cortex__cortex_remember, mcp__omni-cortex__cortex_end_session, mcp__omni-cortex__cortex_get_session_context, mcp__omni-cortex__cortex_link_memories
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
- Be detailed about next steps — future you will thank present you
- Keep it fast — this should take under 30 seconds

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
   - If no topic provided, derive one from the conversation context (2-3 words, kebab-case)

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

6. **Write session summary to Obsidian (best-effort)**
   - This step is NON-BLOCKING — if Obsidian is unreachable, skip and continue
   - Filename: `Claude/Sessions/YYYY-MM-DD-[project-name].md`
     - If a file with that name already exists, append `-2`, `-3`, etc.
     - Project name = current directory name in kebab-case
   - Write using `obsidian_append_content`:
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

7. **Save key decisions to Cortex (best-effort)**
   - This step is NON-BLOCKING — if Cortex is unreachable, skip and continue
   - For each significant decision/solution/learning, call `cortex_remember` with params:
     - **Decisions**: type "decision", importance 70-90
     - **Solutions**: type "solution", importance 60-80
     - **Patterns**: type "learning", importance 50-70
   - Tag with: project name, relevant technologies
   - Link related memories with `cortex_link_memories`
   - Aim for 2-5 memories per session — only save what's worth recalling
   - Call `cortex_end_session` with summary and key_learnings

8. **Update wiki articles (best-effort)**
   - This step is NON-BLOCKING — if the wiki is empty or Obsidian is unreachable, skip
   - Read `wiki/_index.md` to get current categories and articles
   - Based on what was worked on in this session, identify relevant wiki articles
   - For each relevant article:
     - Read it with `obsidian_get_file_contents`
     - Merge in new learnings, decisions, or solutions from this session
     - Update the `updated` date in frontmatter
     - Write back with `obsidian_patch_content`
   - If a significant new topic emerged with no existing article:
     - Create a new article in the appropriate wiki category
     - Update the category `_index.md` and `wiki/_index.md`
   - Keep updates small and focused — this is a per-session update, not a full recompile

9. **Confirm creation**
   - Report using the format below

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
Vault: Claude/Sessions/[filename] [written / skipped]
Cortex: [N memories saved / skipped] | Session [ended / skipped]
Wiki: Updated [N] articles ([list]) | skipped
Wiki: Created [N] new articles ([list]) | skipped
Number: [NNN]
Topic: [topic]

To resume: /pickup
```
