# 🌐 Auto Host Manager - Docker Master Platform

> **Tự động quản lý hosts file cho Windows, macOS và Linux**

## 🚀 Tính Năng

- ✅ **Cross-platform**: Hỗ trợ Windows, macOS, Linux
- ✅ **Auto-detection**: Tự động detect OS và chạy script phù hợp
- ✅ **Backup**: Tự động backup hosts file trước khi thay đổi
- ✅ **DNS Flush**: Tự động flush DNS cache sau khi thay đổi
- ✅ **Validation**: Kiểm tra quyền admin/sudo trước khi chạy
- ✅ **Platform Integration**: Tích hợp với Docker Master Platform

## 📁 Files Structure

```
bin/
├── auto-host              # Cross-platform wrapper script
├── auto-host.bat          # Windows batch script
├── auto-host.sh           # macOS/Linux bash script
├── setup-platform-hosts.bat  # Windows platform setup
└── setup-platform-hosts.sh   # macOS/Linux platform setup
```

## 🔧 Usage

### Cross-Platform (Recommended)
```bash
# Auto-detect OS và chạy script phù hợp
./bin/auto-host add my-shop.local
./bin/auto-host remove my-shop.local
./bin/auto-host list
```

### Windows
```cmd
# Chạy với quyền Administrator
bin\auto-host.bat add my-shop.local
bin\auto-host.bat add api.local 192.168.1.100
bin\auto-host.bat remove my-shop.local
bin\auto-host.bat list
```

### macOS/Linux
```bash
# Chạy với sudo
sudo ./bin/auto-host.sh add my-shop.local
sudo ./bin/auto-host.sh add api.local 192.168.1.100
sudo ./bin/auto-host.sh remove my-shop.local
sudo ./bin/auto-host.sh list
```

## 🌟 Quick Setup for Docker Master Platform

### Windows
```cmd
# Setup tất cả platform hosts (chạy với Administrator)
bin\setup-platform-hosts.bat
```

### macOS/Linux
```bash
# Setup tất cả platform hosts (chạy với sudo)
sudo ./bin/setup-platform-hosts.sh
```

## 💡 Examples

### Thêm Host Đơn Giản
```bash
# Thêm host với IP mặc định (127.0.0.1)
./bin/auto-host add my-blog.io

# Thêm host với IP tùy chỉnh
./bin/auto-host add api.company.com 192.168.1.50
```

### Docker Master Platform Hosts
```bash
# Thêm các host phổ biến cho Docker Master Platform
./bin/auto-host add my-blog.io
./bin/auto-host add my-shop.io
./bin/auto-host add user-api.io
./bin/auto-host add admin-panel.io
./bin/auto-host add laravel-api.io
./bin/auto-host add wordpress-blog.io
```

### Quản Lý Hosts
```bash
# Xem danh sách tất cả hosts
./bin/auto-host list

# Xóa host
./bin/auto-host remove my-blog.io

# Xem help
./bin/auto-host help
```

## 🔒 Security Features

### Windows
- ✅ Kiểm tra quyền Administrator
- ✅ Backup hosts file trước khi thay đổi
- ✅ Validation input để tránh injection
- ✅ Tự động flush DNS cache

### macOS/Linux
- ✅ Kiểm tra quyền sudo
- ✅ Backup hosts file với timestamp
- ✅ Safe sed operations
- ✅ Cross-platform DNS flush

## 📊 Host File Locations

| OS | Hosts File Location |
|---|---|
| **Windows** | `C:\Windows\System32\drivers\etc\hosts` |
| **macOS** | `/etc/hosts` |
| **Linux** | `/etc/hosts` |

## 🛠️ Advanced Usage

### Batch Operations
```bash
# Thêm nhiều hosts cùng lúc
for host in blog shop api admin; do
    ./bin/auto-host add "${host}.local"
done
```

### Integration với Docker Compose
```bash
# Tự động thêm hosts khi tạo platform mới
./bin/create.bat my-new-project
./bin/auto-host add my-new-project.io
```

### Backup Management
```bash
# Hosts file được backup tự động với format:
# Windows: hosts.backup.YYYYMMDD
# macOS/Linux: hosts.backup.YYYYMMDD_HHMMSS
```

## 🚨 Troubleshooting

### Windows Issues
```cmd
# Nếu gặp lỗi permission
# 1. Mở Command Prompt as Administrator
# 2. Navigate đến project folder
# 3. Chạy lại script

# Nếu hosts file bị lock
net stop dnscache
bin\auto-host.bat add my-host.local
net start dnscache
```

### macOS/Linux Issues
```bash
# Nếu gặp lỗi permission
sudo ./bin/auto-host.sh add my-host.local

# Nếu DNS không update
sudo dscacheutil -flushcache  # macOS
sudo systemctl restart systemd-resolved  # Linux
```

## 🔄 Integration với Docker Master Platform

### Auto-Setup khi khởi động
```bash
# Thêm vào auto-start script
bin\auto-start.bat
# -> Tự động gọi setup-platform-hosts.bat

# Hoặc manual setup
bin\setup-platform-hosts.bat  # Windows
sudo ./bin/setup-platform-hosts.sh  # macOS/Linux
```

### Platform Creation Integration
```bash
# Khi tạo platform mới, tự động thêm host
bin\create.bat my-awesome-project
# -> Tự động thêm my-awesome-project.io vào hosts
```

## 📝 Notes

- ⚠️ **Windows**: Cần chạy với quyền Administrator
- ⚠️ **macOS/Linux**: Cần chạy với sudo
- 💾 **Backup**: Hosts file được backup tự động
- 🔄 **DNS Cache**: Tự động flush sau mỗi thay đổi
- 🌐 **Default IP**: 127.0.0.1 nếu không specify IP

## 🎯 Best Practices

1. **Luôn backup** trước khi thay đổi hosts file
2. **Sử dụng meaningful names** cho hosts
3. **Group related hosts** với comments
4. **Regular cleanup** các hosts không dùng
5. **Test connectivity** sau khi thêm hosts

---

**🌟 Professional host management for Docker Master Platform!**
