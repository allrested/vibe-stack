FROM node:22-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    git \
    openssl \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw (Moltbot) globally
# Using @latest to get the most recent version
RUN npm install -g openclaw@latest

# Create non-root user directory structure
WORKDIR /home/node

# Set permissions
RUN chown -R node:node /home/node

USER node

# Default ports
EXPOSE 18789 18790

# Entrypoint
CMD ["openclaw", "gateway", "--bind", "lan", "--allow-unconfigured"]
