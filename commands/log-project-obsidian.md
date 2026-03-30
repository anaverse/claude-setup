---
description: Document the current project to your Obsidian vault
allowed-tools: Read, Write, Glob, Bash, mcp__MCP_DOCKER__obsidian_simple_search, mcp__MCP_DOCKER__obsidian_list_files_in_dir, mcp__MCP_DOCKER__obsidian_get_file_contents, mcp__MCP_DOCKER__obsidian_append_content, mcp__MCP_DOCKER__obsidian_patch_content
model: sonnet
argument-hint: [optional: project name]
---

# Log Project to Obsidian

## Purpose

Document the current project in detail to the Obsidian vault. Creates a new project note or updates an existing one.

## Variables

PROJECT_ARG: $ARGUMENTS
PROJECT_NAME: (detect from directory name if not provided)

## Instructions

- Scan the project thoroughly before writing
- If an existing note exists, update it — don't overwrite
- Follow the vault's style guide: emoji title, blockquote subtitle, `---` dividers
- Place the note in the right folder based on context

## Workflow

1. **Determine project identity**
   - If PROJECT_ARG is provided, use it as the project name
   - Otherwise, detect from current directory name
   - Derive a kebab-case filename: `[project-name].md`

2. **Scan the current project**
   - Read CLAUDE.md / README.md for project description
   - Check `git log --oneline -20` for recent history
   - Check `specs/` folder for plans and handoffs
   - Identify: purpose, stack, architecture, current state, key decisions

3. **Check vault for existing note**
   - Search project notes folder for `[project-name].md`
   - Search client folders for client-related projects
   - If found, read the existing note for context

4. **Determine file placement**
   - If the project has a client/business context → `[Business]/Clients/[client]/[project-name].md`
   - If it's a personal project → `Personal/Projects/[project-name].md`
   - If unclear → ask the user where to place it

5. **Write or update the note**

   **If creating new:**
   - Use the project note template below
   - Write using `obsidian_append_content`

   **If updating existing:**
   - Update `Current State` section with latest info
   - Append new entries to `History` section
   - Add any new `Key Decisions`
   - Use `obsidian_patch_content` to update specific sections

6. **Confirm to user**
   - Report what was written and where
   - Show a summary of the note content

## Project Note Template

```markdown
---
date: [YYYY-MM-DD]
type: project
tags: #project/[name]
status: active
---

# [emoji] [Project Name]

> [One-line description of what this project is]

---

## Overview
[2-3 sentences: what this project is, why it exists, what problem it solves]

---

## Architecture
- **Stack:** [languages, frameworks, tools]
- **Key patterns:** [architecture decisions]
- **Infrastructure:** [hosting, CI/CD, databases if relevant]

---

## Current State
- **Phase:** [what phase the project is in]
- **In progress:** [what's being worked on now]
- **Next up:** [what comes next]

---

## Key Decisions
- [Decision] — [reasoning] ([YYYY-MM-DD])

---

## History
- [YYYY-MM-DD]: [What happened]
```

## Report

```
Project Logged

File: [vault filepath]
Action: [Created / Updated]
Project: [project name]

Summary:
- [Key point 1]
- [Key point 2]
- [Key point 3]
```
