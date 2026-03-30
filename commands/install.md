---
description: Install commands to your global universal commands folder
allowed-tools: Read, Write, Bash, Glob
model: sonnet
---

# Install Commands

## Purpose

Copy commands from this project to your global `~/.claude/commands/` folder, making them available in every project. Since you cloned this repo, you already have these commands at the project level - this installs them universally.

## Instructions

- List all available commands in this project
- Let user select which ones to install globally
- Copy selected commands to `~/.claude/commands/`
- Do not overwrite existing commands without confirmation
- Report what was installed

## Workflow

1. **List available commands**
   - Read all `.md` files in `.claude/commands/`
   - Display each with its description

2. **Check existing global commands**
   - List files in `~/.claude/commands/`
   - Note any that would be overwritten

3. **Present options to user**
   - Show all available commands
   - Indicate which already exist globally
   - Ask which commands to install

4. **Handle conflicts**
   - If a command already exists globally, ask:
     - Skip (keep existing)
     - Overwrite (replace with this version)

5. **Copy selected commands**
   - Ensure `~/.claude/commands/` exists
   - Copy each selected command file
   - Preserve the original filename

6. **Confirm installation**
   - List what was installed
   - List what was skipped

## Report

```
Command Installation Complete

Installed to ~/.claude/commands/:
- quick-plan.md
- build.md
- prime.md

Skipped (already exist):
- all-tools.md

These commands are now available in all projects.
Try: /quick-plan "your feature idea"
```

## Available Commands

| Command | Description |
|---------|-------------|
| all-tools | List all Claude Code tools |
| prime | Understand a codebase quickly |
| parallel-subagents | Launch multiple agents in parallel |
| quick-plan | Create implementation plans |
| build | Build from a plan file |
| handoff | Save session state |
| pickup | Resume from handoff |
| create-command | Generate new commands |
