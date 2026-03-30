---
description: Full round-trip sync between local n8n workflow JSON and live n8n instance
allowed-tools: Bash, Read, Glob, Grep, AskUserQuestion
model: sonnet
argument-hint: [workflow file path or name fragment]
---

# n8n Sync

## Purpose

Interactive sync between local workflow JSON and live n8n. Pulls remote, shows diff, and offers to push local changes.

## Variables

WORKFLOW_ARG: $ARGUMENTS

## Instructions

Reference both **n8n-workflow-push** and **n8n-workflow-sync** skills.

## Workflow

1. **Find the local workflow file**
   - If WORKFLOW_ARG is a full path, use it directly
   - If it's a name fragment, search `n8n/*.json` for a match
   - If empty, list all `n8n/*.json` files and ask which one

2. **Extract workflow ID + API credentials**

3. **Pull remote to temp file**

4. **Run structural diff** (same as /n8n-diff)

5. **Present options based on diff**
   - If no differences: "Local and remote are in sync. Nothing to do."
   - If local has changes: Ask user — "Push local changes to n8n?" or "Pull remote to overwrite local?"
   - If remote has changes local doesn't: Ask user — "Pull remote changes?" or "Push local to overwrite remote?"
   - If both have changes: Show both sides and ask which direction

6. **Execute chosen action**
   - Push: use the n8n-workflow-push allowlist pattern
   - Pull: save remote version to local file

7. **Report result**

## Report

```
n8n Sync: [workflow name]

Direction: [Push local → n8n / Pull n8n → local / Already in sync]

Changes:
  [diff summary]

Result: [Success / Error]
```
