@echo off
REM Docker Master Platform - Fix MySQL/Database Issues
REM Khắc phục các vấn đề về MySQL và database

echo.
echo ========================================
echo   Fix MySQL/Database Issues
echo ========================================
echo.

echo 🔍 KIỂM TRA VẤN ĐỀ DATABASE
echo ================================================================

echo 📊 Kiểm tra containers đang chạy:
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 🗄️ Kiểm tra PostgreSQL (Database chính):
echo ----------------------------------------------------------------
docker exec postgres_low_ram pg_isready -U postgres_user
if errorlevel 1 (
    echo ❌ PostgreSQL không hoạt động
    echo 🔧 Đang restart PostgreSQL...
    docker restart postgres_low_ram
    timeout /t 10 /nobreak >nul
    docker exec postgres_low_ram pg_isready -U postgres_user
) else (
    echo ✅ PostgreSQL hoạt động bình thường
)

echo.
echo 🔍 Kiểm tra MySQL containers:
echo ----------------------------------------------------------------
docker ps -a | findstr mysql
if errorlevel 1 (
    echo ℹ️  Không có MySQL container nào
    echo ℹ️  Hệ thống đang sử dụng PostgreSQL
) else (
    echo ⚠️  Tìm thấy MySQL containers:
    docker ps -a | findstr mysql
    
    echo.
    echo 🔧 Kiểm tra trạng thái MySQL containers:
    for /f "tokens=1" %%i in ('docker ps -a --filter "name=mysql" --format "{{.Names}}"') do (
        echo Checking %%i...
        docker logs %%i --tail 5
    )
)

echo.
echo 🧪 TEST KẾT NỐI DATABASE:
echo ================================================================

echo 📝 Test PostgreSQL connections:
echo ----------------------------------------------------------------

REM Test main PostgreSQL
echo Testing main PostgreSQL connection...
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "SELECT version();" 2>nul
if not errorlevel 1 (
    echo ✅ PostgreSQL connection successful
) else (
    echo ❌ PostgreSQL connection failed
)

echo.
echo 📋 Liệt kê databases hiện có:
docker exec postgres_low_ram psql -U postgres_user -d postgres -c "\l" | findstr "_db"

echo.
echo 🌐 TEST WEBSITE CONNECTIONS:
echo ================================================================

echo Testing Laravel PHP 8.4 (localhost:8010):
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8010' -TimeoutSec 5 -UseBasicParsing; if ($r.StatusCode -eq 200) { Write-Host '✅ Laravel 8.4: OK' -ForegroundColor Green } else { Write-Host '⚠️ Laravel 8.4: Issue' -ForegroundColor Yellow } } catch { Write-Host '❌ Laravel 8.4: Failed' -ForegroundColor Red }"

echo Testing Laravel PHP 7.4 (localhost:8020):
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8020' -TimeoutSec 5 -UseBasicParsing; if ($r.StatusCode -eq 200) { Write-Host '✅ Laravel 7.4: OK' -ForegroundColor Green } else { Write-Host '⚠️ Laravel 7.4: Issue' -ForegroundColor Yellow } } catch { Write-Host '❌ Laravel 7.4: Failed' -ForegroundColor Red }"

echo Testing WordPress PHP 7.4 (localhost:8030):
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8030' -TimeoutSec 5 -UseBasicParsing; if ($r.StatusCode -eq 200) { Write-Host '✅ WordPress: OK' -ForegroundColor Green } else { Write-Host '⚠️ WordPress: Issue' -ForegroundColor Yellow } } catch { Write-Host '❌ WordPress: Failed' -ForegroundColor Red }"

echo.
echo 🔧 KHẮC PHỤC TỰ ĐỘNG:
echo ================================================================

echo 🔄 Restart các containers có vấn đề:
echo ----------------------------------------------------------------

REM Check và restart WordPress nếu cần
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:8030' -TimeoutSec 3 -UseBasicParsing | Out-Null } catch { Write-Host 'Restarting WordPress container...'; docker restart wordpress_php74_low_ram }"

REM Check và restart Laravel containers nếu cần
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:8010' -TimeoutSec 3 -UseBasicParsing | Out-Null } catch { Write-Host 'Restarting Laravel 8.4 container...'; docker restart laravel_php84_low_ram }"

powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:8020' -TimeoutSec 3 -UseBasicParsing | Out-Null } catch { Write-Host 'Restarting Laravel 7.4 container...'; docker restart laravel_php74_low_ram }"

echo.
echo ⏳ Đợi containers khởi động lại...
timeout /t 15 /nobreak >nul

echo.
echo 🧪 TEST LẠI SAU KHI KHẮC PHỤC:
echo ================================================================

echo Re-testing all services:
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8010' -TimeoutSec 10 -UseBasicParsing; if ($r.StatusCode -eq 200) { Write-Host '✅ Laravel 8.4: FIXED' -ForegroundColor Green } else { Write-Host '⚠️ Laravel 8.4: Still issues' -ForegroundColor Yellow } } catch { Write-Host '❌ Laravel 8.4: Still failed' -ForegroundColor Red }"

powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8020' -TimeoutSec 10 -UseBasicParsing; if ($r.StatusCode -eq 200) { Write-Host '✅ Laravel 7.4: FIXED' -ForegroundColor Green } else { Write-Host '⚠️ Laravel 7.4: Still issues' -ForegroundColor Yellow } } catch { Write-Host '❌ Laravel 7.4: Still failed' -ForegroundColor Red }"

powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:8030' -TimeoutSec 10 -UseBasicParsing; if ($r.StatusCode -eq 200) { Write-Host '✅ WordPress: FIXED' -ForegroundColor Green } else { Write-Host '⚠️ WordPress: Still issues' -ForegroundColor Yellow } } catch { Write-Host '❌ WordPress: Still failed' -ForegroundColor Red }"

echo.
echo 📊 TỔNG KẾT:
echo ================================================================

echo 🗄️ Database Status:
docker exec postgres_low_ram pg_isready -U postgres_user
if not errorlevel 1 (
    echo ✅ PostgreSQL: Healthy
) else (
    echo ❌ PostgreSQL: Issues
)

echo.
echo 🌐 Website Status:
echo   • Laravel PHP 8.4: http://localhost:8010
echo   • Laravel PHP 7.4: http://localhost:8020  
echo   • WordPress PHP 7.4: http://localhost:8030
echo   • Mailhog: http://localhost:8025

echo.
echo 💡 GIẢI PHÁP CHO CÁC VẤN ĐỀ THƯỜNG GẶP:
echo ================================================================

echo ❌ Nếu vẫn có lỗi MySQL:
echo    • Hệ thống này SỬ DỤNG POSTGRESQL, không phải MySQL
echo    • Tất cả platforms đều kết nối PostgreSQL
echo    • Nếu cần MySQL, phải tạo container MySQL riêng

echo.
echo ❌ Nếu website không truy cập được:
echo    • Chạy: docker restart [container-name]
echo    • Kiểm tra logs: docker logs [container-name]
echo    • Đợi 1-2 phút để container khởi động hoàn toàn

echo.
echo ❌ Nếu database connection failed:
echo    • Chạy: scripts\fix-platform-databases.bat
echo    • Kiểm tra tên database có đúng không
echo    • Restart PostgreSQL: docker restart postgres_low_ram

echo.
echo 🔧 LỆNH KHẮC PHỤC NHANH:
echo ================================================================

echo scripts\fix-platform-databases.bat    # Sửa database issues
echo scripts\one-click-optimize.bat        # Tối ưu toàn bộ hệ thống
echo docker-compose -f docker-compose.low-ram.yml restart  # Restart tất cả

echo.
echo 🌟 MYSQL/DATABASE ISSUES CHECK COMPLETED!

pause
