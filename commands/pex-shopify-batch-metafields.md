---
description: Batch set variant-level metafields across Shopify products — delivery states, custom fields, etc.
allowed-tools: Read, Edit, Write, Bash, Grep, Glob, mcp__shopify-pex__list_products, mcp__shopify-pex__get_product, mcp__shopify-pex__get_metafield_definitions, mcp__shopify-pex__set_metafields
model: sonnet
argument-hint: [what to set, e.g. "delivery states CA,AZ on all trees" or "set custom.warranty to '2 years' on all shrubs"]
---

# PEX Shopify Batch Metafields

## Purpose

Batch set a metafield across many product variants in Shopify. Uses the batch script at `shopify-mcp/scripts/batch-set-delivery-states.ts` as a template, or runs individual MCP calls for small sets.

## Variables

TASK: $ARGUMENTS
SCRIPT_PATH: shopify-mcp/scripts/batch-set-delivery-states.ts
STORE: johnblackburn.myshopify.com

## Instructions

### Choosing the approach

| Variants | Approach |
|----------|----------|
| 1-20 | Use `set_metafields` MCP tool directly with variant GIDs |
| 20+ | Use or adapt the batch script |

### For small batches (MCP calls)

1. Look up products with `list_products` or `get_product`
2. Extract variant GIDs
3. Call `set_metafields` with `ownerId` set to the variant GID (not product GID)
4. The `metafieldsSet` mutation accepts any GID as ownerId — product OR variant

### For large batches (script)

The batch script at `shopify-mcp/scripts/batch-set-delivery-states.ts` is the template. To adapt it:

1. **Read the script** to understand the current config
2. **Modify these sections as needed:**
   - `STATES` array (or rename to whatever values you're setting)
   - `EXCLUDE_PATTERNS` — product categories to skip
   - `shouldExclude()` — filtering logic (uses primary category from first segment of productType before ">")
   - The metafield namespace/key/type in `batchSetMetafields()`
3. **Always dry-run first:** `npx tsx scripts/batch-set-delivery-states.ts --dry-run`
4. **Review excluded vs included** products before running live
5. **Run live:** `npx tsx scripts/batch-set-delivery-states.ts`

### Key details

- Metafield `custom.delivery_allowed_states` is `list.single_line_text_field` type
- Value format for list type: `["CA","WA","TX"]` (JSON array as string)
- Script reads credentials from `~/.claude/mcp.json` (shopify-pex entry)
- Script batches 25 variants per API call (Shopify max for metafieldsSet)
- Auth is OAuth client_credentials (auto-handled)

### Exclusion logic

The `shouldExclude()` function uses the **first segment** of productType (before ">") to avoid false positives from keyword-stuffed SEO tails. For example, "succulents > succulent soil" has primary category "succulents", not "soil".

Current exclusions: citrus, groundcover, soils, fertilizers, mulch, amendments, DRAFT/ARCHIVED products.

## Workflow

1. **Understand the task** — what metafield, what value, which products
2. **Choose approach** — MCP calls vs batch script
3. **Dry run** — preview what will be changed
4. **Get confirmation** — show the user included/excluded counts
5. **Execute** — run live
6. **Report** — summarize results

## Report

```
Batch Metafield Update Complete

Metafield: [namespace.key]
Value: [what was set]
Products: [count] updated, [count] excluded
Variants: [count] updated
Errors: [count]
```
