FROM node:20-slim

# 1. Install system dependencies during build
RUN apt-get update && apt-get install -y \
    git \
    ssh \
    nano \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# 3. Create necessary directories and set permissions
WORKDIR /app
RUN mkdir -p /repos /home/node/.claude /home/node/.local/share/vibe-kanban \
    && chown -R node:node /repos /app /home/node

# 4. Copy startup script
COPY scripts/start-vibe.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-vibe.sh

# 5. Set default user
# Note: We switch to 'node' user inside the entrypoint script to handle permission fixups as root first if needed
# OR we can stay root and use gosu/su in entrypoint.
# For simplicity, we keep root as default entry user to handle chowns, then switch to node.

# Startup
ENTRYPOINT ["/usr/local/bin/start-vibe.sh"]
