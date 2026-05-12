---
description: Run a health check and discovery pass on your Obsidian knowledge base
allowed-tools: Read, Glob, Bash, mcp__MCP_DOCKER__obsidian_simple_search, mcp__MCP_DOCKER__obsidian_list_files_in_dir, mcp__MCP_DOCKER__obsidian_get_file_contents, mcp__MCP_DOCKER__obsidian_append_content, mcp__MCP_DOCKER__obsidian_patch_content
model: opus
argument-hint: [optional: consistency, discovery, or both (default: both)]
---

# Lint Vault

## Purpose

Run a health check over the Obsidian knowledge base. Finds inconsistencies, stale data, orphaned notes, and suggests new connections and articles. Writes a report to `wiki/_lint-report.md`.

## Variables

MODE: $ARGUMENTS (consistency, discovery, or both — default: both)

## Instructions

- This is a read-heavy operation — read everything, write only the report
- Be specific in findings — include file paths, dates, and concrete suggestions
- Prioritize actionable findings over noise
- The report should be useful on its own — user reads it and decides what to act on

## Workflow

### Pass 1 — Consistency (skip if MODE is "discovery")

1. **Check wiki article sources**
   - For each wiki article, read its `sources` frontmatter
   - Verify each source file still exists using `obsidian_list_files_in_dir`
   - Flag articles with broken source references

2. **Find orphaned raw notes**
   - List all files in `raw/clips/`, `raw/drops/`, `raw/feeds/`
   - Find notes with `status: ingested` that are older than 7 days (stuck in limbo)

3. **Find stale articles**
   - For each wiki article, compare its `updated` date with the dates of its source files
   - If any source was modified after the article's `updated` date, flag as stale

4. **Find duplicates**
   - Read all wiki article titles and overviews
   - Flag articles with significantly overlapping topics that should be merged

### Pass 2 — Discovery (skip if MODE is "consistency")

1. **Missing backlinks**
   - For each wiki article, scan its content for concept names that match other article titles
   - Flag mentions that aren't wrapped in [[wikilinks]]

2. **Uncompiled clusters**
   - Find groups of 3+ raw notes with similar topics that don't have a wiki article
   - Suggest new article candidates

3. **Cross-category connections**
   - Read articles across different categories
   - Suggest connections between articles that reference similar concepts

4. **Session coverage gaps**
   - Read recent session logs (last 30 days)
   - Find topics mentioned in 3+ sessions that have no wiki coverage

### Pass 3 — Write Report

Write the report to `wiki/_lint-report.md` using `obsidian_patch_content` (overwrite any existing report):

```markdown
---
date: [today]
type: lint
---

# Vault Health Check — [today]

## Stats
- Wiki articles: [count]
- Raw notes: [count] ([uncompiled count] uncompiled)
- Categories: [count]
- Sessions analyzed: [count]

## Issues Found

### Broken Source References
- [[wiki/category/article]] — source [[raw/path]] no longer exists

### Stale Articles (source updated since last compile)
- [[wiki/category/article]] — source updated [date], article last compiled [date]

### Orphaned Raw Notes (ingested but never compiled)
- [[raw/channel/filename]] — ingested [date], topics: [topics]

### Suggested Merges
- [[wiki/cat/article-a]] + [[wiki/cat/article-b]] — [reason for overlap]

## Discovery

### Suggested New Articles
- "[Topic]" — [N] raw notes, [N] session mentions, no wiki article

### Missing Backlinks
- [[wiki/cat/article]] mentions "[concept]" but doesn't link to [[wiki/cat/other-article]]

### Cross-Category Connections
- [[wiki/cat-a/article]] should link to [[wiki/cat-b/article]] — [reason]

### Questions Worth Investigating
- [Question suggested by patterns in the data]
```

## Report (to user)

```
Vault Health Check Complete

Report: wiki/_lint-report.md

Summary:
- [N] issues found
- [N] discovery suggestions
- [N] new article candidates

Top findings:
- [Most important finding]
- [Second finding]
- [Third finding]

Run /compile-wiki to address compilation gaps.
```
