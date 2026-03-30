---
description: Create a detailed implementation plan and save to specs/todo/
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
model: opus
argument-hint: [feature or task description]
---

# Quick Plan

## Purpose

Create a detailed implementation plan based on user requirements. The plan is saved to `specs/todo/` and can later be built with `/build`. This separates planning from execution for cleaner workflows.

## Variables

USER_PROMPT: $ARGUMENTS
PLAN_OUTPUT_DIR: specs/todo/

## Instructions

- Think deeply about the best approach before writing
- Include code examples or pseudo-code where helpful
- Consider edge cases, error handling, and scalability
- Generate a descriptive kebab-case filename based on the topic
- Plans should be detailed enough for another developer to follow
- **Every phase MUST include `Verify` and `Done when` fields** — no exceptions

## Workflow

1. **Setup folders**
   - Run `mkdir -p specs/todo specs/done` to ensure structure exists

2. **Analyze requirements**
   - Parse USER_PROMPT to understand the core problem
   - Identify the desired outcome and constraints

3. **Design solution**
   - Develop technical approach
   - Make architecture decisions
   - Plan implementation strategy

4. **Assess complexity**
   - Count the phases needed
   - If 4+ complex phases, consider splitting into multiple specs
   - Name split specs with numeric prefixes: `01-feature-part-one.md`

5. **Document the plan**
   - Create comprehensive markdown document with:
     - Problem statement and objectives
     - Technical approach
     - Step-by-step implementation guide with per-phase verification
     - Testing strategy
     - Success criteria
   - **Per-phase verification format** — every phase must end with:
     ```
     **Verify:** [runnable command or concrete check, e.g. `npm run dev` shows X, `curl` returns Y]
     **Done when:** [observable outcome that proves the phase is complete]
     ```
   - Verify should be a command or action someone can actually run
   - Done when should be a pass/fail statement, not vague ("works correctly" is bad, "screenshot shows 3-panel layout with canvas at 1280x720" is good)

6. **Save and report**
   - Generate descriptive filename
   - Write plan to `specs/todo/[filename].md`
   - Provide summary

## Report

```
Plan Created

File: specs/todo/[filename].md
Topic: [brief description]
Phases: [count]

Key Components:
- [component 1]
- [component 2]
- [component 3]

Next: Run `/build specs/todo/[filename].md` to implement
```
