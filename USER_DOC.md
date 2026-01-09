# User Documentation - Inception Project

## Overview

This project provides a complete web infrastructure stack consisting of:
- **NGINX** - Web server with HTTPS encryption
- **WordPress** - Content Management System  
- **MariaDB** - Database server

All services run in isolated Docker containers and communicate through a private network.

## Getting Started

### Accessing the Services

Once the project is running, you can access:

1. **Main Website**: `https://rgrochow.42.fr`
   - Your WordPress site homepage
   - All public content is available here

2. **Administration Panel**: `https://rgrochow.42.fr/wp-admin`
   - WordPress dashboard for managing content
   - Login with your administrator credentials

## Starting and Stopping the Project

### Starting the Infrastructure

To start all services:
```bash
cd /home/radek/42/inc
make
```

This command will:
- Build all Docker images (first time only)
- Create necessary volumes and networks
- Start all containers in the correct order
- The process takes 2-5 minutes on first run

### Stopping the Infrastructure

To stop all services without removing data:
```bash
make down
```

This preserves your database and WordPress files.

### Complete Cleanup

To remove everything (containers, images, volumes):
```bash
make fclean
```

⚠️ **Warning**: This deletes all data including the database!

## Credentials Management

### Location of Credentials

All credentials are stored in:
```
/home/radek/42/inc/srcs/.env
```

### Important Credentials

You will need these credentials to access the system:

1. **WordPress Administrator**
   - Username: Set in `.env` as `WP_ADMIN_USER`
   - Password: Set in `.env` as `WP_ADMIN_PASSWORD`
   - Email: Set in `.env` as `WP_ADMIN_EMAIL`

2. **WordPress User** (additional user)
   - Username: Set in `.env` as `WP_USER`
   - Password: Set in `.env` as `WP_USER_PASSWORD`

3. **Database Credentials** (for advanced users)
   - Database Name: Value of `MYSQL_DATABASE`
   - Database User: Value of `MYSQL_USER`
   - Database Password: Value of `MYSQL_PASSWORD`
   - Root Password: Value of `MYSQL_ROOT_PASSWORD`

### Changing Credentials

To change any credentials:

1. Stop the services: `make down`
2. Edit the `.env` file: `nano srcs/.env`
3. Change the desired values
4. Restart: `make`

⚠️ **Note**: Changing database credentials after initial setup requires rebuilding the database volume.

## Checking Service Status

### Quick Health Check

To verify all services are running:
```bash
docker ps
```

You should see 3 containers running:
- `nginx` (port 443)
- `wordpress`
- `mariadb`

### Detailed Service Check

Check individual service logs:

```bash
# NGINX logs
docker logs nginx

# WordPress logs
docker logs wordpress

# MariaDB logs
docker logs mariadb
```

### Common Issues and Solutions

#### Website not accessible
1. Check if containers are running: `docker ps`
2. Verify `/etc/hosts` contains: `127.0.0.1 rgrochow.42.fr`
3. Check NGINX logs: `docker logs nginx`

#### Database connection errors
1. Check if MariaDB is running: `docker ps | grep mariadb`
2. Verify database credentials in `.env` file
3. Check MariaDB logs: `docker logs mariadb`

#### Certificate/SSL errors
1. Your browser may show a warning for self-signed certificates
2. Click "Advanced" and "Proceed to site" (this is safe for development)

## Data Persistence

Your data is stored on the host machine in:
- **Database**: `/home/radek/data/mariadb`
- **WordPress files**: `/home/radek/data/wordpress`

These directories persist even when containers are stopped or removed.

## Backup and Restore

### Creating a Backup

```bash
# Stop services first
make down

# Backup data
sudo tar -czf inception-backup-$(date +%Y%m%d).tar.gz /home/radek/data

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

## Support

If you encounter issues:
1. Check this documentation first
2. Review the logs using `docker logs <container-name>`
3. Verify your `.env` file is properly configured
4. Consult the DEV_DOC.md for technical details
