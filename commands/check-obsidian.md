---
description: Pull relevant context from your Obsidian vault into the current session
allowed-tools: Read, Glob, Bash, mcp__MCP_DOCKER__obsidian_simple_search, mcp__MCP_DOCKER__obsidian_list_files_in_dir, mcp__MCP_DOCKER__obsidian_get_file_contents, mcp__MCP_DOCKER__obsidian_list_files_in_vault
model: sonnet
argument-hint: [optional: topic to search for]
---

# Check Obsidian

## Purpose

Pull relevant context from the Obsidian vault (flowlabs) into the current session. Searches for notes related to the current project or a specific topic.

## Variables

TOPIC: $ARGUMENTS
PROJECT_NAME: (detect from current directory name or git remote)

## Instructions

- Search smart, read selectively — don't flood the context window
- Cap at 3-5 most relevant notes
- Present summaries, not full note dumps
- Let the user decide what to dig into

## Workflow

1. **Determine search context**
   - If TOPIC is provided, use it as the primary search term
   - If no TOPIC, detect the current project name from the directory name or git remote
   - Build search terms: project name, key technologies, client names if obvious

2. **Search the vault in priority order**
   - Search `Claude/Sessions/` for recent session logs matching the project/topic
   - Search `Personal/Projects/` for project-specific notes
   - Search `Automatelly/Clients/` for client-related context
   - Search `Companies/` for company info
   - If still under 3 results, do a broad `obsidian_simple_search` across the whole vault

3. **Read and summarize matches**
   - Read each matching note
   - Extract the key information: decisions, current state, next steps, blockers
   - Don't include the full note content — summarize what's relevant

4. **Present findings**
   - List what was found with one-line descriptions
   - Highlight anything directly relevant to the current work
   - Ask if the user wants to dig deeper into any specific note

## Report

```
Vault Context: [TOPIC or PROJECT_NAME]

Found [N] relevant notes:

1. [filepath] — [one-line summary]
2. [filepath] — [one-line summary]
3. [filepath] — [one-line summary]

Key context:
- [Most important finding]
- [Second finding]

Want me to pull the full details from any of these?
```

## If No Results

```
No notes found in the vault for "[TOPIC or PROJECT_NAME]".

Want me to:
1. Try a broader search with different terms?
2. Create a new project note with /log-project-obsidian?
```
