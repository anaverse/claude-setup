---
description: Compare a local n8n workflow JSON with the live version in n8n
allowed-tools: Bash, Read, Glob, Grep
model: sonnet
argument-hint: [workflow file path or name fragment]
---

# n8n Diff

## Purpose

Structurally compare a local workflow JSON with the live version in n8n. Shows added, removed, and changed nodes.

## Variables

WORKFLOW_ARG: $ARGUMENTS

## Instructions

Reference the **n8n-workflow-sync** skill for the diff pattern.

## Workflow

1. **Find the local workflow file**
   - If WORKFLOW_ARG is a full path, use it directly
   - If it's a name fragment, search `n8n/*.json` for a match
   - If empty, list all `n8n/*.json` files and ask which one

2. **Extract workflow ID from local file**
   - Read the JSON and get the `id` field

3. **Extract API credentials**
   ```bash
   N8N_API_URL=$(python3 -c "import json; print(json.load(open('$HOME/.mcp.json'))['mcpServers']['n8n-mcp']['env']['N8N_API_URL'])")
   N8N_API_KEY=$(python3 -c "import json; print(json.load(open('$HOME/.mcp.json'))['mcpServers']['n8n-mcp']['env']['N8N_API_KEY'])")
   ```

4. **Pull remote version to temp file**
   ```bash
   curl -s "$N8N_API_URL/api/v1/workflows/$WORKFLOW_ID" \
     -H "X-N8N-API-KEY: $N8N_API_KEY" \
     | python3 -c "import json,sys; print(json.dumps(json.load(sys.stdin), indent=2))" \
     > /tmp/n8n-remote-workflow.json
   ```

5. **Run structural diff**
   - Compare node sets (added/removed)
   - Compare parameters of shared nodes (changed)
   - Compare connection changes
   - Show summary

## Report

```
n8n Diff: [workflow name]

Nodes: [local count] local / [remote count] remote

Added locally (not in n8n):
  + [node name]

Removed locally (in n8n but not local):
  - [node name]

Changed parameters:
  ~ [node name]

Connections changed: [yes/no]

Summary: [X added, Y removed, Z changed] or "No differences"
```
