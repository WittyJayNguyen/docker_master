@echo off
REM Auto Monitor - Chạy ngầm và theo dõi Docker RAM
REM Tự động start khi Docker khởi động

echo.
echo ========================================
echo   Docker Master Platform - Auto Monitor
echo ========================================
echo.

REM Kiểm tra Docker có chạy không
:check_docker
docker version >nul 2>&1
if errorlevel 1 (
    echo ⏳ Waiting for Docker to start...
    timeout /t 10 /nobreak >nul
    goto check_docker
)

echo ✅ Docker detected! Starting auto-monitor...
echo.

REM Tạo log file với timestamp
set timestamp=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set timestamp=%timestamp: =0%
set logfile=logs\monitor_%timestamp%.log

REM Tạo thư mục logs nếu chưa có
if not exist "logs" mkdir logs

echo 📊 Auto-monitoring started at %date% %time% > %logfile%
echo Log file: %logfile%
echo.

:monitor_loop
REM Lấy thời gian hiện tại
set current_time=%time:~0,8%

REM Kiểm tra Docker vẫn chạy
docker version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker stopped at %current_time%
    echo ❌ Docker stopped at %current_time% >> %logfile%
    echo Waiting for Docker to restart...
    goto check_docker
)

REM Lấy RAM usage
echo [%current_time%] Checking RAM usage... >> %logfile%

REM Lấy container stats và ghi vào log
docker stats --no-stream --format "{{.Container}}: {{.MemUsage}} ({{.MemPerc}})" >> %logfile% 2>&1

REM Tính tổng RAM usage
for /f "tokens=*" %%i in ('docker stats --no-stream --format "{{.MemUsage}}" ^| findstr /R "[0-9]"') do (
    echo Container RAM: %%i >> %logfile%
)

REM Kiểm tra RAM usage cao
for /f "tokens=*" %%i in ('docker stats --no-stream --format "{{.MemPerc}}" ^| findstr /R "[0-9]"') do (
    set mem_percent=%%i
    set mem_percent=!mem_percent:%%=!
    if !mem_percent! GTR 90 (
        echo ⚠️ HIGH RAM USAGE DETECTED: !mem_percent!%% at %current_time%
        echo ⚠️ HIGH RAM USAGE: !mem_percent!%% at %current_time% >> %logfile%
    )
)

REM Hiển thị status mỗi 5 phút (300 giây)
set /a counter+=1
if !counter! GEQ 30 (
    echo [%current_time%] Auto-monitor running... Containers: 
    docker ps --format "{{.Names}}: {{.Status}}" | findstr "Up"
    set counter=0
)

REM Đợi 10 giây trước khi check tiếp
timeout /t 10 /nobreak >nul

goto monitor_loop
