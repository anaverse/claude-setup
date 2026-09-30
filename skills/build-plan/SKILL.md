---
name: build-plan
description: Implement a saved plan from specs/todo and move it to specs/done after successful validation. Use when the user asks to build a plan, implement a spec, execute a planned task, or continue from a plan file.
---

# Build Plan

Implement a plan file into working code.

## Workflow

1. Locate the plan.
   - If the user provides a path, use it.
   - Otherwise list `specs/todo/*.md` and ask which plan to build if more than one exists.

2. Read the full plan before editing.
   - Identify phases, target files, validation commands, and risks.
   - Check current git state before making changes.

3. Implement in order.
   - Follow the plan's phases.
   - Keep edits scoped to the planned change.
   - Adjust the plan only when implementation reveals a necessary correction.

4. Validate.
   - Run the plan's `Verify` commands when practical.
   - Run project tests, type checks, lint, or build when available.
   - Fix issues caused by the implementation.

5. Move the plan only after success.
   - On success: move it from `specs/todo/` to `specs/done/`.
   - On failure or incomplete work: leave it in `specs/todo/`.

6. Report.
   - Summarize changes, files modified, validation results, plan location, and suggested next action.

Do not commit unless the user asks.
