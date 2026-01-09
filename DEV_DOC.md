# Developer Documentation - Inception Project

## Project Structure

```
inception/
├── Makefile                    # Build automation
├── README.md                   # Project documentation
├── USER_DOC.md                 # User documentation
├── DEV_DOC.md                  # This file
└── srcs/
    ├── .env                    # Environment variables (NOT in git)
    ├── docker-compose.yml      # Service orchestration
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── 50-server.cnf
        │   └── tools/
        │       └── mariadb-setup.sh
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── nginx.conf
        │   └── tools/
        │       └── nginx-setup.sh
        └── wordpress/
            ├── Dockerfile
            └── tools/
                └── wordpress-setup.sh
```

## Environment Setup

### Prerequisites

1. **Virtual Machine** VirtualBox
    - Name: inception-vm
    - Username: rgrochow
    - Domain name: rgrochow.42.fr
    - OS: Debian 12 Bookworm
    - CPU: 4
    - RAM: 8GB
    - Disk: 50GB

2. **System Updates**
```bash
su -
usermod -aG sudo rgrochow
exit
```
    - restart VM
```bash
echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nopasswd
sudo apt update && sudo apt upgrade -y
```

3. **Install Docker Engine**
```bash
# Install Build Tools
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    git \
    make \
    vim
# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group (requires logout/login)
sudo usermod -aG docker $USER
```

### Transferring Project Files to VM

If you're developing on a host machine and need to transfer files to the VM:

#### On Host Machine
```bash
# Navigate to your project directory
cd /home/rgrochow/inception

# Start a simple HTTP server
python3 -m http.server 8000

# Find your host IP address
ip a | grep inet  # Look for address like 192.168.1.X
```

#### In VM
```bash
# Download entire folder structure
wget -r -np -nH --cut-dirs=0 http://192.168.1.X:8000/

# Or download a single file
wget http://192.168.1.X:8000/Makefile
```

### Configuration Files

#### 1. Environment Variables (.env)

Create `srcs/.env` with all required variables:

```bash
# Domain Configuration
DOMAIN_NAME=rgrochow.42.fr
# MySQL/MariaDB Configuration
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wp_user
MYSQL_PASSWORD=secure_db_password_here
MYSQL_ROOT_PASSWORD=secure_root_password_here

# WordPress Configuration
WP_TITLE=My Inception Site
WP_ADMIN_USER=admin_user
WP_ADMIN_PASSWORD=secure_admin_password_here
WP_ADMIN_EMAIL=admin@example.com
WP_USER=regular_user
WP_USER_PASSWORD=secure_user_password_here
WP_USER_EMAIL=user@example.com
```

#### 2. Hosts Configuration

Add domain to `/etc/hosts`:
```bash
echo "127.0.0.1   rgrochow.42.fr" | sudo tee -a /etc/hosts
```

## Building and Launching

### Using Makefile

The Makefile provides convenient commands:

```bash
# Build and start all services
make

# Start all services without build
make up

# Stop services (keep data)
make down

# View logs from all services
make logs

# List running containers
make ps

# Stop and remove containers
make clean

# Full cleanup (removes volumes and images)
make fclean

# Rebuild from scratch
make re
```

### Manual Docker Compose Commands

If you need more control:

```bash
cd srcs/

# Build images
docker compose build

# Start services
docker compose up -d

# View logs
docker compose logs -f

# Stop services
docker compose down

# Remove volumes
docker compose down -v
```

## Managing Containers and Volumes

### Container Management

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Start/stop specific container
docker start <container_name>
docker stop <container_name>

# Remove container
docker rm <container_name>

# Execute command in container
docker exec -it <container_name> /bin/bash

# View container logs
docker logs <container_name>
docker logs -f <container_name>  # Follow logs
```

### Volume Management

```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect <volume_name>

# Remove unused volumes
docker volume prune

# Remove specific volume (container must be stopped)
docker volume rm <volume_name>
```

### Network Management

```bash
# List networks
docker network ls

# Inspect network
docker network inspect inception

# View containers in network
docker network inspect inception | grep Name
```

## Data Persistence

### Named Volumes vs Bind Mounts

This project uses **Docker named volumes**

**Named Volumes** (current implementation):
```yaml
volumes:
  wordpress_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/rgrochow/data/wordpress
```

**Advantages**:
- Managed by Docker
- Better portability
- Consistent permissions

### Data Locations

- **Container side**:
  - MariaDB: `/var/lib/mysql`
  - WordPress: `/var/www/html`

- **Host side** (actual storage):
  - MariaDB: `/home/rgrochow/data/mariadb`
  - WordPress: `/home/rgrochow/data/wordpress`

### Accessing Data

```bash
# View database files
ls -la /home/rgrochow/data/mariadb/

# View WordPress files
ls -la /home/rgrochow/data/wordpress/

# Edit WordPress config directly (if needed)
nano /home/rgrochow/data/wordpress/wp-config.php
```

## Service Architecture

### NGINX (Reverse Proxy)
- **Port**: 443 (HTTPS only)
- **Protocol**: TLSv1.2/TLSv1.3
- **Role**: Entry point, forwards PHP requests to WordPress
- **Config**: `requirements/nginx/conf/nginx.conf`

### WordPress + PHP-FPM
- **Port**: 9000 (internal, not exposed)
- **Role**: Processes PHP, serves WordPress
- **Dependencies**: MariaDB must be running
- **Setup script**: `requirements/wordpress/tools/wordpress-setup.sh`

### MariaDB
- **Port**: 3306 (internal, not exposed)
- **Role**: Database server
- **Config**: `requirements/mariadb/conf/50-server.cnf`
- **Setup script**: `requirements/mariadb/tools/mariadb-setup.sh`

### Service Communication

```
Internet (HTTPS:443)
        ↓
    [NGINX]
        ↓ (PHP requests via FastCGI on port 9000)
  [WordPress + PHP-FPM]
        ↓ (MySQL protocol on port 3306)
    [MariaDB]
```

All communication happens through Docker network `inception` (bridge driver).

## Debugging

### Common Issues

#### Build Failures
```bash
# View build output
docker compose build --no-cache

# Build specific service
docker compose build nginx
```

#### Container Crashes
```bash
# Check logs
docker logs mariadb
docker logs wordpress
docker logs nginx

# Check container status
docker ps -a

# Inspect container
docker inspect <container_name>
```

#### Network Issues
```bash
# Test connectivity between containers
docker exec wordpress ping mariadb
docker exec nginx ping wordpress

# Check network
docker network inspect inception
```

#### Permission Issues
```bash
# Check data directory permissions
ls -la /home/rgrochow/data/

# Fix permissions
sudo chown -R $USER:$USER /home/rgrochow/data
```

### Database Access

Access MariaDB directly:
```bash
docker exec -it mariadb mysql -u root -p
# Enter root password from .env

# Inside MySQL
SHOW DATABASES;
USE wordpress_db;
SHOW TABLES;
SELECT * FROM wp_users;
```

### WordPress CLI

Access WordPress via WP-CLI:
```bash
docker exec -it wordpress wp --allow-root user list
docker exec -it wordpress wp --allow-root plugin list
```

## Security Best Practices

**Environment Variables**: Always use `.env` file, never hardcode credentials
**Git**: Add `.env` to `.gitignore`
**TLS**: Use proper certificates in production (Let's Encrypt)

## Testing

### Quick Health Check
```bash
# All containers running?
docker ps | grep -E "nginx|wordpress|mariadb"

# NGINX responding?
curl -k https://rgrochow.42.fr

# Database accessible?
docker exec mariadb mysqladmin -u root -p$MYSQL_ROOT_PASSWORD ping
```

### Full System Test
```bash
# Test NGINX SSL
openssl s_client -connect rgrochow.42.fr:443 -tls1_2

# Test WordPress
curl -k https://rgrochow.42.fr/wp-admin

# Test database connection from WordPress
docker exec wordpress wp --allow-root db check
```

## Troubleshooting Reference

| Issue | Command | Solution |
|-------|---------|----------|
| Port already in use | `sudo lsof -i :443` | Stop conflicting service |
| Volume permission denied | `ls -la /home/rgrochow/data` | Fix ownership with chown |
| Container won't start | `docker logs <container>` | Check logs for errors |
| Network not found | `docker network ls` | Recreate with compose up |
| Database corruption | `make fclean && make` | Rebuild from scratch |