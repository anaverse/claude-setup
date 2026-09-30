---
name: session-pickup
description: Resume from a saved handoff in specs/handoffs. Use when the user says pickup, resume, continue from handoff, list handoffs, or asks what to do next from a previous session.
---

# Session Pickup

Load a saved handoff and prepare to continue work.

## Workflow

1. Check for `specs/handoffs/`.
2. If the user says `list`, list available handoffs sorted by number.
3. If the user provides a number, load the matching handoff.
4. Otherwise load the most recent handoff.
5. Summarize:
   - Where work left off.
   - Completed items.
   - In-progress items.
   - Next steps.
   - Key files.
   - Notes and blockers.
6. Recommend the most sensible next action.

Do not start editing unless the user asks to proceed or the request clearly asks to continue implementation.
