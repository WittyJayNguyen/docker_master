# 🆘 Quick Help - Docker Master Platform

## 🚨 Emergency Commands

### Database Connection Issues (Most Common)
```bash
scripts\fix-database-corruption.bat
```
**Use when:** phpMyAdmin shows "Cannot connect" or MySQL/PostgreSQL won't start

### System Not Starting
```bash
bin\stop.bat
bin\start.bat
```
**Use when:** Services fail to start or containers keep restarting

### Check System Status
```bash
bin\status.bat
```
**Use when:** Want to see what's running and what's not

---

## 🌐 Service URLs

| Service | URL | Credentials |
|---------|-----|-------------|
| **phpMyAdmin** | http://localhost:8080 | root / rootpassword123 |
| **pgAdmin** | http://localhost:8081 | admin@example.com / admin123 |
| **Laravel PHP 8.4** | http://localhost:8010 | - |
| **Laravel PHP 7.4** | http://localhost:8011 | - |
| **WordPress** | http://localhost:8012 | admin / admin |
| **RAM Dashboard** | http://localhost:8090 | - |
| **Mailhog** | http://localhost:8025 | - |

---

## 🗄️ Database Connections

| Database | Host | Port | Username | Password |
|----------|------|------|----------|----------|
| **MySQL** | localhost | 3306 | root | rootpassword123 |
| **PostgreSQL** | localhost | 5432 | postgres_user | postgres_pass |
| **Redis** | localhost | 6379 | - | - |

---

## 🔧 Common Commands

### Daily Operations
```bash
bin\start.bat          # Start everything
bin\stop.bat           # Stop everything
bin\restart.bat        # Restart everything
bin\status.bat         # Check status
```

### Monitoring
```bash
scripts\monitor-ram.bat        # Check RAM usage
scripts\quick-ram-check.bat    # Quick RAM check
```

### Troubleshooting
```bash
scripts\fix-database-corruption.bat    # Fix database issues
scripts\cleanup.bat                    # Clean up junk files
```

---

## ⚠️ Common Issues & Solutions

### ❌ "Cannot connect to MySQL"
**Solution:** `scripts\fix-database-corruption.bat`

### ❌ "Docker is not running"
**Solution:** Start Docker Desktop, then `bin\start.bat`

### ❌ "Port already in use"
**Solution:** `bin\stop.bat`, kill conflicting processes, then `bin\start.bat`

### ❌ "Service not responding"
**Solution:** Wait 2-3 minutes for full startup, or `bin\restart.bat`

### ❌ High RAM usage
**Solution:** `scripts\optimize-ram.bat` or `bin\restart.bat`

---

## 📞 Get More Help

- **Full troubleshooting:** `TROUBLESHOOTING.md`
- **Complete documentation:** `README.md`
- **Scripts guide:** `scripts/README.md`
- **Git management:** `docs/09-GIT-MANAGEMENT.md`

---

## 💡 Pro Tips

1. **Always wait 2-3 minutes** after `bin\start.bat` for full startup
2. **Use `bin\status.bat`** to check what's actually running
3. **If in doubt, run** `scripts\fix-database-corruption.bat`
4. **Stop services** with `bin\stop.bat` before shutting down computer
5. **Monitor RAM** with `scripts\monitor-ram.bat` if system is slow

**🎯 Remember: `scripts\fix-database-corruption.bat` solves 90% of issues!** 🚀
