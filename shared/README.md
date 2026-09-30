# Shared Workflow Source

This folder is for agent-neutral workflow notes, conventions, and migration guidance.

Use it for content that should inform both Claude and Codex, but do not put agent-specific frontmatter or config here.

Recommended split:

| Shared Content | Claude Version | Codex Version |
|---|---|---|
| `shared/workflows/validate.md` | `commands/validate.md` | `skills/validate-project/SKILL.md` |
| `shared/workflows/commit.md` | `commands/commit.md` | `skills/git-commit/SKILL.md` |
| `shared/workflows/review.md` | `commands/review.md` | `skills/review-changes/SKILL.md` |

For now, the existing Claude command files and Codex skill files are the active source files. Add shared workflow documents when you want a neutral canonical version for a workflow.
