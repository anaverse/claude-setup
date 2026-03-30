#!/bin/bash
# Install Claude Code setup — symlinks config into ~/.claude/
# Usage: ./install.sh
# Safe: backs up existing files before overwriting

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backups/pre-setup-$(date +%Y%m%d-%H%M%S)"

# Colors
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
DIM=$'\033[2m'
RESET=$'\033[0m'

echo ""
echo "${GREEN}Claude Code Setup Installer${RESET}"
echo "${DIM}Symlinks config from this repo into ~/.claude/${RESET}"
echo ""

# Create ~/.claude if it doesn't exist (fresh install)
mkdir -p "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/hooks"

# Backup function
backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mkdir -p "$BACKUP_DIR"
    local rel="${target#$CLAUDE_DIR/}"
    local backup_path="$BACKUP_DIR/$rel"
    mkdir -p "$(dirname "$backup_path")"
    cp -r "$target" "$backup_path"
    echo "  ${YELLOW}backed up${RESET} $rel"
  fi
}

# Symlink function
link_file() {
  local src="$1"
  local dest="$2"
  backup_if_exists "$dest"
  ln -sf "$src" "$dest"
  echo "  ${GREEN}linked${RESET} $(basename "$dest")"
}

# --- Root-level files ---
echo "Linking config files..."

for file in CLAUDE.md settings.json statusline.sh lfg.sh; do
  if [ -f "$SCRIPT_DIR/$file" ]; then
    link_file "$SCRIPT_DIR/$file" "$CLAUDE_DIR/$file"
  fi
done

# --- Commands ---
echo ""
echo "Linking commands..."

for cmd in "$SCRIPT_DIR"/commands/*.md; do
  [ -f "$cmd" ] || continue
  link_file "$cmd" "$CLAUDE_DIR/commands/$(basename "$cmd")"
done

# --- Hooks ---
echo ""
echo "Linking hooks..."

for hook in "$SCRIPT_DIR"/hooks/*.sh; do
  [ -f "$hook" ] || continue
  link_file "$hook" "$CLAUDE_DIR/hooks/$(basename "$hook")"
done

# Make scripts executable
chmod +x "$CLAUDE_DIR/statusline.sh" "$CLAUDE_DIR/lfg.sh" "$CLAUDE_DIR/hooks/"*.sh 2>/dev/null

# --- MCP config ---
echo ""
if [ ! -f "$CLAUDE_DIR/mcp.json" ]; then
  echo "${YELLOW}No mcp.json found.${RESET}"
  echo "  Copy mcp.json.example and fill in your API keys:"
  echo "  cp $SCRIPT_DIR/mcp.json.example $CLAUDE_DIR/mcp.json"
else
  echo "${DIM}mcp.json already exists — skipping (won't overwrite your keys)${RESET}"
fi

# --- settings.local.json ---
if [ ! -f "$CLAUDE_DIR/settings.local.json" ]; then
  echo ""
  echo "${YELLOW}No settings.local.json found.${RESET}"
  echo "  Copy the example and customize:"
  echo "  cp $SCRIPT_DIR/settings.local.json.example $CLAUDE_DIR/settings.local.json"
else
  echo "${DIM}settings.local.json already exists — skipping${RESET}"
fi

# --- Done ---
echo ""
if [ -d "$BACKUP_DIR" ]; then
  echo "${YELLOW}Backups saved to:${RESET} $BACKUP_DIR"
fi
echo ""
echo "${GREEN}Done!${RESET} Run ${DIM}claude${RESET} to start using the setup."
echo ""
echo "Next steps:"
echo "  1. Copy mcp.json.example → ~/.claude/mcp.json and add your API keys"
echo "  2. Copy settings.local.json.example → ~/.claude/settings.local.json"
echo "  3. Install plugins: claude and run /install or enable in settings"
echo "  4. Authenticate: claude auth login"
echo ""
