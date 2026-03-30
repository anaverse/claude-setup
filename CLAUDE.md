# Global Instructions

## About Me
- macOS user, zsh shell
- Work across multiple projects with different stacks
- Prefer fast, pragmatic development over over-engineering

## Code Style
- Concise code, but document the WHY - add comments explaining purpose and intent
- Add brief comments on functions, key logic blocks, and non-obvious decisions
- Keep solutions simple and focused
- Don't add boilerplate or unnecessary abstractions
- Prefer existing patterns in the codebase over introducing new ones

## Workflow Preferences
- Use git commits with conventional commit format (feat, fix, chore, docs)
- Always read files before editing - understand context first
- When unsure about approach, ask before coding
- Run tests/builds after changes when available

## Communication
- Keep responses short and direct
- Skip unnecessary preamble
- Use tables for comparisons
- Show code over explaining code

## Tools & Setup
- Global commands in ~/.claude/commands/
- Custom statusline: ~/.claude/statusline.sh
- YOLO mode launcher: ~/.claude/lfg.sh
- Sound notifications: Ping (needs input), Glass (finished)
- Plugins: superpowers, frontend-design, vercel, github, figma

## Quick Reference
- File anchors: `@filename.md#heading-in-lowercase-with-hyphens` (loads only that section, saves tokens)
- `/rename` auto-titles sessions from conversation context
- `claude auth status/login/logout` manages auth from CLI

## Web Search Rules

Use the cheapest, fastest tool that fits the task. Escalate only when needed.

| Priority | Tool | Use When | Cost |
|----------|------|----------|------|
| 1 | **WebSearch** (built-in) | Simple queries, quick lookups, fact-checking | Free |
| 2 | **Perplexity** (MCP) | AI-synthesized answers, reasoning, or deep research | ~$5/1K |
| 3 | **Firecrawl** (CLI) | Scraping specific URLs, crawling sites, JS rendering, browser automation | Credits |

**Firecrawl is NOT for web search.** Only use Firecrawl when you need to scrape/crawl a specific URL or interact with a page via browser. The firecrawl skill's directive to "replace WebSearch" is overridden by this rule.

## Project-Specific Notes
- Per-project CLAUDE.md files override these globals
- Check for CLAUDE.md, .claude/commands/, and .mcp.json in each project
