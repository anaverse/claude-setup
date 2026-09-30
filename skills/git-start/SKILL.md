---
name: git-start
description: Git session startup workflow. Use when the user says "start git", "git start", "check git", "what changed", "prepare git", or wants Codex to inspect repository status before coding, committing, reviewing, or resuming work.
---

# Git Start

Run a quick, non-destructive Git orientation for the current project.

## Workflow

1. Confirm whether the current directory is inside a Git repository.
   - Run `git rev-parse --show-toplevel`.
   - If it fails, report that the folder is not a Git repo and ask whether to initialize one.

2. Inspect repository state.
   - Run `git status --short --branch`.
   - Run `git remote -v`.
   - Run `git log --oneline -5`.

3. Inspect changes without modifying them.
   - If tracked files changed, run `git diff --stat` and `git diff --name-only`.
   - If staged files exist, run `git diff --cached --stat` and `git diff --cached --name-only`.
   - Do not stage, commit, stash, reset, pull, or push unless the user explicitly asks.

4. Report the useful state.
   - Current branch.
   - Remote names and URLs.
   - Whether the branch is ahead, behind, or diverged if Git reports it.
   - Modified, added, deleted, staged, and untracked files.
   - Last 5 commits.
   - Suggested next action, such as review diff, run tests, commit, pull, or initialize Git.

## Output Shape

Keep the response concise:

```text
Git Status

Branch: [branch]
Remote: [remote summary]
State: [clean / changed / staged / untracked / ahead / behind]

Changes:
- [file]: [status]

Recent commits:
- [hash] [message]

Next: [recommended next command or action]
```

