# 🚨 Khắc phục sự cố

> **Mục tiêu**: Giải quyết các lỗi thường gặp khi chạy dự án

## 🔍 Chẩn đoán nhanh

### Kiểm tra trạng thái tổng quan
```bash
# Xem tất cả containers
docker-compose ps

# Xem logs tổng quan
docker-compose logs --tail=50
```

**Kết quả mong đợi**: Tất cả containers có status **"Up"** hoặc **"Up (healthy)"**

## 🐳 Lỗi Docker

### 1. "Docker not found" hoặc "docker command not found"
**Nguyên nhân**: Docker chưa được cài đặt hoặc chưa start

**Giải pháp**:
```bash
# Kiểm tra Docker
docker --version

# Nếu lỗi: Cài Docker Desktop từ https://docker.com
# Sau khi cài: Khởi động Docker Desktop
```

### 2. "Cannot connect to Docker daemon"
**Nguyên nhân**: Docker Desktop chưa chạy

**Giải pháp**:
1. **Mở Docker Desktop**
2. **Đợi** cho đến khi icon Docker ở system tray không còn loading
3. **Thử lại** command

### 3. "docker-compose command not found"
**Nguyên nhân**: Docker Compose chưa được cài

**Giải pháp**:
```bash
# Docker Desktop thường đi kèm docker-compose
# Nếu không có, cài thêm:
pip install docker-compose
```

## 🚢 Lỗi Container

### 1. Container không start (Exited status)
```bash
# Xem lỗi chi tiết
docker-compose logs [container_name]

# Ví dụ:
docker-compose logs laravel_php84_psql_app
```

**Các lỗi thường gặp**:

#### Database connection failed
```
SQLSTATE[HY000] [2002] Connection refused
```
**Giải pháp**: Database container chưa sẵn sàng, đợi thêm 1-2 phút

#### Permission denied
```
Permission denied: '/var/log/apache2'
```
**Giải pháp**:
```bash
# Fix permissions (Linux/macOS)
sudo chown -R $USER:$USER data/ logs/

# Windows: Chạy PowerShell as Administrator
```

### 2. Container liên tục restart
```bash
# Xem logs để tìm nguyên nhân
docker-compose logs -f [container_name]
```

**Nguyên nhân thường gặp**:
- Database chưa sẵn sàng
- Port conflict
- Memory không đủ

### 3. Health check failed
```bash
# Kiểm tra health check
docker inspect [container_name] | findstr Health
```

**Giải pháp**: Thường tự khắc phục sau vài phút

## 🌐 Lỗi Port

### 1. "Port already in use"
```
Error: bind: address already in use
```

**Tìm process đang dùng port**:
```bash
# Windows
netstat -ano | findstr :8010

# Tìm PID và kill process
taskkill /PID [PID] /F
```

**Hoặc đổi port**:
1. **Edit** `docker-compose.yml`
2. **Đổi** `8010:80` thành `8020:80`
3. **Restart**: `docker-compose up -d`

### 2. Không truy cập được URL
**Kiểm tra**:
```bash
# Container có chạy?
docker-compose ps

# Port có được map?
docker port laravel_php84_psql_app
```

**Test connection**:
```bash
# Windows
Test-NetConnection localhost -Port 8010

# Hoặc dùng browser truy cập http://localhost:8010
```

## 💾 Lỗi Database

### 1. PostgreSQL không start
```bash
# Xem logs PostgreSQL
docker-compose logs postgres_server
```

**Lỗi thường gặp**:
```
FATAL: data directory "/var/lib/postgresql/data" has wrong ownership
```

**Giải pháp**:
```bash
# Xóa data và tạo lại
docker-compose down
rm -rf data/postgres
docker-compose up -d
```

### 2. MySQL không start
```bash
# Xem logs MySQL
docker-compose logs mysql_server
```

**Lỗi thường gặp**:
```
[ERROR] Can't start server: Bind on TCP/IP port: Address already in use
```

**Giải pháp**: Port 3306 bị chiếm, đổi port hoặc tắt MySQL local

### 3. Không kết nối được database
**Kiểm tra**:
```bash
# Test PostgreSQL
docker exec -it postgres_server psql -U postgres_user -l

# Test MySQL  
docker exec -it mysql_server mysql -u root -prootpassword123 -e "SHOW DATABASES;"
```

## 🐛 Lỗi Debug

### 1. Xdebug không hoạt động
**Kiểm tra Xdebug có load**:
```bash
docker exec laravel_php74_psql_app php -m | findstr xdebug
```

**Kiểm tra config**:
```bash
docker exec laravel_php74_psql_app php --ini | findstr xdebug
```

### 2. IDE không nhận debug connection
**VS Code**:
1. **Kiểm tra** PHP Debug extension đã cài
2. **Kiểm tra** `.vscode/launch.json` có đúng port
3. **Restart** VS Code

**PhpStorm**:
1. **Kiểm tra** port 9003 trong Settings
2. **Kiểm tra** path mapping
3. **Start listening** trước khi debug

### 3. Breakpoint không dừng
**Kiểm tra**:
1. **File path mapping** có đúng?
2. **IDE đang listen** debug connection?
3. **Xdebug log** có lỗi gì?
```bash
docker exec laravel_php74_psql_app cat /var/log/xdebug.log
```

## 🔧 Lỗi Build

### 1. Build failed
```bash
# Xem lỗi build chi tiết
docker-compose build --no-cache [service_name]
```

**Lỗi thường gặp**:
```
E: Unable to locate package
```
**Giải pháp**: Network issue, thử lại sau

### 2. Out of disk space
```
no space left on device
```

**Giải pháp**:
```bash
# Dọn dẹp Docker
docker system prune -a

# Xóa volumes không dùng
docker volume prune
```

## 🔄 Reset hoàn toàn

### Khi mọi thứ đều lỗi
```bash
# 1. Stop và xóa tất cả
docker-compose down -v

# 2. Xóa images
docker rmi $(docker images -q docker_master*)

# 3. Dọn dẹp
docker system prune -a

# 4. Xóa data (nếu cần)
rm -rf data/

# 5. Setup lại từ đầu
.\scripts\setup.bat
.\scripts\start.bat
```

## 📞 Cần hỗ trợ thêm?

### Thu thập thông tin debug
```bash
# Tạo file debug info
echo "=== Docker Version ===" > debug_info.txt
docker --version >> debug_info.txt
echo "=== Container Status ===" >> debug_info.txt
docker-compose ps >> debug_info.txt
echo "=== Logs ===" >> debug_info.txt
docker-compose logs --tail=100 >> debug_info.txt
```

### Các bước debug cơ bản
1. **Đọc logs** kỹ để tìm error message
2. **Google** error message cụ thể
3. **Kiểm tra** Docker Desktop có đang chạy
4. **Restart** Docker Desktop nếu cần
5. **Thử** reset hoàn toàn nếu không có cách nào khác

**💡 Tip**: Hầu hết lỗi đều do Docker chưa sẵn sàng hoặc port conflict!
