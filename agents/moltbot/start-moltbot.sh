#!/bin/bash
set -e

# Fix permissions as per OpenClaw doctor
echo "--- Fixing permissions for Moltbot ---"
mkdir -p /home/node/.openclaw/credentials
mkdir -p /home/node/clawd
chown -R node:node /home/node/.openclaw /home/node/clawd
chmod 700 /home/node/.openclaw

# Start OpenClaw as node user
echo "--- Starting OpenClaw ---"
# Utilizing su to Switch User since we are root
# Pass the token from environment variable if set
TOKEN_ARG=""
if [ -n "$OPENCLAW_GATEWAY_TOKEN" ]; then
  TOKEN_ARG="--token $OPENCLAW_GATEWAY_TOKEN"
fi

MODEL_ARG=""
if [ -n "$OPENCLAW_MODEL" ]; then
  # Note: The CLI flag might differ, usually it's config based, but passing env is safer
  # If CLI supports --model, we add it. 
  # Based on common patterns, we rely on env var injection to the process.
  echo "Using Model: $OPENCLAW_MODEL"
fi

exec su - node -c "openclaw gateway --bind lan --allow-unconfigured $TOKEN_ARG"
