# Hostinger Management

## Purpose
Manage Hostinger hosting infrastructure — deploy WordPress themes/plugins, manage DNS, set up email records, and import sites.

## Prerequisites
- Hostinger MCP server configured in global settings
- `HOSTINGER_API_TOKEN` env var set in `~/.zshrc`

## Available Tools

### Deployment
| Tool | Use For |
|------|---------|
| `hosting_deployWordpressTheme` | Deploy a theme folder to a domain (params: domain, slug, themePath, activate) |
| `hosting_deployWordpressPlugin` | Deploy a plugin to a domain (params: domain, slug, pluginPath) |
| `hosting_importWordpressWebsite` | Full WP import from archive (params: domain, archivePath, databaseDump) |
| `hosting_deployStaticWebsite` | Deploy static HTML/CSS/JS site (params: domain, archivePath) |
| `hosting_deployJsApplication` | Deploy Node.js app (params: domain, archivePath) |

### DNS Management
| Tool | Use For |
|------|---------|
| `DNS_getDNSRecordsV1` | View current DNS records for a domain |
| `DNS_updateDNSRecordsV1` | Add/update DNS records (MX, TXT, CNAME, A records) |
| `DNS_deleteDNSRecordsV1` | Remove DNS records |
| `DNS_resetDNSRecordsV1` | Reset DNS to defaults |
| `DNS_validateDNSRecordsV1` | Validate records before applying |
| `DNS_getDNSSnapshotListV1` | List DNS backup snapshots |
| `DNS_restoreDNSSnapshotV1` | Restore DNS from a snapshot |

### Billing
| Tool | Use For |
|------|---------|
| `billing_getSubscriptionListV1` | List all subscriptions |
| `billing_getCatalogItemListV1` | View available services and pricing |

## Common Workflows

### Deploy WordPress Theme
```
1. hosting_deployWordpressTheme with domain, slug (theme folder name), themePath (local path), activate: true
```

### Set Up Email DNS (MX Records)
```
1. DNS_getDNSRecordsV1 — check current records
2. DNS_updateDNSRecordsV1 — add MX, SPF (TXT), DKIM (CNAME) records
```

### Google Search Console Verification
```
1. DNS_updateDNSRecordsV1 — add TXT record with verification code
```

### Full Site Migration
```
1. Zip theme + database dump
2. hosting_importWordpressWebsite with domain, archivePath, databaseDump
```

## Notes
- Always check DNS records before modifying (`DNS_getDNSRecordsV1`)
- Take a DNS snapshot before major changes (`DNS_getDNSSnapshotListV1`)
- Theme deployment requires the theme to be in a local directory accessible to the MCP
