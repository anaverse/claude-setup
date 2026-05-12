---
description: Process raw files in your Obsidian vault into structured notes
allowed-tools: Read, Glob, Bash, mcp__MCP_DOCKER__obsidian_simple_search, mcp__MCP_DOCKER__obsidian_list_files_in_dir, mcp__MCP_DOCKER__obsidian_get_file_contents, mcp__MCP_DOCKER__obsidian_append_content, mcp__MCP_DOCKER__obsidian_patch_content, mcp__MCP_DOCKER__obsidian_delete_file
model: sonnet
argument-hint: [optional: specific subfolder - clips, drops, or feeds]
---

# Ingest Raw

## Purpose

Process unstructured files in `raw/` into structured notes with frontmatter, summaries, and key points. This is the first stage of the knowledge base pipeline — raw content goes in, structured notes come out.

## Variables

SUBFOLDER: $ARGUMENTS (if provided, only process that subfolder; otherwise process all three)

## Instructions

- Process files in all three raw/ subdirectories unless a specific one is given
- Skip files that already have `status: ingested` or `status: compiled` in frontmatter
- Skip README.md files in each directory
- For each file: read it, generate a structured version, overwrite in place
- Be concise in summaries — 2-3 sentences max
- Auto-detect topics from content for tagging

## Workflow

1. **Determine scope**
   - If SUBFOLDER is provided, only scan `raw/[SUBFOLDER]/`
   - Otherwise scan `raw/clips/`, `raw/drops/`, `raw/feeds/`

2. **List files in each directory**
   - Use `obsidian_list_files_in_dir` for each directory
   - Filter out README.md and any file whose content starts with `status: ingested` or `status: compiled`

3. **For each unprocessed file:**
   a. Read the file with `obsidian_get_file_contents`
   b. Determine the channel from the directory (clips, drops, feeds)
   c. Extract or generate:
      - Title (from content or filename)
      - Source URL (from content if available, otherwise filename)
      - 2-3 sentence summary
      - 3-5 key points
      - Topic tags (auto-detected from content)
   d. Overwrite the file using `obsidian_patch_content` with structured format:
      ```markdown
      ---
      date: [today's date]
      source: [url or original filename]
      type: raw
      tags: #raw/[channel]
      status: ingested
      topics: [comma-separated auto-detected topics]
      ---

      # [Title]

      ## Summary
      [2-3 sentence summary]

      ## Key Points
      - [point 1]
      - [point 2]
      - [point 3]

      ## Raw Content
      [cleaned/formatted original content]
      ```

4. **Report results**

## Report

```
Ingest Complete

Scanned: [N] directories
Processed: [N] files
Skipped: [N] (already ingested)

Processed files:
- raw/clips/[filename] — [title] — topics: [tags]
- raw/drops/[filename] — [title] — topics: [tags]

Ready for compilation with /compile-wiki
```
