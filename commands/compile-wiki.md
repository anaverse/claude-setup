---
description: Compile raw notes and session logs into wiki knowledge articles
allowed-tools: Read, Glob, Bash, mcp__MCP_DOCKER__obsidian_simple_search, mcp__MCP_DOCKER__obsidian_list_files_in_dir, mcp__MCP_DOCKER__obsidian_get_file_contents, mcp__MCP_DOCKER__obsidian_append_content, mcp__MCP_DOCKER__obsidian_patch_content, mcp__MCP_DOCKER__obsidian_delete_file
model: opus
argument-hint: [optional: specific wiki category to focus on]
---

# Compile Wiki

## Purpose

Synthesize raw ingested notes and recent session logs into wiki knowledge articles. This is the core compilation step — turning scattered information into organized, interlinked concept articles.

## Variables

CATEGORY: $ARGUMENTS (if provided, only compile into that category; otherwise compile everything new)

## Instructions

- Read the master index first to understand current wiki state
- Only process raw notes with `status: ingested` (not yet `compiled`)
- Only process session logs from the last 7 days that haven't been synthesized
- Merge into existing articles when possible; create new articles only for genuinely new topics
- Always update _index.md files after changes
- Use [[wikilinks]] for connections between articles
- Keep articles focused — one concept per article

## Workflow

1. **Read current wiki state**
   - Read `wiki/_index.md` to get categories and article counts
   - Read each category's `_index.md` to get article summaries

2. **Gather new content to compile**
   - List files in `raw/clips/`, `raw/drops/`, `raw/feeds/`
   - Read each file, filter to those with `status: ingested` (not `compiled`)
   - List recent files in `Claude/Sessions/`, `Claude/Learnings/`, `Claude/Decisions/`
   - Read those from the last 7 days

3. **Plan compilation**
   - For each piece of new content, determine:
     - Which wiki category it belongs to
     - Whether an existing article covers this topic (check category indexes)
     - If no category fits, what new category to create
   - Group content by target article

4. **Compile articles**
   For each target article:

   **If updating an existing article:**
   a. Read the current article with `obsidian_get_file_contents`
   b. Merge new information into the appropriate sections
   c. Update the `updated` date in frontmatter
   d. Add new sources to the Sources section
   e. Add any new [[Connections]]
   f. Write back with `obsidian_patch_content`

   **If creating a new article:**
   a. Create the wiki category directory if it doesn't exist (by creating the _index.md)
   b. Write the article with `obsidian_append_content`:
      ```markdown
      ---
      date: [today]
      updated: [today]
      type: wiki
      tags: #wiki/[category]
      sources:
        - [raw note path or session path]
      ---

      # [Concept Name]

      ## Overview
      [What this concept is, why it matters — 2-3 sentences]

      ## Details
      [Core knowledge, organized by subtopic with ### headers as needed]

      ## Connections
      - [[wiki/category/related-article]] — [how they relate]

      ## Sources
      - [[raw/channel/filename]] — [what it contributed]
      ```

5. **Update index files**
   - For each category that was touched, rewrite its `_index.md`:
     ```markdown
     ---
     type: system
     tags: #wiki/index
     ---
     # [Category Name]

     Last updated: [today]
     Articles: [count]

     | Article | Summary | Updated |
     |---------|---------|---------|
     | [[article-name]] | One-line description | [date] |
     ```
   - Rewrite `wiki/_index.md` with updated category list and counts

6. **Mark raw notes as compiled**
   - For each raw note that was compiled, update its frontmatter: `status: compiled`
   - Use `obsidian_patch_content` to change `status: ingested` to `status: compiled`

7. **Report results**

## Report

```
Wiki Compilation Complete

New content processed:
- Raw notes: [N] compiled
- Session logs: [N] synthesized

Wiki changes:
- Updated articles: [N]
  - [category/article-name] — [what was added]
- Created articles: [N]
  - [category/article-name] — [summary]
- New categories: [N]
  - [category-name]

Wiki stats:
- Total categories: [N]
- Total articles: [N]
```
