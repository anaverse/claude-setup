---
name: validate-project
description: Detect the project type and run relevant validation checks. Use when the user asks to validate, test, lint, type-check, run checks, verify the app, or use flags like quick, fix, or verbose.
---

# Validate Project

Run practical validation for the current project.

## Arguments

Interpret natural-language flags:
- `quick`: skip long-running tests when reasonable.
- `fix`: apply safe lint/format fixes when available.
- `verbose`: include more command output in the summary.

## Detection

Inspect files to choose checks:

| Files | Likely Checks |
|---|---|
| `package.json` + `vitest.config.*` | `npx vitest run` |
| `package.json` + `jest.config.*` | `npm test` |
| `bun.lockb` | `bun test` |
| `package.json` | scripts such as `typecheck`, `lint`, `build`, `test` |
| `pyproject.toml` | `pytest`, `ruff`, project build if configured |
| `requirements.txt` | `python -m pytest` when tests exist |
| `Cargo.toml` | `cargo test` |
| `go.mod` | `go test ./...` |

Prefer package scripts over raw tool commands when scripts exist.

## Workflow

1. Detect project type and available scripts/config.
2. Run type checks first when available.
3. Run lint checks; use fix mode only when requested.
4. Run build checks when available.
5. Run tests unless quick mode was requested.
6. Continue through independent checks even if one fails.
7. Summarize pass/fail/skipped status and actionable next steps.

Do not install missing dependencies unless the user asks or approves.

## Report

Use this shape:

```markdown
Validation Results

Project: [name]
Status: PASSED | PARTIAL | FAILED
Framework: [detected stack]

Checks:
- Type check: PASSED/FAILED/SKIPPED
- Lint: PASSED/FAILED/SKIPPED
- Build: PASSED/FAILED/SKIPPED
- Tests: PASSED/FAILED/SKIPPED

Next:
- [Only include concrete follow-up items.]
```
