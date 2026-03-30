#!/bin/bash
# Migrate sensitive .env values to macOS Keychain
# Usage: bash migrate-env-to-keychain.sh /path/to/.env
#
# Only migrates values that look like secrets (tokens, keys, passwords).
# Skips booleans, numbers, cron schedules, URLs, and paths.

ENV_FILE="${1:-.env}"

if [ ! -f "$ENV_FILE" ]; then
  echo "File not found: $ENV_FILE"
  exit 1
fi

# Patterns that indicate a secret value
SECRET_PATTERNS="TOKEN|KEY|SECRET|PASSWORD|AUTH_TOKEN|SID|ACCOUNT_SID"

# Patterns in values that are clearly NOT secrets
SKIP_VALUE_PATTERNS="^(true|false|[0-9]+|http://|https://|/Users|/opt|\*|[0-9]+\s)"

COUNT=0
SKIPPED=0

while IFS= read -r line; do
  # Skip comments and empty lines
  [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue

  # Parse KEY=VALUE
  KEY=$(echo "$line" | cut -d'=' -f1 | xargs)
  VALUE=$(echo "$line" | cut -d'=' -f2- | xargs)

  # Remove surrounding quotes from value
  VALUE="${VALUE%\"}"
  VALUE="${VALUE#\"}"
  VALUE="${VALUE%\'}"
  VALUE="${VALUE#\'}"

  # Skip empty values
  [ -z "$VALUE" ] && continue

  # Only migrate keys that look like secrets
  if ! echo "$KEY" | grep -qE "$SECRET_PATTERNS"; then
    continue
  fi

  # Skip values that are clearly not secrets
  if echo "$VALUE" | grep -qE "$SKIP_VALUE_PATTERNS"; then
    continue
  fi

  # Check if already exists in Keychain
  EXISTING=$(security find-generic-password -s "$KEY" -w 2>/dev/null)
  if [ -n "$EXISTING" ]; then
    if [ "$EXISTING" = "$VALUE" ]; then
      echo "  SKIP  $KEY (already in Keychain, same value)"
      ((SKIPPED++))
      continue
    else
      # Update: delete old, add new
      security delete-generic-password -s "$KEY" 2>/dev/null
      echo "  UPDATE $KEY (value changed)"
    fi
  fi

  # Add to Keychain
  security add-generic-password -s "$KEY" -a "$(whoami)" -w "$VALUE"
  if [ $? -eq 0 ]; then
    echo "  ADDED  $KEY"
    ((COUNT++))
  else
    echo "  ERROR  $KEY — failed to add"
  fi
done < "$ENV_FILE"

echo ""
echo "Done: $COUNT added, $SKIPPED skipped"
echo ""
echo "To read a key:  security find-generic-password -s KEY_NAME -w"
echo "To list all:    security dump-keychain | grep 'svce'"
