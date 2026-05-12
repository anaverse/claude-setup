---
description: Initialize a new PEX project with shared .env, brand reference, and standard structure
allowed-tools: Bash, Read, Write, Glob
model: sonnet
---

# PEX Init

## Purpose

Set up any new PEX (Plants Express) project with:
- Shared `.env` symlink (all PEX repos share one file)
- Brand reference document
- Standard folder structure
- `.gitignore` for secrets

Run this when creating a new PEX repo or when a PEX project is missing its shared config.

## Workflow

### 1. Check shared .env exists

```bash
ls -la ~/pex-shared.env
```

If missing, warn the user: "Shared env file not found at ~/pex-shared.env. Create it first by copying an existing PEX .env there."

### 2. Link .env

Check if `.env` already exists in this project:
- If it's already a symlink to `~/pex-shared.env` — skip, report "already linked"
- If it's a regular file — back it up to `.env.backup-YYYYMMDD`, then replace with symlink
- If it doesn't exist — create the symlink

```bash
ln -s ~/pex-shared.env .env
```

Verify the symlink works:
```bash
[ -f .env ] && echo "OK: .env linked" || echo "FAIL: symlink broken"
```

### 3. Copy brand reference

Copy the PEX brand reference to this project (if not already present):

```bash
cp ~/Vibe\ Coding/PEX-BRAND-REFERENCE.md ./PEX-BRAND-REFERENCE.md
```

If it already exists, skip.

### 4. Scaffold folders

Create standard PEX project folders if missing:

```bash
mkdir -p specs/todo specs/done specs/handoffs
```

### 5. Ensure .gitignore covers secrets

Check `.gitignore` exists and contains `.env` entries. If not, append:

```
# Secrets
.env
.env.*
!.env.example
pex-shared.env
```

### 6. Update Obsidian PEX index

Read `/Users/ana/Documents/flowlabs/Companies/PEX/_index.md` and check if this repo is listed. If not, suggest adding it.

### 7. Read the project

Run the equivalent of `/prime-init`:
- `git ls-files` to list tracked files
- Read `README.md` if it exists
- Identify stack from package.json / requirements.txt / pyproject.toml
- Note folder structure and entry points

## Report

```
PEX Project Initialized

Project: [name]
Stack: [technologies]

Setup:
  .env:             [linked / already linked / backed up + linked]
  Brand reference:  [copied / already present]
  Folders:          [created / already exist]
  .gitignore:       [updated / already good]

Structure:
- [key folder]: [purpose]

Entry Points:
- [file]: [description]

Shared .env: ~/pex-shared.env (76 keys)
Brand ref:   ./PEX-BRAND-REFERENCE.md

Ready to work. What would you like to do?
```
