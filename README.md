# 🚀 Vibe Stack

Production-ready Docker setup for **Vibe-Kanban** + **Claude Code** AI coding platform.

[![Docker](https://img.shields.io/badge/Docker-Ready-blue?logo=docker)](https://docker.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## ✨ Features

- 🤖 **Vibe-Kanban** - AI agent orchestration platform
- 💻 **code-server** - Browser-based VS Code
- 🌐 **Nginx Proxy Manager** - Easy reverse proxy management
- 🛡️ **AdGuard Home** - Network-wide ad & tracker blocking
- 🦞 **Moltbot** - Personal AI assistant (multi-channel: WhatsApp, Telegram, Discord, Slack, etc.)
- 🔐 **Secure Secrets** - Project secrets isolated from AI agents
- 📦 **Persistent Data** - Projects and settings survive restarts
- 🐳 **One Command Deploy** - Get started in minutes

## 📋 Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/install/)
- [Anthropic/Claude Account](https://console.anthropic.com/)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/halilbarim/vibe-stack.git
cd vibe-stack
```

### 2. Configure Environment

```bash
cp .env.example .env
# Edit .env with your settings
```

### 3. Configure Claude (API Keys)

```bash
cp agents/claude/settings.json.example agents/claude/settings.json
```

Edit `agents/claude/settings.json` with your API key:

```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your-api-key",
    "ANTHROPIC_BASE_URL": "https://api.anthropic.com"
  }
}
```

### 4. Start Services

```bash
docker-compose up -d
```

### 5. First-time Claude Login

```bash
docker exec -it vibe-server su - node -c "claude --dangerously-skip-permissions"
```

1. Select theme with arrow keys
2. Copy the login URL from terminal
3. Open in browser, login with your Anthropic account
4. Click "Authorize" and copy the token
5. Paste token in terminal and press Enter
6. Type `exit` twice to leave container

### 6. Access Services

| Service | URL | Password |
|---------|-----|----------|
| Vibe-Kanban | http://localhost:4000 | - |
| VS Code | http://localhost:8443 | From `.env` file |
| Nginx Proxy Manager | http://localhost:81 | Default: `admin@example.com` / `changeme` |
| AdGuard Home (Setup) | http://localhost:8086 | - |
| AdGuard Home (Web) | http://localhost:8085 | Set during setup |
| Moltbot Gateway | http://localhost:18789 | - |

## 📁 Project Structure

```
vibe-stack/
├── docker-compose.yml    # Main configuration
├── .env                  # Environment variables
├── agents/
│   ├── claude/           # Claude Code settings
│   │   └── settings.json
│   └── moltbot/          # Moltbot settings (NEW)
├── data/                 # Persistent data
│   ├── npm/              # Nginx Proxy Manager data
│   └── adguard/          # AdGuard Home data
├── secrets/              # Project secrets (NOT accessible by agent)
│   └── your-project/
│       └── .env.*
├── HELPER.md             # Docker command reference
└── README.md
```

## 🔐 Security

- **Project Secrets**: Stored in `/root/secrets` - agent cannot access
- **Claude Config**: Stored in `agents/claude` - agent can access (required)
- **SSH Keys**: Mounted read-only

## 🛠️ Common Commands

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Restart services
docker-compose restart

# Enter container shell
docker exec -it vibe-server bash

# Check status
docker-compose ps
```

## 📊 Resource Usage

| Container | Image Size | RAM |
|-----------|-----------|-----|
| vibe-kanban | ~200 MB | ~300 MB |
| code-server | ~500 MB | ~400 MB |
| moltbot | ~300 MB | ~250 MB |
| nginx-proxy | ~100 MB | ~100 MB |
| adguard-home | ~100 MB | ~100 MB |

## 🔧 Configuration

### Add Project Secrets

1. Create folder: `secrets/your-project/`
2. Add env files: `.env.development`, `.env.production`
3. Restart: `docker-compose restart vibe-kanban`

Secrets are automatically copied to `/repos/your-project/.env.*.local`

### code-server Password

Set in `.env`:
```
CODE_SERVER_PASSWORD=your-secure-password
CLAWDBOT_GATEWAY_TOKEN=your-gateway-token
```

### Using GLM-4 / Alternative LLMs (via z.ai Proxy)

This setup supports using zhipu.ai GLM-4 models as an alternative to Claude. Edit `agents/claude/settings.json`:

```json
{
  "hasAcknowledgedDangerousSkipPermissions": true,
  "hasCompletedOnboarding": true,
  "theme": "dark",
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "your-z-ai-api-key",
    "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic",
    "API_TIMEOUT_MS": "3000000",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.5-air",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.7",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-4.7"
  }
}
```

| Model | Maps To |
|-------|---------|
| Haiku | glm-4.5-air |
| Sonnet | glm-4.7 |
| Opus | glm-4.7 |

### Moltbot (Personal AI Assistant)

Moltbot is a multi-channel AI assistant that connects to WhatsApp, Telegram, Discord, Slack, and more.

**First-time Setup:**

```bash
# Generate gateway token (already in .env)
openssl rand -hex 32

# Start services
docker-compose up -d

# Run onboarding wizard
docker exec -it moltbot-gateway openclaw onboard
```

**Ports:**
- `18789`: Gateway API (HTTP/WebSocket)
- `18790`: Control plane

**Config:** `agents/moltbot/` - accessible from project root
- `18790`: Control plane

**Config:** `agents/moltbot/` - accessible from project root

## 📖 Documentation

- [HELPER.md](HELPER.md) - Docker command reference

## ⚠️ Important Notes

- `docker-compose down -v` **deletes all data** - use with caution
- Claude login required after `down -v` or first setup
- Normal restarts preserve all data

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.

---

Made with ❤️ for AI-powered development
