# Claude To Codex Migration

This repo now supports both Claude and Codex without deleting the original Claude setup.

## Rule

Keep working Claude files intact. Add Codex equivalents beside them.

## Current Compatibility Layout

| Area | Current Source |
|---|---|
| Claude instructions | `CLAUDE.md` |
| Claude commands | `commands/` |
| Claude installer | `install.sh` |
| Codex instructions | `AGENTS.md` |
| Codex skills | `skills/` |
| Codex installer | `install-codex.sh` |
| Shared guidance | `shared/` |
| Installer wrappers | `scripts/` |

The `claude/` and `codex/` folders document each side while preserving the root-level files that already work.

## Migration Process

For each Claude command or skill:

1. Read the original file fully.
2. Identify whether it is generic workflow logic, MCP-dependent logic, or Claude-only UI/config behavior.
3. Create a Codex skill at `skills/[skill-name]/SKILL.md`.
4. Remove Claude-only metadata such as `allowed-tools`, model names, and slash-command assumptions.
5. Keep the useful procedural steps.
6. If the workflow depends on an external service, decide whether it needs a Codex MCP server, a local script, or both.
7. Install with `./install-codex.sh`.
8. Test in a fresh Codex session with a natural prompt.

## What To Migrate First

Good candidates:

- Planning and build workflows.
- Validation workflows.
- Git commit/review workflows.
- Handoff and pickup workflows.
- Codebase orientation workflows.

Migrate later:

- Shopify.
- n8n.
- Hostinger.
- Obsidian.
- Cortex memory.

Those need MCP setup decisions.
