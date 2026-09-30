---
name: prime-codebase
description: Build a quick understanding of an unfamiliar repository. Use when the user asks to prime, inspect, orient, analyze this repo, explain the architecture, or get ready to work in a project.
---

# Prime Codebase

Orient quickly in a project before making changes.

## Workflow

1. Create planning folders if useful: `specs/todo`, `specs/done`, `specs/handoffs`.
2. Identify repository root and tracked files.
3. Read key project files when present:
   - `README.md`
   - `AGENTS.md`
   - package/config files such as `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`.
4. Identify stack, entry points, major directories, scripts, test/build commands, and notable conventions.
5. Report concise project understanding and ask what to work on next.

## Report

Use this shape:

```markdown
Project: [name]
Stack: [technologies]

Structure:
- [folder]: [purpose]

Entry Points:
- [file]: [purpose]

Useful Commands:
- [command]: [purpose]

Notes:
- [important conventions or risks]
```
