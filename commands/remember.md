---
description: Save a decision, solution, or learning to Omni-Cortex memory
allowed-tools: mcp__omni-cortex__cortex_remember, mcp__omni-cortex__cortex_recall, mcp__omni-cortex__cortex_link_memories
model: sonnet
argument-hint: what to remember (e.g. "chose Neon over Supabase for branching support")
---

# Remember — Save to Cortex

## Purpose

Quick-save important information to Omni-Cortex. Decisions, solutions, patterns, gotchas — anything worth recalling in a future session or across projects.

## Variables

CONTENT: $ARGUMENTS

## Workflow

1. **Parse what to remember**
   - If CONTENT is provided, use it directly
   - If empty, review the recent conversation and ask: "What should I save? A decision, solution, or something you learned?"

2. **Auto-detect the memory type**
   - "Chose X over Y" / "Decided to" / "Going with" → type: `decision`, importance: 75
   - "Fixed by" / "Solved with" / "The trick was" → type: `solution`, importance: 70
   - "Turns out" / "TIL" / "Gotcha:" / "Watch out for" → type: `learning`, importance: 65
   - "Client wants" / "Requirement:" / "Must have" → type: `requirement`, importance: 80
   - Anything else → type: auto-detect, importance: 60

3. **Auto-tag from context**
   - Detect current project name from directory or git remote
   - Extract technology names mentioned (e.g. Next.js, n8n, Clerk)
   - Extract client/company names if mentioned
   - Add these as tags

4. **Check for duplicates**
   - Quick `cortex_recall` with the core topic to see if a similar memory exists
   - If a near-duplicate is found, ask: "Update the existing memory or save as new?"

5. **Save it**
   - Call `cortex_remember` — all fields MUST be nested inside a `params` object:
     ```
     cortex_remember({ params: { content: "...", tags: [...], type: "...", importance: N, context: "..." } })
     ```
   - Context should include: project name, date, brief "why this matters"

6. **Link if relevant**
   - If the duplicate check surfaced related (but not duplicate) memories, offer to link them with `cortex_link_memories`

## Report

```
Saved to Cortex

Type: [decision/solution/learning/requirement]
Tags: [tag1, tag2, tag3]
Importance: [score]/100
ID: [memory_id]

[If related memories found:]
Related: [memory_id] — [one-line summary]
Linked: [yes/no]
```
