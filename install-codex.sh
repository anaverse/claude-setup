#!/bin/bash
# Install Codex setup from this repo.
# Symlinks AGENTS.md and local skills into ~/.codex/.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_DIR/skills"
BACKUP_DIR="$CODEX_DIR/backups/pre-claude-setup-migration-$(date +%Y%m%d-%H%M%S)"

GREEN=$'\033[32m'
YELLOW=$'\033[33m'
DIM=$'\033[2m'
RESET=$'\033[0m'

echo ""
echo "${GREEN}Codex Setup Installer${RESET}"
echo "${DIM}Symlinks reusable Codex files from this repo into $CODEX_DIR${RESET}"
echo ""

mkdir -p "$CODEX_DIR" "$SKILLS_DIR"

backup_if_needed() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mkdir -p "$BACKUP_DIR"
    local rel="${target#$CODEX_DIR/}"
    local backup_path="$BACKUP_DIR/$rel"
    mkdir -p "$(dirname "$backup_path")"
    cp -R "$target" "$backup_path"
    echo "  ${YELLOW}backed up${RESET} $rel"
  fi
}

link_path() {
  local src="$1"
  local dest="$2"
  backup_if_needed "$dest"
  ln -sfn "$src" "$dest"
  echo "  ${GREEN}linked${RESET} ${dest#$CODEX_DIR/}"
}

if [ -f "$SCRIPT_DIR/AGENTS.md" ]; then
  link_path "$SCRIPT_DIR/AGENTS.md" "$CODEX_DIR/AGENTS.md"
fi

echo ""
echo "Linking skills..."

for skill in "$SCRIPT_DIR"/skills/*; do
  [ -d "$skill" ] || continue
  [ -f "$skill/SKILL.md" ] || continue
  link_path "$skill" "$SKILLS_DIR/$(basename "$skill")"
done

echo ""
if [ -d "$BACKUP_DIR" ]; then
  echo "${YELLOW}Backups saved to:${RESET} $BACKUP_DIR"
fi

echo "${GREEN}Done.${RESET}"
echo ""
echo "Restart Codex or start a new session so newly installed skills are discovered."
echo "Try prompts like:"
echo "  start git"
echo "  prime this repo"
echo "  create a plan for adding auth"
echo "  validate this project"
echo ""
