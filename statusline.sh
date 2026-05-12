#!/bin/bash
# Claude Code Status Line - macOS Bash Version
# Bold & Colorful style with gradient progress bar
# Dual Display: raw message % + estimated total % (with system overhead)

INPUT=$(cat)

if [ -z "$INPUT" ]; then
  printf "[!] No input"
  exit 0
fi

# Parse JSON with jq
model=$(echo "$INPUT" | jq -r '.model.display_name // "Claude"')
context_size=$(echo "$INPUT" | jq -r '.context_window.context_window_size // 200000')

# System overhead estimate (~30K tokens for tools, CLAUDE.md, MCP configs)
SYSTEM_OVERHEAD=30000

# Calculate tokens
input_tokens=$(echo "$INPUT" | jq -r '.context_window.current_usage.input_tokens // empty')
data_available=false
tokens_used=0
raw_percent=0

if [ -n "$input_tokens" ]; then
  cache_creation=$(echo "$INPUT" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
  cache_read=$(echo "$INPUT" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
  tokens_used=$(( input_tokens + cache_creation + cache_read ))
  raw_percent=$(echo "scale=1; ($tokens_used * 100) / $context_size" | bc)
  data_available=true
else
  used_pct=$(echo "$INPUT" | jq -r '.context_window.used_percentage // empty')
  if [ -n "$used_pct" ]; then
    raw_percent=$used_pct
    tokens_used=$(echo "scale=0; ($raw_percent * $context_size) / 100" | bc)
    data_available=true
  fi
fi

# Estimated total with system overhead
total_tokens=$(( tokens_used + SYSTEM_OVERHEAD ))
total_percent=$(echo "scale=0; ($total_tokens * 100) / $context_size" | bc)
if [ "$total_percent" -gt 100 ] 2>/dev/null; then
  total_percent=100
fi

# Duration
duration_ms=$(echo "$INPUT" | jq -r '.cost.total_duration_ms // 0')
cwd=$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // "unknown"')

# Format tokens (e.g., 76000 -> 76K)
format_tokens() {
  local t=$1
  if [ "$t" -ge 1000 ] 2>/dev/null; then
    echo "$(( t / 1000 ))K"
  else
    echo "$t"
  fi
}

tokens_display=$(format_tokens "$tokens_used")
context_display=$(format_tokens "$context_size")

# ANSI colors
reset="\033[0m"
bold="\033[1m"
dim="\033[2m"
purple="\033[38;5;135m"
yellow="\033[38;5;220m"
red="\033[38;5;196m"
green="\033[38;5;114m"
blue="\033[38;5;117m"
cyan="\033[38;5;87m"
white="\033[38;5;255m"

# Integer versions for comparison
raw_int=${raw_percent%.*}
raw_int=${raw_int:-0}
total_int=${total_percent%.*}
total_int=${total_int:-0}

# Bar color based on estimated total usage
if [ "$total_int" -ge 80 ] 2>/dev/null; then
  bar_color=$red
elif [ "$total_int" -ge 60 ] 2>/dev/null; then
  bar_color=$yellow
else
  bar_color=$purple
fi

# Gradient progress bar (10 blocks)
filled=$(( total_int / 10 ))
if [ "$filled" -gt 10 ]; then filled=10; fi
empty=$(( 10 - filled ))

bar=""
for ((i=0; i<filled; i++)); do bar+="▓"; done
for ((i=0; i<empty; i++)); do bar+="░"; done

# Git branch + open-work indicator (dirty count, unpushed commits) — surfaces /close gap
git_branch=""
git_dirty=0
git_ahead=0
if [ -d "$cwd" ]; then
  git_branch=$(cd "$cwd" 2>/dev/null && git branch --show-current 2>/dev/null || true)
  if [ -n "$git_branch" ]; then
    git_dirty=$(cd "$cwd" 2>/dev/null && git status --porcelain 2>/dev/null | wc -l | tr -d ' ' || echo 0)
    if cd "$cwd" 2>/dev/null && git rev-parse --abbrev-ref @{u} >/dev/null 2>&1; then
      git_ahead=$(cd "$cwd" 2>/dev/null && git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
    fi
  fi
fi

# Truncate path (replace HOME with ~)
path_display="${cwd/#$HOME/\~}"
max_path=40
if [ ${#path_display} -gt $max_path ]; then
  path_display="...${path_display: -$max_path}"
fi

# Format duration
format_duration() {
  local ms=$1
  local secs=$(( ms / 1000 ))
  local mins=$(( secs / 60 ))
  local hours=$(( mins / 60 ))
  if [ "$hours" -gt 0 ]; then
    echo "${hours}h $(( mins % 60 ))m"
  elif [ "$mins" -gt 0 ]; then
    echo "${mins}m"
  else
    echo "${secs}s"
  fi
}

duration_display=$(format_duration "$duration_ms")
start_ms=$(( $(date +%s) * 1000 - duration_ms ))
start_time=$(date -r $(( start_ms / 1000 )) "+%-I:%M %p" 2>/dev/null || date -d "@$(( start_ms / 1000 ))" "+%-I:%M %p" 2>/dev/null || echo "?")
current_datetime=$(date "+%b %-d %-I:%M %p")

sep=" · "

# Build output
output=""
output+="${bold}${white}[ ${model} ]${reset}"

if [ "$data_available" = true ]; then
  output+=" ${bar_color}${bar}${reset}"
  output+=" ${dim}${raw_int}%${reset}"
  output+=" ${bar_color}~${total_int}%${reset}"
  output+=" ${dim}(${tokens_display}/${context_display})${reset}"
else
  output+=" ${dim}[waiting for first response...]${reset}"
fi

if [ -n "$git_branch" ]; then
  output+="${sep}${green}⎇ ${git_branch}${reset}"
  # Append open-work badge — only render when there's something to flag
  if [ "$git_dirty" -gt 0 ] 2>/dev/null || [ "$git_ahead" -gt 0 ] 2>/dev/null; then
    badge=""
    [ "$git_dirty" -gt 0 ] 2>/dev/null && badge+=" ${yellow}●${git_dirty}${reset}"
    [ "$git_ahead" -gt 0 ] 2>/dev/null && badge+=" ${yellow}↑${git_ahead}${reset}"
    output+="${badge}"
  fi
fi
output+="${sep}${blue}${path_display}${reset}"
output+="${sep}${cyan}⏱ ${duration_display} (since ${start_time})${reset}"
output+="${sep}${purple}${current_datetime}${reset}"
output+="${sep}${yellow}DIR${reset}${dim}·${reset}${yellow}STACK${reset}${dim}·${reset}${yellow}TRIED${reset}"

printf "%b" "$output"
