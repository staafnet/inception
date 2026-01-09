# User Documentation - Inception Project

## Overview

This project provides a complete web infrastructure stack consisting of:
- **NGINX** - Web server
- **WordPress** - Management System  
- **MariaDB** - Database
All services run in isolated Docker containers and communicate through a private network.

## Getting Started

1. **Main Website**: `https://rgrochow.42.fr`
2. **Administration Panel**: `https://rgrochow.42.fr/wp-admin`

## Starting the Infrastructure

To start all services:
```bash
make
```
This command will:
- Build all Docker images (first time only)
- Create necessary volumes and networks
- Start all containers in the correct order

To start all services without build:
```bash
make up
```

## Stopping the Infrastructure

To stop all services without removing data:
```bash
make down
```
This preserves your database and WordPress files.

To remove everything (containers, images, volumes):
```bash
make fclean
```
This deletes all data including the database!

## Credentials Management

All credentials are stored in the `/srcs/.env` file:
This file contains sensitive passwords and should never be committed to git.

You will need these credentials to access the system:

1. **Domain Configuration**
   - Domain Name: `DOMAIN_NAME`
2. **WordPress Administrator**
   - Username: `WP_ADMIN_USER`
   - Password: `WP_ADMIN_PASSWORD`
   - Email: `WP_ADMIN_EMAIL`
3. **WordPress User** (additional user)
   - Username: `WP_USER`
   - Password: `WP_USER_PASSWORD`
4. **Database Credentials** (for advanced users)
   - Database Name: `MYSQL_DATABASE`
   - Database User: `MYSQL_USER`
   - Database Password: `MYSQL_USER_PASSWORD`
   - Root Password: `MYSQL_ROOT_PASSWORD`

## Checking Service Status

To verify all services are running:
```bash
docker ps
```

You should see 3 containers running:
- `nginx` (port 443)
- `wordpress`
- `mariadb`

## Detailed Service Check

Check individual service logs:

```bash
# NGINX logs
docker logs nginx

# WordPress logs
docker logs wordpress

# MariaDB logs
docker logs mariadb
```

## Common Issues and Solutions

### Website not accessible
1. Check if containers are running: `docker ps`
2. Verify `/etc/hosts` contains: `127.0.0.1 rgrochow.42.fr`
3. Check NGINX logs: `docker logs nginx`
### Database connection errors
1. Check if MariaDB is running: `docker ps | grep mariadb`
2. Verify database credentials in `.env` file
3. Check MariaDB logs: `docker logs mariadb`

### Certificate/SSL errors
1. Your browser may show a warning for self-signed certificates
2. Click "Advanced" and "Proceed to site" (this is safe for development)

## Data Persistence

Your data is stored on the host machine in:
- **Database**: `/home/rgrochow/data/mariadb`
- **WordPress files**: `/home/rgrochow/data/wordpress`

These directories persist even when containers are stopped or removed.

## Backup and Restore

### Creating a Backup

```bash
# Stop services first
make down

# Backup data
sudo tar -czf inception-backup-$(date +%Y%m%d).tar.gz /home/rgrochow/data

# Restart services
make
```

### Restoring from Backup

```bash
# Stop and clean
make fclean

# Restore data
sudo tar -xzf inception-backup-YYYYMMDD.tar.gz -C /

# Restart
make
```