---
name: review-changes
description: Review current changes or an implementation against a spec. Use when the user asks to review, check the diff, compare implementation to a plan/spec, find bugs, or approve changes.
---

# Review Changes

Review changes with a bug-finding stance.

## Modes

- If the user provides a spec path, compare implementation against that spec.
- If no spec is provided, review the current git diff.
- For UI changes, use browser/screenshot tooling only when available and useful.

## Workflow

1. Inspect git status and relevant diffs.
2. If a spec is provided, read it fully and check each requirement.
3. Focus on bugs, regressions, missing validation, data loss, security issues, accessibility issues, and missing tests.
4. Classify issues:
   - `blocker`: must fix before release.
   - `tech_debt`: acceptable short-term but should be tracked.
   - `skippable`: minor note.
5. Avoid style-only comments unless they affect maintainability or behavior.

## Report

Lead with findings, ordered by severity. Include file and line references when possible.

Use this shape:

```markdown
Findings
- [severity] [file:line] [issue and impact]

Open Questions
- [Only if needed.]

Summary
[Brief approval status and residual risk.]
```

If no issues are found, say so clearly and mention any checks that were not run.
