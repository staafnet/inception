_This project has been created by rgrochow._

## Description

This project demonstrates system administration skills using Docker containerization. It involves setting up a small infrastructure composed of different services (NGINX, WordPress, and MariaDB) running in isolated Docker containers, orchestrated via Docker Compose.

### Installation

1. Clone the repository
2. Configure environment variables
3. Update `/etc/hosts` to point your domain to localhost:
```bash
sudo nano /etc/hosts
# Add: 127.0.0.1   rgrochow.42.fr
```
4. Build and launch the infrastructure:
```bash
make
```
5. Access the website:
- Open browser: `https://rgrochow.42.fr`
- WordPress admin: `https://rgrochow.42.fr/wp-admin`

### Common Commands
```bash
make          # Build and start all services
make up       # Start all services
make down     # Stop all services
make logs     # View logs from all services
make ps       # List running containers
make fclean   # Full cleanup
make re       # Rebuild everything
```

### Documentation
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Documentation](https://wordpress.org/documentation/)
- [MariaDB Documentation](https://mariadb.com/kb/en/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Networking](https://docs.docker.com/network/)
- [SSL/TLS with NGINX](https://nginx.org/en/docs/http/configuring_https_servers.html)


## Project Architecture

### Virtual Machines vs Docker
This project uses **Docker containers** instead of virtual machines:
- **Virtual Machines**: Full OS virtualization, higher resource usage, slower startup, complete isolation
- **Docker**: OS-level virtualization, shares host kernel, lightweight, fast startup, process isolation
- Docker is ideal for microservices architecture where each service runs in isolation but shares resources efficiently

### Secrets vs Environment Variables
- **Environment Variables (.env file)**: Used for non-sensitive configuration (domain names, ports, database names)
- **Docker Secrets**: Recommended for sensitive data (passwords, API keys). Secrets are encrypted and only available to services that need them
- This project uses .env for basic configuration and should implement Docker secrets in production for enhanced security

### Docker Network vs Host Network
- **Docker Bridge Network (used in this project)**: Creates isolated network for containers, services communicate via container names, provides network isolation
- **Host Network**: Container shares host's network stack directly, no network isolation, faster but less secure
- Bridge network is preferred for security and service isolation while allowing inter-container communication

### Docker Volumes vs Bind Mounts
- **Docker Named Volumes (required for this project)**: Managed by Docker, stored in `/var/lib/docker/volumes/`, better performance, easier backup
- **Bind Mounts**: Direct mapping of host directories, useful for development, host-path dependent
- Named volumes provide better portability and are managed through Docker API, making them ideal for production data persistence