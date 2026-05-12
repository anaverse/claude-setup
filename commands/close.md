---
description: Run the Close Ritual on the current project — verify nothing is left in an ambiguous state
allowed-tools: Bash, Read, Glob, TaskList
model: sonnet
argument-hint: [optional: notes for the close]
---

# Close

## Purpose

Run Ana's **Close Ritual** to ensure the current project is left clean — nothing uncommitted, unpushed, unverified, unscheduled, or unsaid. Closing is Ana's #1 self-identified personal gap; this command is the operationalization of that discipline.

## Variables

USER_NOTES: $ARGUMENTS

## The 5 Checks

Run in order. Be terse. Don't lecture — execute.

### 1. Anything uncommitted?
- Run `git status --short`
- If empty → ✅ "Working tree clean."
- If non-empty → list what's modified, ask: **commit (with what message?), stash, or leave with reason?**
- If user says commit, suggest a message based on the diff and confirm before committing.

### 2. Anything not pushed?
- Run `git status -sb` to check ahead/behind state
- **Ahead** of remote → ask: push now or hold (and if hold, why?)
- **Behind** remote → ask: pull --no-rebase now?
- **Diverged** → stop, surface the situation, let user decide
- **In sync** → ✅ "Branch in sync with remote."

### 3. Did the deliverable actually work?
- Look at recent activity: last commit's diff, recently modified files in cwd
- Identify the implicit deliverable (the thing the session was *about* — a feature, a doc, a config)
- Ask Ana directly: **"Have you actually verified [deliverable]? (loaded the page / run the test / clicked through / read it back)"**
- If she hasn't, suggest the one-line verification step.
- Don't accept "looks good in the diff" — verification means observing the outcome, not just inspecting code.

### 4. What's open / paused / blocked?
- Run `TaskList` to see in-session tasks
- For each `in_progress` or `pending` task → **complete it now, schedule it for later, or kill it as no-longer-needed?**
- Ask the open-loops question: **"Anything you started thinking about but didn't finish? Decisions you're sitting on? Loose threads in your head?"**
- Capture each loose thread → either resolve it, log it (in repo, in Obsidian, in memory), or schedule it.

### 5. When am I back on this?
- Ask: **"When are you next picking this up — today / tomorrow / this week / 'when X happens'?"**
- If recurring → suggest `/schedule` for a routine
- If one-shot follow-up with a clear trigger → suggest `/schedule` for a one-time agent
- If "not sure" → push back gently. "Vague = will drift. Pick a date."

## Optional 6th Step — Coaching Reflection

If the session had any notable wins or patterns, give Ana **one sentence each**:

```
What worked: [a specific thing she did well — especially around closing]
What I'd flag: [one observation — pattern to watch for, or area to grow]
```

Skip this step if the session was unremarkable. Do not manufacture critique.

## Report

```
🌙 Close Ritual — [project name]

✅/❌ Committed — [details]
✅/❌ Pushed — [details]
✅/❌ Deliverable verified — [details]
✅/❌ Open loops handled — [count handled / count remaining]
✅/❌ Next move — [date / cadence / "drift risk: ___"]

[Optional: What worked / What I'd flag — 2 lines]
```

## Examples

**Standard close:**
```
/close
```

**Close with note about the session:**
```
/close "shipped Module 0 system; Day 1 done"
```

## Notes for the Assistant

- Be terse, run commands, get answers, move on. No essays.
- This command exists because Ana has named closing as her #1 gap. Don't undermine that by being soft. Push for completion.
- Never end the close ritual until step 5 has a concrete answer. "I'll come back to it" is not concrete unless paired with a date or trigger.
- Resist the urge to start NEW work mid-close. If something new comes up, log it for next session.
- Read `~/.claude/projects/-Users-ana-Vibe-Coding-aeo-geo-expert/memory/feedback_close_the_tail.md` for the underlying coaching context.
