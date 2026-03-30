#!/bin/bash
# Claude Code YOLO Mode Launcher
# Run: lfg (alias in ~/.zshrc)
# Colors from Obsidianite theme

# Obsidianite palette
CYAN=$'\033[38;2;15;182;214m'     # #0fb6d6 accent
PINK=$'\033[38;2;244;86;157m'     # #f4569d sub-accent
BLUE=$'\033[38;2;69;170;255m'     # #45aaff dim
SOFT=$'\033[38;2;107;202;251m'    # #6bcafb link
DM=$'\033[2m'                     # Dim
B=$'\033[1m'                      # Bold
RST=$'\033[0m'                    # Reset

printf "\n"
printf "  ${B}${CYAN}██╗     ${BLUE}███████╗${PINK} ██████╗ ${RST}\n"
printf "  ${B}${CYAN}██║     ${BLUE}██╔════╝${PINK}██╔════╝ ${RST}\n"
printf "  ${B}${CYAN}██║     ${BLUE}█████╗  ${PINK}██║  ███╗${RST}\n"
printf "  ${B}${CYAN}██║     ${BLUE}██╔══╝  ${PINK}██║   ██║${RST}\n"
printf "  ${B}${CYAN}███████╗${BLUE}██║     ${PINK}╚██████╔╝${RST}\n"
printf "  ${B}${CYAN}╚══════╝${BLUE}╚═╝      ${PINK}╚═════╝ ${RST}\n"
printf "\n"
printf "  ${B}${SOFT}[ ${PINK}YOLO${SOFT} ]${RST} ${CYAN}▓▓▓▓▓▓▓▓▓▓${RST} ${DM}·${RST} ${BLUE}Opus${RST} ${DM}·${RST} ${CYAN}No permissions${RST} ${DM}·${RST} ${PINK}Full send${RST}\n"
printf "\n"

sleep 0.5

exec claude --dangerously-skip-permissions --model opus "$@"
