#!/bin/bash
set -e

# Fix permissions
echo "--- Fixing permissions for Moltbot ---"
mkdir -p /home/node/.openclaw
mkdir -p /home/node/clawd
chown -R node:node /home/node/.openclaw /home/node/clawd /home/node

# Start OpenClaw as node user
echo "--- Starting OpenClaw ---"
# Utilizing su to Switch User since we are root
# Pass the token from environment variable if set
TOKEN_ARG=""
if [ -n "$CLAWDBOT_GATEWAY_TOKEN" ]; then
  TOKEN_ARG="--token $CLAWDBOT_GATEWAY_TOKEN"
fi

exec su - node -c "openclaw gateway --bind lan --allow-unconfigured $TOKEN_ARG"
