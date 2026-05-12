#!/bin/bash
# close-check.sh — Stop hook that nudges Claude to coach Ana through /close
# when the current repo has open work (uncommitted changes or unpushed commits).
#
# Behavior:
# - Silent if cwd isn't a git repo, or working tree is clean and in sync
# - Silent if it already fired in the last 30 minutes (per session) — prevents nag spam
# - Otherwise outputs JSON with `additionalContext` so Claude sees a system reminder
#   and proactively prompts Ana to run /close
#
# Why: Ana has identified closing as her #1 personal gap. This hook is the safety net.

set -e

# Scheduled / headless runs opt out via env var. Keeps the nudge interactive-only —
# scheduled jobs need their full turn for actual work, not /close coaching.
if [ "${CLAUDE_SKIP_CLOSE_CHECK:-0}" = "1" ]; then
    exit 0
fi

# Read stdin to extract session_id (used for throttle key)
INPUT=$(cat 2>/dev/null || echo '{}')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "default"' 2>/dev/null || echo "default")

# Bail if we're not in a git repo
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

# Throttle: only fire once per 30 min per session, so I don't spam the user
SENTINEL="/tmp/.claude-close-nudge-${SESSION_ID}"
NOW=$(date +%s)
if [ -f "$SENTINEL" ]; then
    LAST=$(cat "$SENTINEL" 2>/dev/null || echo 0)
    if [ $((NOW - LAST)) -lt 1800 ]; then
        exit 0
    fi
fi

# Detect open loops
DIRTY=$(git status --short 2>/dev/null | head -10)

AHEAD=0
if git rev-parse --abbrev-ref @{u} >/dev/null 2>&1; then
    AHEAD=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
fi

# Clean state → silent exit (don't bump sentinel either, so next dirty state fires immediately)
if [ -z "$DIRTY" ] && [ "$AHEAD" -eq 0 ]; then
    exit 0
fi

# Build a concise summary for the model
SUMMARY=""
if [ -n "$DIRTY" ]; then
    DIRTY_COUNT=$(echo "$DIRTY" | wc -l | tr -d ' ')
    SUMMARY="${SUMMARY}${DIRTY_COUNT} uncommitted file(s)"
fi
if [ "$AHEAD" -gt 0 ]; then
    [ -n "$SUMMARY" ] && SUMMARY="${SUMMARY}, "
    SUMMARY="${SUMMARY}${AHEAD} unpushed commit(s)"
fi

# Bump sentinel BEFORE emitting (avoids re-fire even if jq below fails)
echo "$NOW" > "$SENTINEL"

# Emit JSON. Stop hooks don't support hookSpecificOutput.additionalContext;
# the supported way to feed context back to Claude is decision:"block" + reason,
# which prevents the stop so Claude can act on the nudge before truly ending.
jq -n --arg msg "$SUMMARY" '{
  decision: "block",
  reason: ("Open work detected in cwd: " + $msg + ". Ana has stated closing is her #1 personal gap. Before this turn ends, briefly check in with her: ask if she wants to close out cleanly with /close or hold the work intentionally with a reason. Keep it to one sentence. Do not lecture. If she just opened a new line of work, do not interrupt — let her finish. This nudge is throttled to once per 30 minutes.")
}'
