---
description: Toggle MCP servers on/off to free up context window
allowed-tools: Read, Write, Edit, Bash, Glob
model: sonnet
argument-hint: [list | disable <name> | enable <name> | only <name,name,...>]
---

# MCP Toggle

## Purpose

Manage MCP server connections to reduce context window usage. Every active MCP server adds tool descriptions to your context. Disable unused servers to free up tokens for actual work.

## Variables

ACTION: $ARGUMENTS

## Config Locations

MCP servers live in these files (check all):

1. **Project `.mcp.json`** - servers for current project (in working directory)
2. **Global `~/.claude.json`** → `mcpServers` key - servers available everywhere
3. **Per-project in `~/.claude.json`** → `projects["/path"].mcpServers` - project-specific servers set via Claude settings

To disable a server, add `"disabled": true` to its config object. To re-enable, remove the `disabled` key or set it to `false`.

## Instructions

- NEVER delete server configs - only toggle the `disabled` flag
- Always show before/after status
- When disabling, preserve all other config (command, args, env, etc.)
- Support partial name matching (case-insensitive)
- Claude.ai connector MCPs (Figma, Vercel, Instantly, Hugging Face, n8n) are managed through Claude.ai settings, not local config - inform the user if they try to toggle these

## Workflow

### If ACTION is empty or "list"

1. Read all config files listed above
2. Display a table of ALL MCP servers with:
   - Name
   - Source (project .mcp.json | global | per-project)
   - Status (enabled / disabled)
   - Type hint (what tools it provides, if recognizable)
3. Show total count: X enabled, Y disabled
4. Suggest: "Use `/mcp-toggle disable <name>` or `/mcp-toggle only <name,name>` to manage"

### If ACTION starts with "disable"

1. Parse server name(s) from ACTION (comma-separated supported)
2. Find the server in the appropriate config file
3. Add `"disabled": true` to the server's config object
4. Write the updated config file
5. Report what was disabled

### If ACTION starts with "enable"

1. Parse server name(s) from ACTION
2. Find the server in the appropriate config file
3. Remove the `"disabled"` key (or set to `false`)
4. Write the updated config file
5. Report what was enabled

### If ACTION starts with "only"

1. Parse the comma-separated list of server names to KEEP enabled
2. Disable ALL other servers across all config files
3. Report what was kept and what was disabled
4. This is the power move for freeing context fast

### If ACTION starts with "profile"

Manage saved presets of enabled/disabled servers.

- `profile save <name>` - Save current enabled/disabled state as a named profile
- `profile load <name>` - Load a saved profile (disable/enable servers to match)
- `profile list` - Show saved profiles

Profiles are stored in `~/.claude/mcp-profiles.json`.

## Example Profiles

Suggest these common profiles to the user:
- **minimal** - Only essential servers (e.g., context7)
- **dev** - Development servers (context7, n8n-mcp, perplexity)
- **marketing** - Marketing stack (obsidian, clickup, perplexity)
- **full** - Everything enabled

## Report

```
MCP Server Status

| Server           | Source      | Status   |
|-----------------|-------------|----------|
| MCP_DOCKER      | global      | enabled  |
| perplexity      | .mcp.json   | disabled |
| n8n-mcp         | per-project | enabled  |
| ...             | ...         | ...      |

Total: X enabled, Y disabled
Context savings: ~Y fewer tool descriptions loaded

To change: /mcp-toggle disable <name>
To keep only specific: /mcp-toggle only context7,n8n-mcp
To save this setup: /mcp-toggle profile save minimal
```

## Important Notes

- Changes take effect on next conversation (restart Claude Code or start new chat)
- The `disabled` flag is the official Claude Code mechanism - it's safe and reversible
- Docker MCP gateway servers (MCP_DOCKER, MCP_DOCKER_1, MCP_DOCKER_2) often bundle many tools - disabling one can free significant context
