#!/bin/bash
# Global hook: block Claude from reading .env files or displaying API keys
# Runs as a PreToolUse hook on Read and Bash tools

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Block direct reads of .env files (but allow .env.example)
if [ "$TOOL_NAME" = "Read" ]; then
  BASENAME=$(basename "$FILE_PATH")
  if [[ "$BASENAME" == ".env" || "$BASENAME" == ".env.local" || "$BASENAME" == ".env.production" ]]; then
    echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"BLOCKED: Reading .env files directly exposes API keys in the conversation. Use `security find-generic-password -s KEY_NAME -w` to read individual secrets from macOS Keychain, or read .env.example for the structure."}}'
    exit 0
  fi
fi

# Block Bash commands that would cat/grep/read .env files
if [ "$TOOL_NAME" = "Bash" ]; then
  # Match commands that would dump .env contents (but not .env.example)
  if echo "$COMMAND" | grep -qE '(cat|head|tail|less|more|source|\.)\s+.*\.env(\s|$|"|\x27)'; then
    echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"BLOCKED: This command would expose .env secrets in the conversation. Use macOS Keychain instead."}}'
    exit 0
  fi
  # Match grep on .env that could expose values
  if echo "$COMMAND" | grep -qE 'grep.*\.env(\s|$|")' | grep -qvE '\.env\.example'; then
    echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"BLOCKED: Grepping .env files could expose secrets. Use `security find-generic-password -s KEY_NAME -w` instead."}}'
    exit 0
  fi
fi
