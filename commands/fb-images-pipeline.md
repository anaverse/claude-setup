# Facebook Images Pipeline

Scrapes all images from a Facebook business page, renames them with SEO-friendly names (`{client-slug}_{seq}_{caption}.jpg`), uploads to WordPress media library, and backs up to Box.com.

## Variables

ARGS: $ARGUMENTS

## Setup Check

Before running, verify the project has:

1. A `.env` file (copy from `.env.example` if missing)
2. A `pipeline.py` file in the project root
3. Python venv active or dependencies installed

## Auth Setup Guide (run once per client)

### Anthropic API Key (for AI image naming)
1. Go to https://console.anthropic.com/account/keys
2. Create a new key → add to `.env` as `ANTHROPIC_API_KEY`
3. Uses claude-haiku-4-5 (~$0.001/image). Pass `--skip-ai` to bypass.

### Apify Token
1. Sign up at https://apify.com (free tier = $5/month credit)
2. Go to https://console.apify.com/account/integrations
3. Copy your API token → add to `.env` as `APIFY_API_TOKEN`

### WordPress Application Password
1. WP Admin → Users → Your Profile
2. Scroll to "Application Passwords" section
3. Enter name (e.g., "Pipeline Script") → click "Add New"
4. Copy the password (spaces included) → add to `.env` as `WP_APP_PASSWORD`
5. Site must be on HTTPS

### Box.com Developer Token (personal accounts)
1. Go to https://app.box.com/developers/console
2. Create New App → Custom App → Server Authentication (CCG)
3. Open your app → "Developer Token" tab → click "Generate Developer Token"
4. Copy the token → add to `.env` as `BOX_DEVELOPER_TOKEN`
5. **Token expires in 60 minutes** — regenerate before large runs
6. Pipeline auto-creates a `/{client-slug}/` subfolder in your Box root

## Instructions

Parse ARGS for:
- `--page <url>` — Facebook page URL (required if not in .env)
- `--client <slug>` — client slug for file naming (required if not in .env)
- `--limit N` — cap number of images (default 500)
- `--dry-run` — preview without making changes
- `--step <name>` — run only one step: scrape, download, upload-wp, upload-box, status

1. Check that `pipeline.py` exists in the current directory. If not, tell the user to run this command from the project folder.
2. Check that `.env` exists. If not:
   - Offer to copy `.env.example` to `.env`
   - Show the auth setup guide above
   - Stop and ask them to fill in the values
3. If `--client` is provided, update `.env` to set `CLIENT_SLUG={slug}`
4. If `--page` is provided, update `.env` to set `FACEBOOK_PAGE_URL={url}`
5. Run the pipeline:
   - Full run: `python pipeline.py run [--limit N] [--dry-run]`
   - Single step: `python pipeline.py {step} [--limit N] [--dry-run]`
6. Report results to the user.

## Example Usage

```bash
# Full pipeline (uses .env for page URL and client slug)
/fb-images-pipeline

# Full pipeline with overrides
/fb-images-pipeline --page https://facebook.com/WoodEnWonders --client wood-en-wonders

# Dry run to preview (no changes made)
/fb-images-pipeline --dry-run --limit 5

# Scrape only
/fb-images-pipeline --step scrape

# Upload already-downloaded images to WordPress only
/fb-images-pipeline --step upload-wp

# Upload already-downloaded images to Box only
/fb-images-pipeline --step upload-box

# Check what's in the downloads folder
/fb-images-pipeline --step status
```

## Reusing for a New Client

1. Create a new project folder for the client
2. Copy `pipeline.py`, `config.py`, `requirements.txt`, `.env.example` into it
3. Create a new `.env` with the client's values
4. Run `/fb-images-pipeline --client new-client-slug --page https://facebook.com/TheirPage`
