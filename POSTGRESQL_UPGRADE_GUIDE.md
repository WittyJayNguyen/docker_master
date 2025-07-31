# PostgreSQL Upgrade Guide - Version 15 to 17

## 📋 Overview

This guide will help you upgrade your PostgreSQL installation from version 15 to version 17 in your Docker Master Platform.

## 🎯 What's New in PostgreSQL 17

### Performance Improvements
- **Enhanced Query Optimization**: Better query planner with improved statistics
- **Parallel Processing**: Improved parallel query execution
- **Memory Management**: Better memory allocation and garbage collection
- **Index Performance**: Faster B-tree and hash index operations

### New Features
- **Enhanced JSON Support**: Better JSON and SQL/JSON functionality
- **Improved Security**: Enhanced authentication and authorization
- **Better Monitoring**: More detailed performance metrics
- **Advanced Partitioning**: Improved table partitioning capabilities

## 🔧 Pre-Upgrade Checklist

- [ ] **Backup Current Data**: All databases backed up
- [ ] **Check Disk Space**: Ensure sufficient space for backup and upgrade
- [ ] **Stop Applications**: Stop all applications using PostgreSQL
- [ ] **Review Dependencies**: Check if applications are compatible with PostgreSQL 17
- [ ] **Plan Downtime**: Schedule maintenance window

## 🚀 Upgrade Process

### Step 1: Check Current Setup
```bash
scripts\check-postgresql-compatibility.bat
```
This script will:
- Display current PostgreSQL version and configuration
- List all databases and users
- Check extensions and their versions
- Provide compatibility assessment

### Step 2: Perform the Upgrade
```bash
scripts\upgrade-postgresql.bat
```
This script will:
- Create a complete backup of all databases
- Stop the current PostgreSQL 15 container
- Start the new PostgreSQL 17 container
- Restore data from backup (if needed)
- Verify the upgrade

### Step 3: Test the Installation
```bash
scripts\test-postgresql17.bat
```
This script will:
- Verify PostgreSQL 17 is running correctly
- Test basic database operations
- Check new features functionality
- Validate application database connections

## 📁 Files Updated

The following configuration files have been updated to use PostgreSQL 17:

- `docker-compose.yml` - Main compose file ✅ (Already updated)
- `docker-compose.low-ram.yml` - Low RAM configuration ✅
- `config/docker-compose/base.yml` - Base configuration ✅
- `docker/combined/supervisord.conf` - Supervisor configuration ✅
- `config/README.md` - Documentation ✅
- `.augment/env/setup.sh` - Setup script ✅

## 🔄 Rollback Plan

If you need to rollback to PostgreSQL 15:

1. **Stop PostgreSQL 17**:
   ```bash
   docker-compose stop postgres
   ```

2. **Restore from backup**:
   ```bash
   # Restore the backup created during upgrade
   docker exec -i postgres_low_ram psql -U postgres_user < backups\postgresql\postgres_backup_[timestamp].sql
   ```

3. **Update configuration files** back to PostgreSQL 15 if needed

## 🛠️ Configuration Changes

### Memory Settings (Optimized for PostgreSQL 17)
```yaml
environment:
  POSTGRES_SHARED_BUFFERS: 64MB      # Optimized for development
  POSTGRES_EFFECTIVE_CACHE_SIZE: 192MB
  POSTGRES_WORK_MEM: 4MB
  POSTGRES_MAINTENANCE_WORK_MEM: 16MB
  POSTGRES_MAX_CONNECTIONS: 50
```

### Performance Tuning
```yaml
command: >
  postgres
  -c shared_buffers=64MB
  -c effective_cache_size=192MB
  -c work_mem=4MB
  -c maintenance_work_mem=16MB
  -c max_connections=50
  -c random_page_cost=1.1
  -c effective_io_concurrency=200
```

## 🔍 Troubleshooting

### Common Issues

1. **Container won't start**:
   - Check Docker logs: `docker logs postgres_low_ram`
   - Verify port 5432 is not in use
   - Check disk space

2. **Data restore fails**:
   - Verify backup file integrity
   - Check user permissions
   - Review PostgreSQL logs

3. **Application connection errors**:
   - Update connection strings if needed
   - Check firewall settings
   - Verify user credentials

### Useful Commands

```bash
# Check PostgreSQL status
docker exec postgres_low_ram pg_isready -U postgres_user

# View PostgreSQL logs
docker logs postgres_low_ram

# Connect to PostgreSQL
docker exec -it postgres_low_ram psql -U postgres_user -d docker_master

# Check version
docker exec postgres_low_ram psql -U postgres_user -c "SELECT version();"

# List databases
docker exec postgres_low_ram psql -U postgres_user -c "\l"
```

## 📊 Performance Monitoring

After upgrade, monitor these metrics:

- **Query Performance**: Check if queries run faster
- **Memory Usage**: Monitor memory consumption
- **Connection Count**: Verify connection pooling works
- **Disk I/O**: Check for improved I/O performance

## 🎉 Post-Upgrade Tasks

1. **Update Application Documentation**
2. **Review and Update Backup Scripts**
3. **Update Monitoring Configurations**
4. **Test All Application Features**
5. **Update Development Team**
6. **Plan Regular Maintenance**

## 📞 Support

If you encounter issues during the upgrade:

1. Check the troubleshooting section above
2. Review PostgreSQL 17 documentation
3. Check Docker and container logs
4. Verify system resources (CPU, memory, disk)

## 🔗 Useful Links

- [PostgreSQL 17 Release Notes](https://www.postgresql.org/docs/17/release-17.html)
- [PostgreSQL 17 Documentation](https://www.postgresql.org/docs/17/)
- [Docker PostgreSQL Official Image](https://hub.docker.com/_/postgres)

---

**Note**: Always test the upgrade process in a development environment before applying to production!
