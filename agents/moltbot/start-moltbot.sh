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
exec su - node -c "openclaw gateway --bind lan --allow-unconfigured"
