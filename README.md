# Claude/Codex Team Setup

Shared Claude Code configuration plus migrated Codex instructions and skills.

## Quick Start

### Claude Code

```bash
git clone <this-repo> ~/claude-setup
cd ~/claude-setup
chmod +x install.sh
./install.sh
```

The installer symlinks everything into `~/.claude/` — updates to the repo apply automatically via `git pull`.

### Codex

```bash
cd ~/claude-setup
chmod +x install-codex.sh
./install-codex.sh
```

The Codex installer symlinks `AGENTS.md` and reusable skills into `~/.codex/`.
Restart Codex or start a new Codex session after installing so skills are discovered.

## What's Included

| Component | Description |
|-----------|-------------|
| `CLAUDE.md` | Global instructions — code style, workflow, communication preferences |
| `settings.json` | Base permissions, hooks, plugins, statusline config |
| `statusline.sh` | Custom status bar with context usage, git branch, timer |
| `lfg.sh` | YOLO mode launcher (`--dangerously-skip-permissions` with Opus) |
| `commands/` | 30 slash commands for common workflows |
| `hooks/` | Security hooks (block .env reads, keychain migration) |
| `mcp.json.example` | MCP server template — copy and add your keys |
| `AGENTS.md` | Codex-facing global instructions adapted from `CLAUDE.md` |
| `skills/` | Codex skills migrated from high-value Claude commands |
| `install-codex.sh` | Installer for Codex instructions and skills |
| `claude/` | Claude-side documentation; root files remain source-compatible |
| `codex/` | Codex-side documentation; root files remain source-compatible |
| `shared/` | Agent-neutral workflow notes and migration space |
| `scripts/` | Compatibility installer wrappers |
| `MIGRATION.md` | Claude-to-Codex migration guide |

## Dual-Agent Layout

This repo intentionally keeps the original Claude setup intact. The new folders document and organize the migration without deleting or moving existing work.

| Use Case | Entry Point |
|----------|-------------|
| Install Claude setup | `./install.sh` or `./scripts/install-claude.sh` |
| Install Codex setup | `./install-codex.sh` or `./scripts/install-codex.sh` |
| Edit Claude commands | `commands/` |
| Edit Codex skills | `skills/` |
| Add shared workflow notes | `shared/workflows/` |
| Follow migration guidance | `MIGRATION.md` |

## Codex Skills

Installed prompts/workflows:

| Skill | Try Saying |
|-------|------------|
| `git-start` | "start git" |
| `prime-codebase` | "prime this repo" |
| `create-plan` | "create a plan for adding auth" |
| `build-plan` | "build specs/todo/auth.md" |
| `validate-project` | "validate this project" |
| `git-commit` | "commit these changes" |
| `review-changes` | "review the current diff" |
| `session-handoff` | "create a handoff" or "save session to Obsidian" |
| `session-pickup` | "pickup from the latest handoff" |

## After Installing

1. **Add your API keys** — copy `mcp.json.example` to `~/.claude/mcp.json` and fill in credentials
2. **Personal overrides** — copy `settings.local.json.example` to `~/.claude/settings.local.json`
3. **Install plugins** — open Claude Code and install plugins listed in `settings.json`
4. **Authenticate** — `claude auth login`

## Commands

| Command | Purpose |
|---------|---------|
| `/plan` | Create implementation plans |
| `/build` | Execute a plan step by step |
| `/commit` | Smart git commit with conventional format |
| `/review` | Code review current changes |
| `/validate` | Run tests and checks |
| `/handoff` | Save session state for pickup later and mirror to Obsidian |
| `/pickup` | Resume from last handoff |
| `/daily` | Daily standup summary |
| `/retrospective` | Session retrospective |
| `/prime-init` | Bootstrap a new project |
| `/install` | Install dependencies and tools |
| `/shopify` | Manage Shopify products via MCP |
| `/shopify-batch-metafields` | Batch update Shopify metafields |
| `/n8n-sync` | Sync n8n workflows |
| `/n8n-push` | Push workflow to n8n |
| `/n8n-pull` | Pull workflow from n8n |
| `/n8n-diff` | Diff local vs remote workflow |
| `/check-obsidian` | Pull context from Obsidian vault |
| `/log-project-obsidian` | Document project to Obsidian |
| `/hostinger` | Manage Hostinger infrastructure |
| `/remember` | Save something to memory |
| `/screenshot-compare` | Compare screenshots |
| `/visual-verify` | Visual verification of UI |
| `/parallel-subagents` | Run multiple agents in parallel |
| `/create-command` | Create a new slash command |
| `/video-to-skill` | Convert video tutorial to a skill |
| `/apply-learnings` | Apply learnings from past sessions |
| `/mcp-toggle` | Enable/disable MCP servers |
| `/all-tools` | List all available tools |
| `/fb-images-pipeline` | Facebook images pipeline |

## Customizing

- **Add commands** — drop `.md` files in `commands/`, they're available immediately
- **Add MCP servers** — edit your local `~/.claude/mcp.json`
- **Override settings** — use `settings.local.json` (gitignored) for personal tweaks
- **Add hooks** — drop scripts in `hooks/` and register them in `settings.json`

## Security

- No API keys or secrets are committed — all credentials go in `mcp.json` (gitignored)
- The `block-secrets.sh` hook prevents Claude from reading `.env` files
- The `migrate-env-to-keychain.sh` helper moves secrets from `.env` to macOS Keychain
- `settings.local.json` is gitignored for personal overrides
