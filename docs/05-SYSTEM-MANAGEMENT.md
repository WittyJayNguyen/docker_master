# ⚙️ Quản lý hệ thống

> **Mục tiêu**: Quản lý, monitor và tối ưu hệ thống Docker Master Platform

## 🐳 Docker Management

### Container Operations
```bash
# Xem tất cả containers
docker-compose ps

# Start/Stop specific service
docker-compose start laravel_php84_psql_app
docker-compose stop laravel_php84_psql_app

# Restart service
docker-compose restart laravel_php84_psql_app

# Remove containers
docker-compose down

# Remove containers + volumes
docker-compose down -v
```

### Image Management
```bash
# List images
docker images

# Remove unused images
docker image prune

# Remove specific image
docker rmi docker_master-laravel-php84-psql

# Rebuild image
docker-compose build --no-cache laravel-php84-psql
```

### Volume Management
```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect docker_master_postgres_data

# Remove unused volumes
docker volume prune

# Backup volume
docker run --rm -v docker_master_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres_backup.tar.gz -C /data .
```

## 📊 Monitoring

### System Resources
```bash
# Container resource usage
docker stats

# Specific container stats
docker stats laravel_php84_psql_app

# System info
docker system df
docker system info
```

### Logs Management
```bash
# View logs
docker-compose logs

# Follow logs
docker-compose logs -f

# Specific service logs
docker-compose logs -f laravel_php84_psql_app

# Last N lines
docker-compose logs --tail=100

# Logs with timestamps
docker-compose logs -t
```

### Health Monitoring
```bash
# Check container health
docker inspect laravel_php84_psql_app | grep -A 10 Health

# Health check logs
docker inspect laravel_php84_psql_app | jq '.[0].State.Health'
```

## 🗄️ Database Management

### PostgreSQL Operations
```bash
# Connect to PostgreSQL
docker exec -it postgres_server psql -U postgres_user

# List databases
docker exec -it postgres_server psql -U postgres_user -c "\l"

# Create database
docker exec -it postgres_server createdb -U postgres_user new_database

# Backup database
docker exec postgres_server pg_dump -U postgres_user laravel_php84_psql > backup.sql

# Restore database
docker exec -i postgres_server psql -U postgres_user laravel_php84_psql < backup.sql

# Database size
docker exec -it postgres_server psql -U postgres_user -c "SELECT pg_size_pretty(pg_database_size('laravel_php84_psql'));"
```

### MySQL Operations
```bash
# Connect to MySQL
docker exec -it mysql_server mysql -u root -prootpassword123

# Show databases
docker exec -it mysql_server mysql -u root -prootpassword123 -e "SHOW DATABASES;"

# Create database
docker exec -it mysql_server mysql -u root -prootpassword123 -e "CREATE DATABASE new_database;"

# Backup database
docker exec mysql_server mysqldump -u root -prootpassword123 wordpress_php74_mysql > backup.sql

# Restore database
docker exec -i mysql_server mysql -u root -prootpassword123 wordpress_php74_mysql < backup.sql

# Database size
docker exec -it mysql_server mysql -u root -prootpassword123 -e "SELECT table_schema AS 'Database', ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)' FROM information_schema.tables GROUP BY table_schema;"
```

### Redis Operations
```bash
# Connect to Redis
docker exec -it redis_server redis-cli

# Redis info
docker exec -it redis_server redis-cli info

# Clear all data
docker exec -it redis_server redis-cli flushall

# Monitor Redis
docker exec -it redis_server redis-cli monitor
```

## 🔧 Performance Tuning

### Container Resources
```yaml
# docker-compose.yml
services:
  laravel-php84-psql:
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
```

### PHP Optimization
```ini
# docker/php84/php.ini
memory_limit = 512M
max_execution_time = 300
opcache.enable = 1
opcache.memory_consumption = 256
opcache.max_accelerated_files = 20000
```

### Database Optimization
```sql
-- PostgreSQL
ANALYZE;
VACUUM;

-- MySQL
OPTIMIZE TABLE table_name;
```

### Apache Optimization
```apache
# docker/apache/apache2.conf
MaxRequestWorkers 400
ThreadsPerChild 25
ServerLimit 16
```

## 🔒 Security Management

### Container Security
```bash
# Run security scan
docker scan docker_master-laravel-php84-psql

# Check for vulnerabilities
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image docker_master-laravel-php84-psql
```

### Network Security
```yaml
# Isolate networks
networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true
```

### Secrets Management
```yaml
# Use Docker secrets
services:
  app:
    secrets:
      - db_password
    environment:
      - DB_PASSWORD_FILE=/run/secrets/db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

## 📦 Backup & Recovery

### Automated Backup Script
```bash
#!/bin/bash
# backup.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./backups/$DATE"

mkdir -p $BACKUP_DIR

# Backup PostgreSQL
docker exec postgres_server pg_dumpall -U postgres_user > $BACKUP_DIR/postgres_backup.sql

# Backup MySQL
docker exec mysql_server mysqldump -u root -prootpassword123 --all-databases > $BACKUP_DIR/mysql_backup.sql

# Backup project files
tar -czf $BACKUP_DIR/projects_backup.tar.gz projects/

# Backup configurations
tar -czf $BACKUP_DIR/config_backup.tar.gz platforms/ docker/ .env docker-compose.yml

echo "Backup completed: $BACKUP_DIR"
```

### Recovery Process
```bash
# 1. Stop services
docker-compose down

# 2. Restore databases
docker-compose up -d postgres mysql redis

# Wait for databases to be ready
sleep 30

# 3. Restore data
docker exec -i postgres_server psql -U postgres_user < backups/latest/postgres_backup.sql
docker exec -i mysql_server mysql -u root -prootpassword123 < backups/latest/mysql_backup.sql

# 4. Restore files
tar -xzf backups/latest/projects_backup.tar.gz
tar -xzf backups/latest/config_backup.tar.gz

# 5. Start all services
docker-compose up -d
```

## 🔄 Maintenance Tasks

### Daily Tasks
```bash
# Check container health
docker-compose ps

# Check disk usage
docker system df

# Clean up logs older than 7 days
find logs/ -name "*.log" -mtime +7 -delete
```

### Weekly Tasks
```bash
# Update images
docker-compose pull

# Clean unused resources
docker system prune

# Backup databases
./backup.sh

# Check for security updates
docker scan --severity high docker_master-laravel-php84-psql
```

### Monthly Tasks
```bash
# Full system cleanup
docker system prune -a

# Update Docker
# (Manual process - update Docker Desktop)

# Review and rotate logs
logrotate /etc/logrotate.d/docker

# Performance review
docker stats --no-stream > performance_report.txt
```

## 📈 Scaling

### Horizontal Scaling
```yaml
# docker-compose.scale.yml
services:
  laravel-php84-psql:
    deploy:
      replicas: 3
    ports:
      - "8010-8012:80"
```

### Load Balancing
```yaml
# Add nginx load balancer
nginx:
  image: nginx:alpine
  ports:
    - "80:80"
  volumes:
    - ./nginx.conf:/etc/nginx/nginx.conf
  depends_on:
    - laravel-php84-psql
```

### Auto-scaling (Docker Swarm)
```bash
# Initialize swarm
docker swarm init

# Deploy stack
docker stack deploy -c docker-compose.yml docker_master

# Scale service
docker service scale docker_master_laravel-php84-psql=3
```

## 🚨 Alerting & Notifications

### Health Check Alerts
```bash
#!/bin/bash
# health_check.sh

for container in $(docker-compose ps -q); do
    if [ "$(docker inspect -f '{{.State.Health.Status}}' $container)" != "healthy" ]; then
        echo "ALERT: Container $container is unhealthy"
        # Send notification (email, Slack, etc.)
    fi
done
```

### Resource Monitoring
```bash
# Monitor disk usage
df -h | awk '$5 > 80 {print "ALERT: Disk usage high on " $1 ": " $5}'

# Monitor memory usage
free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
```

## 🔧 Troubleshooting Tools

### Debug Container Issues
```bash
# Enter container for debugging
docker exec -it laravel_php84_psql_app bash

# Check container processes
docker exec -it laravel_php84_psql_app ps aux

# Check network connectivity
docker exec -it laravel_php84_psql_app ping postgres_server

# Check file permissions
docker exec -it laravel_php84_psql_app ls -la /app
```

### Network Debugging
```bash
# List networks
docker network ls

# Inspect network
docker network inspect docker_master_network

# Test connectivity between containers
docker exec -it laravel_php84_psql_app nslookup postgres_server
```

**Cần hỗ trợ thêm?** → [06-TROUBLESHOOTING.md](06-TROUBLESHOOTING.md)
