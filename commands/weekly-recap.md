---
description: Generate a weekly Excalidraw diagram from all session handoffs
allowed-tools: Read, Glob, Bash, Skill, mcp__MCP_DOCKER__obsidian_append_content, mcp__MCP_DOCKER__obsidian_get_file_contents, mcp__MCP_DOCKER__obsidian_list_files_in_dir, mcp__MCP_DOCKER__obsidian_patch_content, mcp__omni-cortex__cortex_recall, mcp__omni-cortex__cortex_get_timeline, mcp__omni-cortex__cortex_get_activities
model: sonnet
argument-hint: [optional: "last" for previous week]
---

# Weekly Recap

## Purpose

Generate a visual Excalidraw diagram summarizing an entire week of work. Pulls from handoff files and Cortex memories to create a single "project state snapshot" — what moved, what's blocked, what connects to what.

Run this once a week, ideally Friday end-of-day or whenever you want a big-picture view.

## Variables

WEEK_ARG: $ARGUMENTS

## Instructions

- Default: current week (Monday through today)
- If "last" is passed: previous full week (Mon-Sun)
- Read ALL handoff files from the target week
- Supplement with Cortex memories for decisions and patterns
- Generate ONE comprehensive Excalidraw diagram

## Workflow

1. **Determine date range**
   - Calculate the Monday and Sunday of the target week
   - Log the range: "Generating recap for YYYY-MM-DD to YYYY-MM-DD"

2. **Gather handoff files**
   - List all files in `specs/handoffs/`
   - Filter to files with dates within the target week
   - Read each matching handoff file
   - If no handoffs found, check Obsidian `Claude/Sessions/` for that week's notes

3. **Gather Cortex context (best-effort)**
   - NON-BLOCKING — skip if Cortex unreachable
   - Call `cortex_get_timeline` for the week's date range
   - Call `cortex_get_activities` for session summaries
   - Call `cortex_recall` with query "decisions and solutions this week"

4. **Synthesize the week**
   - Group work by project/theme
   - Identify: completed items, in-progress items, blockers, key decisions
   - Note patterns: what kept coming up, what got stuck, what moved fast

5. **Generate Excalidraw diagram**
   - Use the `/excalidraw-diagram` skill to generate the diagram
   - **Layout:**
     - **Top**: Week header with date range
     - **Left column**: Timeline of completed work (top to bottom, grouped by day/project)
     - **Right column**: Mind map of current project state — key files, active decisions, connections between projects
     - **Bottom row**: Next week priorities / carry-over items
     - **Color coding**: Green = completed, Yellow = in progress, Red = blocked, Blue = decisions
   - Keep it scannable — this is a snapshot, not a novel

6. **Save to Obsidian (best-effort)**
   - NON-BLOCKING — skip if Obsidian unreachable
   - Filename: `Claude/Weekly/YYYY-W[NN]-recap.diagram.md`
   - Also create a companion text note: `Claude/Weekly/YYYY-W[NN]-recap.md`
     ```markdown
     ---
     date: YYYY-MM-DD
     week: YYYY-W[NN]
     tags: #claude/weekly-recap
     ---

     # Week [NN] Recap — YYYY-MM-DD to YYYY-MM-DD

     ## Completed
     - [Items across all sessions]

     ## In Progress
     - [Carry-over items]

     ## Key Decisions
     - [Decisions made this week]

     ## Blockers
     - [Anything stuck]

     ## Next Week
     - [Priorities for next week]

     ## Visual Map
     ![[YYYY-W[NN]-recap.diagram]]
     ```

7. **Report**

## Report

```
Weekly Recap Generated

Week: YYYY-W[NN] (YYYY-MM-DD to YYYY-MM-DD)
Sessions: [N] handoffs processed
Sources: [handoffs / Cortex / Obsidian]
Diagram: Claude/Weekly/YYYY-W[NN]-recap.diagram [written / skipped]
Summary: Claude/Weekly/YYYY-W[NN]-recap.md [written / skipped]

Highlights:
- [Top 3 accomplishments this week]

Carry-over:
- [Top items for next week]
```
