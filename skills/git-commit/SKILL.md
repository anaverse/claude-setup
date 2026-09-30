---
name: git-commit
description: Create a conventional Git commit from the current changes. Use when the user asks to commit, make a git commit, save changes, or generate a commit message.
---

# Git Commit

Create a concise conventional commit.

## Workflow

1. Inspect changes.
   - Run `git status --short`.
   - If there are no changes, report that there is nothing to commit.
   - Run `git diff --stat` and inspect relevant diffs.
   - Include staged changes with `git diff --cached --stat` when present.

2. Determine commit type.
   - `feat`: new functionality.
   - `fix`: bug fix.
   - `docs`: documentation only.
   - `style`: formatting only.
   - `refactor`: restructuring without behavior change.
   - `test`: tests only.
   - `chore`: maintenance/config/tooling.

3. Choose message.
   - Use the user's message if provided.
   - Otherwise generate `type: concise description`.
   - Use present tense.
   - Keep subject near 50 characters when practical.
   - Do not add AI attribution footers.

4. Commit.
   - Stage relevant changes. Use `git add -A` only when the user clearly wants all current changes committed.
   - Run `git commit -m "[message]"`.
   - Do not push unless the user explicitly asks.

5. Report commit hash, message, changed file count, and push command if relevant.

If unrelated user changes are present, mention them and avoid committing them unless the user explicitly asked to commit everything.
