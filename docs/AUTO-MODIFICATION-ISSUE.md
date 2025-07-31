# Vấn đề Tự động Sửa Đổi Code - Auto Modification Issue

## 🚨 Vấn đề
Các file cấu hình Docker Compose, đặc biệt là phần `volumes:`, bị tự động sửa đổi mà không có sự can thiệp trực tiếp của người dùng.

## 🔍 Nguyên nhân có thể

### 1. **Scripts Tự động (Auto-scripts)**
Hệ thống có nhiều script có thể tự động sửa đổi cấu hình:

**Scripts có khả năng sửa đổi docker-compose files:**
- `scripts/auto-platform.bat` - Tự động tạo và cập nhật cấu hình platform
- `scripts/auto-discovery.bat` - Quét và cập nhật cấu hình tự động
- `scripts/ultimate-optimize.bat` - Tối ưu hóa cấu hình container
- `scripts/fix-nginx-configs.bat` - Sửa cấu hình nginx
- `scripts/docker-optimize.bat` - Tối ưu hóa Docker

**Đặc điểm của các script này:**
```bash
# Ví dụ từ auto-platform.bat
echo     volumes:
echo       - ../../projects/%PLATFORM_NAME%:/var/www/html
echo       - ../../logs/apache/%PLATFORM_NAME%:/var/log/apache2
echo       - ../../data/uploads/%PLATFORM_NAME%:/app/uploads
```

### 2. **IDE/Editor Auto-formatting**
- **VS Code Extensions**: Docker, YAML extensions có thể tự động format
- **Auto-save với format**: Tự động format khi save file
- **Prettier/YAML formatters**: Tự động sửa indentation và cấu trúc

### 3. **Docker Compose Override**
- File `docker-compose.override.yml` có thể ghi đè cấu hình
- Environment variables có thể thay đổi cấu hình

### 4. **Monitoring Scripts**
- Scripts giám sát có thể tự động "sửa" cấu hình khi phát hiện lỗi
- Health check scripts có thể cập nhật cấu hình

## ✅ Giải pháp đã triển khai

### 1. **Protection Tool**
Script `scripts/protect-config-files.bat` để:
- ✅ Kiểm tra processes có thể sửa đổi file
- ✅ Tạo backup tự động
- ✅ Làm file read-only
- ✅ Disable auto-scripts tạm thời

### 2. **File Change Monitor**
Script `scripts/monitor-file-changes.ps1` để:
- ✅ Giám sát file thay đổi real-time
- ✅ Phát hiện process nào sửa đổi file
- ✅ Log tất cả thay đổi
- ✅ Alert ngay khi có thay đổi

### 3. **Backup System**
- ✅ Tự động backup config files
- ✅ Timestamp cho mỗi backup
- ✅ Lưu trong thư mục `backups/`

## 🛠️ Cách sử dụng

### Bảo vệ file cấu hình:
```bash
scripts\protect-config-files.bat
```

### Giám sát thay đổi file:
```powershell
powershell -ExecutionPolicy Bypass -File "scripts\monitor-file-changes.ps1"
```

### Khôi phục từ backup:
```bash
copy "backups\asmo-foodservice-docker-compose-YYYYMMDD.yml" "platforms\asmo-foodservice\docker-compose.asmo-foodservice.yml"
```

## 🔧 Cách ngăn chặn

### 1. **Disable Auto-scripts**
```bash
# Tạm thời disable
ren "scripts\auto-monitor.bat" "scripts\auto-monitor.bat.disabled"
ren "scripts\auto-discovery.bat" "scripts\auto-discovery.bat.disabled"
ren "scripts\auto-platform.bat" "scripts\auto-platform.bat.disabled"
```

### 2. **VS Code Settings**
Thêm vào `settings.json`:
```json
{
    "editor.formatOnSave": false,
    "yaml.format.enable": false,
    "docker.enableAutoFormat": false
}
```

### 3. **Read-only Protection**
```bash
attrib +R "platforms\asmo-foodservice\docker-compose.asmo-foodservice.yml"
```

### 4. **Git Protection**
```bash
# Ignore local changes
git update-index --skip-worktree "platforms\asmo-foodservice\docker-compose.asmo-foodservice.yml"
```

## 📊 Monitoring Dashboard

### File Change Log
Location: `logs\file-changes.log`

### Real-time Monitoring
```powershell
# Monitor specific file
powershell -File "scripts\monitor-file-changes.ps1" -FilePath "platforms\asmo-foodservice\docker-compose.asmo-foodservice.yml"

# Monitor with custom interval
powershell -File "scripts\monitor-file-changes.ps1" -CheckInterval 10
```

## 🚨 Emergency Recovery

### Nếu file bị sửa đổi:
1. **Stop tất cả containers**:
   ```bash
   docker-compose down
   ```

2. **Khôi phục từ backup**:
   ```bash
   copy "backups\asmo-foodservice-docker-compose-*.yml" "platforms\asmo-foodservice\docker-compose.asmo-foodservice.yml"
   ```

3. **Restart containers**:
   ```bash
   docker-compose -f "platforms\asmo-foodservice\docker-compose.asmo-foodservice.yml" up -d
   ```

## 📋 Checklist Phòng ngừa

- [ ] Backup config files định kỳ
- [ ] Disable auto-format trong IDE
- [ ] Monitor file changes
- [ ] Review scripts trước khi chạy
- [ ] Use read-only mode cho files quan trọng
- [ ] Check git history thường xuyên
- [ ] Disable auto-scripts không cần thiết

## 🔗 Related Files

- `scripts/protect-config-files.bat` - Protection tool
- `scripts/monitor-file-changes.ps1` - File monitor
- `backups/` - Backup directory
- `logs/file-changes.log` - Change log

## 📞 Support

Nếu vấn đề vẫn tiếp tục:
1. Chạy file monitor để xác định nguồn gốc
2. Check VS Code extensions
3. Review scheduled tasks
4. Kiểm tra Docker Desktop settings
