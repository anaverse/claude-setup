---
description: Push a local n8n workflow JSON to the live n8n instance
allowed-tools: Bash, Read, Glob, Grep
model: sonnet
argument-hint: [workflow file path or name fragment]
---

# n8n Push

## Purpose

Push a local workflow JSON file to n8n via REST API. Handles field stripping and validation automatically.

## Variables

WORKFLOW_ARG: $ARGUMENTS

## Instructions

Reference the **n8n-workflow-push** skill for the correct allowlist pattern.

## Workflow

1. **Find the workflow file**
   - If WORKFLOW_ARG is a full path, use it directly
   - If it's a name fragment, search `n8n/*.json` for a match
   - If empty, list all `n8n/*.json` files and ask which one

2. **Extract workflow ID**
   - Read the JSON file and get the `id` field
   - If no `id` field, ask the user for the workflow ID

3. **Extract API credentials**
   ```bash
   N8N_API_URL=$(python3 -c "import json; print(json.load(open('$HOME/.mcp.json'))['mcpServers']['n8n-mcp']['env']['N8N_API_URL'])")
   N8N_API_KEY=$(python3 -c "import json; print(json.load(open('$HOME/.mcp.json'))['mcpServers']['n8n-mcp']['env']['N8N_API_KEY'])")
   ```

4. **Clean the payload** (allowlist only)
   - Keep ONLY: `name`, `nodes`, `connections`, `settings`, `staticData`, `pinData`
   - Strip `settings` to only `executionOrder`
   - Write cleaned JSON to `/tmp/n8n-push-payload.json`

5. **Push via curl**
   ```bash
   curl -s -X PUT "$N8N_API_URL/api/v1/workflows/$WORKFLOW_ID" \
     -H "X-N8N-API-KEY: $N8N_API_KEY" \
     -H "Content-Type: application/json" \
     -d @/tmp/n8n-push-payload.json
   ```

6. **Report result**
   - Parse response: success has `id` field, error has `message`
   - Show: workflow name, node count, status

## Report

```
n8n Push Complete

Workflow: [name]
ID: [id]
Nodes: [count]
Status: Success / Error: [message]
```
