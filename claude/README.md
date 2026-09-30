# Claude Setup

This folder documents the Claude side of the setup without moving or deleting the existing files.

## Source Files

The current Claude-compatible files remain at the repository root for backward compatibility:

| File | Purpose |
|---|---|
| `../CLAUDE.md` | Global Claude instructions |
| `../commands/` | Claude slash commands |
| `../settings.json` | Claude settings, permissions, hooks, and plugins |
| `../hooks/` | Claude hook scripts |
| `../statusline.sh` | Claude statusline |
| `../lfg.sh` | Claude launcher |
| `../mcp.json.example` | Claude MCP example configuration |
| `../install.sh` | Claude installer |

## Install

From the repo root:

```bash
./install.sh
```

Or through the wrapper:

```bash
./scripts/install-claude.sh
```

## Notes

- Keep Claude command files in `../commands/` until you intentionally migrate a workflow.
- Do not delete Claude-specific files just because a Codex equivalent exists.
- MCP servers should be kept agent-specific because Claude and Codex use different configuration formats.
