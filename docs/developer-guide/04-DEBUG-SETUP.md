# 🐛 Cấu hình Debug với Xdebug

> **Mục tiêu**: Setup debug để có thể đặt breakpoint và debug code PHP

## ✅ Xdebug đã được cài sẵn!

Dự án đã có Xdebug cho tất cả PHP versions:

| PHP Version | Debug Port | Test URL |
|-------------|------------|----------|
| **PHP 8.4** | 9084 | http://localhost:8010/xdebug_test.php |
| **PHP 7.4** | 9074 | http://localhost:8011/xdebug_test.php |
| **WordPress** | 9012 | http://localhost:8012/xdebug_test.php |

## 🔧 Setup VS Code (Khuyến nghị)

### Bước 1: Cài Extension
1. **Mở VS Code**
2. **Ctrl+Shift+X** → Extensions
3. **Tìm**: `PHP Debug`
4. **Cài đặt**: Extension **"PHP Debug"** by **Xdebug**

### Bước 2: Sử dụng Config có sẵn
File `.vscode/launch.json` đã được tạo với 3 configurations:

- 🐛 **Debug Laravel PHP 8.4** (Port 9084)
- 🐛 **Debug Laravel PHP 7.4** (Port 9003) 
- 🐛 **Debug WordPress PHP 7.4** (Port 9012)

### Bước 3: Test Debug
1. **Mở file**: `projects/laravel-php74-psql/xdebug_test.php`
2. **Đặt breakpoint**: Click vào **số dòng 46**
3. **Start debug**: **F5** → Chọn **"🐛 Debug Laravel PHP 7.4"**
4. **Truy cập**: http://localhost:8011/xdebug_test.php
5. **VS Code sẽ dừng** tại breakpoint! 🎉

## 🔧 Setup PhpStorm

### Bước 1: Cấu hình Debug Port
1. **File** → **Settings** → **PHP** → **Debug**
2. **Xdebug port**: `9003` (default)

### Bước 2: Tạo Server
1. **Settings** → **PHP** → **Servers** → **+**
2. **Điền**:
   - **Name**: `Laravel-PHP74`
   - **Host**: `localhost`
   - **Port**: `8011`
   - **Debugger**: `Xdebug`
   - **Path mappings**: ✅
     - Local: `D:\www\docker_master\projects\laravel-php74-psql`
     - Server: `/app/laravel-php74-psql`

### Bước 3: Debug Configuration
1. **Run** → **Edit Configurations** → **+** → **PHP Remote Debug**
2. **Điền**:
   - **Name**: `Laravel PHP 7.4`
   - **IDE key**: `PHPSTORM`
   - **Server**: Chọn server đã tạo

### Bước 4: Start Debug
1. **Đặt breakpoint** trong code
2. **Click** 📞 **Start Listening**
3. **Run** debug configuration
4. **Truy cập** ứng dụng

## 🧪 Test Files có sẵn

### PHP 8.4 Test
**File**: `projects/laravel-php84-psql/xdebug_test.php`  
**URL**: http://localhost:8010/xdebug_test.php

**Breakpoints đề xuất**:
- Dòng 46: `$test_variable = "Hello from PHP 8.4 with Xdebug!";`
- Dòng 69: Trong function `test_function_c()`

### PHP 7.4 Test  
**File**: `projects/laravel-php74-psql/xdebug_test.php`  
**URL**: http://localhost:8011/xdebug_test.php

**Breakpoints đề xuất**:
- Dòng 46: `$test_variable = "Hello from PHP 7.4 with Xdebug!";`
- Dòng 69: Trong function `test_function_c()`

## 🎯 Debug Workflow

### 1. Chuẩn bị
```bash
# Đảm bảo containers đang chạy
docker-compose ps

# Kiểm tra Xdebug
docker exec laravel_php74_psql_app php -m | findstr xdebug
```

### 2. Debug Steps
1. **Mở file** cần debug trong IDE
2. **Đặt breakpoint** (click vào số dòng)
3. **Start listening** (F5 trong VS Code)
4. **Truy cập** URL trong browser
5. **IDE dừng** tại breakpoint
6. **Inspect variables**, step through code

### 3. Debug Controls
- **Continue (F5)**: Tiếp tục chạy
- **Step Over (F10)**: Chạy dòng tiếp theo
- **Step Into (F11)**: Vào trong function
- **Step Out (Shift+F11)**: Ra khỏi function

## 🔍 Xdebug Configuration

### Current Settings
```ini
xdebug.mode=debug,develop
xdebug.client_host=host.docker.internal
xdebug.client_port=9003
xdebug.idekey=PHPSTORM
xdebug.start_with_request=yes
```

### Port Mapping
- **Container**: Port 9003 (internal)
- **Host**: 
  - PHP 8.4: Port 9084
  - PHP 7.4: Port 9074  
  - WordPress: Port 9012

## 🐛 Troubleshooting Debug

### Debug không hoạt động?

1. **Kiểm tra Extension**: VS Code có PHP Debug extension?
2. **Kiểm tra Port**: Port debug có bị block?
3. **Kiểm tra Container**: 
   ```bash
   docker exec laravel_php74_psql_app php --ini | findstr xdebug
   ```
4. **Kiểm tra Logs**:
   ```bash
   docker exec laravel_php74_psql_app cat /var/log/xdebug.log
   ```

### Path Mapping sai?
- **VS Code**: Kiểm tra `.vscode/launch.json`
- **PhpStorm**: Kiểm tra Server configuration

### Performance chậm?
Xdebug có thể làm chậm ứng dụng. Để tắt:
```bash
# Tạm thời disable Xdebug
docker exec laravel_php74_psql_app php -d xdebug.mode=off your-script.php
```

## 🎉 Debug thành công!

Khi debug hoạt động, bạn sẽ thấy:
- ✅ IDE dừng tại breakpoint
- ✅ Variables panel hiển thị giá trị
- ✅ Call stack hiển thị function calls
- ✅ Có thể step through code

**Cần hỗ trợ thêm?** → [06-TROUBLESHOOTING.md](06-TROUBLESHOOTING.md)
