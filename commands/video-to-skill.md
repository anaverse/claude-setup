---
description: Convert a screen recording into a Claude Code skill by extracting an SOP via Gemini video understanding, then drafting the skill
allowed-tools: Bash, Read, Write, Edit, Glob, AskUserQuestion
model: opus
argument-hint: <path-to-video-file>
---

# Video to Skill

## Purpose

Turn a screen recording of any process into a Claude Code skill. Uses Gemini's video understanding API to extract a detailed SOP (capturing tacit knowledge, nuances, and spoken commentary), then converts that SOP into a ready-to-use command file.

Use when: you want to automate something you already do manually and the easiest way to document it is to just *do it* on screen.

## Variables

VIDEO_PATH: $ARGUMENTS
GEMINI_MODEL: gemini-3-flash-preview
COMPRESS_THRESHOLD_MB: 50
OUTPUT_DIR: ~/.claude/commands
SOP_DIR: ~/.claude/sops

## Instructions

- Require `GEMINI_API_KEY` env var — fail fast with a clear message if missing
- Use `uv run --with google-genai` for all Python code (avoids PEP 668 system Python issues)
- If video > 50MB, compress it with ffmpeg before uploading (target ~30MB, keep audio)
- Upload via Gemini Files API and poll until state is ACTIVE
- Extract SOP capturing: all steps in order, tacit decisions, spoken nuances, style preferences, things the user seems to care about
- Save the raw SOP as a markdown file in `~/.claude/sops/` for reference
- Then use the SOP to draft a skill following the standard command template
- Ask user to confirm the skill name and trigger description before writing
- Save the final skill to `~/.claude/commands/`

## Workflow

1. **Validate inputs**
   - Check `$ARGUMENTS` is provided — if empty, ask user for the video path via AskUserQuestion
   - Verify the file exists and is a video format (.mp4, .mov, .webm, .avi)
   - Check `GEMINI_API_KEY` is set in the environment; if not, try fetching from macOS Keychain: `security find-generic-password -s "GEMINI_API_KEY" -w`. If neither works, print: `Error: GEMINI_API_KEY not set. Get one at https://aistudio.google.com` and stop

2. **Prepare the video**
   - Get file size with `du -sh`
   - If > 50MB, compress using Python + ffmpeg:
     ```bash
     python3 -c "
     import subprocess, os, sys
     input_path = sys.argv[1]
     output_path = input_path.replace('.', '_compressed.')
     subprocess.run(['ffmpeg', '-i', input_path, '-vf', 'scale=1280:-2', '-crf', '28', '-preset', 'fast', '-c:a', 'aac', '-b:a', '96k', output_path], check=True)
     print(output_path)
     " "$VIDEO_PATH"
     ```
   - Use the compressed file for upload; inform user of size reduction

3. **Upload to Gemini Files API**
   - Run all Python code via `uv run --with google-genai python3 -c "..."` (system Python is PEP 668 protected)
   - Upload and wait for processing:
     ```python
     import os, time, subprocess
     from google import genai

     # Get API key from env or macOS Keychain
     api_key = os.environ.get("GEMINI_API_KEY") or subprocess.check_output(
         ["security", "find-generic-password", "-s", "GEMINI_API_KEY", "-w"]
     ).decode().strip()
     client = genai.Client(api_key=api_key)

     print("Uploading video to Gemini Files API...")
     video_file = client.files.upload(file=VIDEO_PATH)

     print(f"Uploaded: {video_file.name} — waiting for processing...")
     while video_file.state.name == "PROCESSING":
         time.sleep(3)
         video_file = client.files.get(name=video_file.name)

     if video_file.state.name == "FAILED":
         raise ValueError(f"File processing failed: {video_file.state.name}")

     print(f"Ready: {video_file.uri}")
     ```

4. **Extract the SOP**
   - Send to Gemini with this prompt:
     ```
     Watch this screen recording carefully. Your job is to produce the most comprehensive,
     detailed Standard Operating Procedure (SOP) of everything you observe.

     Extract and document:
     1. Every step in order — including micro-decisions and clicks
     2. Anything said out loud (spoken nuances, opinions, complaints, preferences)
     3. Things the person does WITHOUT explaining why — these are tacit knowledge gems
     4. Quality standards implied by their choices (e.g. they rewrote it 3 times → they care about X)
     5. Style or tone preferences visible from their interactions
     6. Any tools, websites, or references they use and WHY
     7. Decision points where a different choice would lead to a different outcome

     Format as structured markdown with phases, steps, and a "Key Nuances & Tacit Knowledge" section at the end.
     Be specific. Capture the devil in the details. This SOP will be used to train an AI agent to do this task.
     ```
   - Save the SOP to `~/.claude/sops/<video-filename>-sop.md`
   - Print a summary of the key phases identified

5. **Design the skill**
   - Read the SOP carefully
   - Identify: what triggers this skill, what inputs are needed, what the human must decide vs what can be automated
   - Draft the skill following the standard command template (see below)
   - Use AskUserQuestion to confirm:
     - The skill name (kebab-case)
     - The trigger description (one line, used in /help)
     - Whether to add human-in-the-loop checkpoints (minimal / moderate / full control)

6. **Write the skill**
   - Save to `~/.claude/commands/<skill-name>.md`
   - Print the full skill content so user can review
   - Remind: "Restart your Claude Code session for the new skill to be available"

## Command Template Structure

```markdown
---
description: [what it does, when to use it]
allowed-tools: [tools needed]
model: sonnet
argument-hint: [optional]
---

# Skill Name

## Purpose
[What it does and when to use it]

## Variables
[Dynamic inputs first, then static constants]

## Instructions
[Rules and constraints as bullet points]

## Workflow
[Numbered steps — be explicit about decision points and human-in-the-loop moments]

## Report
[What gets output at the end]
```

## Report

```
Video-to-Skill Complete

SOP saved:   ~/.claude/sops/<name>-sop.md
Skill saved: ~/.claude/commands/<name>.md

Key phases extracted: [list]
Skill trigger: [description]

Next: restart Claude Code session, then invoke with /<skill-name>
```
