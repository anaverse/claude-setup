#!/bin/bash
# Wrapper: loads Cloudinary secrets from Keychain, then starts the MCP server
# Usage: mcp-cloudinary.sh <account-name> <cloud-name>
#   e.g. mcp-cloudinary.sh pex pex
#   e.g. mcp-cloudinary.sh anaverse anaverse

ACCOUNT="${1:?Missing account name (e.g. pex, anaverse)}"
CLOUD_NAME="${2:?Missing cloud name}"

# Load secrets from Keychain using the ACCOUNT prefix
KEY_NAME="CLOUDINARY_${ACCOUNT^^}_API_KEY"
SECRET_NAME="CLOUDINARY_${ACCOUNT^^}_API_SECRET"

export CLOUDINARY_CLOUD_NAME="$CLOUD_NAME"
export CLOUDINARY_API_KEY="$(security find-generic-password -s "$KEY_NAME" -w 2>/dev/null)"
export CLOUDINARY_API_SECRET="$(security find-generic-password -s "$SECRET_NAME" -w 2>/dev/null)"

if [ -z "$CLOUDINARY_API_KEY" ] || [ -z "$CLOUDINARY_API_SECRET" ]; then
  echo "ERROR: Could not load Cloudinary secrets for account '$ACCOUNT' from Keychain" >&2
  echo "Expected keys: $KEY_NAME, $SECRET_NAME" >&2
  exit 1
fi

# Start the MCP server
exec npx -y --package @cloudinary/asset-management-mcp -- mcp start
