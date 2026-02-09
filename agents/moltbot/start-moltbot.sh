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

exec su - node -c "openclaw gateway --bind lan --allow-unconfigured $TOKEN_ARG"
