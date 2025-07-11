# 🤖 Auto-Monitoring System

> **Hệ thống theo dõi tự động 24/7 cho Docker Master Platform**

## 🎯 Tổng quan

Auto-Monitoring System giúp bạn:
- 📊 **Theo dõi RAM/CPU** tất cả containers mỗi 30 giây
- ⚠️ **Cảnh báo tự động** khi RAM > 90%
- 📁 **Ghi logs chi tiết** vào files để phân tích
- 🌐 **Web dashboard** real-time tại http://localhost:8090
- 🚀 **Chạy ngầm 24/7** không cần can thiệp thủ công

## ⚡ Quick Start

```bash
# Windows - Bắt đầu ngay
scripts\start-auto-monitor.bat

# macOS/Linux - Bắt đầu ngay  
./scripts/start-auto-monitor.sh

# Truy cập dashboard
http://localhost:8090
```

## 🛠️ Hệ thống đã tạo

### 📊 Monitoring Services

#### 1. RAM Monitor Container
- **Image**: Alpine Linux (nhẹ, chỉ 64MB RAM)
- **Chức năng**: Theo dõi containers mỗi 30 giây
- **Output**: Ghi logs vào `logs/current_stats.log`
- **Alerts**: Cảnh báo khi RAM > 90%

#### 2. Web Dashboard Container  
- **Image**: Nginx Alpine (32MB RAM)
- **URL**: http://localhost:8090
- **Features**: Real-time stats, charts, mobile-friendly
- **Auto-refresh**: Mỗi 10 giây

### 📁 Scripts được tạo

#### Windows (.bat files)
- `start-auto-monitor.bat` - Khởi động monitoring
- `toggle-auto-monitor.bat` - Bật/tắt monitoring
- `monitor-ram.bat` - Monitor thủ công
- `optimize-ram.bat` - Tối ưu RAM

#### macOS/Linux (.sh files)
- `auto-monitor.sh` - Monitor tự động
- `monitor-ram.sh` - Monitor thủ công  
- `optimize-ram.sh` - Tối ưu RAM
- `quick-ram-check.sh` - Kiểm tra nhanh

### 📄 Files cấu hình

- `docker-compose.monitoring.yml` - Định nghĩa monitoring services
- `monitoring/dashboard.html` - Web interface
- `logs/` - Thư mục chứa tất cả logs

## 🚀 Cách sử dụng

### Option 1: Auto-start (Khuyến nghị)

```bash
# Start monitoring cùng với containers chính
scripts\start-auto-monitor.bat

# Monitoring sẽ chạy ngầm và tự động:
# - Theo dõi RAM/CPU mỗi 30 giây
# - Ghi logs vào logs/current_stats.log
# - Cảnh báo khi RAM cao
# - Cung cấp web dashboard
```

### Option 2: Manual control

```bash
# Start monitoring services
docker-compose -f docker-compose.monitoring.yml up -d

# Stop monitoring
docker-compose -f docker-compose.monitoring.yml down

# View logs
docker-compose -f docker-compose.monitoring.yml logs ram-monitor
```

### Option 3: Tích hợp vào main compose

```yaml
# Uncomment trong docker-compose.yml:
include:
  # - ./docker-compose.monitoring.yml

# Sau đó restart:
docker-compose down && docker-compose up -d
```

## 📊 Web Dashboard Features

### 🌐 Truy cập Dashboard
- **URL**: http://localhost:8090
- **Mobile-friendly**: Hoạt động tốt trên điện thoại
- **Real-time**: Cập nhật mỗi 10 giây

### 📈 Thông tin hiển thị
- **Container Stats**: RAM/CPU usage từng container
- **System Info**: Tổng RAM hệ thống, disk usage
- **Alerts**: Cảnh báo RAM cao, container down
- **Charts**: Biểu đồ trực quan dễ hiểu

### 🔄 Interactive Features
- **Auto-refresh**: Bật/tắt tự động cập nhật
- **Manual refresh**: Refresh từng section riêng
- **Log viewer**: Xem logs trực tiếp trong browser
- **Alert history**: Lịch sử cảnh báo

## 📁 Log Files

### Các file logs được tạo:

```
logs/
├── current_stats.log          # Stats hiện tại của containers
├── alerts.log                 # Cảnh báo RAM cao
├── system.log                 # Thông tin hệ thống
└── monitor_YYYYMMDD_HHMMSS.log # Logs theo thời gian
```

### Ví dụ nội dung logs:

```bash
# current_stats.log
CONTAINER         MEM USAGE / LIMIT    MEM %    CPU %
laravel_php84     56.09MiB / 256MiB   21.91%   0.03%
postgres_server   45.2MiB / 256MiB    17.66%   0.01%

# alerts.log  
[2025-07-05 00:15:30] ⚠️ HIGH RAM USAGE: pgadmin 95.24%

# system.log
[2025-07-05 00:10:00] System Status:
TYPE      TOTAL    SIZE     RECLAIMABLE
Images    13       7.64GB   898MB (11%)
```

## ⚙️ Configuration

### Thay đổi monitoring interval

```yaml
# Edit docker-compose.monitoring.yml
environment:
  - MONITOR_INTERVAL=60        # Check every 60 seconds (default: 30)
  - HIGH_RAM_THRESHOLD=80      # Alert at 80% (default: 90%)
  - LOG_LEVEL=INFO
```

### Tùy chỉnh dashboard

```html
<!-- Edit monitoring/dashboard.html -->
<script>
const REFRESH_INTERVAL = 5000;  // 5 seconds (default: 10s)
const HIGH_RAM_THRESHOLD = 85;  // 85% (default: 90%)
</script>
```

## 🎯 Performance Impact

### Resource Usage
- **RAM Overhead**: ~96MB total (64MB monitor + 32MB dashboard)
- **CPU Impact**: < 1% average
- **Disk Usage**: ~50MB for images + logs
- **Network**: Chỉ local, không ra internet

### Benefits
- **Proactive**: Phát hiện vấn đề trước khi nghiêm trọng
- **24/7**: Theo dõi liên tục không cần can thiệp
- **Easy access**: Web dashboard thay vì command line
- **Cross-platform**: Hoạt động trên Windows, macOS, Linux

## 🐛 Troubleshooting

### Monitor không start
```bash
# Check Docker
docker version

# Check ports
netstat -an | findstr :8090

# Restart monitoring
docker-compose -f docker-compose.monitoring.yml restart
```

### Dashboard không load
```bash
# Check dashboard container
docker logs docker_master_monitor_dashboard

# Test direct access
curl http://localhost:8090
```

### Logs không được tạo
```bash
# Check monitor container
docker logs docker_master_ram_monitor

# Check permissions
ls -la logs/

# Manual test
docker exec docker_master_ram_monitor docker stats --no-stream
```

## 💡 Best Practices

### 1. Daily Usage
- **Morning**: Check dashboard để xem overnight status
- **Development**: Để monitor chạy ngầm
- **Evening**: Review alerts nếu có

### 2. Weekly Maintenance
- **Review logs**: Xem trends và patterns
- **Clean old logs**: Xóa logs cũ > 7 ngày
- **Check alerts**: Analyze high RAM usage patterns

### 3. Monthly Tasks
- **Archive logs**: Backup logs quan trọng
- **Review thresholds**: Điều chỉnh alert thresholds nếu cần
- **Update monitoring**: Check for improvements

## 🚀 Quick Commands

```bash
# Start monitoring
scripts\start-auto-monitor.bat

# View dashboard
start http://localhost:8090

# Check current status
docker stats --no-stream

# View recent alerts
type logs\alerts.log

# Stop monitoring
docker-compose -f docker-compose.monitoring.yml down

# Restart if needed
docker-compose -f docker-compose.monitoring.yml restart
```

## 🎉 Kết luận

Auto-Monitoring System cung cấp:
- ✅ **Monitoring 24/7** không cần can thiệp
- ✅ **Web dashboard** dễ sử dụng
- ✅ **Low overhead** (~96MB RAM)
- ✅ **Cross-platform** support
- ✅ **Proactive alerts** cho high RAM usage

**🎯 Bây giờ bạn có thể theo dõi Docker Master Platform một cách chuyên nghiệp!** 🚀
