---
name: create-plan
description: Create an implementation plan and save it under specs/todo. Use when the user asks to plan, create a spec, write an implementation plan, break down a feature, or prepare work before coding.
---

# Create Plan

Create a detailed implementation plan from the user's requested feature or task.

## Workflow

1. Ensure project planning folders exist: `specs/todo`, `specs/done`, and `specs/handoffs`.
2. Inspect relevant project files before planning when the task depends on existing code.
3. Identify the goal, constraints, impacted files, risks, and likely validation steps.
4. Write a markdown plan to `specs/todo/[descriptive-kebab-case-name].md`.
5. Make the plan specific enough for another developer or Codex session to implement.

## Plan Format

Use this structure:

```markdown
# [Plan Title]

## Goal
[What needs to be true when this is done.]

## Context
- [Relevant current behavior, files, constraints, or decisions.]

## Approach
- [Technical direction and tradeoffs.]

## Phases

### Phase 1: [Name]
- [Concrete implementation steps.]

**Verify:** [Runnable command or concrete manual check.]
**Done when:** [Observable pass/fail outcome.]

### Phase 2: [Name]
- [Concrete implementation steps.]

**Verify:** [Runnable command or concrete manual check.]
**Done when:** [Observable pass/fail outcome.]

## Testing
- [Commands or checks to run.]

## Risks
- [Important edge cases, migration concerns, or unknowns.]
```

Every phase must include `Verify` and `Done when`.

## Report

Report the created file, topic, phase count, key components, and the next command or prompt to build it.
