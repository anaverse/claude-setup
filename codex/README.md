# Codex Setup

This folder documents the Codex side of the setup without moving or deleting the existing files.

## Source Files

The current Codex-compatible files remain at the repository root for backward compatibility:

| File | Purpose |
|---|---|
| `../AGENTS.md` | Codex instructions |
| `../skills/` | Codex skills |
| `../install-codex.sh` | Codex installer |

## Install

From the repo root:

```bash
./install-codex.sh
```

Or through the wrapper:

```bash
./scripts/install-codex.sh
```

## Installed Skills

| Skill | Prompt |
|---|---|
| `git-start` | `start git` |
| `prime-codebase` | `prime this repo` |
| `create-plan` | `create a plan for ...` |
| `build-plan` | `build specs/todo/...` |
| `validate-project` | `validate this project` |
| `git-commit` | `commit these changes` |
| `review-changes` | `review the current diff` |
| `session-handoff` | `create a handoff` or `save session to Obsidian` |
| `session-pickup` | `pickup from the latest handoff` |

## Notes

- Codex skills live in `../skills/` for now and are symlinked into `~/.codex/skills`.
- `session-handoff` writes the project handoff to `specs/handoffs/` and mirrors a lean note to the Obsidian vault at `/Users/ana/Documents/flowlabs` by default. Set `CODEX_OBSIDIAN_VAULT` to override it.
- Use `codex mcp add` for service integrations instead of copying Claude MCP JSON directly.
- Use plugins when a real Codex plugin exists; use skills for repeatable workflows.
