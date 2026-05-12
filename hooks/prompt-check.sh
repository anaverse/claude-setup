#!/bin/bash
# Prompt quality checker — nudges when longer prompts lack upfront constraints
# Fires on UserPromptSubmit, reads stdin JSON with session context

INPUT=$(cat)

# Extract the user's message from stdin
message=$(echo "$INPUT" | jq -r '.message // ""')

# Count words (rough)
word_count=$(echo "$message" | wc -w | tr -d ' ')

# Short prompts (< 25 words) are follow-ups — skip check
if [ "$word_count" -lt 25 ]; then
  exit 0
fi

# Check for constraint signals
has_dir=false
has_stack=false
has_tried=false

# Directory/path signals
echo "$message" | grep -qiE '(/Users/|~/|\.\/|in the .* (dir|repo|project|folder)|working in|project root)' && has_dir=true

# Stack/tool signals
echo "$message" | grep -qiE '(shopify|supabase|n8n|klaviyo|remotion|typescript|python|react|next\.?js|node)' && has_stack=true

# Prior attempts signals
echo "$message" | grep -qiE '(already tried|didn.t work|failed|rejected|not working|tried .* but|ruled out|doesn.t support)' && has_tried=true

# Build missing checklist
missing=""
if [ "$has_dir" = false ]; then
  missing="${missing} DIR"
fi
if [ "$has_stack" = false ]; then
  missing="${missing} STACK"
fi
if [ "$has_tried" = false ]; then
  missing="${missing} TRIED"
fi

# If all 3 are missing on a substantial prompt, nudge
missing_count=0
[ "$has_dir" = false ] && missing_count=$((missing_count + 1))
[ "$has_stack" = false ] && missing_count=$((missing_count + 1))
[ "$has_tried" = false ] && missing_count=$((missing_count + 1))

if [ "$missing_count" -eq 0 ]; then
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"UserPromptSubmit\",\"additionalContext\":\"[Prompt Coach] Great prompt! Has DIR + STACK + TRIED — this is exactly the kind of upfront context that prevents wrong-approach friction. Keep doing this.\"}}"
elif [ "$missing_count" -ge 2 ]; then
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"UserPromptSubmit\",\"additionalContext\":\"[Prompt Coach] This prompt is missing upfront constraints:${missing}. Consider adding: which directory/project, what stack/tools, and what you already tried. This helps avoid wrong-approach friction (your #1 issue at 28 events). This is a gentle reminder, not a blocker.\"}}"
fi
