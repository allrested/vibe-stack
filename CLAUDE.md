# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

**Vibe Stack** is a production-ready Docker containerized platform that orchestrates multiple AI-powered services and development tools. It bundles AI agents (Claude Code, OpenClaw/OpenClaw) with development infrastructure (VS Code Server, Nginx Proxy Manager, AdGuard Home) into a cohesive Docker environment.

## Tech Stack

- **Runtime:** Node.js 20 (Vibe-Kanban), Node.js 22 (OpenClaw)
- **Orchestration:** Docker & Docker Compose
- **Package Manager:** NPM (global installs via npx)
- **Scripts:** Bash shell scripts, Node.js for installation wizard
- **Key Dependencies:**
  - `@anthropic-ai/claude-code` - Claude Code CLI
  - `vibe-kanban` - AI agent orchestration platform
  - `openclaw` - Multi-channel AI assistant framework (OpenClaw)

## Directory Structure

```
vibe-stack/
├── docker-compose.yml      # Main service orchestration (5 services)
├── Dockerfile              # Vibe-Kanban image
├── install.sh              # Shell wrapper for installation wizard
├── scripts/
│   ├── install.js          # Interactive installation wizard
│   ├── start-vibe.sh       # Vibe-Kanban startup script
│   └── dev-server.sh       # Lightweight dev server runner
├── agents/
│   ├── claude/             # Claude Code configuration
│   └── openclaw/            # OpenClaw service (Dockerfile, startup script)
├── repos/                  # Shared project workspace (gitignored)
├── secrets/                # Project secrets, isolated from agents
└── data/                   # Persistent data volumes (gitignored)
```

## Common Commands

```bash
# Start all services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Restart specific service
docker-compose restart vibe-kanban

# Enter container shell
docker exec -it vibe-server bash

# Check service status
docker-compose ps

# Run installation wizard
./install.sh
```

## Service Ports

| Service            | Port  | Purpose           |
| ------------------ | ----- | ----------------- |
| Vibe-Kanban        | 4000  | Main AI platform  |
| VS Code            | 8443  | Browser-based IDE |
| OpenClaw Gateway   | 18789 | API endpoint      |
| OpenClaw Dashboard | 18790 | Control plane     |
| Nginx Admin        | 81    | Proxy management  |
| AdGuard            | 8086  | DNS setup         |

## Docker Compose Profiles

Services use profiles for selective enablement:

- `vibe` - Vibe-Kanban
- `code` - VS Code Server
- `openclaw` - OpenClaw AI Assistant
- `nginx` - Nginx Proxy Manager
- `dns` - AdGuard Home

## Coding Conventions

### Startup Script Pattern

All services follow a consistent initialization pattern:

1. Fix permissions (ensure correct user ownership)
2. Configure environment (copy SSH keys, setup git)
3. Copy project secrets to correct locations
4. Switch to non-root user (`node`) for running service
5. Start main process

### Security Model

- Services run as `node` user (non-root) for security
- Secrets in `/secrets` are mounted read-only and isolated from agents
- SSH keys copied from host during container startup
- Configuration files properly chown'd to `node:node`

### Environment Configuration

- `.env.example` serves as template - copy to `.env` for local config
- Agent configs stored in `/agents/<agent-name>/`
- Project secrets separated into `/secrets/your-project/.env.*`

## Key Files to Know

- `docker-compose.yml` - Service definitions and orchestration
- `Dockerfile` - Vibe-Kanban container build
- `agents/openclaw/Dockerfile` - OpenClaw container build
- `scripts/start-vibe.sh` - Main startup script, sets up permissions and environment
- `scripts/install.js` - Interactive wizard for setup and configuration
- `.env.example` - Environment variable template
