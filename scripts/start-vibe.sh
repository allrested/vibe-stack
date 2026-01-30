#!/bin/bash
set -e

# 1. Fix permissions (since volumes might be mounted as root)
chown -R node:node /home/node/.claude
chown -R node:node /repos

# 2. Project Configuration (Secret copying)
echo '--- Checking projects for secrets ---'
for d in /repos/* ; do
  if [ -d "$d" ]; then
    proje_adi=$(basename "$d")
    if [ -d "/root/secrets/$proje_adi" ]; then
      cp -f "/root/secrets/$proje_adi/.env.development" "$d/.env.development.local" 2>/dev/null || true
      cp -f "/root/secrets/$proje_adi/.env.production" "$d/.env.production.local" 2>/dev/null || true
      chown node:node "$d/.env.development.local" "$d/.env.production.local" 2>/dev/null || true
    fi
  fi
done

echo '--- Secrets processed ---'

# 3. SSH Setup (Copy from root mount to node user)
echo '--- Configuring SSH for node user ---'
if [ -d "/root/.ssh" ]; then
    mkdir -p /home/node/.ssh
    
    # Copy keys if they exist
    if ls /root/.ssh/id_* 1> /dev/null 2>&1; then
        cp -f /root/.ssh/id_* /home/node/.ssh/
        chmod 600 /home/node/.ssh/id_*
    fi
    
    # Copy known_hosts or config if they exist
    [ -f "/root/.ssh/known_hosts" ] && cp -f /root/.ssh/known_hosts /home/node/.ssh/
    [ -f "/root/.ssh/config" ] && cp -f /root/.ssh/config /home/node/.ssh/

    # Ensure permissions
    chmod 700 /home/node/.ssh
    chown -R node:node /home/node/.ssh
    
    # Add GitHub/GitLab to known_hosts to prevent interactive prompts
    if [ ! -f "/home/node/.ssh/known_hosts" ]; then
        ssh-keyscan github.com gitlab.com >> /home/node/.ssh/known_hosts 2>/dev/null
        chown node:node /home/node/.ssh/known_hosts
    fi
fi

# 4. Git Configuration
echo '--- Configuring Git ---'
# Fix permissions for the data volume
echo "Fixing permissions for /home/node/.vibe-kanban..."
mkdir -p /home/node/.vibe-kanban
chown -R node:node /home/node/.vibe-kanban

# Define variables before switching user to use in the exec command or run as node here
# We'll run git config commands as node user using su
su - node -c "
    # Set default identity if not configured
    if [ -z \"\$(git config --global user.email)\" ]; then
        git config --global user.email \"${GIT_EMAIL:-vibe-agent@local}\"
        git config --global user.name \"${GIT_NAME:-Vibe Agent}\"
    fi

    # Mark repos safe
    git config --global --add safe.directory '/repos/*'
    git config --global init.defaultBranch main
"

echo '--- Starting Vibe Kanban ---'

# 3. Switch to node user and run app
# Using exec to replace shell process
exec su - node -c 'HOME=/home/node npm_config_cache=/home/node/.npm PORT=4000 HOST=0.0.0.0 CLAUDE_SKIP_PERMISSION_CHECK=true DANGEROUS_SKIP_PERMISSION=true npx vibe-kanban'
