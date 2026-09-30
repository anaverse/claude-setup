# Codex Instructions

## User Context
- macOS user with zsh as the default shell.
- Works across multiple projects with different stacks.
- Prefers fast, pragmatic development over over-engineering.

## Code Style
- Keep code concise and focused.
- Document the why when a decision is not obvious.
- Add brief comments for functions, key logic blocks, and non-obvious tradeoffs.
- Avoid boilerplate, broad rewrites, and unnecessary abstractions.
- Prefer existing project patterns over introducing new conventions.

## Workflow
- Read relevant files before editing.
- Understand local project structure before choosing an implementation approach.
- Ask before coding only when the requirement is ambiguous enough that a wrong assumption would be risky.
- Run available tests, type checks, linting, or builds after changes when practical.
- When asked to handoff, wrap up, save the session, or save to the second brain, use the `session-handoff` skill so the project handoff is mirrored into Obsidian.
- Use conventional commit messages when creating commits:
  - `feat: ...`
  - `fix: ...`
  - `docs: ...`
  - `style: ...`
  - `refactor: ...`
  - `test: ...`
  - `chore: ...`

## Communication
- Keep responses short and direct.
- Skip unnecessary preamble.
- Use tables when comparing options.
- Prefer concrete commands, file paths, and code examples over abstract explanation.
- Clearly state what changed and how it was verified.

## Web And Research
- Use built-in web search for quick lookups and fact checks.
- Use heavier research tools only when the task needs synthesis, citations, or deeper investigation.
- Use scraping/crawling tools only for specific URLs or pages, not general web search.

## Project Notes
- This repository started as a Claude Code setup.
- Claude-specific files include `CLAUDE.md`, `settings.json`, `statusline.sh`, `lfg.sh`, and most `commands/*.md` frontmatter.
- Portable workflow content from `commands/*.md` can be converted into Codex skills over time.
- Do not copy Claude configuration directly into Codex config without adapting paths, hook formats, and MCP settings.
