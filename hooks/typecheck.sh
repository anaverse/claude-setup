#!/bin/bash
# Auto type-check after editing TypeScript files
# Only runs when the edited file is .ts/.tsx and a tsconfig.json exists nearby

INPUT=$(cat)

# Get the file path from the tool output
file_path=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_response.filePath // ""')

# Only check TypeScript files
echo "$file_path" | grep -qE '\.(ts|tsx)$' || exit 0

# Walk up from the file to find the nearest tsconfig.json
dir=$(dirname "$file_path")
tsconfig=""
while [ "$dir" != "/" ]; do
  if [ -f "$dir/tsconfig.json" ]; then
    tsconfig="$dir/tsconfig.json"
    break
  fi
  dir=$(dirname "$dir")
done

# No tsconfig found — skip
[ -z "$tsconfig" ] && exit 0

project_dir=$(dirname "$tsconfig")

# Run tsc from the project root, timeout after 15s, capture first 15 lines
errors=$(cd "$project_dir" && timeout 15 npx tsc --noEmit 2>&1 | head -15)
exit_code=${PIPESTATUS[0]}

# Timeout (exit 124) — skip silently
[ $exit_code -eq 124 ] && exit 0

if [ $exit_code -ne 0 ]; then
  # Escape for JSON
  escaped=$(echo "$errors" | jq -Rs .)
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"PostToolUse\",\"additionalContext\":\"[TypeCheck] tsc found errors after editing ${file_path}:\\n${errors}\"}}"
fi
