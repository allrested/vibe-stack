#!/bin/bash
set -e

# Fix permissions
echo "--- Fixing permissions for Moltbot ---"
mkdir -p /home/node/.openclaw/credentials
mkdir -p /home/node/clawd
chown -R node:node /home/node/.openclaw /home/node/clawd
chmod 700 /home/node/.openclaw

# Export env vars for node user sessions
if [ -n "$OPENCLAW_GATEWAY_TOKEN" ]; then
    echo "export OPENCLAW_GATEWAY_TOKEN=$OPENCLAW_GATEWAY_TOKEN" >> /etc/profile.d/openclaw-env.sh
fi
if [ -n "$OPENCLAW_MODEL" ]; then
    echo "export OPENCLAW_MODEL=$OPENCLAW_MODEL" >> /etc/profile.d/openclaw-env.sh
fi
chmod +r /etc/profile.d/openclaw-env.sh 2>/dev/null || true

echo "--- Moltbot container ready ---"
echo "To install OpenClaw, run: docker exec -it moltbot-gateway su - node"

# Keep container running (don't auto-start gateway)
exec tail -f /dev/null
