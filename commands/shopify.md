---
description: Manage Shopify products — list, create, update, pricing, images, metafields
allowed-tools: Read, Bash, Grep, Glob, mcp__shopify__list_products, mcp__shopify__get_product, mcp__shopify__create_product, mcp__shopify__update_product, mcp__shopify__update_variants, mcp__shopify__add_variants, mcp__shopify__add_images, mcp__shopify__reorder_images, mcp__shopify__get_metafield_definitions, mcp__shopify__set_metafields
model: sonnet
argument-hint: [what to do, e.g. "list all products" or "update SKU pricing"]
---

# Shopify

## Purpose

Manage Shopify products via the shopify MCP server. Use this for product lookups, price changes, creating new PDPs, managing images, and setting metafields.

## Variables

TASK: $ARGUMENTS
STORE: your-store.myshopify.com
AUDIT_LOG: shopify-mcp/logs/audit.jsonl

## Instructions

- You have 10 MCP tools — 3 read, 7 write. There are NO delete tools by design.
- **Always look before you leap** — use `list_products` or `get_product` to verify state before making changes.
- **Price guardrails** are enforced: $0.01–$9,999.99. Prices outside this range will be rejected.
- **Setting status to ACTIVE** requires a two-step confirmation (first call returns a prompt, second call with `confirm: true` applies it).
- All write operations are logged to `shopify-mcp/logs/audit.jsonl`.
- Product GIDs look like `gid://shopify/Product/123456789`. You can also look up by handle.
- When creating products, default to DRAFT status unless explicitly asked to go live.
- For variant prices, pass numbers (not strings) — the tool converts them.

## Available Tools

| Tool | Type | Purpose |
|------|------|---------|
| `list_products` | Read | Search/browse by title, vendor, tag, status |
| `get_product` | Read | Full details by GID or handle (variants, metafields, images) |
| `get_metafield_definitions` | Read | List all metafield schemas |
| `create_product` | Write | New product (defaults DRAFT) with optional variants |
| `update_product` | Write | Change title, description, vendor, status, tags |
| `update_variants` | Write | Update price, SKU, weight on existing variants |
| `add_variants` | Write | Add new variants to a product |
| `add_images` | Write | Upload images from URLs |
| `reorder_images` | Write | Change image display order |
| `set_metafields` | Write | Create/update metafields (max 25/call) |

## Workflow

1. **Parse the task** — understand what the user wants to do
2. **Gather context** — look up relevant products/data first
3. **Execute** — make the changes using the appropriate tool(s)
4. **Verify** — confirm the changes took effect
5. **Report** — summarize what was done

## Report

```
Shopify Update Complete

Action: [what was done]
Products affected: [list]
Changes: [summary of changes]

Audit log entry written.
```
