# Docker Container Logs Commands

## Basic Log Viewing Commands

### Standard Docker Commands

```bash
# View all logs for a container by ID or name
docker logs <container_id_or_name>

# Show only the last 100 lines
docker logs --tail 100 <container_id_or_name>

# Follow logs in real-time (follow)
docker logs -f <container_id_or_name>

# Follow logs + show last 50 lines
docker logs -f --tail 50 <container_id_or_name>

# Show logs with timestamps
docker logs --timestamps <container_id_or_name>

# Show specific number of lines with timestamps
docker logs --tail 50 --timestamps <container_id_or_name>
```

### Advanced Log Operations

```bash
# Show logs in reverse order (newest to oldest)
docker logs <container_id_or_name> | tac

# Save logs to a file
docker logs <container_id_or_name> > logs.txt

# Compress logs with gzip
docker logs <container_id_or_name> | gzip > logs_$(date +%Y%m%d).gz

# Clear logs (only stdout/stderr)
docker logs --tail 0 <container_id_or_name>

# Remove log files (all logs)
docker container prune -f
```

## Docker Compose Commands (For Vibe Stack)

### All Service Logs

```bash
# Show logs for all running containers
docker-compose logs

# Show logs for all containers (including stopped)
docker-compose logs --all

# Follow all logs in real-time
docker-compose logs -f

# Follow logs + show last 100 lines
docker-compose logs -f --tail 100
```

### Specific Service Logs

```bash
# Show Vibe-Kanban logs
docker-compose logs vibe-kanban

# Follow Vibe-Kanban logs in real-time
docker-compose logs -f vibe-kanban

# Show OpenClaw logs
docker-compose logs openclaw

# Follow OpenClaw logs in real-time
docker-compose logs -f openclaw

# Show VS Code server logs
docker-compose logs code-server

# Follow VS Code server logs in real-time
docker-compose logs -f code-server

# Show Nginx logs
docker-compose logs nginx

# Show AdGuard logs
docker-compose logs dns
```

### Log Filtering and Search

```bash
# Search for errors in a specific service
docker-compose logs vibe-kanban | grep -i error

# Search for errors across all services
docker-compose logs | grep -i error

# Search for specific word (case-sensitive)
docker-compose logs vibe-kanban | grep "ERROR"

# Show with line numbers
docker-compose logs -n vibe-kanban

# Filter with specific number of lines
docker-compose logs --tail 50 vibe-kanban

# Show logs in reverse order
docker-compose logs vibe-kanban | tac

# Show logs with timestamps
docker-compose logs --timestamps vibe-kanban

# Show logs matching a specific pattern
docker-compose logs --tail 100 vibe-kanban | grep "2024-01-"
```

## Container Information and Status

### Container Listing

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# List containers with detailed format
docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"

# Filter containers by status
docker ps --filter "status=running"
docker ps --filter "status=exited"

# Filter containers by name
docker ps --filter "name=vibe"

# Filter containers by image
docker ps --filter "ancestor=vibe-kanban"
```

### Container Information

```bash
# Detailed container information
docker inspect <container_id_or_name>

# Container disk usage
docker system df

# Check container log path
docker container inspect <container_id_or_name> --format='{{.LogPath}}'
```

## Advanced Log Operations

### Log Parsing and Formatting

```bash
# Show logs in JSON format (if supported)
docker logs <container_id_or_name> | jq .

# Group logs by hour
docker logs <container_id_or_name> | grep "2024-01-01T0[0-9]:"

# Find error count
docker logs <container_id_or_name> | grep -c "ERROR"

# Filter logs by IP addresses
docker logs <container_id_or_name> | grep "192.168."
```

### Log Management and Maintenance

```bash
# Stop containers
docker-compose stop

# Restart containers
docker-compose restart

# Restart containers from scratch
docker-compose up -d

# Remove containers
docker-compose down

# Clean up stopped containers
docker container prune -f

# Clean up entire Docker system (use with caution)
docker system prune -f
```

## Practical Usage Scenarios for Vibe Stack

### Extended Log Follow Script

```bash
#!/bin/bash
# logs-tail.sh - Follow all Vibe Stack logs

echo "Following Vibe Stack Service Logs..."
echo "===================================="

# Follow logs for each service
docker-compose logs -f --tail 10 vibe-kanban &
docker-compose logs -f --tail 10 openclaw &
docker-compose logs -f --tail 10 code-server &
docker-compose logs -f --tail 10 nginx &
docker-compose logs -f --tail 10 dns &

# Wait for all background processes
wait
```

### Error Search Script

```bash
#!/bin/bash
# find-errors.sh - Search for errors

echo "Searching for errors in services..."
echo "==================================="

# Vibe-Kanban errors
echo -e "\n--- Vibe-Kanban Errors ---"
docker-compose logs vibe-kanban | grep -i error

# OpenClaw errors
echo -e "\n--- OpenClaw Errors ---"
docker-compose logs openclaw | grep -i error

# General errors
echo -e "\n--- General Errors ---"
docker-compose logs | grep -i error
```

## Most Used Vibe Stack Commands

```bash
# Start all services
docker-compose up -d

# Follow logs
docker-compose logs -f

# Follow only Vibe-Kanban logs
docker-compose logs -f vibe-kanban

# Check container status
docker-compose ps

# Restart specific service
docker-compose restart vibe-kanban

# Stop all services
docker-compose down

# Clear volumes (includes logs)
docker-compose down -v
```

## Tips and Best Practices

1. **Log Size**: Long-running containers can have very large log files. Use `--tail` to limit output.

2. **Real-time Monitoring**: Use the `-f` (follow) flag for real-time log monitoring.

3. **Timestamps**: The `--timestamps` flag is very helpful for debugging.

4. **Filtering**: Use `grep` to filter logs by specific patterns.

5. **Session Management**: For real-time log monitoring, open a separate terminal window for better management.

6. **Sensitive Information**: Logs may contain sensitive information. Be careful before sharing.
