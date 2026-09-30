# Shared Workflows

Store agent-neutral workflow descriptions here when a process should exist in both Claude and Codex.

Keep these files free of:

- Claude `allowed-tools` frontmatter.
- Codex skill trigger descriptions.
- Agent-specific MCP tool names.
- Paths like `~/.claude` or `~/.codex` unless comparing both systems.

Suggested format:

```markdown
# Workflow Name

## Goal
[Outcome.]

## Inputs
- [Input.]

## Steps
1. [Step.]

## Validation
- [Check.]

## Agent Versions
- Claude: `commands/[name].md`
- Codex: `skills/[name]/SKILL.md`
```
