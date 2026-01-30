# 🐳 Docker Commands - Quick Reference

## 🚀 Starting

```bash
# Start all services
docker-compose up -d

# Start only vibe-kanban
docker-compose up -d vibe-kanban

# Start only code-server
docker-compose up -d code-server

# Start only moltbot
docker-compose up -d moltbot

# Start only nginx-proxy
docker-compose up -d npm

# Start only adguard
docker-compose up -d adguard

# Start with logs visible (for debugging)
docker-compose up
```

## 🔐 Claude Code Initial Setup (When Container is Reset)

> ⚠️ **Important:** Claude login is required when container is completely reset (`docker-compose down -v`) or created for the first time.

### Step 1: Enter Container
```bash
docker exec -it vibe-server bash
```

### Step 2: Switch to Node User
```bash
su - node
```

### Step 3: Start Claude
```bash
claude --dangerously-skip-permissions
```

### Step 4: Select Theme
- Use arrow keys to select or type `1` and press Enter (Dark mode)

### Step 5: Login
1. Copy the **login link** shown in terminal
2. Open in browser and **login with your Claude/Anthropic account**
3. Click **"Authorize"** button
4. Copy the **token** that appears
5. Return to Docker terminal, **paste** and press Enter

### Step 6: Exit
```bash
exit  # exit from node
exit  # exit from container
```

### One-liner (Quick Access)
```bash
docker exec -it vibe-server su - node -c "claude --dangerously-skip-permissions"
```

> 💡 **Note:** Login is not required for normal restarts (`docker-compose restart`). Only needed after `docker-compose down -v` or when container is newly created.

## 🦞 Moltbot Initial Setup

> Moltbot is a personal AI assistant that connects to WhatsApp, Telegram, Discord, Slack, and more.

### Step 1: Ensure Gateway Token is Set
Check `.env` file has `CLAWDBOT_GATEWAY_TOKEN` set.

### Step 2: Run Onboarding
```bash
docker exec -it moltbot-gateway openclaw onboard
```

### Step 3: Configure Channels
Follow the interactive wizard to connect your messaging channels.

### Quick Commands
```bash
# View moltbot logs
docker logs -f moltbot-gateway

# Check channel status
docker exec -it moltbot-gateway openclaw channels status

# Restart moltbot
docker-compose restart moltbot
```

## 🛑 Stopping

```bash
# Stop all services (removes containers)
docker-compose down

# Stop services + delete volumes (CAUTION: Data will be lost!)
docker-compose down -v

# Stop only one service
docker-compose stop vibe-kanban
docker-compose stop code-server
```

## 🔄 Restarting

```bash
# Restart all services
docker-compose restart

# Restart single service
docker-compose restart vibe-kanban
docker-compose restart code-server

# Complete reset and start
docker-compose down && docker-compose up -d
```

## 📋 Status Check

```bash
# View running containers
docker-compose ps

# Detailed status
docker ps -a

# Resource usage (CPU, RAM)
docker stats
```

## 📜 Viewing Logs

```bash
# All logs (live follow)
docker-compose logs -f

# Only vibe-kanban logs
docker-compose logs -f vibe-kanban

# Only code-server logs
docker-compose logs -f code-server

# Only nginx-proxy logs
docker-compose logs -f npm

# Only adguard logs
docker-compose logs -f adguard

# Last 50 lines of logs
docker-compose logs --tail 50

# Last 100 lines for debugging
docker logs vibe-server --tail 100
docker logs code-server --tail 100
```

## 💻 Entering Container (Shell)

```bash
# Enter vibe-kanban container
docker exec -it vibe-server bash

# Enter code-server container
docker exec -it code-server bash

# Enter nginx-proxy container
docker exec -it nginx-proxy sh

# Enter adguard container
docker exec -it adguard-home sh

# Enter moltbot container
docker exec -it moltbot-gateway sh

# Enter as root
docker exec -it -u root vibe-server bash
```

## 🧹 Cleanup

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove unused volumes (CAUTION: All data will be lost!)
docker volume prune

# Remove everything (CAUTION: All data will be lost! Include other yours container)
docker system prune -a --volumes
```

## 📦 Volume Management

```bash
# List volumes
docker volume ls

# Delete specific volume (CAUTION: All data in volume will be lost!)
docker volume rm vibe-stack_code_server_data

# Check volume contents
docker run --rm -v vibe-stack_vibe_workspace:/data alpine ls -la /data
```

## 🔧 Image Management

```bash
# Update images
docker-compose pull

# Rebuild images
docker-compose build --no-cache

# Update and restart with latest images
docker-compose pull && docker-compose up -d
```

## 🌐 Access URLs

| Service | URL | Password |
|---------|-----|----------|
| Vibe-Kanban | http://localhost:4000 | - |
| VS Code (code-server) | http://localhost:8443 | from `.env` file |
| Moltbot Gateway | http://localhost:18789 | - |
| Moltbot Control | http://localhost:18790 | - |
| Nginx Proxy Manager | http://localhost:81 | Default: `admin@example.com` / `changeme` |
| AdGuard Home (Setup) | http://localhost:8086 | - |

## 🆘 Troubleshooting

```bash
# Why is container crashing?
docker logs code-server --tail 50

# Is port in use?
lsof -i :4000
lsof -i :8443
lsof -i :18789

# Force stop container
docker kill vibe-server
docker kill code-server

# Force stop all containers
docker-compose kill

# Network issues
docker network ls
docker network inspect vibe-stack_default
```

## 🔄 Daily Usage Scenarios

### Starting Work in the Morning
```bash
cd ~/vibe-stack
docker-compose up -d
```

### Ending Work in the Evening
```bash
docker-compose stop
```

### When Something Breaks (caution: resets containers)
```bash
docker-compose down
docker-compose up -d
```

### Complete Reset
```bash
docker-compose down -v  # All volumes deleted, all data lost!
docker-compose up -d
```

---

## 🛠️ Advanced: Accessing Containers (SSH/Shell)

If you need to enter a running container to check files or run commands manually (like `ssh`), use the following commands:

**Generic Command:**
```bash
docker exec -it <container_name> sh
# or if sh is not available:
docker exec -it <container_name> bash
```

**Specific Shortcuts:**

1.  **Vibe Server (Kanban):**
    ```bash
    docker exec -it vibe-server sh
    ```

2.  **Moltbot (AI Agent):**
    ```bash
    docker exec -it moltbot-gateway bash
    ```

3.  **Code Server (VS Code):**
    ```bash
    docker exec -it code-server bash
    ```

4.  **Nginx Proxy Manager:**
    ```bash
    docker exec -it nginx-proxy sh
    ```

> **Tip:** To run a command as `root` (e.g. to install packages), add `-u root`:
> `docker exec -it -u root vibe-server sh`

*Last Updated: 2026-01-30*
