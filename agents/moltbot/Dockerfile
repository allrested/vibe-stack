FROM node:22-slim

# Install system dependencies (openclaw will be installed manually by user)
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    git \
    openssl \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Give node user passwordless sudo access (needed for openclaw install script)
RUN echo "node ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/node

# Create non-root user directory structure
WORKDIR /home/node
RUN mkdir -p /home/node/.openclaw/credentials && \
    mkdir -p /home/node/clawd && \
    chown -R node:node /home/node/.openclaw /home/node/clawd && \
    chmod 700 /home/node/.openclaw

# Set permissions
# Default ports
EXPOSE 18789 18790

# Copy startup script
COPY start-moltbot.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-moltbot.sh

# Copy onboarding script to profile.d (runs on interactive login)
COPY openclaw-onboarding.sh /etc/profile.d/
RUN chmod +x /etc/profile.d/openclaw-onboarding.sh

# Entrypoint - Run as root first to fix permissions
ENTRYPOINT ["/usr/local/bin/start-moltbot.sh"]
