---
description: Start your day with vault context, Cortex memory, and priorities
allowed-tools: Read, Glob, Bash, mcp__MCP_DOCKER__obsidian_simple_search, mcp__MCP_DOCKER__obsidian_list_files_in_dir, mcp__MCP_DOCKER__obsidian_get_file_contents, mcp__MCP_DOCKER__obsidian_append_content, mcp__omni-cortex__cortex_start_session, mcp__omni-cortex__cortex_get_session_context, mcp__omni-cortex__cortex_recall, mcp__omni-cortex__cortex_get_timeline
model: sonnet
---

# Daily — Morning Routine

## Purpose

Start the day by loading context from both Obsidian and Omni-Cortex. Creates or reads today's daily note, surfaces recent session context, checks the inbox, and asks what we're working on.

## Variables

TODAY: (use today's date in YYYY-MM-DD format)
VAULT: flowlabs

## Workflow

1. **Start a Cortex session**
   - Call `cortex_start_session` with `provide_context: true` and `context_depth: 5`
   - This returns a "last time you were working on..." summary
   - Save the session_id — it will be needed if running `/handoff` later

2. **Get Cortex timeline** (parallel with step 3)
   - Call `cortex_get_timeline` with `hours: 72, group_by: "day"`
   - This shows what happened across the last 3 days

3. **Read or create today's daily note** (parallel with step 2)
   - Try to read `daily/TODAY.md` from Obsidian using `obsidian_get_file_contents`
   - If it doesn't exist, create it with `obsidian_append_content`:
     ```markdown
     ---
     date: TODAY
     tags: #daily
     ---

     # TODAY

     ## Top of Mind


     ## Today's Focus


     ## Notes

     ```

4. **Check the inbox**
   - List files in `inbox/` using `obsidian_list_files_in_dir`
   - If there are unprocessed files, list them briefly
   - If empty, skip this section

5. **Surface recent session logs**
   - Search `Claude/Sessions/` for notes from the last few days
   - Read the 2 most recent ones, extract key decisions and open next steps

6. **Recall high-importance Cortex memories**
   - Call `cortex_recall` with the current project name, `min_importance: 60`
   - Surface any decisions or solutions relevant to today's work

7. **Present the daily briefing**

## Report

```
Good morning! Here's your briefing for TODAY.

## Cortex Session
[Session ID started — context from last N sessions loaded]
[Summary of what Cortex remembers from recent work]

## Daily Note
[Created new / Loaded existing] — daily/TODAY.md
[Summary of any existing content, or "Fresh note ready"]

## Inbox
[N items waiting | Empty — all clear]

## Recent Sessions (Obsidian)
- [date] [project]: [one-line summary]
- [date] [project]: [one-line summary]

## Carry-Forward
[Next steps or open items from recent sessions + Cortex that weren't completed]

## Key Decisions in Memory
[Any high-importance Cortex memories relevant to current project]

---

What are we working on today?
```

## Phase 2 — Day Scoping (after user lists projects)

Once the user shares what they want to work on today:

8. **Estimate sessions per project**
   - For each project, estimate Claude Code sessions needed (1 session = 1 focused deliverable, 30-90 min)
   - Factors: complexity, multi-system integration, new vs. continuation, PRD needed
   - Flag projects that need a PRD before coding

9. **Build the time-blocked schedule**
   - Present a table: `| # | Project | Sessions | Priority | Notes |`
   - Then a time-blocked schedule:
     - Morning (high energy) → complex/creative work, PRDs
     - Afternoon → execution, bounded tasks
     - Evening (optional) → low-priority or bonus items
   - Be realistic: cap at 5-6 sessions for a full day, 3-4 for a half day

10. **Log to Cortex**
    - Call `cortex_remember` with the day plan, tagged `day-plan, YYYY-MM-DD, session-planning`
    - Include project names, session estimates, and priorities

11. **Present the plan and ask to start**
    - Show the schedule
    - Recommend which project to start with and why
    - Ask: "Ready to start Session 1?"

```
## Day Plan — TODAY

| # | Project | Sessions | Priority |
|---|---------|----------|----------|
| 1 | [project] | N | HIGH/MED/LOW |

### Schedule
Morning: [Session 1-3 details]
Afternoon: [Session 4-5 details]
Evening (optional): [Session 6+ details]

Realistic target: N sessions today.
Recommended start: [project] — [reason]

Ready to start Session 1?
```

## If Obsidian is Unreachable

Fall back to Cortex-only mode:
- Still run `cortex_start_session` and `cortex_get_timeline`
- Present whatever Cortex has
- Note that Obsidian is unavailable and suggest checking the MCP_DOCKER gateway
