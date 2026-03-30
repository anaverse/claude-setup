---
description: Pull an n8n workflow from the live instance to a local JSON file
allowed-tools: Bash, Read, Glob, Grep
model: sonnet
argument-hint: [workflow ID or name fragment]
---

# n8n Pull

## Purpose

Pull a workflow from n8n via REST API and save it locally. Preserves full response for local reference.

## Variables

WORKFLOW_ARG: $ARGUMENTS

## Instructions

Reference the **n8n-workflow-sync** skill for the correct pull pattern.

## Workflow

1. **Identify the workflow**
   - If WORKFLOW_ARG looks like an ID (alphanumeric), use it directly
   - If it's a name fragment, list remote workflows and find the match
   - If empty, list all remote workflows and ask which one

2. **Extract API credentials**
   ```bash
   N8N_API_URL=$(python3 -c "import json; print(json.load(open('$HOME/.mcp.json'))['mcpServers']['n8n-mcp']['env']['N8N_API_URL'])")
   N8N_API_KEY=$(python3 -c "import json; print(json.load(open('$HOME/.mcp.json'))['mcpServers']['n8n-mcp']['env']['N8N_API_KEY'])")
   ```

3. **Pull the workflow**
   ```bash
   curl -s "$N8N_API_URL/api/v1/workflows/$WORKFLOW_ID" \
     -H "X-N8N-API-KEY: $N8N_API_KEY" \
     | python3 -c "import json,sys; print(json.dumps(json.load(sys.stdin), indent=2))" \
     > "$OUTPUT_FILE"
   ```

4. **Determine output file**
   - Check if a local file already exists for this workflow (match by `id` in `n8n/*.json`)
   - If yes, overwrite it
   - If no, create `n8n/<workflow-name-slugified>.json`

5. **Report result**
   - Show: file path, workflow name, node count, active status

## Report

```
n8n Pull Complete

Workflow: [name]
ID: [id]
Saved to: [file path]
Nodes: [count]
Active: [yes/no]
```
